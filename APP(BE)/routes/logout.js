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
    var user_id = verify_success.id;

    con = await db.createConnection(inform);
	await con.beginTransaction();
	const check_militaryUnit = "select militaryUnit from user where id = ?;";
    const check_militaryUnit_param = user_id;
    const [check_militaryUnit_result] = await con.query(check_militaryUnit, check_militaryUnit_param);
    if(check_militaryUnit_result.length==0){
        res.send({status:400, message:'Bad Request', data:null});
        return;
    }
    var militaryUnit = check_militaryUnit_result[0].militaryUnit;
	var delete_token_sql = "delete from refresh_token where id = ?;";
	var delete_token_param = user_id;
	var result = await myQuery(delete_token_sql, delete_token_param);
	if(!result){
		res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:500, message:'Internal Server Error', data:null});
        await con.rollback();
		return;
	}
	////////////////
//////내용 
	///////////////
	res.send({status:200, message:"Ok", data:null});
	await con.commit();
});


module.exports = router;
