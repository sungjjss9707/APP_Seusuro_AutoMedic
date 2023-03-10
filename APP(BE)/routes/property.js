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

async function getLogInform(log_id_arr, militaryUnit){
    try{
		var string_id_arr = "(";
		for(let i=0; i<log_id_arr.length; ++i){
			string_id_arr+="'";
			string_id_arr+=log_id_arr[i];
			string_id_arr+="'";
			if(i!=log_id_arr.length-1){
				string_id_arr+=",";
			}
		}
		string_id_arr+=")"
		//console.log(string_id_arr);
		var select_log_sql = "select * from paymentLog_"+militaryUnit+" where id in "
		select_log_sql+=string_id_arr;
		select_log_sql+=" order by createdAt;";
        var select_log_param = string_id_arr;
        var [select_log_result] = await con.query(select_log_sql, select_log_param);
		var data = [];
        for(let i=0; i<select_log_result.length; ++i){
            var id = select_log_result[i].id;
            var receiptPayment = select_log_result[i].receiptPayment;
            var confirmor_id = select_log_result[i].confirmor_id;
            var target = select_log_result[i].target;
            var YearMonthDate = select_log_result[i].YearMonthDate;
            var log_num = select_log_result[i].log_num;
            var property_id_arr = select_log_result[i].property_id_arr;
            var storagePlace_arr = select_log_result[i].storagePlace_arr;
            var amount_arr = select_log_result[i].amount_arr;
            var unit_arr = select_log_result[i].unit_arr;
            var createdAt = select_log_result[i].createdAt;
            var updatedAt = select_log_result[i].updatedAt;
            //console.log(property_id_arr);
            //console.log(storagePlace_arr);
            //console.log(amount_arr);
            //console.log(unit_arr);
            var arr_property_id = property_id_arr.split('/');   ////////////////
            var arr_storagePlace = storagePlace_arr.split('/'); ////////////////
            var str_arr_amount = amount_arr.split('/');
            var arr_unit = unit_arr.split('/');//////////////////
            var arr_amount = [];    ////////////////////
            var arr_name = [];  ///////////////////
            var arr_expirationDate = [];    ///////////
            var len = arr_property_id.length;
            var getsu;
            for(let i=0; i<str_arr_amount.length; ++i){
                getsu = parseInt(str_arr_amount[i]);
                arr_amount.push(getsu);
            }
            var p_id;
            for(let k=0; k<arr_property_id.length; ++k){
                p_id = arr_property_id[k];
                var id_split = p_id.split('-');
                arr_name.push(id_split[0]);
                var myexpirationDate = id_split[1]+"-"+id_split[2]+"-"+id_split[3];
                arr_expirationDate.push(myexpirationDate);
            }
    ///////////////////////////////////////////////////////
            var niin_arr = [];
            var niin, category;
            var category_arr = [];
            var select_medicInform_sql = "select * from medicInform where name = ?;";
            var select_medicInform_param;
            for(let k=0; k<len; ++k){
                select_medicInform_param = arr_name[k];
                var [select_medicInform_result] = await con.query(select_medicInform_sql, select_medicInform_param);
                if(select_medicInform_result.length==0){
                    //res.send({status:500, message:'Internal Server Error', data:null});
    //                res.send({status:400, message:"Bad Request", data:null});
                    return {status:500, message:'Internal Server Error', data:null};
                }
                else{
                    niin = select_medicInform_result[0].niin;
                    category = select_medicInform_result[0].category;
                }
                niin_arr.push(niin);
                category_arr.push(category);
            }
    ///////////////////////////////////////////////////////
            var items = [];
            var individual_item;
            for(let k=0; k<len; ++k){
                ///////////////////////////////////////////////////////////////////////////////
                individual_item = {name:arr_name[k], amount:arr_amount[k], unit:arr_unit[k],category:category_arr[k], niin:niin_arr[k] , storagePlace:arr_storagePlace[k], expirationDate:arr_expirationDate[k]};
                items.push(individual_item);
            }
            var select_user_sql = "select * from user where id = ?;";
            var select_user_param = confirmor_id;
            const [select_user_result, select_user_field] = await con.query(select_user_sql, select_user_param);
            if(select_user_result.length==0){
                //res.send({status:500, message:'Internal Server Error', data:null});
                return {status:500, message:'Internal Server Error', data:null};
    //            res.send({status:400, message:"Bad Request"});
            }
            else{
                var user_name = select_user_result[0].name;
                var email = select_user_result[0].email;
                var phoneNumber = select_user_result[0].phoneNumber;
                var serviceNumber = select_user_result[0].serviceNumber;
                var rank = select_user_result[0].mil_rank;
                var enlistmentDate = select_user_result[0].enlistmentDate;
                var dischargeDate = select_user_result[0].dischargeDate;
                militaryUnit = select_user_result[0].militaryUnit;
                var pictureName = select_user_result[0].pictureName;
                var user_createdAt = select_user_result[0].createdAt;
                var user_updatedAt = select_user_result[0].updatedAt;
                var militaryUnit_blank = militaryUnit.replace(/_/g, " ");
                var user_data = {id:confirmor_id, name:user_name, email:email, phoneNumber:phoneNumber, serviceNumber:serviceNumber, rank:rank, enlistmentDate:enlistmentDate, dischargeDate:dischargeDate,militaryUnit:militaryUnit_blank,pictureName:pictureName, createdAt:user_createdAt, updatedAt:user_updatedAt };
                var individual_data = {id:id, receiptPayment:receiptPayment, target:target,items:items, confirmor:user_data, createdAt:createdAt, updatedAt:updatedAt};
                //return {success:true, data:data};
                data.push(individual_data);
            }
        }
        return {status:200, message:'Ok', data:data};
    }catch(error){
        console.log(error);
        return {status:500, message:'Internal Server Error', data:null};
        //return false;
    }
}


router.get('/storagePlace', async function(req, res, next) {
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
	res.setHeader("accessToken", new_access_token);
    res.setHeader("refreshToken", new_refresh_token);
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
	var blank_militaryUnit = militaryUnit.replace(/_/g, " ");
	var select_storagePlace_sql = "select distinct(name) from storagePlace_"+militaryUnit+";";
	var [select_storagePlace_result] = await con.query(select_storagePlace_sql);
	if(select_storagePlace_result.length==0){
		res.send({status:200, message:"값이 없습니다.", data:null});
		return;
	}
	var data = [];
	for(let i=0; i<select_storagePlace_result.length; ++i){
		data.push(select_storagePlace_result[i].name);
	}
    ////////////////
//////내용
    ///////////////
    res.send({status:200, message:"Ok", data:data});
});



router.delete('/favorite', async function(req, res, next) {
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
	res.setHeader("accessToken", new_access_token);
    res.setHeader("refreshToken", new_refresh_token);
    var user_id = verify_success.id;

    con = await db.createConnection(inform);
    await con.beginTransaction();
    const check_militaryUnit = "select militaryUnit from user where id = ?;";
    const check_militaryUnit_param = user_id;
    const [check_militaryUnit_result] = await con.query(check_militaryUnit, check_militaryUnit_param);
    if(check_militaryUnit_result.length==0){
        res.send({status:400, message:'Bad Request', data:null});
        await con.commit();
        return;
    }
    var militaryUnit = check_militaryUnit_result[0].militaryUnit;
    var property_id = req.body.id;
    var select_sql = "select * from property_"+militaryUnit+" where id = ?;";
    var select_param = property_id;
    var [select_result] = await con.query(select_sql, select_param);
    if(select_result.length==0){
        res.send({status:200, message:'없는 재산입니다.', data:null});
        await con.commit();
        return;
    }
    var select_favorite_sql = "select * from favorite_"+militaryUnit+" where user_id = ? and property_id = ?;";
    var select_favorite_param = [user_id, property_id];
    var [select_favorite_result] = await con.query(select_favorite_sql, select_favorite_param);
    if(select_favorite_result.length==0){
        res.send({status:200, message:"값이 없습니다.", data:null});
        await con.commit();
        return;
    }


    var delete_favorite_sql = "delete from favorite_"+militaryUnit+" where user_id=? and property_id=?";
    var delete_favorite_param = [user_id, property_id];
    var delete_favorite_success = await myQuery(delete_favorite_sql, delete_favorite_param);
    if(!delete_favorite_success){
        res.send({status:500, message:"Internal Server Error", data:null});
        await con.commit();
        return;
    }

    select_favorite_sql = "select * from favorite_"+militaryUnit+" where user_id = ?;";
    select_favorite_param = user_id;
    //select_favorite_result = [];
    var [select_favorite_result] = await con.query(select_favorite_sql, select_favorite_param);
    var data = [];
    if(select_favorite_result.length==0){
        res.send({status:200, message:"값이 없습니다.", data:null});
        await con.commit();
        return;
    }
    for(let i=0; i<select_favorite_result.length; ++i){
        var property_id = select_favorite_result[i].property_id;
        var select_property_sql = "select * from property_"+militaryUnit+" where id = ?;";
        var select_property_param = property_id;
        console.log(select_property_param);
        const [select_property_result] = await con.query(select_property_sql, select_property_param);
        if(select_property_result[0].length==0){
            var individual_data={id:property_id, totalAmount:0, message:"현재 없는 재산입니다."};
            console.log("열로옴");
            data.push(individual_data);
            continue;
        }
        var id = select_property_result[0].id;
        var name = select_property_result[0].name;
        var totalAmount = select_property_result[0].totalAmount;
        var unit = select_property_result[0].unit;
        var expirationDate = select_property_result[0].expirationDate;
        var created_time = select_property_result[0].createdAt;
        var updated_time = select_property_result[0].updatedAt;
        var select_amountByPlace_sql = "select name, amount from storagePlace_"+militaryUnit+" where property_id = ?;";
        var select_amountByPlace_param = id;
        var [select_amountByPlace_result] = await con.query(select_amountByPlace_sql, select_amountByPlace_param);
        var amountByPlace = [];
        for(let k=0; k<select_amountByPlace_result.length; ++k){
           amountByPlace.push({storagePlace:select_amountByPlace_result[k].name, amount:select_amountByPlace_result[k].amount});
        }
        var select_log_sql = "select id from paymentLog_"+militaryUnit+" where property_id_arr like ? order by createdAt, log_num;";
        var select_log_param = "%"+id+"%";
        var [select_log_result] = await con.query(select_log_sql,select_log_param);
		var log_arr = [];
        var log_id_arr = [];
        for(let k=0; k<select_log_result.length; ++k){
                //////////////////////
            log_id_arr.push(select_log_result[k].id);
        }
        var logData = await getLogInform(log_id_arr,militaryUnit);
        if(logData.status!=200){
            res.send({status: logData.status, message:logData.message, data:null});
            return;
        }
        log_arr = logData.data;
        var niin, category;
        var select_medicInform_sql = "select * from medicInform where name = ?;";
        var select_medicInform_param = name;
        var [select_medicInform_result] = await con.query(select_medicInform_sql, select_medicInform_param);
        if(select_medicInform_result.length==0){
            res.send({status:400, message:"Bad Request", data:null});
            await con.rollback();
            return;
        }
        niin = select_medicInform_result[0].niin;
        category = select_medicInform_result[0].category;
		
        var individual_data={id :id,name:name,unit:unit,totalAmount:totalAmount, amountByPlace:amountByPlace,category:category, niin:niin,expirationDate:expirationDate,logRecord:log_arr ,createdAt:created_time, updatedAt : updated_time};
        data.push(individual_data);
    }
    res.send({status:200, message:"Ok", data:data});
    await con.commit();
    ////////////////
//////내용
    ///////////////
});


router.get('/favorite', async function(req, res, next) {
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
	res.setHeader("accessToken", new_access_token);
    res.setHeader("refreshToken", new_refresh_token);
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
    var select_favorite_sql = "select * from favorite_"+militaryUnit+" where user_id = ?;";
    var select_favorite_param = user_id;
    var [select_favorite_result] = await con.query(select_favorite_sql, select_favorite_param);
    if(select_favorite_result.length==0){
        res.send({status:200, message:"값이 없습니다.", data:null});
        return;
    }
    var data = [];
    for(let i=0; i<select_favorite_result.length; ++i){
        //data.push(select_favorite_result[i].name);
        var property_id = select_favorite_result[i].property_id;
        var select_property_sql = "select * from property_"+militaryUnit+" where id = ?;";
        var select_property_param = property_id;
        const [select_property_result] = await con.query(select_property_sql, select_property_param);
        if(select_property_result[0].length==0){
            var individual_data={id:property_id, totalAmount:0, message:"현재 없는 재산입니다."};
            data.push(individual_data);
            continue;
        }
        var id = select_property_result[0].id;
        var name = select_property_result[0].name;
        var totalAmount = select_property_result[0].totalAmount;
        var unit = select_property_result[0].unit;
        var expirationDate = select_property_result[0].expirationDate;
        var created_time = select_property_result[0].createdAt;
        var updated_time = select_property_result[0].updatedAt;
        var select_amountByPlace_sql = "select name, amount from storagePlace_"+militaryUnit+" where property_id = ?;";
        var select_amountByPlace_param = id;
        var [select_amountByPlace_result] = await con.query(select_amountByPlace_sql, select_amountByPlace_param);
        var amountByPlace = [];
        for(let k=0; k<select_amountByPlace_result.length; ++k){
           amountByPlace.push({storagePlace:select_amountByPlace_result[k].name, amount:select_amountByPlace_result[k].amount});
        }
        var select_log_sql = "select id from paymentLog_"+militaryUnit+" where property_id_arr like ? order by createdAt, log_num;";
        var select_log_param = "%"+id+"%";
        var [select_log_result] = await con.query(select_log_sql,select_log_param);
		var log_arr = [];
        var log_id_arr = [];
        for(let k=0; k<select_log_result.length; ++k){
                //////////////////////
            log_id_arr.push(select_log_result[k].id);
        }
        var logData = await getLogInform(log_id_arr,militaryUnit);
        if(logData.status!=200){
            res.send({status: logData.status, message:logData.message, data:null});
            return;
        }
        log_arr = logData.data;
        var niin, category;
        var select_medicInform_sql = "select * from medicInform where name = ?;";
        var select_medicInform_param = name;
        var [select_medicInform_result] = await con.query(select_medicInform_sql, select_medicInform_param);
        if(select_medicInform_result.length==0){
            res.send({status:400, message:"Bad Request", data:null});
            await con.rollback();
            return;
        }
        niin = select_medicInform_result[0].niin;
        category = select_medicInform_result[0].category;
        var individual_data={id :id,name:name,unit:unit,totalAmount:totalAmount, amountByPlace:amountByPlace,category:category, niin:niin,expirationDate:expirationDate,logRecord:log_arr ,createdAt:created_time, updatedAt : updated_time};
        data.push(individual_data);
    }
    res.send({status:200, message:"Ok", data:data});
    await con.commit();
    ////////////////
//////내용
    ///////////////
});


router.post('/favorite', async function(req, res, next) {
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
	res.setHeader("accessToken", new_access_token);
    res.setHeader("refreshToken", new_refresh_token);
    var user_id = verify_success.id;

    con = await db.createConnection(inform);
    await con.beginTransaction();
    const check_militaryUnit = "select militaryUnit from user where id = ?;";
    const check_militaryUnit_param = user_id;
    const [check_militaryUnit_result] = await con.query(check_militaryUnit, check_militaryUnit_param);
    if(check_militaryUnit_result.length==0){
        res.send({status:400, message:'Bad Request', data:null});
        await con.commit();
        return;
    }
    var militaryUnit = check_militaryUnit_result[0].militaryUnit;
    var property_id = req.body.id;
    var select_sql = "select * from property_"+militaryUnit+" where id = ?;";
    var select_param = property_id;
    var [select_result] = await con.query(select_sql, select_param);
    if(select_result.length==0){
        res.send({status:200, message:'없는 재산입니다.', data:null});
        await con.commit();
        return;
    }
    var insert_favorite_sql = "insert into favorite_"+militaryUnit+" values (?, ?);";
    var insert_favorite_param = [user_id, property_id];
    var insert_favorite_success = await myQuery(insert_favorite_sql, insert_favorite_param);
    if(!insert_favorite_success){
        res.send({status:400, message:"이미 즐겨찾기 있습니다.", data:null});
        await con.commit();
        return;
    }
    var select_favorite_sql = "select * from favorite_"+militaryUnit+" where user_id = ?;";
    var select_favorite_param = user_id;
    var [select_favorite_result] = await con.query(select_favorite_sql, select_favorite_param);
    if(select_favorite_result.length==0){
        res.send({status:500, message:"Internal Server Error", data:null});
        await con.rollback();
        return;
    }
    var data = [];
    for(let i=0; i<select_favorite_result.length; ++i){
        var property_id = select_favorite_result[i].property_id;
        var select_property_sql = "select * from property_"+militaryUnit+" where id = ?;";
        var select_property_param = property_id;
        const [select_property_result] = await con.query(select_property_sql, select_property_param);
        if(select_property_result[0].length==0){
            var individual_data={id:property_id, totalAmount:0, message:"현재 없는 재산입니다."};
            data.push(individual_data);
            continue;
        }
        var id = select_property_result[0].id;
        var name = select_property_result[0].name;
        var totalAmount = select_property_result[0].totalAmount;
        var unit = select_property_result[0].unit;
        var expirationDate = select_property_result[0].expirationDate;
        var created_time = select_property_result[0].createdAt;
        var updated_time = select_property_result[0].updatedAt;
        var select_amountByPlace_sql = "select name, amount from storagePlace_"+militaryUnit+" where property_id = ?;";
        var select_amountByPlace_param = id;
        var [select_amountByPlace_result] = await con.query(select_amountByPlace_sql, select_amountByPlace_param);
        var amountByPlace = [];
        for(let k=0; k<select_amountByPlace_result.length; ++k){
           amountByPlace.push({storagePlace:select_amountByPlace_result[k].name, amount:select_amountByPlace_result[k].amount});
        }
        var select_log_sql = "select id from paymentLog_"+militaryUnit+" where property_id_arr like ? order by createdAt, log_num;";
        var select_log_param = "%"+id+"%";
        var [select_log_result] = await con.query(select_log_sql,select_log_param);

		var log_arr = [];
        var log_id_arr = [];
        for(let k=0; k<select_log_result.length; ++k){
                //////////////////////
            log_id_arr.push(select_log_result[k].id);
        }
        var logData = await getLogInform(log_id_arr,militaryUnit);
        if(logData.status!=200){
        	res.send({status: logData.status, message:logData.message, data:null});
            return;
        }
        log_arr = logData.data;

        var niin, category;
        var select_medicInform_sql = "select * from medicInform where name = ?;";
        var select_medicInform_param = name;
        var [select_medicInform_result] = await con.query(select_medicInform_sql, select_medicInform_param);
        if(select_medicInform_result.length==0){
            res.send({status:400, message:"Bad Request", data:null});
            await con.rollback();
            return;
        }
        niin = select_medicInform_result[0].niin;
        category = select_medicInform_result[0].category;
        var individual_data={id :id,name:name,unit:unit,totalAmount:totalAmount, amountByPlace:amountByPlace,category:category, niin:niin,expirationDate:expirationDate,logRecord:log_arr ,createdAt:created_time, updatedAt : updated_time};
        data.push(individual_data);
    }
    res.send({status:200, message:"Ok", data:data});
    await con.commit();
    ////////////////
//////내용
    ///////////////
});






router.post('/', async function(req, res, next) {
/*
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Credentials", "true");
    res.setHeader("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
    res.setHeader("Access-Control-Allow-Headers", "Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers");
*/
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
	res.setHeader("accessToken", new_access_token);
    res.setHeader("refreshToken", new_refresh_token);
    var user_id = verify_success.id;

    con = await db.createConnection(inform);
    const check_militaryUnit = "select militaryUnit from user where id = ?;";
    const check_militaryUnit_param = user_id;
    const [check_militaryUnit_result] = await con.query(check_militaryUnit, check_militaryUnit_param);
    if(check_militaryUnit_result.length==0){
		res.send({status:500, message:'Internal Sever Error', data:null});
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
		res.send({status:200, message:"검색결과가 없습니다", data:null});
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
			if(select_log_result.length==0){	//재산이 있는데 로그가 없을리가 없음
				res.send({status: 500, message:"Internal Server Error", data:null});
                return;
			}
			log_arr = [];
			var log_id_arr = [];
            for(let k=0; k<select_log_result.length; ++k){
				//////////////////////
                log_id_arr.push(select_log_result[k].id);
            }
			var logData = await getLogInform(log_id_arr,militaryUnit);
			console.log(logData);
            if(logData.status!=200){
              res.send({status: logData.status, message:logData.message, data:null});
              return;
            }
            log_arr = logData.data;
            var niin, category;
            var select_medicInform_sql = "select * from medicInform where name = ?;";
            var select_medicInform_param = name;
            var [select_medicInform_result] = await con.query(select_medicInform_sql, select_medicInform_param);
            if(select_medicInform_result.length==0){
				res.send({status: 500, message:"Internal Server Error", data:null});
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
        res.send({status:200, message:"Ok", data:data});
	}
	else{
		var select_storagePlace_sql = "select * from storagePlace_"+militaryUnit+" where name = ?;";
		var select_storagePlace_param = storagePlace;
		var [select_storagePlace_result] = await con.query(select_storagePlace_sql, select_storagePlace_param);
		if(select_storagePlace_result.length==0){
			res.send({status:200, message:"검색결과가 없습니다.", data:null});
			return;
		}
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
			var log_id_arr = [];
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
                        log_id_arr.push(select_log_result[j].id);
                        break;
                    }
                }
            }
            for(let j=0; j<select_log_by_target_result.length; ++j){
                if(select_log_by_target_result[j].receiptPayment=="이동"){
                    log_id_arr.push(select_log_by_target_result[j].id);
                }
            }
			if(log_id_arr.length==0){
                res.send({status:500, message:"Internal Server Error", data:null});
                return;
            }
            var logData = await getLogInform(log_id_arr,militaryUnit);
            //console.log(logData);
            if(logData.status!=200){
              	res.send({status: logData.status, message:logData.message, data:null});
              	return;
            }
            log_arr = logData.data;
//////////////////////////////////////////////////////////////////

            var niin, category;
            var select_medicInform_sql = "select * from medicInform where name = ?;";
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
        res.send({status:200, message:"Ok", data:data});
	}
	//var data = {};
    //res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:200, message:"Ok", data:data});
});



router.get('/', async function(req, res, next) {
/*
	res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Credentials", "true");
    res.setHeader("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
    res.setHeader("Access-Control-Allow-Headers", "Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers");
*/
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
	res.setHeader("accessToken", new_access_token);
    res.setHeader("refreshToken", new_refresh_token);
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
        res.send({status:200, message:"재산이 없습니다.", data:null});
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
            var select_medicInform_sql = "select * from medicInform where name = ?;";
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
		res.send({status:200, message:"Ok", data:data});
    }
});


router.get('/:id', async function(req, res, next) {
	/*
	res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Credentials", "true");
    res.setHeader("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
    res.setHeader("Access-Control-Allow-Headers", "Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers");
*/
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
	res.setHeader("accessToken", new_access_token);
    res.setHeader("refreshToken", new_refresh_token);
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
            var log_id_arr = [];
            for(let k=0; k<select_log_result.length; ++k){
                //////////////////////
                log_id_arr.push(select_log_result[k].id);
            }
            var logData = await getLogInform(log_id_arr,militaryUnit);
            console.log(logData);
            if(logData.status!=200){
              res.send({status: logData.status, message:logData.message, data:null});
              return;
            }
            log_arr = logData.data;

        	var niin, category;
        	var select_medicInform_sql = "select * from medicInform where name = ?;";
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
        	res.send({status:200, message:"Ok", data:data});	
		}
    }
});

module.exports = router;
