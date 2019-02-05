// Import packages
const http = require('http');
// App
const app = require('./app');
//port
const port = process.env.PORT || 8080;
//server
const server = http.createServer(app);
//listen()
server.listen(port);