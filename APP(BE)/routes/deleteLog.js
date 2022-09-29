var express = require('express'); 
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

var deleteLog = async function(militaryUnit, confirmor_id, log_id) {
    con = await db.createConnection(inform);
	var select_log_sql =  "select * from paymentLog_"+militaryUnit+" where id = ?;";
	var select_log_param = log_id;
	const [select_log_result] = await con.query(select_log_sql, select_log_param);
	//console.log(select_log_result.length);
	if(select_log_result.length!=1){
		return false;
	}
	var origin_receiptPayment = select_log_result[0].receiptPayment;
    confirmor_id = select_log_result[0].confirmor_id;
    var target = select_log_result[0].target;
    var YearMonthDate = select_log_result[0].YearMonthDate;
    var log_num = select_log_result[0].log_num;
    var property_id_arr = select_log_result[0].property_id_arr;
    var storagePlace_arr = select_log_result[0].storagePlace_arr;
    var amount_arr = select_log_result[0].amount_arr;
    var unit_arr = select_log_result[0].unit_arr;
    var createdAt = select_log_result[0].createdAt;
    var updatedAt = select_log_result[0].updatedAt;
   /*     console.log(property_id_arr);
        console.log(storagePlace_arr);
        console.log(amount_arr);
        console.log(unit_arr);
*/     
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
    for(let i=0; i<arr_property_id.length; ++i){
        p_id = arr_property_id[i];
        var id_split = p_id.split('-');
        arr_name.push(id_split[0]);
        var myexpirationDate = id_split[1]+"-"+id_split[2]+"-"+id_split[3];
        arr_expirationDate.push(myexpirationDate);
    }	
	var select_property_sql, select_property_param, select_property_result;
	var modify_amount;
    var update_property_sql, update_property_param, update_property_result;
    var insert_property_sql, insert_property_param, insert_property_result;
    var insert_storagePlace_sql, insert_storagePlace_param, insert_storagePlace_result;
    var update_storagePlace_sql, update_storagePlace_param, update_storagePlace_result;
    var select_storagePlace_sql, select_storagePlace_param, select_storagePlace_result;
	var delete_storagePlace_sql, delete_storagePlace_param, delete_storagePlace_result;
	var delete_property_sql, delete_property_param, delete_property_result;
	var storagePlace_id;
	if(origin_receiptPayment=="수입"){	//수입을 했어도 옛날거기 때문에 지금 없을수도 있음 
		for(let i=0; i<len; ++i){
            select_property_sql = "select * from property_"+militaryUnit+" where id = ?;";
            select_property_param = arr_property_id[i];
            [select_property_result] = await con.query(select_property_sql, select_property_param);
            //console.log(select_property_result[0]);
			if(select_property_result==0){  //없으면
                insert_property_sql = "insert into property_"+militaryUnit+" values (?,?,?,?,?,now(), now());";
                insert_property_param = [arr_property_id[i], arr_name[i], (-1)*arr_amount[i], arr_unit[i], arr_expirationDate[i]];
                insert_property_result = await myQuery(insert_property_sql, insert_property_param);
                if(!insert_property_result){
					return false;
                }
				storagePlace_id = arr_property_id[i]+"-"+arr_storagePlace[i];
                select_storagePlace_sql = "select * from storagePlace_"+militaryUnit+" where property_id = ? and name = ?;";
                select_storagePlace_param = [arr_property_id[i], arr_storagePlace[i]];
                [select_storagePlace_result] = await con.query(select_storagePlace_sql, select_storagePlace_param);
                if(select_storagePlace_result.length==0){
                    insert_storagePlace_sql = "insert into storagePlace_"+militaryUnit+" values (?,?,?,?,?);";
                    insert_storagePlace_param = [storagePlace_id, arr_property_id[i], arr_storagePlace[i], (-1)*arr_amount[i], arr_unit[i]];
                    insert_storagePlace_result = await myQuery(insert_storagePlace_sql, insert_storagePlace_param);
                    if(!insert_storagePlace_result){
                        return false;
                    }
                }
                else{
                    var origin_amount = select_storagePlace_result[0].amount;
                    var final_amount = origin_amount-arr_amount[i];
					if(final_amount==0){
						delete_storagePlace_sql = "delete from storagePlace_"+militaryUnit+" where property_id = ? and name = ?;";
						delete_storagePlace_param = [arr_property_id[i], arr_storagePlace[i]];
						if(!delete_storagePlace_result){
                            return false;
                        }
					}
					else{
						update_storagePlace_sql = "update storagePlace_"+militaryUnit+" set amount = ? where property_id = ? and name = ?;";
                    	update_storagePlace_param = [final_amount, arr_property_id[i], arr_storagePlace[i]];
                    	update_storagePlace_result = await myQuery(update_storagePlace_sql, update_storagePlace_param);
                    	if(!update_storagePlace_result){
                        	return false;
                    	}
					}
                }			
/////////////////////////////

            }
            else{	//있으면
                var origin_totalAmount = select_property_result[0].totalAmount;
                modify_amount = arr_amount[i];
                var final_totalAmount = origin_totalAmount-modify_amount;
                console.log(final_totalAmount);
				if(final_totalAmount==0){
					delete_property_sql = "delete from property_"+militaryUnit+" where id = ?;";
					delete_property_param = arr_property_id[i];
					delete_property_result = await myQuery(delete_property_sql, delete_property_param);
					if(!delete_property_result){
                        console.log("열로옴");
                        return false;
                    }
				}
				else{
					update_property_sql = "update property_"+militaryUnit+" set totalAmount = ? where id = ?;";
                	console.log(final_totalAmount+"  "+arr_property_id[i]);
                	update_property_param = [final_totalAmount, arr_property_id[i]];
                	update_property_result = await myQuery(update_property_sql, update_property_param);
                	if(!update_property_result){
                    	console.log("열로옴");
                    	return false;
                	}
				}
				storagePlace_id = arr_property_id[i]+"-"+arr_storagePlace[i];
                select_storagePlace_sql = "select * from storagePlace_"+militaryUnit+" where property_id = ? and name = ?;";
                select_storagePlace_param = [arr_property_id[i], arr_storagePlace[i]];
                [select_storagePlace_result] = await con.query(select_storagePlace_sql, select_storagePlace_param);
                if(select_storagePlace_result.length==0){
                    insert_storagePlace_sql = "insert into storagePlace_"+militaryUnit+" values (?,?,?,?,?);";
                    insert_storagePlace_param = [storagePlace_id, arr_property_id[i], arr_storagePlace[i], (-1)*arr_amount[i], arr_unit[i]];
                    insert_storagePlace_result = await myQuery(insert_storagePlace_sql, insert_storagePlace_param);
                    if(!insert_storagePlace_result){
                        return false;
                    }
                }
                else{
					var origin_amount = select_storagePlace_result[0].amount;
                    var final_amount = origin_amount-arr_amount[i];
                    if(final_amount==0){
                        delete_storagePlace_sql = "delete from storagePlace_"+militaryUnit+" where property_id = ? and name = ?;";
                        delete_storagePlace_param = [arr_property_id[i], arr_storagePlace[i]];
						delete_storagePlace_result = await myQuery(delete_storagePlace_sql, delete_storagePlace_param);
                        if(!delete_storagePlace_result){
                            return false;
                        }
                    }
                    else{
                        update_storagePlace_sql = "update storagePlace_"+militaryUnit+" set amount = ? where property_id = ? and name = ?;";
                        update_storagePlace_param = [final_amount, arr_property_id[i], arr_storagePlace[i]];
                        update_storagePlace_result = await myQuery(update_storagePlace_sql, update_storagePlace_param);
                        if(!update_storagePlace_result){
                            return false;
                        }
                    }
                }
//////////////////////////////////
            }
        }
	}
	else if(origin_receiptPayment=="이동"){	////타겟은 빼주고, storagePlace는 더해주고

		for(let i=0; i<len; ++i){	//타겟은 빼주고, storagePlace는 더해주고 

			select_storagePlace_sql = "select * from storagePlace_"+militaryUnit+" where property_id = ? and name = ?;";
            select_storagePlace_param = [arr_property_id[i], target];
            [select_storagePlace_result] = await con.query(select_storagePlace_sql, select_storagePlace_param);
			
			if(select_storagePlace_result.length==0){ //일단 마이너스로 넣자 
				storagePlace_id = arr_property_id[i]+"-"+target;
				insert_storagePlace_sql = "insert into storagePlace_"+militaryUnit+" values (?,?,?,?,?);";
                insert_storagePlace_param = [storagePlace_id, arr_property_id[i], target, (-1)*arr_amount[i], arr_unit[i]];
                insert_storagePlace_result = await myQuery(insert_storagePlace_sql, insert_storagePlace_param);
                if(!insert_storagePlace_result){
                    return false;
                }
			}
			else{
				var origin_amount = select_storagePlace_result[0].amount;
                var final_amount = origin_amount-arr_amount[i];
                if(final_amount==0){
                    delete_storagePlace_sql = "delete from storagePlace_"+militaryUnit+" where property_id = ? and name = ?;";
                    delete_storagePlace_param = [arr_property_id[i], target];
					delete_storagePlace_result = await myQuery(delete_storagePlace_sql, delete_storagePlace_param);
                    if(!delete_storagePlace_result){
						//res.send(arr_property_id[i]+" "+target);
                        return false;
                    }
                }
                else{
                    update_storagePlace_sql = "update storagePlace_"+militaryUnit+" set amount = ? where property_id = ? and name = ?;";
                    update_storagePlace_param = [final_amount, arr_property_id[i], target];
                    update_storagePlace_result = await myQuery(update_storagePlace_sql, update_storagePlace_param);
                    if(!update_storagePlace_result){
                        return false;
                    }
                }
			}
			select_storagePlace_sql = "select * from storagePlace_"+militaryUnit+" where property_id = ? and name = ?;";
            select_storagePlace_param = [arr_property_id[i], arr_storagePlace[i]];
            [select_storagePlace_result] = await con.query(select_storagePlace_sql, select_storagePlace_param);
			if(select_storagePlace_result.length==0){
				storagePlace_id = arr_property_id[i]+"-"+arr_storagePlace[i];
                insert_storagePlace_sql = "insert into storagePlace_"+militaryUnit+" values (?,?,?,?,?);";
                insert_storagePlace_param = [storagePlace_id, arr_property_id[i], arr_storagePlace[i], arr_amount[i], arr_unit[i]];
                insert_storagePlace_result = await myQuery(insert_storagePlace_sql, insert_storagePlace_param);
                if(!insert_storagePlace_result){
                    return false;
                }
            }
            else{
                var origin_amount = select_storagePlace_result[0].amount;
                var final_amount = origin_amount+arr_amount[i];
                console.log(final_amount);
                update_storagePlace_sql = "update storagePlace_"+militaryUnit+" set amount = ? where property_id = ? and name = ?;";
                update_storagePlace_param = [final_amount, arr_property_id[i], arr_storagePlace[i]];
                update_storagePlace_result = await myQuery(update_storagePlace_sql, update_storagePlace_param);
                if(!update_storagePlace_result){
                    return false;
                }
            }
        }
	}
	else{	//폐기 반납 불출일때는 단순 빼기였으니까 그냥 그대로 더해준다\
	//	var insert_storagePlace_sql, insert_storagePlace_param, insert_storagePlace_result;
		for(let i=0; i<len; ++i){
        	select_property_sql = "select * from property_"+militaryUnit+" where id = ?;";
        	select_property_param = arr_property_id[i];
        	[select_property_result] = await con.query(select_property_sql, select_property_param);
/*
			var property_name = select_property_result[0].name;
			var property_totalAmount = select_property_result[0].totalAmount;
			var property_unit = select_property_result[0].unit;
			var property_expirationDate = select_property_result[0].expirationDate;
			var property_createdAt = select_property_result[0].createdAt;
			var property_updatedAt = select_property_result[0].updatedAt;
*/
			if(select_property_result==0){	//오류가 아니라 그 빼기함으로써 다 써서 없는거임 
				insert_property_sql = "insert into property_"+militaryUnit+" values (?,?,?,?,?, now(), now());";
				insert_property_param = [arr_property_id[i], arr_name[i], arr_amount[i], arr_unit[i], arr_expirationDate[i]];
				insert_property_result = await myQuery(insert_property_sql, insert_property_param);
				if(!insert_property_result){
					return false; 
				}
			//약장함에도 약 없음
				storagePlace_id = arr_property_id[i]+"-"+arr_storagePlace[i];
				insert_storagePlace_sql = "insert into storagePlace_"+militaryUnit+" values (?,?,?,?,?);";
				insert_storagePlace_param = [storagePlace_id, arr_property_id[i], arr_storagePlace[i], arr_amount[i], arr_unit[i]];
				insert_storagePlace_result = await myQuery(insert_storagePlace_sql, insert_storagePlace_param);
				//storagePlace_id = arr_property_id[i]+"-"+arr_storagePlace[i];
				if(!insert_storagePlace_result){
                    return false;
                }
			}
			else{
				var origin_totalAmount = select_property_result[0].totalAmount;
            	modify_amount = arr_amount[i];
            	var final_totalAmount = origin_totalAmount+modify_amount;
            	update_property_sql = "update property_"+militaryUnit+" set totalAmount = ? where id = ?;";
				update_property_param = [final_totalAmount, arr_property_id[i]];
				update_property_result = await myQuery(update_property_sql, update_property_param);
				if(!update_property_result){
					return false;
                }
				storagePlace_id = arr_property_id[i]+"-"+arr_storagePlace[i];
				select_storagePlace_sql = "select * from storagePlace_"+militaryUnit+" where id = ?;";
				select_storagePlace_param = storagePlace_id;
				[select_storagePlace_result] = await con.query(select_storagePlace_sql, select_storagePlace_param);
				if(select_storagePlace_result.length==0){
                	insert_storagePlace_sql = "insert into storagePlace_"+militaryUnit+" values (?,?,?,?,?);";
                	insert_storagePlace_param = [storagePlace_id, arr_property_id[i], arr_storagePlace[i], arr_amount[i], arr_unit[i]];
                	insert_storagePlace_result = await myQuery(insert_storagePlace_sql, insert_storagePlace_param);
					if(!insert_storagePlace_result){
                    	return false;
                	}
				}
				else{
					var origin_amount = select_storagePlace_result[0].amount;
					var final_amount = origin_amount+arr_amount[i];
					update_storagePlace_sql = "update storagePlace_"+militaryUnit+" set amount = ? where id = ?;";
                	update_storagePlace_param = [final_amount, storagePlace_id];
                	update_storagePlace_result = await myQuery(update_storagePlace_sql, update_storagePlace_param);
                	if(!update_storagePlace_result){
						return false;
                	}
				}
///////////////////////////////////////약장함도 고치기
			}
        	//console.log(select_property_result[0]);

    	}
	}
	return true;
}

exports.deleteLog = deleteLog;
