var express = require('express'); 
var bcrypt = require('bcrypt');
var router = express.Router(); 
var con;
var db = require('mysql2/promise');
var config = require('../config');
var mysql = require('../config');
var crypto = require('crypto');
var table = require('../routes/table');
var inform = mysql.inform;
var verify = require('../routes/verify');
const jwt = require('jsonwebtoken');
var new_issue = require('../routes/issue');
var refresh_time = config.refresh_time;
var access_time = config.access_time;
const bodyParser = require('body-parser');
const multer = require('multer');
const form_data = multer();
var app = express();
app.use(express.json());
app.use(express.urlencoded({extended: false}));
app.use(form_data.array());
var cors = require('cors');
app.use(cors());
async function myQuery(sql, param){
    try{
        const [row, field] = await con.query(sql,param);
        return true;
    }catch(error){
        console.log(error);
        return false;
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



router.post('/', upload.single('img'), (req, res) => {
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Credentials", "true");
    res.setHeader("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
    res.setHeader("Access-Control-Allow-Headers", "Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers");
    res.setHeader("Access-Control-Expose-Headers","*");
	console.log("준거 : "+req.file.filename);
    res.send({status:200, message:"Ok", data:req.file.filename});
});

module.exports = router;
