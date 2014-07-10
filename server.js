var http = require('http');
var connect = require('connect');
var static = require('serve-static');
var port = process.env.NODE_PORT || 4567;

var app = connect();

app.use(static('./public'));
app.use(static('./node_modules/bootstrap/dist'));

http.createServer(app).listen(port);
