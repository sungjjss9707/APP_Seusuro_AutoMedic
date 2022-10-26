var express = require('express'); 
var bcrypt = require('bcrypt');
var router = express.Router(); 
var con;
var db = require('mysql2/promise');
var mysql = require('../config');
var crypto = require('crypto');
var table = require('../routes/table');
var inform = mysql.inform;


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
	con = await db.createConnection(inform);
	var militaryUnit = req.body.militaryUnit;
	const code = req.body.code;
	var delete_mil_and_code = myQuery("delete from mil_and_code where militaryUnit = ?;", militaryUnit);
    if(!delete_mil_and_code){
        res.send("Fail");
    }
	var insert_mil_and_code = myQuery("insert into mil_and_code values (?,?);", [militaryUnit, code]);
	if(!insert_mil_and_code){
		res.send("Fail");
		return;
	}
	militaryUnit = militaryUnit.replace(/ /g, "_");
	var property_drop_success = await table.propertyDrop(militaryUnit);
    var log_drop_success = await table.paymentLogDrop(militaryUnit);
    var storagePlace_drop_success = await table.storagePlaceDrop(militaryUnit);
	//var medicInform_drop_success = await table.medicInformDrop(militaryUnit);
	var favorite_drop_success = await table.favoriteDrop(militaryUnit);
	var bookmark_drop_success = await table.bookmarkDrop(militaryUnit);
    //if(property_drop_success.success&&log_drop_success.success&&storagePlace_drop_success&&medicInform_drop_success){
	var property_make_success = await table.propertyMake(militaryUnit);
    var log_make_success = await table.paymentLogMake(militaryUnit);
    var storagePlace_make_success = await table.storagePlaceMake(militaryUnit);
	//var medicInform_make_success = await table.medicInformMake(militaryUnit);
	var favorite_make_success = await table.favoriteMake(militaryUnit);
    var bookmark_make_success = await table.bookmarkMake(militaryUnit);
    	//if(property_make_success.success&&log_make_success.success&&storagePlace_make_success&&medicInform_make_success){
	res.send("success");
    	//}
    	//else res.send({status:400, message:"Bad Request"});
    //}
   // else res.send({status:400, message:"Bad Request"});

});

module.exports = router;
