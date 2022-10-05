var express = require('express'); 
var bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const config = require('../config');
var router = express.Router(); 
var db = require('mysql2/promise');
var new_issue = require('../routes/issue');
var del_ref = require('../routes/del_refresh');
var inform = config.inform;
var refresh_time = config.refresh_time;
var access_time = config.access_time;
var con;

async function verify_token(token){
	//console.log("받은 토큰 : "+token);
	try {
        const tokenInfo = await new Promise((resolve, reject) => {
            jwt.verify(token, config.secret,
                (err, decoded) => {
                    if (err) {
                        reject(err);
                    } else {
                        resolve(decoded);
                    }
            });
        });
		return {success:true, decoded:tokenInfo};
            //res.send("인증성공");
    } catch(err) {
        //console.log(err.message);
        console.log("인증실패");
        return {success:false , message : err.message};
    }
}

async function Query(sql, param){
    try{
        //console.log(update_sql);
        const [row, field] = await con.query(sql, param);
        return true;
    }catch(error){
        return false;
    }
}

var verifyFunction = async function(accessToken,refreshToken, id) {
    //const accessToken = req.body.token; 
	if (accessToken == null) {
		return {success:false, message:"토큰없음"};
		//res.status(403).json({status:400, message:'Bad Request', data:null});
	} else{
		var access = await verify_token(accessToken);
		if(access.success){
			console.log("인증성공");
            return {success:true, "accessToken":accessToken,"refreshToken":refreshToken};
        }
        else{
			con = await db.createConnection(inform);
			var select_user_inform_sql = "select email, name from user where id = ?;";
        	var select_user_inform_param = id;
        	const [select_user_inform_result] = await con.query(select_user_inform_sql ,select_user_inform_param);
        	if(select_user_inform_result.length==0){
            	console.log("이미 삭제됨");
            	return {success:false, message:"없는계정임"};
        	    //res.send({status:400, message:"Bad Request", data:null});
        	}
			var select_token_sql = "select token from refresh_token where id = ?;";
       		var select_token_param = id;			
			const [select_token_result] = await con.query(select_token_sql, select_token_param);
			if(select_token_result.length==0){
				return {success:false, message:"토큰 만료"};
			}
			var server_refresh_token = select_token_result[0].token;
			if(server_refresh_token!=refreshToken){
                return {success:false, message:"토큰 만료"};
            }
			var refresh_valid = await verify_token(refreshToken);
			if(!refresh_valid.success){
				var mymessage;
				if(refresh_valid.message=="jwt expired"){
					mymessage = "토큰 만료";
				}
				else{
					mymessage = "잘못된 토큰";
				}
				var delete_refresh_token_sql = "delete from refresh_token where id = ?;";
				var delete_refresh_token_param = id;
				var delete_success = await Query(delete_refresh_token_sql, delete_refresh_token_param);
				if(delete_success) return {success:false, message:mymessage};
			}
			//여까지 온건 refresh가 발리드 하단 뜻임
        	var name = select_user_inform_result[0].name;
        	var email = select_user_inform_result[0].email;

			var access_token_obj = await new_issue.issue_new_token(email, name, access_time);
            var new_access_token = access_token_obj.Token;
			return {success:true, "accessToken":new_access_token,"refreshToken":refreshToken};
		}
	}
}

//modul.eexports = router;
exports.verifyFunction = verifyFunction;
