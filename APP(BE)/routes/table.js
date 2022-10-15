var express = require('express'); 
var router = express.Router(); 
var db = require('mysql2/promise');
var mysql = require('../config');
var inform = mysql.inform;


var propertyMake = async function(militaryUnit){
    try{
		var con = await db.createConnection(inform);
		var sql = "create table property_"+militaryUnit+" ( id varchar(100) not null, name varchar(100) not null, totalAmount int not null, unit varchar(20) not null,category varchar(100) not null, expirationDate datetime not null, createdAt datetime, updatedAt datetime, primary key(id) );";
        const [row, field] = await con.query(sql);
        return {success:true};
    }catch(error){
        console.log(error);
        return {success:false, error:error};
    }
}

var paymentLogMake = async function(militaryUnit){
    try{
        var con = await db.createConnection(inform);
		var sql = "create table paymentLog_"+militaryUnit+" ( id varchar(100) not null, receiptPayment varchar(20) not null, confirmor_id varchar(100) not null, target varchar(100), YearMonthDate varchar(20) not null, log_num int not null, property_id_arr varchar(5000) not null, storagePlace_arr varchar(1000) not null, amount_arr varchar(1000) not null, unit_arr varchar(1000) not null,createdAt datetime, updatedAt datetime, primary key(id) );"
        const [row, field] = await con.query(sql);
        return {success:true};
    }catch(error){
        console.log(error);
        return {success:false, error:error};
    }
}

var storagePlaceMake = async function(militaryUnit){
    try{
        var con = await db.createConnection(inform);
        var sql = "create table storagePlace_"+militaryUnit+" ( id varchar(150) not null, property_id varchar(100) not null, name varchar(100) not null, amount int not null,unit varchar(20) not null, primary key(id) );"
        const [row, field] = await con.query(sql);
        return {success:true};
    }catch(error){
        console.log(error);
        return {success:false, error:error};
    }
}

var medicInformMake = async function(militaryUnit){
    try{
        var con = await db.createConnection(inform);
		var sql = "create table medicInform_"+militaryUnit+" ( name varchar(100), category varchar(100), niin varchar(100), primary key (name) );"
        const [row, field] = await con.query(sql);
        return {success:true};
    }catch(error){
        console.log(error);
        return {success:false, error:error};
    }
}


var bookmarkMake = async function(militaryUnit){
    try{
        var con = await db.createConnection(inform);
        var sql = "create table bookmark_"+militaryUnit+" ( user_id varchar(100), name varchar(100), primary key (user_id, name) );"
        const [row, field] = await con.query(sql);
        return {success:true};
    }catch(error){
        console.log(error);
        return {success:false, error:error};
    }
}

var favoriteMake = async function(militaryUnit){
    try{
        var con = await db.createConnection(inform);
        var sql = "create table favorite_"+militaryUnit+" ( user_id varchar(100), property_id varchar(100), primary key (user_id, name) );"
        const [row, field] = await con.query(sql);
        return {success:true};
    }catch(error){
        console.log(error);
        return {success:false, error:error};
    }
}

var propertyDrop = async function(militaryUnit){
    try{
        var con = await db.createConnection(inform);
        var sql = "drop table property_"+militaryUnit+";";
        const [row, field] = await con.query(sql);
        return {success:true};
    }catch(error){
        console.log(error);
        return {success:false, error:error};
    }
}

var paymentLogDrop = async function(militaryUnit){
    try{
        var con = await db.createConnection(inform);
        var sql = "drop table paymentLog_"+militaryUnit+";";
        const [row, field] = await con.query(sql);
        return {success:true};
    }catch(error){
        console.log(error);
        return {success:false, error:error};
    }
}

var storagePlaceDrop = async function(militaryUnit){
    try{
        var con = await db.createConnection(inform);
        var sql = "drop table storagePlace_"+militaryUnit+";";
        const [row, field] = await con.query(sql);
        return {success:true};
    }catch(error){
        console.log(error);
        return {success:false, error:error};
    }
}

var medicInformDrop = async function(militaryUnit){
    try{
        var con = await db.createConnection(inform);
        var sql = "drop table medicInform_"+militaryUnit+";";
        const [row, field] = await con.query(sql);
        return {success:true};
    }catch(error){
        console.log(error);
        return {success:false, error:error};
    }
}

var bookmarkDrop = async function(militaryUnit){
    try{
        var con = await db.createConnection(inform);
        var sql = "drop table bookmark_"+militaryUnit+";";
        const [row, field] = await con.query(sql);
        return {success:true};
    }catch(error){
        console.log(error);
        return {success:false, error:error};
    }
}

var favoriteDrop = async function(militaryUnit){
    try{
        var con = await db.createConnection(inform);
        var sql = "drop table favorite_"+militaryUnit+";";
        const [row, field] = await con.query(sql);
        return {success:true};
    }catch(error){
        console.log(error);
        return {success:false, error:error};
    }
}

exports.propertyMake = propertyMake;
exports.paymentLogMake = paymentLogMake;
exports.storagePlaceMake = storagePlaceMake;
exports.medicInformMake = medicInformMake;
exports.bookmarkMake = bookmarkMake;
exports.favoriteMake = favoriteMake;
exports.propertyDrop = propertyDrop;
exports.paymentLogDrop = paymentLogDrop;
exports.storagePlaceDrop = storagePlaceDrop;
exports.medicInformDrop = medicInformDrop;
exports.bookmarkDrop = bookmarkDrop;
exports.favoriteDrop = favoriteDrop;

