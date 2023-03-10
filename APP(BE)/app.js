var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var userRouter = require('./routes/user');
var loginRouter = require('./routes/login');
var logoutRouter = require('./routes/logout');
var deleteRouter = require('./routes/delete');
var checkbelongRouter = require('./routes/check_belong');
var propertyRouter = require('./routes/property');
var paymentLogRouter = require('./routes/paymentLog');
var make_table_Router = require('./routes/make_table');
var drop_table_Router = require('./routes/drop_table');
var drop_make_Router = require('./routes/drop_make');
var testRouter = require('./routes/test');
var pictureRouter = require('./routes/picture');
var indexRouter = require('./routes/index');
var tokencheckRouter = require('./routes/tokencheck');
var bookmarkRouter = require('./routes/bookmark');
var favoriteRouter = require('./routes/favorite');
//var indexRouter = require('./routes/index');
//var usersRouter = require('./routes/users');
//var verifyRouter = require('./routes/verify');
//var test = require('./routes/test');
//var login = require('./routes/jwt_test');
var app = express();
app.use(express.json());
app.use(express.urlencoded({extended:true}));
// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.set('port', process.env.PORT || 3000);
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
//var helmet = require('helmet');
//app.use(helmet.referrerPolicy({ policy: 'strict-origin-when-cross-origin' }));
var cors = require('cors');
app.use(cors());

//app.use('/', indexRouter);
//app.use('/users', usersRouter);
//app.use('/test', test);
app.use('/login', loginRouter);
app.use('/logout', logoutRouter);
app.use('/user', userRouter);
//app.use('/delete', deleteRouter);
//app.use('/checkbelong', checkbelongRouter);
app.use('/property', propertyRouter);
app.use('/paymentLog', paymentLogRouter);
app.use('/maketable', make_table_Router);
app.use('/droptable', drop_table_Router);
app.use('/dropmake', drop_make_Router);
//app.use('/test', testRouter);
app.use('/picture', pictureRouter);
app.use('/', indexRouter);
//app.use('/verify', verifyRouter);
app.use('/tokencheck', tokencheckRouter);
app.use('/bookmark', bookmarkRouter);
app.use('/favorite', favoriteRouter);
// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
var server = app.listen(app.get('port'), function() {
    console.log('Express server listening on port ' + server.address().port);

});
