var express = require('express'); 
var bcrypt = require('bcrypt');
var router = express.Router(); 
var con;
var db = require('mysql2/promise');
var mysql = require('../config');
var crypto = require('crypto');
var inform = mysql.inform;
var verify = require('../routes/verify');
var table = require('../routes/table');

async function myQuery(sql, param){
    try{
        const [row, field] = await con.query(sql,param);
        return true;
    }catch(error){
        console.log(error);
        return false;
    }
}

router.post('/filter', async function(req, res, next) {
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Credentials", "true");
    res.setHeader("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
    res.setHeader("Access-Control-Allow-Headers", "Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers");
    res.setHeader("Access-Control-Expose-Headers","*");

    const accessToken = req.header('accessToken');
    const refreshToken = req.header('refreshToken');
    if (accessToken == null || refreshToken==null) {
        res.send({status:400, message:"토큰없음", data:null});
        return;
    }
    //console.log(accessToken+"  "+id);
    var verify_success = await verify.verifyFunction(accessToken,refreshToken);
    if(!verify_success.success){
        res.send({status:400, message:verify_success.message, data:null});
        return;
    }
    var new_access_token = verify_success.accessToken;
    var new_refresh_token = verify_success.refreshToken;
    var user_id = verify_success.id;

    con = await db.createConnection(inform);
    const check_militaryUnit = "select militaryUnit from user where id = ?;";
    const check_militaryUnit_param = user_id;
    const [check_militaryUnit_result] = await con.query(check_militaryUnit, check_militaryUnit_param);
    if(check_militaryUnit_result.length==0){
        res.send({status:400, message:'Bad Request', data:null});
        return;
    }
    var militaryUnit = check_militaryUnit_result[0].militaryUnit;
	var category_arr = req.body.category;
	var firstDate = req.body.firstDate;
	var lastDate = req.body.lastDate;
	var storagePlace = req.body.storagePlace;
	//var select_property_sql = "select * from property where category in ? and DATE(expirationDate) between ? and ?;";
	var select_property_sql = "select * from property_"+militaryUnit+" where category in (";
	var select_property_param = [];
	var category_param="";
//	select * from property_75 where category in ('바르는거', '경구약') and DATE(expirationDate) between '1000-01-01' and '9999-12-31';
	if(category_arr==null){
		category_param += "'경구약','백신류','분무약', '수액류', '시럽류', '안약류', '액체류', '연고류', '주사제', '파스류', '의약외품', '소모품'";
	}
	else{
		//category_param = "";
		console.log(category_arr);
		for(let i=0; i<category_arr.length; ++i){
			category_param+="'";
			category_param+=category_arr[i];
			category_param+="'";
			//console.log(category_param);
			if(i!=category_arr.length-1) category_param+=",";
		}
		//console.log(category_param);
	}
	select_property_sql+=category_param;
	select_property_sql+=") and DATE(expirationDate) between ? and ?;";
	//console.log(select_property_sql);
	if(firstDate==null&&lastDate==null){
		select_property_param.push("1000-01-01");
		select_property_param.push("9999-12-31");
	}
	else{
		select_property_param.push(firstDate);
        select_property_param.push(lastDate);
	}
	console.log(select_property_sql);
	console.log(select_property_param);
	var [select_property_result] = await con.query(select_property_sql, select_property_param);
	if(select_property_result.length==0){
		res.send({status:200, message:"검색결과가 없습니다.", data:null});
        return;
	}
	if(storagePlace==null){
		var data = [];
        var log_arr = [];
        var Individual_data;
        var select_log_result, select_log_field;
        var id, name, totalAmount, unit, expirationDate, created_time, updated_time, select_log_sql, select_log_param;
        var select_amountByPlace_sql;
        var select_amountByPlace_param;
        var select_amountByPlace_result;
        var amountByPlace;
        for(let i=0; i<select_property_result.length; ++i){
            id = select_property_result[i].id;
            name = select_property_result[i].name;
            totalAmount = select_property_result[i].totalAmount;
            unit = select_property_result[i].unit;
            expirationDate = select_property_result[i].expirationDate;
            created_time = select_property_result[i].createdAt;
            updated_time = select_property_result[i].updatedAt;
            select_amountByPlace_sql = "select name, amount from storagePlace_"+militaryUnit+" where property_id = ?;";
            select_amountByPlace_param = id;
            [select_amountByPlace_result] = await con.query(select_amountByPlace_sql, select_amountByPlace_param);
            amountByPlace = [];
            for(let k=0; k<select_amountByPlace_result.length; ++k){
               amountByPlace.push({storagePlace:select_amountByPlace_result[k].name, amount:select_amountByPlace_result[k].amount});
            }

            select_log_sql = "select id from paymentLog_"+militaryUnit+" where property_id_arr like ? order by createdAt, log_num;";
            select_log_param = "%"+id+"%";
            [select_log_result, select_log_field] = await con.query(select_log_sql,select_log_param);
            log_arr = [];
            for(let k=0; k<select_log_result.length; ++k){
                log_arr.push(select_log_result[k].id);
            }
            var niin, category;
            var select_medicInform_sql = "select * from medicInform_"+militaryUnit+" where name = ?;";
            var select_medicInform_param = name;
            var [select_medicInform_result] = await con.query(select_medicInform_sql, select_medicInform_param);
            if(select_medicInform_result.length==0){
                res.send({status:400, message:"Bad Request", data:null});
                return;
            }
            else{
                niin = select_medicInform_result[0].niin;
                category = select_medicInform_result[0].category;
            }
            individual_data={id :id,name:name,unit:unit,totalAmount:totalAmount, amountByPlace:amountByPlace,category:category, niin:niin,expirationDate:expirationDate,logRecord:log_arr ,createdAt:created_time, updatedAt : updated_time};
            data.push(individual_data);
        }
        //res.setHeader({"accessToken":new_access_token, "refreshToken":new_refresh_token});
        //res.send({status:200, message:"Ok", data:data});
        res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:200, message:"Ok", data:data});
	}
	else{
		var data = [];
        var log_arr = [];
        var Individual_data;
        var select_log_result, select_log_field;
        var id, name, totalAmount, unit, expirationDate, created_time, updated_time, select_log_sql, select_log_param;
        for(let i=0; i<select_property_result.length; ++i){
            id = select_property_result[i].id;
            name = select_property_result[i].name;
            //totalAmount = select_property_result[i].totalAmount;
			totalAmount = 0;
            unit = select_property_result[i].unit;
            expirationDate = select_property_result[i].expirationDate;
            created_time = select_property_result[i].createdAt;
            updated_time = select_property_result[i].updatedAt;
            var select_amountByPlace_sql = "select name, amount from storagePlace_"+militaryUnit+" where property_id = ? and name = ?;";
            var select_amountByPlace_param = [id, storagePlace];
            var [select_amountByPlace_result] = await con.query(select_amountByPlace_sql, select_amountByPlace_param);
			if(select_amountByPlace_result.length==0) continue;
            var amountByPlace = [];
            for(let k=0; k<select_amountByPlace_result.length; ++k){
			   totalAmount+=select_amountByPlace_result[k].amount;
               amountByPlace.push({storagePlace:select_amountByPlace_result[k].name, amount:select_amountByPlace_result[k].amount});
            }
			
			var select_log_sql = "select id, property_id_arr, storagePlace_arr from paymentLog_"+militaryUnit+" where property_id_arr like ? and storagePlace_arr like ?  order by createdAt, log_num;";
            var select_log_param =["%"+id+"%", "%"+storagePlace+"%"];
            var select_log_by_target_sql = "select id, receiptPayment from paymentLog_"+militaryUnit+" where target = ? and property_id_arr like ?;";
            var select_log_by_target_param = [storagePlace, "%"+id+"%"];
            const [select_log_result] = await con.query(select_log_sql,select_log_param);
            const [select_log_by_target_result] = await con.query(select_log_by_target_sql,select_log_by_target_param);
            if(select_log_result.length==0&&select_log_by_target_result.length==0){	//한개는 무조건 있어야함
                res.send({status:400, message:'Bad Request', data:null});
                return;
            }
            var log_arr = [];
            var string_property_id_arr, string_storagePlace_arr;
            for(let j=0; j<select_log_result.length; ++j){
                //log_arr.push(select_log_result[j].id);
                //console.log(string_property_id_arr+"   "+string_storagePlace_arr);
                string_property_id_arr = select_log_result[j].property_id_arr;
                string_storagePlace_arr = select_log_result[j].storagePlace_arr;
                //console.log(select_log_result[k].id+"  "+string_property_id_arr+"   "+string_storagePlace_arr);
                var property_id_arr = string_property_id_arr.split('/');
                var storagePlace_arr = string_storagePlace_arr.split('/');
                for(let k=0; k<property_id_arr.length; ++k){
                    if(storagePlace_arr[k]==storagePlace&&property_id_arr[k]==id){
                        log_arr.push(select_log_result[j].id);
                        break;
                    }
                }
            }
            for(let j=0; j<select_log_by_target_result.length; ++j){
                if(select_log_by_target_result[j].receiptPayment=="이동"){
                    log_arr.push(select_log_by_target_result[j].id);
                }
            }
/*
            select_log_sql = "select id from paymentLog_"+militaryUnit+" where property_id_arr like ? order by createdAt, log_num;";
            select_log_param = "%"+id+"%";
            [select_log_result, select_log_field] = await con.query(select_log_sql,select_log_param);
            log_arr = [];
            for(let k=0; k<select_log_result.length; ++k){
                log_arr.push(select_log_result[k].id);
            }
*/
            var niin, category;
            var select_medicInform_sql = "select * from medicInform_"+militaryUnit+" where name = ?;";
            var select_medicInform_param = name;
            var [select_medicInform_result] = await con.query(select_medicInform_sql, select_medicInform_param);
            if(select_medicInform_result.length==0){
                res.send({status:400, message:"Bad Request", data:null});
                return;
            }
            else{
                niin = select_medicInform_result[0].niin;
                category = select_medicInform_result[0].category;
            }
            individual_data={id :id,name:name,unit:unit,totalAmount:totalAmount, amountByPlace:amountByPlace,category:category, niin:niin,expirationDate:expirationDate,logRecord:log_arr ,createdAt:created_time, updatedAt : updated_time};
            data.push(individual_data);
        }
        //res.setHeader({"accessToken":new_access_token, "refreshToken":new_refresh_token});
        //res.send({status:200, message:"Ok", data:data});
        res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:200, message:"Ok", data:data});
	}
	//var data = {};
    //res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:200, message:"Ok", data:data});
});


router.get('/expirationDate', async function(req, res, next) {
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Credentials", "true");
    res.setHeader("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
    res.setHeader("Access-Control-Allow-Headers", "Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers");
	res.setHeader("Access-Control-Expose-Headers","*");
	
	const accessToken = req.header('accessToken');
    const refreshToken = req.header('refreshToken');
    if (accessToken == null || refreshToken==null) {
        res.send({status:400, message:"토큰없음", data:null});
        return;
    }
    //console.log(accessToken+"  "+id);
    var verify_success = await verify.verifyFunction(accessToken,refreshToken);
    if(!verify_success.success){
        res.send({status:400, message:verify_success.message, data:null});
        return;
    }
    var new_access_token = verify_success.accessToken;
    var new_refresh_token = verify_success.refreshToken;
    var user_id = verify_success.id;

/*
    const accessToken = req.header('accessToken');
    const refreshToken = req.header('refreshToken');
    if (accessToken == null || refreshToken==null) {
        res.send({status:400, message:"토큰없음", data:null});
        return;
    }
    var verify_success = await verify.verifyFunction(accessToken,refreshToken,user_id);
    if(!verify_success.success){
        res.send({status:400, message:verify_success.message, data:null});
        return;
    }
    var new_access_token = verify_success.accessToken;
    var new_refresh_token = verify_success.refreshToken;
*/
    con = await db.createConnection(inform);
    const check_militaryUnit = "select militaryUnit from user where id = ?;";
    const check_militaryUnit_param = user_id;
    const [check_militaryUnit_result] = await con.query(check_militaryUnit, check_militaryUnit_param);
    if(check_militaryUnit_result.length==0){
        res.send({status:400, message:'Bad Request', data:null});
        return;
    }
    var militaryUnit = check_militaryUnit_result[0].militaryUnit;
    var category = req.params.category;

    ////////////////
//////내용
    ///////////////
    var select_distinct_expirationDate_sql = "select distinct(expirationDate) from property_"+militaryUnit+" order by expirationDate;";
    var [select_distinct_expirationDate_result] = await con.query(select_distinct_expirationDate_sql);
    if(select_distinct_expirationDate_result.length==0){
        res.send({status:200, message:'검색결과가 없습니다', data:null});
        return;
    }
    var data = [];
    for(let index = 0; index<select_distinct_expirationDate_result.length; ++index){
        var expirationDate = select_distinct_expirationDate_result[index].expirationDate;
        var select_expirationDate_sql = "select * from property_"+militaryUnit+" where expirationDate = ?;";
        var select_expirationDate_param = expirationDate;
        var [select_expirationDate_result] = await con.query(select_expirationDate_sql, select_expirationDate_param);
        if(select_expirationDate_result.length==0){
            res.send({status:200, message:'검색결과가 없습니다', data:null});
            return;
        }
        var individual_data_arr = [];
        for(let i=0; i<select_expirationDate_result.length; ++i){
            var property_id = select_expirationDate_result[i].id;
            var property_name = select_expirationDate_result[i].name;
            var property_totalAmount = select_expirationDate_result[i].totalAmount;
            var property_unit = select_expirationDate_result[i].unit;
            var property_category = select_expirationDate_result[i].category;
            var property_createdAt = select_expirationDate_result[i].createdAt;
            var property_updatedAt = select_expirationDate_result[i].updatedAt;
            var amountByPlace = [];
            var select_amountByPlace_sql = "select name, amount from storagePlace_"+militaryUnit+" where property_id = ?;";
            var select_amountByPlace_param = property_id;
            const[select_amountByPlace_result] = await con.query(select_amountByPlace_sql, select_amountByPlace_param);
            if(select_amountByPlace_result.length==0){
                res.send({status:400, message:"Bad Request"});
                return;
            }
            for(let j=0; j<select_amountByPlace_result.length; ++j){
                amountByPlace.push({storagePlace:select_amountByPlace_result[j].name, amount:select_amountByPlace_result[j].amount});
            }
            var select_log_sql = "select id from paymentLog_"+militaryUnit+" where property_id_arr like ? order by createdAt, log_num;";
            var select_log_param = "%"+property_id+"%";
            const [select_log_result, select_log_field] = await con.query(select_log_sql,select_log_param);
            if(select_log_result.length==0){
                console.log("위");
                res.send({status:400, message:'Bad Request', data:null});
                return;
            }
            var log_arr = [];
            //console.log(select_log_result);
            for(let j=0; j<select_log_result.length; ++j){
                log_arr.push(select_log_result[j].id);
            }
            var niin;
            var select_medicInform_sql = "select * from medicInform_"+militaryUnit+" where name = ?;";
            var select_medicInform_param = property_name;
            var [select_medicInform_result] = await con.query(select_medicInform_sql, select_medicInform_param);
            if(select_medicInform_result.length==0){
                console.log("밑");
                res.send({status:400, message:"Bad Request", data:null});
                return;
            }
            niin = select_medicInform_result[0].niin;
            var individual_individual_data = {id:property_id, name:property_name, unit:property_unit, totalAmount:property_totalAmount, category:property_category, niin:niin ,amountByPlace:amountByPlace, expirationDate:expirationDate, logRecord:log_arr, createdAt:property_createdAt, updatedAt:property_updatedAt};
            individual_data_arr.push(individual_individual_data);
        }
        var individual_data = {expirationDate:expirationDate, individualData:individual_data_arr};
        data.push(individual_data);
    }
    res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:200, message:"Ok", data:data});
});


router.get('/expirationDate/:expirationDate', async function(req, res, next) {
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Credentials", "true");
    res.setHeader("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
    res.setHeader("Access-Control-Allow-Headers", "Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers");
	res.setHeader("Access-Control-Expose-Headers","*");

	const accessToken = req.header('accessToken');
    const refreshToken = req.header('refreshToken');
    if (accessToken == null || refreshToken==null) {
        res.send({status:400, message:"토큰없음", data:null});
        return;
    }
    //console.log(accessToken+"  "+id);
    var verify_success = await verify.verifyFunction(accessToken,refreshToken);
    if(!verify_success.success){
        res.send({status:400, message:verify_success.message, data:null});
        return;
    }
    var new_access_token = verify_success.accessToken;
    var new_refresh_token = verify_success.refreshToken;
    var user_id = verify_success.id;
/*
    const accessToken = req.header('accessToken');
    const refreshToken = req.header('refreshToken');
    if (accessToken == null || refreshToken==null) {
        res.send({status:400, message:"토큰없음", data:null});
        return;
    }
    var verify_success = await verify.verifyFunction(accessToken,refreshToken,user_id);
    if(!verify_success.success){
        res.send({status:400, message:verify_success.message, data:null});
        return;
    }
    var new_access_token = verify_success.accessToken;
    var new_refresh_token = verify_success.refreshToken;
*/
    con = await db.createConnection(inform);
    const check_militaryUnit = "select militaryUnit from user where id = ?;";
    const check_militaryUnit_param = user_id;
    const [check_militaryUnit_result] = await con.query(check_militaryUnit, check_militaryUnit_param);
    if(check_militaryUnit_result.length==0){
        res.send({status:400, message:'Bad Request', data:null});
        return;
    }
    var militaryUnit = check_militaryUnit_result[0].militaryUnit;
    var expirationDate = req.params.expirationDate;

    ////////////////
//////내용
    ///////////////
    var select_expirationDate_sql = "select * from property_"+militaryUnit+" where expirationDate = ?;";
    var select_expirationDate_param = expirationDate;
    var [select_expirationDate_result] = await con.query(select_expirationDate_sql, select_expirationDate_param);
    if(select_expirationDate_result.length==0){
        res.send({status:200, message:'검색결과가 없습니다', data:null});
        return;
    }
    var data = [];
    for(let i=0; i<select_expirationDate_result.length; ++i){
        var property_id = select_expirationDate_result[i].id;
        var property_name = select_expirationDate_result[i].name;
        var property_totalAmount = select_expirationDate_result[i].totalAmount;
        var property_unit = select_expirationDate_result[i].unit;
        var property_category = select_expirationDate_result[i].category;
        var property_createdAt = select_expirationDate_result[i].createdAt;
        var property_updatedAt = select_expirationDate_result[i].updatedAt;
        var amountByPlace = [];
        var select_amountByPlace_sql = "select name, amount from storagePlace_"+militaryUnit+" where property_id = ?;";
        var select_amountByPlace_param = property_id;
        const[select_amountByPlace_result] = await con.query(select_amountByPlace_sql, select_amountByPlace_param);
        if(select_amountByPlace_result.length==0){
            res.send({status:400, message:"Bad Request"});
            return;
        }
        for(let j=0; j<select_amountByPlace_result.length; ++j){
            amountByPlace.push({storagePlace:select_amountByPlace_result[j].name, amount:select_amountByPlace_result[j].amount});
        }
        var select_log_sql = "select id from paymentLog_"+militaryUnit+" where property_id_arr like ? order by createdAt, log_num;";
        var select_log_param = "%"+property_id+"%";
        const [select_log_result, select_log_field] = await con.query(select_log_sql,select_log_param);
        if(select_log_result.length==0){
            console.log("위");
            res.send({status:400, message:'Bad Request', data:null});
            return;
        }
        var log_arr = [];
            //console.log(select_log_result);
        for(let j=0; j<select_log_result.length; ++j){
            log_arr.push(select_log_result[j].id);
        }
        var niin;
        var select_medicInform_sql = "select * from medicInform_"+militaryUnit+" where name = ?;";
        var select_medicInform_param = property_name;
        var [select_medicInform_result] = await con.query(select_medicInform_sql, select_medicInform_param);
        if(select_medicInform_result.length==0){
            console.log("밑");
            res.send({status:400, message:"Bad Request", data:null});
            return;
        }
        niin = select_medicInform_result[0].niin;
        var individual_data = {id:property_id, name:property_name, unit:property_unit, totalAmount:property_totalAmount, category:property_category, niin:niin ,amountByPlace:amountByPlace, expirationDate:expirationDate, logRecord:log_arr, createdAt:property_createdAt, updatedAt:property_updatedAt};

        data.push(individual_data);

    }
    res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:200, message:"Ok", data:data});
});


router.get('/category', async function(req, res, next) {
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Credentials", "true");
    res.setHeader("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
    res.setHeader("Access-Control-Allow-Headers", "Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers");
	res.setHeader("Access-Control-Expose-Headers","*");

	const accessToken = req.header('accessToken');
    const refreshToken = req.header('refreshToken');
    if (accessToken == null || refreshToken==null) {
        res.send({status:400, message:"토큰없음", data:null});
        return;
    }
    //console.log(accessToken+"  "+id);
    var verify_success = await verify.verifyFunction(accessToken,refreshToken);
    if(!verify_success.success){
        res.send({status:400, message:verify_success.message, data:null});
        return;
    }
    var new_access_token = verify_success.accessToken;
    var new_refresh_token = verify_success.refreshToken;
    var user_id = verify_success.id;
/*
    const accessToken = req.header('accessToken');
    const refreshToken = req.header('refreshToken');
    if (accessToken == null || refreshToken==null) {
        res.send({status:400, message:"토큰없음", data:null});
        return;
    }
    var verify_success = await verify.verifyFunction(accessToken,refreshToken,user_id);
    if(!verify_success.success){
        res.send({status:400, message:verify_success.message, data:null});
        return;
    }
    var new_access_token = verify_success.accessToken;
    var new_refresh_token = verify_success.refreshToken;
*/
    con = await db.createConnection(inform);
    const check_militaryUnit = "select militaryUnit from user where id = ?;";
    const check_militaryUnit_param = user_id;
    const [check_militaryUnit_result] = await con.query(check_militaryUnit, check_militaryUnit_param);
    if(check_militaryUnit_result.length==0){
        res.send({status:400, message:'Bad Request', data:null});
        return;
    }
    var militaryUnit = check_militaryUnit_result[0].militaryUnit;
    var category = req.params.category;

    ////////////////
//////내용
    ///////////////
	var select_distinct_category_sql = "select distinct(category) from property_"+militaryUnit+";";
	var [select_distinct_category_result] = await con.query(select_distinct_category_sql);
	if(select_distinct_category_result.length==0){
		res.send({status:200, message:'검색결과가 없습니다', data:null});
        return;
	}
	var data = [];
	for(let index = 0; index<select_distinct_category_result.length; ++index){
		var category = select_distinct_category_result[index].category;
		var select_category_sql = "select * from property_"+militaryUnit+" where category = ?;";
    	var select_category_param = category;
    	var [select_category_result] = await con.query(select_category_sql, select_category_param);
    	if(select_category_result.length==0){
        	res.send({status:200, message:'검색결과가 없습니다', data:null});
        	return;
    	}
		var individual_data_arr = [];
    	for(let i=0; i<select_category_result.length; ++i){
        	var property_id = select_category_result[i].id;
        	var property_name = select_category_result[i].name;
        	var property_totalAmount = select_category_result[i].totalAmount;
        	var property_unit = select_category_result[i].unit;
        	var property_expirationDate = select_category_result[i].expirationDate;
        	var property_createdAt = select_category_result[i].createdAt;
        	var property_updatedAt = select_category_result[i].updatedAt;
        	var amountByPlace = [];
        	var select_amountByPlace_sql = "select name, amount from storagePlace_"+militaryUnit+" where property_id = ?;";
        	var select_amountByPlace_param = property_id;
        	const[select_amountByPlace_result] = await con.query(select_amountByPlace_sql, select_amountByPlace_param);
        	if(select_amountByPlace_result.length==0){
            	res.send({status:400, message:"Bad Request"});
            	return;
        	}
        	for(let j=0; j<select_amountByPlace_result.length; ++j){
            	amountByPlace.push({storagePlace:select_amountByPlace_result[j].name, amount:select_amountByPlace_result[j].amount});
        	}
        	var select_log_sql = "select id from paymentLog_"+militaryUnit+" where property_id_arr like ? order by createdAt, log_num;";
        	var select_log_param = "%"+property_id+"%";
        	const [select_log_result, select_log_field] = await con.query(select_log_sql,select_log_param);
        	if(select_log_result.length==0){
            	console.log("위");
            	res.send({status:400, message:'Bad Request', data:null});
            	return;
        	}
        	var log_arr = [];
            //console.log(select_log_result);
        	for(let j=0; j<select_log_result.length; ++j){
            	log_arr.push(select_log_result[j].id);
        	}
        	var niin;
        	var select_medicInform_sql = "select * from medicInform_"+militaryUnit+" where name = ?;";
        	var select_medicInform_param = property_name;
        	var [select_medicInform_result] = await con.query(select_medicInform_sql, select_medicInform_param);
        	if(select_medicInform_result.length==0){
            	console.log("밑");
            	res.send({status:400, message:"Bad Request", data:null});
            	return;
        	}
        	niin = select_medicInform_result[0].niin;
        	var individual_individual_data = {id:property_id, name:property_name, unit:property_unit, totalAmount:property_totalAmount, category:category, niin:niin ,amountByPlace:amountByPlace, expirationDate:property_expirationDate, logRecord:log_arr, createdAt:property_createdAt, updatedAt:property_updatedAt};
			individual_data_arr.push(individual_individual_data);
    	}
		var individual_data = {category:category, individualData:individual_data_arr};
		data.push(individual_data);
    }
    res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:200, message:"Ok", data:data});
});


router.get('/category/:category', async function(req, res, next) {
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Credentials", "true");
    res.setHeader("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
    res.setHeader("Access-Control-Allow-Headers", "Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers");
	res.setHeader("Access-Control-Expose-Headers","*");

	const accessToken = req.header('accessToken');
    const refreshToken = req.header('refreshToken');
    if (accessToken == null || refreshToken==null) {
        res.send({status:400, message:"토큰없음", data:null});
        return;
    }
    //console.log(accessToken+"  "+id);
    var verify_success = await verify.verifyFunction(accessToken,refreshToken);
    if(!verify_success.success){
        res.send({status:400, message:verify_success.message, data:null});
        return;
    }
    var new_access_token = verify_success.accessToken;
    var new_refresh_token = verify_success.refreshToken;
    var user_id = verify_success.id;
/*
    const accessToken = req.header('accessToken');
    const refreshToken = req.header('refreshToken');
    if (accessToken == null || refreshToken==null) {
        res.send({status:400, message:"토큰없음", data:null});
        return;
    }
    var verify_success = await verify.verifyFunction(accessToken,refreshToken,user_id);
    if(!verify_success.success){
        res.send({status:400, message:verify_success.message, data:null});
        return;
    }
    var new_access_token = verify_success.accessToken;
    var new_refresh_token = verify_success.refreshToken;
*/
    con = await db.createConnection(inform);
    const check_militaryUnit = "select militaryUnit from user where id = ?;";
    const check_militaryUnit_param = user_id;
    const [check_militaryUnit_result] = await con.query(check_militaryUnit, check_militaryUnit_param);
    if(check_militaryUnit_result.length==0){
        res.send({status:400, message:'Bad Request', data:null});
        return;
    }
    var militaryUnit = check_militaryUnit_result[0].militaryUnit;
	var category = req.params.category;
	
    ////////////////
//////내용
    ///////////////
	var select_category_sql = "select * from property_"+militaryUnit+" where category = ?;";
	var select_category_param = category;
	var [select_category_result] = await con.query(select_category_sql, select_category_param);
	if(select_category_result.length==0){
		res.send({status:200, message:'검색결과가 없습니다', data:null});
		return;
	}
	var data = [];
	for(let i=0; i<select_category_result.length; ++i){
		var property_id = select_category_result[i].id;
		var property_name = select_category_result[i].name;
		var property_totalAmount = select_category_result[i].totalAmount;
		var property_unit = select_category_result[i].unit;
		var property_expirationDate = select_category_result[i].expirationDate;
		var property_createdAt = select_category_result[i].createdAt;
		var property_updatedAt = select_category_result[i].updatedAt;
		var amountByPlace = [];
        var select_amountByPlace_sql = "select name, amount from storagePlace_"+militaryUnit+" where property_id = ?;";
        var select_amountByPlace_param = property_id;
        const[select_amountByPlace_result] = await con.query(select_amountByPlace_sql, select_amountByPlace_param);
        if(select_amountByPlace_result.length==0){
            res.send({status:400, message:"Bad Request"});
            return;
        }
		for(let j=0; j<select_amountByPlace_result.length; ++j){
            amountByPlace.push({storagePlace:select_amountByPlace_result[j].name, amount:select_amountByPlace_result[j].amount});
        }
		var select_log_sql = "select id from paymentLog_"+militaryUnit+" where property_id_arr like ? order by createdAt, log_num;";
        var select_log_param = "%"+property_id+"%";
        const [select_log_result, select_log_field] = await con.query(select_log_sql,select_log_param);
		if(select_log_result.length==0){
			console.log("위");
			res.send({status:400, message:'Bad Request', data:null});
        	return;
		}
		var log_arr = [];
            //console.log(select_log_result);
        for(let j=0; j<select_log_result.length; ++j){
            log_arr.push(select_log_result[j].id);
        }
        var niin;
        var select_medicInform_sql = "select * from medicInform_"+militaryUnit+" where name = ?;";
        var select_medicInform_param = property_name;
        var [select_medicInform_result] = await con.query(select_medicInform_sql, select_medicInform_param);
        if(select_medicInform_result.length==0){
			console.log("밑");
            res.send({status:400, message:"Bad Request", data:null});
            return;
        }
        niin = select_medicInform_result[0].niin;
		var individual_data = {id:property_id, name:property_name, unit:property_unit, totalAmount:property_totalAmount, category:category, niin:niin ,amountByPlace:amountByPlace, expirationDate:property_expirationDate, logRecord:log_arr, createdAt:property_createdAt, updatedAt:property_updatedAt};

		data.push(individual_data);

	}
    res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:200, message:"Ok", data:data});
});


router.get('/storagePlace', async function(req, res, next) {
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Credentials", "true");
    res.setHeader("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
    res.setHeader("Access-Control-Allow-Headers", "Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers");
	res.setHeader("Access-Control-Expose-Headers","*");

	const accessToken = req.header('accessToken');
    const refreshToken = req.header('refreshToken');
    if (accessToken == null || refreshToken==null) {
        res.send({status:400, message:"토큰없음", data:null});
        return;
    }
    //console.log(accessToken+"  "+id);
    var verify_success = await verify.verifyFunction(accessToken,refreshToken);
    if(!verify_success.success){
        res.send({status:400, message:verify_success.message, data:null});
        return;
    }
    var new_access_token = verify_success.accessToken;
    var new_refresh_token = verify_success.refreshToken;
    var user_id = verify_success.id;
/*
    const user_id = req.body.id;        /////////////////////////////////////////////////////// //무슨 id인지 고치기
    const accessToken = req.header('accessToken');
    const refreshToken = req.header('refreshToken');
    if (accessToken == null || refreshToken==null) {
        res.send({status:400, message:"토큰없음", data:null});
        return;
    }
    var verify_success = await verify.verifyFunction(accessToken,refreshToken,user_id);
    if(!verify_success.success){
        res.send({status:400, message:verify_success.message, data:null});
        return;
    }
    var new_access_token = verify_success.accessToken;
    var new_refresh_token = verify_success.refreshToken;
*/
    con = await db.createConnection(inform);
    const check_militaryUnit = "select militaryUnit from user where id = ?;";
    const check_militaryUnit_param = user_id;
    const [check_militaryUnit_result] = await con.query(check_militaryUnit, check_militaryUnit_param);
    if(check_militaryUnit_result.length==0){
        res.send({status:400, message:'Bad Request', data:null});
        return;
    }
    var militaryUnit = check_militaryUnit_result[0].militaryUnit;
	var select_distinct_storagePlace_sql = "select distinct(name) from storagePlace_"+militaryUnit+";";
    var [select_distinct_storagePlace_result] = await con.query(select_distinct_storagePlace_sql);
	if(select_distinct_storagePlace_result.length==0){
		res.send({status:200, message:'검색결과가 없습니다', data:null});
		return;
	}
	var storagePlace;
	var data = [];
	var individual_data;
	for(let index=0; index<select_distinct_storagePlace_result.length; ++index){
		storagePlace = select_distinct_storagePlace_result[index].name;
		var select_storagePlace_sql = "select * from storagePlace_"+militaryUnit+" where name = ?;";
    	var select_storagePlace_param = storagePlace;
    	var [select_storagePlace_result] = await con.query(select_storagePlace_sql, select_storagePlace_param);
    	if(select_storagePlace_result.length==0){
        	res.send({status:200, message:'검색결과가 없습니다', data:null});
			return;
    	}
        var property_id,storagePlace_id,storagePlace_name, amount, unit;
        var property_name, property_expirationDate, proeprty_createdAt, proeprty_updatedAt;
        var medicInform_category, medicInform_niin;
        var	individual_data_arr = [];
	    var individual_individual_data;
       	for(let i=0; i<select_storagePlace_result.length; ++i){
            property_id = select_storagePlace_result[i].property_id;
           	storagePlace_id = select_storagePlace_result[i].id;
           	storagePlace_name = storagePlace;
           	amount = select_storagePlace_result[i].amount;
           	unit = select_storagePlace_result[i].unit;

           	var select_property_sql = "select * from property_"+militaryUnit+" where id = ?;";
           	var select_property_param = property_id;
           	var [select_property_result] = await con.query(select_property_sql, select_property_param);
           	if(select_property_result.length==0){
               	res.send({status:400, message:'Bad Request', data:null});
               	return;
           	}
           	property_name = select_property_result[0].name;
           	property_expirationDate = select_property_result[0].expirationDate;
           	property_createdAt = select_property_result[0].createdAt;
           	property_updatedAt = select_property_result[0].updatedAt;
           	var select_medicInform_sql = "select * from medicInform_"+militaryUnit+" where name = ?;";
           	var select_medicInform_param = property_name;
           	var [select_medicInform_result] = await con.query(select_medicInform_sql, select_medicInform_param);
           	if(select_medicInform_result.length==0){
               	res.send({status:400, message:'Bad Request', data:null});
               	return;
           	}
           	medicInform_category = select_medicInform_result[0].category;
           	medicInform_niin = select_medicInform_result[0].niin;
           	var select_log_sql = "select id, property_id_arr, storagePlace_arr from paymentLog_"+militaryUnit+" where property_id_arr like ? and storagePlace_arr like ?  order by createdAt, log_num;";
           	var select_log_param =["%"+property_id+"%", "%"+storagePlace+"%"];
           	var select_log_by_target_sql = "select id, receiptPayment from paymentLog_"+militaryUnit+" where target = ? and property_id_arr like ?;";
           	var select_log_by_target_param = [storagePlace, "%"+property_id+"%"];
           	const [select_log_result] = await con.query(select_log_sql,select_log_param);
           	const [select_log_by_target_result] = await con.query(select_log_by_target_sql,select_log_by_target_param);
           	if(select_log_result.length==0&&select_log_by_target_result.length==0){
               	res.send({status:400, message:'Bad Request', data:null});
               	return;
           	}
           	var log_arr = [];
           	var string_property_id_arr, string_storagePlace_arr;
           	for(let j=0; j<select_log_result.length; ++j){
                //log_arr.push(select_log_result[j].id);
                //console.log(string_property_id_arr+"   "+string_storagePlace_arr);
               	string_property_id_arr = select_log_result[j].property_id_arr;
               	string_storagePlace_arr = select_log_result[j].storagePlace_arr;
                //console.log(select_log_result[k].id+"  "+string_property_id_arr+"   "+string_storagePlace_arr);
               	var property_id_arr = string_property_id_arr.split('/');
               	var storagePlace_arr = string_storagePlace_arr.split('/');
               	for(let k=0; k<property_id_arr.length; ++k){
                   	if(storagePlace_arr[k]==storagePlace&&property_id_arr[k]==property_id){
                       	log_arr.push(select_log_result[j].id);
                       	break;
                   	}
               	}
           	}
           	for(let j=0; j<select_log_by_target_result.length; ++j){
               	if(select_log_by_target_result[j].receiptPayment=="이동"){
                   	log_arr.push(select_log_by_target_result[j].id);
               	}
           	}

           	individual_individual_data={propertyId :property_id,propertyName:property_name,unit:unit,amount:amount, category:medicInform_category, niin:medicInform_niin,expirationDate:property_expirationDate,logRecord:log_arr,createdAt:property_createdAt, updatedAt : property_updatedAt};
            //individual_data={propertyId :property_id,propertyName:property_name,unit:unit,amount:amount, category:medicInform_category, niin:medicInform_niin,expirationDate:property_expirationDate,createdAt:property_createdAt, updatedAt : property_updatedAt};
           	individual_data_arr.push(individual_individual_data);
		}
		individual_data = {name:storagePlace, individualData:individual_data_arr};
		data.push(individual_data);
	}
	res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:200, message:'Ok', data:data});
});


router.get('/storagePlace/:storagePlace', async function(req, res, next) {
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Credentials", "true");
    res.setHeader("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
    res.setHeader("Access-Control-Allow-Headers", "Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers");
	res.setHeader("Access-Control-Expose-Headers","*");

	const accessToken = req.header('accessToken');
    const refreshToken = req.header('refreshToken');
    if (accessToken == null || refreshToken==null) {
        res.send({status:400, message:"토큰없음", data:null});
        return;
    }
    //console.log(accessToken+"  "+id);
    var verify_success = await verify.verifyFunction(accessToken,refreshToken);
    if(!verify_success.success){
        res.send({status:400, message:verify_success.message, data:null});
        return;
    }
    var new_access_token = verify_success.accessToken;
    var new_refresh_token = verify_success.refreshToken;
    var user_id = verify_success.id;
/*
    const accessToken = req.header('accessToken');
    const refreshToken = req.header('refreshToken');
    if (accessToken == null || refreshToken==null) {
        res.send({status:400, message:"토큰없음", data:null});
        return;
    }
    var verify_success = await verify.verifyFunction(accessToken,refreshToken,user_id);
    if(!verify_success.success){
        res.send({status:400, message:verify_success.message, data:null});
        return;
    }
    var new_access_token = verify_success.accessToken;
    var new_refresh_token = verify_success.refreshToken;
*/
    con = await db.createConnection(inform);
    const check_militaryUnit = "select militaryUnit from user where id = ?;";
    const check_militaryUnit_param = user_id;
    const [check_militaryUnit_result] = await con.query(check_militaryUnit, check_militaryUnit_param);
    if(check_militaryUnit_result.length==0){
        res.send({status:400, message:'Bad Request', data:null});
        return;
    }
    var militaryUnit = check_militaryUnit_result[0].militaryUnit;
	var storagePlace = req.params.storagePlace;
	var select_storagePlace_sql = "select * from storagePlace_"+militaryUnit+" where name = ?;";
	var select_storagePlace_param = storagePlace;
	var [select_storagePlace_result] = await con.query(select_storagePlace_sql, select_storagePlace_param);
	if(select_storagePlace_result.length==0){
		res.send({status:200, message:'검색결과가 없습니다', data:null});
	}
	else{
		var property_id,storagePlace_id,storagePlace_name, amount, unit;
		var property_name, property_expirationDate, proeprty_createdAt, proeprty_updatedAt;
		var medicInform_category, medicInform_niin;
		var data = [];
		var individual_data;
		for(let i=0; i<select_storagePlace_result.length; ++i){
			property_id = select_storagePlace_result[i].property_id;
			storagePlace_id = select_storagePlace_result[i].id;
			storagePlace_name = storagePlace;
			amount = select_storagePlace_result[i].amount;
			unit = select_storagePlace_result[i].unit;
			
			var select_property_sql = "select * from property_"+militaryUnit+" where id = ?;";
			var select_property_param = property_id;
			var [select_property_result] = await con.query(select_property_sql, select_property_param);
			if(select_property_result.length==0){
				res.send({status:400, message:'Bad Request', data:null});
        		return;
			}
			property_name = select_property_result[0].name;
			property_expirationDate = select_property_result[0].expirationDate;
			property_createdAt = select_property_result[0].createdAt;
			property_updatedAt = select_property_result[0].updatedAt;
			var select_medicInform_sql = "select * from medicInform_"+militaryUnit+" where name = ?;";
            var select_medicInform_param = property_name;
            var [select_medicInform_result] = await con.query(select_medicInform_sql, select_medicInform_param);
			if(select_medicInform_result.length==0){
                res.send({status:400, message:'Bad Request', data:null});
                return;
            }
			medicInform_category = select_medicInform_result[0].category;
			medicInform_niin = select_medicInform_result[0].niin;
			var select_log_sql = "select id, property_id_arr, storagePlace_arr from paymentLog_"+militaryUnit+" where property_id_arr like ? and storagePlace_arr like ?  order by createdAt, log_num;";
			var select_log_param =["%"+property_id+"%", "%"+storagePlace+"%"];
			var select_log_by_target_sql = "select id, receiptPayment from paymentLog_"+militaryUnit+" where target = ? and property_id_arr like ?;";
			var select_log_by_target_param = [storagePlace, "%"+property_id+"%"];
        	const [select_log_result] = await con.query(select_log_sql,select_log_param);
			const [select_log_by_target_result] = await con.query(select_log_by_target_sql,select_log_by_target_param);
			if(select_log_result.length==0&&select_log_by_target_result.length==0){
				res.send({status:400, message:'Bad Request', data:null});
                return;
			}
			var log_arr = [];
			var string_property_id_arr, string_storagePlace_arr;
			for(let j=0; j<select_log_result.length; ++j){
				//log_arr.push(select_log_result[j].id);
				//console.log(string_property_id_arr+"   "+string_storagePlace_arr);
					string_property_id_arr = select_log_result[j].property_id_arr;
                	string_storagePlace_arr = select_log_result[j].storagePlace_arr;
                //console.log(select_log_result[k].id+"  "+string_property_id_arr+"   "+string_storagePlace_arr);
                	var property_id_arr = string_property_id_arr.split('/');
                	var storagePlace_arr = string_storagePlace_arr.split('/');
                	for(let k=0; k<property_id_arr.length; ++k){
                    	if(storagePlace_arr[k]==storagePlace&&property_id_arr[k]==property_id){
                        	log_arr.push(select_log_result[j].id);
                        	break;
                    	}
                	}
/*
				string_property_id_arr = select_log_result[j].property_id_arr;
				string_storagePlace_arr = select_log_result[j].storagePlace_arr;
				//console.log(select_log_result[k].id+"  "+string_property_id_arr+"   "+string_storagePlace_arr);
				var property_id_arr = string_property_id_arr.split('/');
				var storagePlace_arr = string_storagePlace_arr.split('/');
				for(let k=0; k<property_id_arr.length; ++k){
					if(storagePlace_arr[k]==storagePlace&&property_id_arr[k]==property_id){
						log_arr.push(select_log_result[j].id);
						break;
					}
				}
*/
			}
			for(let j=0; j<select_log_by_target_result.length; ++j){
				if(select_log_by_target_result[j].receiptPayment=="이동"){
					log_arr.push(select_log_by_target_result[j].id);
				}			
			}

			individual_data={propertyId :property_id,propertyName:property_name,unit:unit,amount:amount, category:medicInform_category, niin:medicInform_niin,expirationDate:property_expirationDate,logRecord:log_arr,createdAt:property_createdAt, updatedAt : property_updatedAt};
			//individual_data={propertyId :property_id,propertyName:property_name,unit:unit,amount:amount, category:medicInform_category, niin:medicInform_niin,expirationDate:property_expirationDate,createdAt:property_createdAt, updatedAt : property_updatedAt};
			data.push(individual_data);
		}
		
        res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:200, message:'Ok', data:data});
    	
	}
    ////////////////
//////내용
    ///////////////
    //res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:200, message:"Ok", data:data});
});


router.get('/', async function(req, res, next) {
	res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Credentials", "true");
    res.setHeader("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
    res.setHeader("Access-Control-Allow-Headers", "Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers");
	res.setHeader("Access-Control-Expose-Headers","*");
    console.log("show-PAGE");
	
	const accessToken = req.header('accessToken');
    const refreshToken = req.header('refreshToken');
    if (accessToken == null || refreshToken==null) {
        res.send({status:400, message:"토큰없음", data:null});
        return;
    }
    //console.log(accessToken+"  "+id);
    var verify_success = await verify.verifyFunction(accessToken,refreshToken);
    if(!verify_success.success){
        res.send({status:400, message:verify_success.message, data:null});
        return;
    }
    var new_access_token = verify_success.accessToken;
    var new_refresh_token = verify_success.refreshToken;
    var user_id = verify_success.id;
/*
	const user_id = req.body.id;
    const accessToken = req.header('accessToken');
    const refreshToken = req.header('refreshToken');
    if (accessToken == null || refreshToken==null) {
        res.send({status:400, message:"토큰없음", data:null});
        return;
    }
    //console.log(accessToken+"  "+id);
    var verify_success = await verify.verifyFunction(accessToken,refreshToken,user_id);
    if(!verify_success.success){
        res.send({status:400, message:verify_success.message, data:null});
        return;
    }
    var new_access_token = verify_success.accessToken;
    var new_refresh_token = verify_success.refreshToken;
*/
/*   
	 const accessToken = req.header('Authorization');
    if (accessToken == null) {
        res.send({status:400, message:'Bad Request', data:null});
        return;
    }
    var verify_success = await verify.verifyFunction(accessToken, user_id);
    if(!verify_success){
        res.send({status:400, message:'Bad Request', data:null});
        return;
    }
*/
    con = await db.createConnection(inform);
	const check_militaryUnit = "select militaryUnit from user where id = ?;";
    const check_militaryUnit_param = user_id;
    const [check_militaryUnit_result] = await con.query(check_militaryUnit, check_militaryUnit_param);
    if(check_militaryUnit_result.length==0){
        res.send({status:400, message:'Bad Request', data:null});
        return;
    }
    var militaryUnit = check_militaryUnit_result[0].militaryUnit;
    var select_property_sql = "select * from property_"+militaryUnit+";";
    const [select_property_result, select_property_field1] = await con.query(select_property_sql);
    if(select_property_result.length==0){
        res.send({status:400, message:"Bad Request"});
    }
    else{
		var data = [];
		var log_arr = [];
		var Individual_data;
		var select_log_result, select_log_field;
		var id, name, totalAmount, unit, expirationDate, created_time, updated_time, select_log_sql, select_log_param;
		var select_amountByPlace_sql;
        var select_amountByPlace_param;
        var select_amountByPlace_result;
		var amountByPlace;
		for(let i=0; i<select_property_result.length; ++i){
			id = select_property_result[i].id;
			name = select_property_result[i].name;
        	totalAmount = select_property_result[i].totalAmount;
        	unit = select_property_result[i].unit;
        	expirationDate = select_property_result[i].expirationDate;
        	created_time = select_property_result[i].createdAt;
        	updated_time = select_property_result[i].updatedAt;
			select_amountByPlace_sql = "select name, amount from storagePlace_"+militaryUnit+" where property_id = ?;";
        	select_amountByPlace_param = id;
        	[select_amountByPlace_result] = await con.query(select_amountByPlace_sql, select_amountByPlace_param);
			amountByPlace = [];
			for(let k=0; k<select_amountByPlace_result.length; ++k){
         	   amountByPlace.push({storagePlace:select_amountByPlace_result[k].name, amount:select_amountByPlace_result[k].amount});
        	}

        	select_log_sql = "select id from paymentLog_"+militaryUnit+" where property_id_arr like ? order by createdAt, log_num;";
        	select_log_param = "%"+id+"%";
			[select_log_result, select_log_field] = await con.query(select_log_sql,select_log_param);
			log_arr = [];
			for(let k=0; k<select_log_result.length; ++k){
                log_arr.push(select_log_result[k].id);
            }
			var niin, category;
            var select_medicInform_sql = "select * from medicInform_"+militaryUnit+" where name = ?;";
            var select_medicInform_param = name;
            var [select_medicInform_result] = await con.query(select_medicInform_sql, select_medicInform_param);
            if(select_medicInform_result.length==0){
                res.send({status:400, message:"Bad Request", data:null});
                return;
            }
            else{
                niin = select_medicInform_result[0].niin;
                category = select_medicInform_result[0].category;
            }
			individual_data={id :id,name:name,unit:unit,totalAmount:totalAmount, amountByPlace:amountByPlace,category:category, niin:niin,expirationDate:expirationDate,logRecord:log_arr ,createdAt:created_time, updatedAt : updated_time};
			data.push(individual_data);
		}
		//res.setHeader({"accessToken":new_access_token, "refreshToken":new_refresh_token});
		//res.send({status:200, message:"Ok", data:data});
		res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:200, message:"Ok", data:data});
    }
});


router.get('/:id', async function(req, res, next) {
	res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Credentials", "true");
    res.setHeader("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
    res.setHeader("Access-Control-Allow-Headers", "Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers");
	res.setHeader("Access-Control-Expose-Headers","*");
    console.log("show-PAGE");

	const accessToken = req.header('accessToken');
    const refreshToken = req.header('refreshToken');
    if (accessToken == null || refreshToken==null) {
        res.send({status:400, message:"토큰없음", data:null});
        return;
    }
    //console.log(accessToken+"  "+id);
    var verify_success = await verify.verifyFunction(accessToken,refreshToken);
    if(!verify_success.success){
        res.send({status:400, message:verify_success.message, data:null});
        return;
    }
    var new_access_token = verify_success.accessToken;
    var new_refresh_token = verify_success.refreshToken;
    var user_id = verify_success.id;

    const id = req.params.id;
/*
    const user_id = req.body.id;
    const accessToken = req.header('accessToken');
    const refreshToken = req.header('refreshToken');
    if (accessToken == null || refreshToken==null) {
        res.send({status:400, message:"토큰없음", data:null});
        return;
    }
    //console.log(accessToken+"  "+id);
    var verify_success = await verify.verifyFunction(accessToken,refreshToken,user_id);
    if(!verify_success.success){
        res.send({status:400, message:verify_success.message, data:null});
        return;
    }
    var new_access_token = verify_success.accessToken;
    var new_refresh_token = verify_success.refreshToken;
*/
/*    
	const accessToken = req.header('Authorization');
    if (accessToken == null) {
        res.send({status:400, message:'Bad Request', data:null});
        return;
    }
    var verify_success = await verify.verifyFunction(accessToken, user_id);
    if(!verify_success){
        res.send({status:400, message:'Bad Request', data:null});
        return;
    }
*/

    con = await db.createConnection(inform);
	const check_militaryUnit = "select militaryUnit from user where id = ?;";
    const check_militaryUnit_param = user_id;
    const [check_militaryUnit_result] = await con.query(check_militaryUnit, check_militaryUnit_param);
    if(check_militaryUnit_result.length==0){
        res.send({status:400, message:'Bad Request', data:null});
        return;
    }
    var militaryUnit = check_militaryUnit_result[0].militaryUnit;
    var select_property_sql = "select * from property_"+militaryUnit+" where id = ?;";
    var select_property_param = id;
    const [select_property_result, select_property_field1] = await con.query(select_property_sql,select_property_param);
    if(select_property_result.length==0){
        res.send({status:400, message:"Bad Request"});
    }
    else{
        //console.log(select_result1);
        var name = select_property_result[0].name;
        var totalAmount = select_property_result[0].totalAmount;
        var unit = select_property_result[0].unit;
        var expirationDate = select_property_result[0].expirationDate;
        var created_time = select_property_result[0].createdAt;
        var updated_time = select_property_result[0].updatedAt;
		var amountByPlace = [];
		var select_amountByPlace_sql = "select name, amount from storagePlace_"+militaryUnit+" where property_id = ?;";
		var select_amountByPlace_param = id;
		const[select_amountByPlace_result] = await con.query(select_amountByPlace_sql, select_amountByPlace_param);
		if(select_amountByPlace_result.length==0){
			res.send({status:400, message:"Bad Request"});
			return;
		}
		for(let i=0; i<select_amountByPlace_result.length; ++i){
			amountByPlace.push({storagePlace:select_amountByPlace_result[i].name, amount:select_amountByPlace_result[i].amount});
		}
		var select_log_sql = "select id from paymentLog_"+militaryUnit+" where property_id_arr like ? order by createdAt, log_num;";
        var select_log_param = "%"+id+"%";
    	const [select_log_result, select_log_field] = await con.query(select_log_sql,select_log_param);
        //console.log(created_time+" "+updated_time);
		if(select_log_result.length==0){	//재산이 있다면 로그가 없을수가 없음 절대로 
        	res.send({status:400, message:"Bad Request"});
    	}
		else{
			var log_arr = [];
			//console.log(select_log_result);
			for(let i=0; i<select_log_result.length; ++i){
				log_arr.push(select_log_result[i].id);
			}
        	var niin, category;
        	var select_medicInform_sql = "select * from medicInform_"+militaryUnit+" where name = ?;";
        	var select_medicInform_param = name;
            var [select_medicInform_result] = await con.query(select_medicInform_sql, select_medicInform_param);
            if(select_medicInform_result.length==0){
               	res.send({status:400, message:"Bad Request", data:null});
                return;
            }
            else{
                niin = select_medicInform_result[0].niin;
                category = select_medicInform_result[0].category;
            }
			var data = {id :id, name : name, unit:unit, totalAmount:totalAmount,amountByPlace:amountByPlace,category:category, niin:niin,expirationDate:expirationDate,logRecord:log_arr ,createdAt:created_time, updatedAt : updated_time};
        	res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:200, message:"Ok", data:data});	
		}
    }
});

module.exports = router;
