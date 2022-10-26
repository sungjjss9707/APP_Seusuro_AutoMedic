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

router.delete('/', async function(req, res, next) {

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
        res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:200, message:"값이 없습니다.", data:null});
        await con.commit();
        return;
    }


	var delete_favorite_sql = "delete from favorite_"+militaryUnit+" where user_id=? and property_id=?";
    var delete_favorite_param = [user_id, property_id];
    var delete_favorite_success = await myQuery(delete_favorite_sql, delete_favorite_param);
    if(!delete_favorite_success){
        res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:500, message:"Internal Server Error", data:null});
        await con.commit();
        return;
    }

    select_favorite_sql = "select * from favorite_"+militaryUnit+" where user_id = ?;";
    select_favorite_param = user_id;
    //select_favorite_result = [];
	var [select_favorite_result] = await con.query(select_favorite_sql, select_favorite_param);
    var data = [];
	if(select_favorite_result.length==0){
		res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:200, message:"값이 없습니다.", data:null});
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
        for(let k=0; k<select_log_result.length; ++k){
            log_arr.push(select_log_result[k].id);
        }
        var niin, category;
        var select_medicInform_sql = "select * from medicInform_"+militaryUnit+" where name = ?;";
        var select_medicInform_param = name;
        var [select_medicInform_result] = await con.query(select_medicInform_sql, select_medicInform_param);
        if(select_medicInform_result.length==0){
            res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:400, message:"Bad Request", data:null});
            await con.rollback();
            return;
        }
        niin = select_medicInform_result[0].niin;
        category = select_medicInform_result[0].category;
        var individual_data={id :id,name:name,unit:unit,totalAmount:totalAmount, amountByPlace:amountByPlace,category:category, niin:niin,expirationDate:expirationDate,logRecord:log_arr ,createdAt:created_time, updatedAt : updated_time};
        data.push(individual_data);
    }
    res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:200, message:"Ok", data:data});
    await con.commit();
    ////////////////
//////내용
    ///////////////
});

router.get('/', async function(req, res, next) {
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
    var select_favorite_sql = "select * from favorite_"+militaryUnit+" where user_id = ?;";
    var select_favorite_param = user_id;
    var [select_favorite_result] = await con.query(select_favorite_sql, select_favorite_param);
    if(select_favorite_result.length==0){
		res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:200, message:"값이 없습니다.", data:null});
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
        for(let k=0; k<select_log_result.length; ++k){
            log_arr.push(select_log_result[k].id);
        }
        var niin, category;
        var select_medicInform_sql = "select * from medicInform_"+militaryUnit+" where name = ?;";
        var select_medicInform_param = name;
        var [select_medicInform_result] = await con.query(select_medicInform_sql, select_medicInform_param);
        if(select_medicInform_result.length==0){
            res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:400, message:"Bad Request", data:null});
            await con.rollback();
            return;
        }
        niin = select_medicInform_result[0].niin;
        category = select_medicInform_result[0].category;
        var individual_data={id :id,name:name,unit:unit,totalAmount:totalAmount, amountByPlace:amountByPlace,category:category, niin:niin,expirationDate:expirationDate,logRecord:log_arr ,createdAt:created_time, updatedAt : updated_time};
        data.push(individual_data);
    }
    res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:200, message:"Ok", data:data});
    await con.commit();
    ////////////////
//////내용
    ///////////////
});

router.post('/', async function(req, res, next) {

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
		res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:400, message:"이미 즐겨찾기 있습니다.", data:null});	
		await con.commit();
		return;
	}
	var select_favorite_sql = "select * from favorite_"+militaryUnit+" where user_id = ?;";
	var select_favorite_param = user_id;
	var [select_favorite_result] = await con.query(select_favorite_sql, select_favorite_param);
	if(select_favorite_result.length==0){
		res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:500, message:"Internal Server Error", data:null});
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
		var	select_log_sql = "select id from paymentLog_"+militaryUnit+" where property_id_arr like ? order by createdAt, log_num;";
        var select_log_param = "%"+id+"%";
        var [select_log_result] = await con.query(select_log_sql,select_log_param);
		var log_arr = [];
        for(let k=0; k<select_log_result.length; ++k){
            log_arr.push(select_log_result[k].id);
        }
		var niin, category;
        var select_medicInform_sql = "select * from medicInform_"+militaryUnit+" where name = ?;";
        var select_medicInform_param = name;
        var [select_medicInform_result] = await con.query(select_medicInform_sql, select_medicInform_param);
        if(select_medicInform_result.length==0){
            res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:400, message:"Bad Request", data:null});
			await con.rollback();
            return;
        }
        niin = select_medicInform_result[0].niin;
        category = select_medicInform_result[0].category;
        var individual_data={id :id,name:name,unit:unit,totalAmount:totalAmount, amountByPlace:amountByPlace,category:category, niin:niin,expirationDate:expirationDate,logRecord:log_arr ,createdAt:created_time, updatedAt : updated_time};
		data.push(individual_data);
	}
	res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:200, message:"Ok", data:data});
	await con.commit();
	////////////////
//////내용 
	///////////////
});


module.exports = router;

















