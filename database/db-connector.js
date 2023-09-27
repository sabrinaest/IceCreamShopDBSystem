// ./database/db-connector.js

// Get an instance of mysql we can use in the app
const mysql = require('mysql')

// Create a 'connection pool' using the provided credentials
const pool = mysql.createPool({
    connectionLimit : 10,
    host            : 'localhost',
    user            : 'YOUR_MYSQL_USERNAME',
    password        : 'YOUR_MYSQL_PASSWORD',
    database        : 'sunshinescoops'
});


// Export it for use in our applicaiton
module.exports.pool = pool;
