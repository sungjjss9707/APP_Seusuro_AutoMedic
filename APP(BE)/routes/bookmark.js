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
    var medicine_name = req.body.id;
	var select_bookmark_sql = "select * from bookmark_"+militaryUnit+" where user_id = ? and name = ?;";
    var select_bookmark_param = [user_id, medicine_name];
    var [select_bookmark_result] = await con.query(select_bookmark_sql, select_bookmark_param);
    if(select_bookmark_result.length==0){
        res.send({status:200, message:"값이 없습니다.", data:null});
        await con.commit();
        return;
    }


	var delete_bookmark_sql = "delete from bookmark_"+militaryUnit+" where user_id=? and name=?";
    var delete_bookmark_param = [user_id, medicine_name];
    var delete_bookmark_success = await myQuery(delete_bookmark_sql, delete_bookmark_param);
    if(!delete_bookmark_success){
        res.send({status:500, message:"Internal Server Error", data:null});
        await con.commit();
        return;
    }

    var select_bookmark_sql2 = "select * from bookmark_"+militaryUnit+" where user_id = ?;";
    var select_bookmark_param2 = user_id;
    var [select_bookmark_result2] = await con.query(select_bookmark_sql2, select_bookmark_param2);
    var data = [];
    for(let i=0; i<select_bookmark_result2.length; ++i){
        data.push(select_bookmark_result2[i].name);
    }
    res.send({status:200, message:"Ok", data:data});
    await con.commit();
    ////////////////
//////내용
    ///////////////
});

router.get('/', async function(req, res, next) {
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
    var select_bookmark_sql = "select * from bookmark_"+militaryUnit+" where user_id = ?;";
    var select_bookmark_param = user_id;
    var [select_bookmark_result] = await con.query(select_bookmark_sql, select_bookmark_param);
    if(select_bookmark_result.length==0){
		res.send({status:200, message:"값이 없습니다.", data:null});
		return;
    }
    var data = [];
    for(let i=0; i<select_bookmark_result.length; ++i){
        data.push(select_bookmark_result[i].name);
    }
    res.send({status:200, message:"Ok", data:data});
    await con.commit();
    ////////////////
//////내용
    ///////////////
});

router.post('/', async function(req, res, next) {
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
	var medicine_name = req.body.id;
	var entpName = req.body.entpName;
	var efcyQesitm = req.body.efcyQesitm;
	var useMethodQesitm = req.body.useMethodQesitm;
	var atpnWarnQesitm = req.body.atpnWarnQesitm;
	var atpnQesitm = req.body.atpnQesitm;
	var intrcQesitm = req.body.intrcQesitm;
	var seQesitm = req.body.intrcQesitm;
	var depositMethodQesitm = req.body.depositMethodQesitm;
	var itemImage = req.body.itemImage;

	var insert_bookmark_sql = "insert into bookmark_"+militaryUnit+" values (?, ?);";
	var insert_bookmark_param = [user_id, medicine_name];
	var insert_bookmark_success = await myQuery(insert_bookmark_sql, insert_bookmark_param);
	if(!insert_bookmark_success){
		res.send({status:400, message:"이미 북마크에 있습니다.", data:null});	
		await con.commit();
		return;
	}
	var select_bookmark_sql = "select * from bookmark_"+militaryUnit+" where user_id = ?;";
	var select_bookmark_param = user_id;
	var [select_bookmark_result] = await con.query(select_bookmark_sql, select_bookmark_param);
	if(select_bookmark_result.length==0){
		res.send({status:500, message:"Internal Server Error", data:null});
		await con.rollback();
        return;
	}
	var select_medicine_sql = "select * from medicine where itemName = ?;";
	var select_medicine_param = medicine_name;
	var [select_medicine_result] = await con.query(select_medicine_sql, select_medicine_param);
	if(select_medicine_result.length==0){
		var insert_medicine_sql = "insert into medicine values (?,?,?,?,?,?,?,?,?,?);";
		var insert_medicine_param = [entpName, medicine_name, efcyQesitm, useMethodQesitm, atpnWarnQesitm, atpnQesitm, intrcQesitm, seQesitm, depositMethodQesitm, itemImage];
		var insert_medicine_result = await myQuery(insert_medicine_sql, insert_medicine_param);
		if(!insert_medicine_result){
			res.send({status:500, message:"Internal Server Error", data:null});
        	await con.rollback();
        	return;
		}
	}

	var data = [];
	var individual_data;
	for(let i=0; i<select_bookmark_result.length; ++i){
		select_medicine_sql = "select * from medicine where itemName = ?;";
		select_medicine_param = select_bookmark_result[i].name;
		var [result] = await con.query(select_medicine_sql, select_medicine_param);
		if(result.length==0){
			res.send({status:500, message:"Internal Server Error", data:null});
        	await con.rollback();
        	return;
		}
		individual_data = {entpName:result[0].entpName, itemName:result[0].itemName, efcyQesitm:result[0].efcyQesitm, useMethodQesitm:result[0].useMethodQesitm, atpnWarnQesitm:result[0].atpnWarnQesitm, atpnQesitm:result[0].atpnQesitm, intrcQesitm:result[0].intrcQesitm, seQesitm:result[0].seQesitm, depositMethodQesitm:result[0].depositMethodQesitm, itemImage:result[0].itemImage };
		data.push(individual_data);
	}
	res.send({status:200, message:"Ok", data:data});
	await con.commit();
	////////////////
//////내용 
	///////////////
});


module.exports = router;

















