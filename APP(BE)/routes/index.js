var express = require('express');
var cors = require('cors');
var router = express.Router();
var app = express();
app.use(cors());
/* GET home page. */
router.get('/', function(req, res, next) {
	res.setHeader("Access-Control-Allow-Origin", "*");
    //res.setHeader("Access-Control-Allow-Origin", "https://seusuro.com");
    //res.setHeader("Access-Control-Allow-Credentials", "true");
    //res.setHeader("Access-Control-Allow-Methods", "HEAD,OPTIONS,POST,PUT,DELETE");
    //res.setHeader("Access-Control-Allow-Headers",");
//    res.setHeader("Access-Control-Allow-Headers", "Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers,Authorization");
    //res.setHeader("Access-Control-Allow-Headers","Access-Control-Allow-Origin, Content-Type,Accept, Authorization");
    ///res.setHeader("Access-Control-Expose-Headers","*");
	//res.setHeader("Authorization","sibal");
	//res.setHeader("refreshToken","si");
	//res.setHeader("accessToken","bal");
	//const Authorization = req.hearder('Authorization');
    //const accessToken = req.header('accessToken');
    //const refreshToken = req.header('refreshToken');
    //console.log(accessToken);
    //console.log(refreshToken);
	const accept = req.header('accept');
	const accept_encoding = req.header('accept-encoding');
	console.log(accept);
	console.log(accept_encoding);
	res.setHeader("Authorization","sibal");
    res.render('index', { title: '존나안되네' });
});

module.exports = router;
