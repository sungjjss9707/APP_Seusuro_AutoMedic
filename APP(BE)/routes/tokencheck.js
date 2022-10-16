var express = require('express'); 
var bcrypt = require('bcrypt');
var router = express.Router(); 
var con;
var db = require('mysql2/promise');
var mysql = require('../config');
var crypto = require('crypto');
var table = require('../routes/table');
var inform = mysql.inform;
var verify = require('../routes/verify');
const bodyParser = require('body-parser');
const multer = require('multer');
const form_data = multer();
var app = express();
app.use(express.json());
app.use(express.urlencoded({extended: false}));
app.use(form_data.array());

async function myQuery(sql, param){
    try{
        const [row, field] = await con.query(sql,param);
        return {success:true, error:null};
    }catch(error){
        console.log(error);
        return {success:false, error:error};
    }
}

const upload = multer({
    storage: multer.diskStorage({
        destination: function (req, file, cb) {
            cb(null, 'public/');
        },
        filename: function (req, file, cb) {
            cb(null, Date.now()+"-"+file.originalname);
        }
    }),
});


//const upload = multer({ dest: 'uploads/', limits: { fileSize: 5 * 1024 * 1024 } });


router.post('/', async function(req, res, next) {
    const id = req.body.id;
    const accessToken = req.header('accessToken');
	const refreshToken = req.header('refreshToken');
    if (accessToken == null || refreshToken==null) {
        res.send({status:400, message:"토큰없음", data:null});
        return;
    }
	//console.log(accessToken+"  "+id);
    var verify_success = await verify.verifyFunction(accessToken,refreshToken,id);
    if(!verify_success.success){
        res.send({status:400, message:verify_success.message, data:null});
        return;
    }
	var new_access_token = verify_success.accessToken;
	var new_refresh_token = verify_success.refreshToken;
	res.header({"accessToken":new_access_token, "refreshToken":new_refresh_token}).send({status:200, message:"Ok", data:null});

});


module.exports = router;
