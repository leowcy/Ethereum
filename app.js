// Import packages
const express = require('express')
const morgan = require('morgan')
const phonebookRoutes = require('./api/routes/phonebook')
const bodyParser = require('body-parser')
// App
const app = express()

// Morgan
app.use(morgan('tiny'))

//bodyParser
app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());
//indicate the path
app.use('/phonebook', phonebookRoutes);

//Error message reported
app.use((req, res, next) => {
    const error = new Error('Not found');
    error.status = 404;
    next(error);
});

module.exports = app;