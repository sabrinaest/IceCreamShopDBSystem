// npm install express, body-parser, mongoose, ejs
var express = require("express");
var app = express();
const db = require('./database/db-connector')
const methodOverride = require('method-override');
var bodyParser = require("body-parser");
PORT = 52990;


// set app to use the ejs engine 'view engine', 'ejs'
app.set('view engine', 'ejs');

// set app to use bodyParser urlencoded (extended: true)
app.use(bodyParser.urlencoded({extended: true}));

// set app to OVERRIDE POST methods in order to PATCH or DELETE
app.use(methodOverride('_method'))

app.use(function(req, res, next) {
  console.log('Request body:', req.body);
  next();
});

// Serve static files from the public directory
app.use(express.static('public'));

app.use(function(req, res, next) {
  console.log('Request body:', req.body);
  next();
});

///////////////////// HOME PAGE ///////////////////////////
app.get('/', function(req, res) {
  res.render('index');
});

///////////////////// Customers ///////////////////////////

// SELECT ALL CUSTOMERS -- Purpose of showMessage is to alert user of duplicate phone numbers
app.get('/customers/:showMessage', function(req, res) {
  const showMessage = req.params.showMessage
  getCustomerData(res, showMessage);
});  

// INSERT INTO
app.post('/customers', function(req, res) {
  addCustomerData(req, res);
});

// EDIT SPECIFIC CUSTOMER
app.patch('/customers/:customerID', function(req, res) {
  editCustomerData(req, res);
});

// DELETE SPECIFIC CUSTOMER
app.delete('/customers/:customerID', function(req, res) {
  deleteCustomerData(req, res);
});

//// Helper functions ////

function getCustomerData(res, message) {
  
  const get_query = 'SELECT * FROM Customers;';
  let alert = message
  if (alert === "dupe") {
    alert = "Cannot add or edit customer because phone number already exists in the system."
    console.log(alert)
  }
 
  db.pool.query(get_query, function(err, results, fields) {
    if (!err) {
      res.render('customers', {data: results, showAlert: alert});
    } else {
      console.log(err);
      res.status(500).send('Error retrieving customer data');
    }
  });
};

function addCustomerData(req, res) {
  const firstName = req.body.first_name;
  const lastName = req.body.last_name;
  const rewardPointTotal = 0;
  const totalSale = 0;
  const phoneNumber = req.body.phone_number;
  let action = 0;

  console.log(`phone is ${phoneNumber}`);


  // Check for an existing customer with the same phone number
  const check_existing_phone_number = `SELECT * FROM Customers WHERE phone_number='${phoneNumber}'`;

  db.pool.query(check_existing_phone_number, function (err, rows, fields) {
    if (!err) {
      if (rows.length > 0) {
        action = 2;
        console.log("FOUND EXISTING PHONE NUMBER THAT MATCHES INPUTTED NUMBER");
        handleRedirectCustomer(action, res);

      } else {

        console.log("DID NOT FIND EXISTING PHONE NUMBER");
        const insert = `INSERT INTO Customers (first_name, last_name, reward_point_total, total_sale, phone_number) VALUES ('${firstName}', '${lastName}', ${rewardPointTotal}, ${totalSale}, '${phoneNumber}')`;
        db.pool.query(insert, function (err, result) {
          if (!err) {
            handleRedirectCustomer(action, res);
          } else {
            console.log(err);
            res.status(500).send("Internal server error");
          }
        });
      }
    } else {
      console.log(err);
      res.status(500).send("Internal server error");
    }
  });
};

function editCustomerData(req, res) {
  const firstName = req.body.first_name;
  const lastName = req.body.last_name;
  const phoneNumber = req.body.phone_number;
  let action = 0;

  // Check for an existing customer with the same phone number
  const check_existing_phone_number = `SELECT * FROM Customers WHERE phone_number='${phoneNumber}'`;

  db.pool.query(check_existing_phone_number, function (err, rows, fields) {
    if (!err) {
      if (rows.length > 0) {
        action = 2;
        console.log("FOUND EXISTING PHONE NUMBER THAT MATCHES INPUTTED NUMBER");
        handleRedirectCustomer(action, res);

      } else {

        console.log("DID NOT FIND EXISTING PHONE NUMBER");
        const update = `UPDATE Customers SET first_name='${firstName}', last_name='${lastName}', phone_number='${phoneNumber}' WHERE customer_id=${req.params.customerID}`;
        
        db.pool.query(update, function (err, result) {
          if (!err) {
            handleRedirectCustomer(action, res);
          } else {
            console.log(err);
            res.status(500).send("Internal server error");
          }
        });
      }
    } else {
      console.log(err);
      res.status(500).send("Internal server error");
    }
  });
};

function handleRedirectCustomer(action, res) {
  console.log(`action is: ${action}`);
  if (action == 2) {
    const showMessage = "dupe";
    res.redirect("/customers/" + showMessage);
  } else {
    const showMessage = "success";
    res.redirect("/customers/" + showMessage);
  }
};

function deleteCustomerData(req, res) {
  const delete_cust = `DELETE FROM Customers WHERE customer_id=${req.params.customerID}`;
  
  db.pool.query(delete_cust, function(err, rows, fields) {
    if (!err) {
      res.redirect('/customers/success');
    } else {
      console.log(err)
      res.status(500).send('Internal server error');
    }
  })
};


///////////////////// MENU ITEMS ///////////////////////////

// SELECT ALL MENU ITEMS
app.get('/menu-items', function(req, res) {
  getMenuItemData(res)
});

// INSERT INTO
app.post('/menu-items', function(req, res) {
  addMenuItemData(req, res);
});

// EDIT SPECIFIC MENU ITEM
app.patch('/menu-items/:menuID', function(req, res) {
  editMenuItemData(req, res);
});

// DELETE SPECIFIC MENU ITEM
app.delete('/menu-items/:menuID', function(req, res) {
  deleteMenuItemData(req, res);
});

//// Helper functions ////

function getMenuItemData(res) {
  
  const search_query = 'SELECT * FROM Menu_Items;';
  
  db.pool.query(search_query, function(err, results, fields) {
    if (!err) {
      res.render('menu_items', {data: results});
    } else {
      console.log(err)
    }
  })
};

function addMenuItemData(req, res) {
  const menuName = req.body.menu_name;
  const pricePerUnit = req.body.price_per_unit;
  const description = req.body.description;
  
  const insert = `INSERT INTO Menu_Items (menu_name, price_per_unit, description) VALUES ('${menuName}', '${pricePerUnit}','${description}')`;
  
  db.pool.query(insert, function(err, rows, fields) {
    if (!err) {
      res.redirect('/menu-items');
    } else {
      console.log(err)
      res.status(500).send('Internal server error');
    }
  })
};

function editMenuItemData(req, res) {
  const menuName = req.body.menu_name;
  const pricePerUnit = req.body.price_per_unit;
  const description = req.body.description;

  const update = `UPDATE Menu_Items SET menu_name='${menuName}', price_per_unit='${pricePerUnit}', description='${description}' WHERE menu_id=${req.params.menuID}`;
  
  db.pool.query(update, function(err, rows, fields) {
    if (!err) {
      res.redirect('/menu-items');
    } else {
      console.log(err)
      res.status(500).send('Internal server error');
    }
  })
};

function deleteMenuItemData(req, res) {
  const delete_menu_item = `DELETE FROM Menu_Items WHERE menu_id=${req.params.menuID}`;
  
  db.pool.query(delete_menu_item, function(err, rows, fields) {
    if (!err) {
      res.redirect('/menu-items');
    } else {
      console.log(err)
      res.status(500).send('Internal server error');
    }
  })
};

///////////////////// FLAVORS ///////////////////////////

// SELECT ALL FLAVORS
app.get('/flavors', function(req, res) {
  getFlavorData(res);
});

// INSERT INTO
app.post('/flavors', function(req, res) {
  addFlavorData(req, res);
});

// EDIT SPECIFIC FLAVOR
app.patch('/flavors/:flavorID', function(req, res) {
  editFlavorData(req, res);
});

// DELETE SPECIFIC FLAVOR
app.delete('/flavors/:flavorID', function(req, res) {
  deleteFlavorData(req, res);
});

//// Helper functions ////

function getFlavorData(res) {
  
  const search_query = 'SELECT * FROM Flavors;';
  
  db.pool.query(search_query, function(err, results, fields) {
    if (!err) {
      res.render('flavors', {data: results});
    } else {
      console.log(err);
      res.status(500).send('Error retrieving flavors data');
    }
  });
};

function addFlavorData(req, res) {
  const flavorName = req.body.flavor_name;
  const qtyInStock = req.body.qty_in_stock;
  
  const insert = `INSERT INTO Flavors (flavor_name, qty_in_stock) VALUES ('${flavorName}', '${qtyInStock}')`;
  
  db.pool.query(insert, function(err, rows, fields) {
    if (!err) {
      res.redirect('/flavors');
    } else {
      console.log(err)
      res.status(500).send('Internal server error');
    }
  })
};

function editFlavorData(req, res) {
  const flavorName = req.body.flavor_name;
  const qtyInStock = req.body.qty_in_stock;

  const update = `UPDATE Flavors SET flavor_name='${flavorName}', qty_in_stock='${qtyInStock}' WHERE flavor_id=${req.params.flavorID}`;
  
  db.pool.query(update, function(err, rows, fields) {
    if (!err) {
      res.redirect('/flavors');
    } else {
      console.log(err)
      res.status(500).send('Internal server error');
    }
  })
};

function deleteFlavorData(req, res) {
  const delete_flav = `DELETE FROM Flavors WHERE flavor_id=${req.params.flavorID}`;
  
  db.pool.query(delete_flav, function(err, rows, fields) {
    if (!err) {
      res.redirect('/flavors');
    } else {
      console.log(err)
      res.status(500).send('Internal server error');
    }
  })
};

///////////////////// CONTAINERS ///////////////////////////

// SELECT ALL CONTAINERS
app.get('/containers', function(req, res) {
  getContainerData(res)
});

// INSERT INTO
app.post('/containers', function(req, res) {
  addContainerData(req, res);
});

// EDIT SPECIFIC CONTAINER
app.patch('/containers/:containerID', function(req, res) {
  editContainerData(req, res);
});

// DELETE SPECIFIC CONTAINER
app.delete('/containers/:containerID', function(req, res) {
  deleteContainerData(req, res);
});

//// Helper functions ////

function getContainerData(res) {
  
  const search_query = 'SELECT * FROM Containers;';
  
  db.pool.query(search_query, function(err, results, fields) {
    if (!err) {
      res.render('containers', {data: results});
    } else {
      console.log(err)
    }
  })
};

function addContainerData(req, res) {
  const containerName = req.body.container_name;
  const pricePerUnit = req.body.price_per_unit;
  const qtyInStock = req.body.qty_in_stock;
  
  const insert = `INSERT INTO Containers (container_name, price_per_unit, qty_in_stock) VALUES ('${containerName}', '${pricePerUnit}','${qtyInStock}')`;
  
  db.pool.query(insert, function(err, rows, fields) {
    if (!err) {
      res.redirect('/containers');
    } else {
      console.log(err)
      res.status(500).send('Internal server error');
    }
  })
};

function editContainerData(req, res) {
  const containerName = req.body.container_name;
  const pricePerUnit = req.body.price_per_unit;
  const qtyInStock = req.body.qty_in_stock;

  const update = `UPDATE Containers SET container_name='${containerName}', price_per_unit='${pricePerUnit}', qty_in_stock='${qtyInStock}' WHERE container_id=${req.params.containerID}`;
  
  db.pool.query(update, function(err, rows, fields) {
    if (!err) {
      res.redirect('/containers');
    } else {
      console.log(err)
      res.status(500).send('Internal server error');
    }
  })
};

function deleteContainerData(req, res) {
  const delete_cont = `DELETE FROM Containers WHERE container_id=${req.params.containerID}`;
  
  db.pool.query(delete_cont, function(err, rows, fields) {
    if (!err) {
      res.redirect('/containers');
    } else {
      console.log(err)
      res.status(500).send('Internal server error');
    }
  })
};

///////////////////// ORDERS ///////////////////////////// 


// SELECT SPECIFIC ORDER AND SUBORDERS -- Purpose of showMessage is to alert user of duplicate entries.
app.get('/orders/:orderID/:showMessage', function(req, res) {
  const getOrderID = req.params.orderID
  const showMessage = req.params.showMessage
  getOrderData(req, res, getOrderID, showMessage);
});

// SELECT ALL ORDERS AND SUBORDERS
app.get('/orders', function(req, res) {
  getOrderData(req, res, -1)
});

// INSERT INTO
app.post('/orders', function(req, res) {
  addOrderData(req, res);
});

// EDIT SPECIFIC ORDER
app.patch('/orders/:orderID', function(req, res) {
  editOrderData(req, res);
});

// DELETE SPECIFIC ORDER
app.delete('/orders/:orderID', function(req, res) {
  deleteOrderData(req, res);
});

//////////////////////// SUBORDERS //////////////////////////////////

// INSERT INTO
app.post('/suborders', function(req, res) {
  console.log("Reached Add suborder route")
  addSuborderData(req, res);
});

// EDIT SPECIFIC SUBORDER
app.patch('/suborders/:suborderID', function(req, res) {
  editSuborderData(req, res);
});

// DELETE SPECIFIC SUBORDER
app.delete('/suborders/:orderID/:suborderID', function(req, res) {
  console.log("Reached Delete Suborder route")
  deleteSuborderData(req, res);
});

//// Helper functions ////

function getOrderData(req, res, ID, message) {
  
  let order_query = "";
  let suborder_query_2 = "";
  let alert = message
  if (alert === "dupe") {
    alert = "Cannot make requested changes to suborder because another suborder contains matching contents."
    console.log(alert)
  }
 
  if (ID === -1) {
    order_query = `
      SELECT Orders.*, COUNT(Suborders.suborder_item_id) AS suborder_count
      FROM Orders
      LEFT JOIN Suborders ON Orders.order_id = Suborders.order_id
      GROUP BY Orders.order_id;
    `;
    suborder_query_2 = `
    SELECT Suborders.suborder_item_id, Menu_Items.menu_name, Flavors.flavor_name, Flavors.flavor_id, Containers.container_name, Containers.container_id, Menu_Items.menu_id, Suborders.quantity_ordered, Suborders.subtotal, Orders.order_id, Containers.price_per_unit AS cont_price, Menu_Items.price_per_unit AS menu_price, Menu_Items.menu_name AS menu_name
    FROM Suborders
    JOIN Menu_Items ON Suborders.menu_id = Menu_Items.menu_id
    JOIN Flavors ON Suborders.flavor_id = Flavors.flavor_id
    LEFT JOIN Containers ON Suborders.container_id = Containers.container_id
    JOIN Orders ON Suborders.order_id = Orders.order_id
    ORDER BY Orders.order_id, Suborders.suborder_item_id ASC;
    `;
    
  } else {
    order_query = `
      SELECT Orders.*, COUNT(Suborders.suborder_item_id) AS suborder_count
      FROM Orders
      LEFT JOIN Suborders ON Orders.order_id = Suborders.order_id
      WHERE Orders.order_id=${ID}
      GROUP BY Orders.order_id;
    `;

    suborder_query_2 = `
    SELECT Suborders.suborder_item_id, Menu_Items.menu_name, Flavors.flavor_name, Flavors.flavor_id, Containers.container_name, Containers.container_id, Menu_Items.menu_id, Suborders.quantity_ordered, Suborders.subtotal, Orders.order_id, Containers.price_per_unit AS cont_price, Menu_Items.price_per_unit AS menu_price, Menu_Items.menu_name AS menu_name
    FROM Suborders
    JOIN Menu_Items ON Suborders.menu_id = Menu_Items.menu_id
    JOIN Flavors ON Suborders.flavor_id = Flavors.flavor_id
    LEFT JOIN Containers ON Suborders.container_id = Containers.container_id
    JOIN Orders ON Suborders.order_id = Orders.order_id
    WHERE Orders.order_id=${ID}
    ORDER BY Orders.order_id, Suborders.suborder_item_id ASC;
    `;
  }

  const customer_query = 'SELECT * FROM Customers;';

  const menu_query = 'SELECT * FROM Menu_Items;';

  const flavor_query = 'SELECT * FROM Flavors;';

  const container_query = 'SELECT * FROM Containers;';

  db.pool.query(order_query, function(err, order_results, fields) {
    if (!err) {
      db.pool.query(suborder_query_2, function(err, sub_results, fields) {
        if (!err) {
          db.pool.query(menu_query, function(err, menu_results, fields) {
            if (!err) {
              db.pool.query(flavor_query, function(err, flavor_results, fields) {
                if (!err) {
                  db.pool.query(container_query, function(err, container_results, fields) {
                    if (!err) {
                      db.pool.query(customer_query, function(err, customer_results, fields) {
                        if (!err) {
                          res.render('orders', {
                            data: order_results,
                            suborder_data: sub_results,
                            menu_data: menu_results,
                            flavor_data: flavor_results,
                            container_data: container_results,
                            customer_data: customer_results,
                            showAlert: alert
                          });
                        } else {
                          console.log(err);
                        }
                      });
                    } else {
                      console.log(err);
                    }
                  });
                } else {
                  console.log(err);
                }
              });
            } else {
              console.log(err);
            }
          });
        } else {
          console.log(err);
        }
      });
    } else {
      console.log(err);
    }
  });
};
    
function addOrderData(req, res) {
  const customerID = req.body.customer_id;
  const timeOfSale = req.body.time_of_sale;
  const orderSubtotal = 0;
  const orderTax = 0;
  const orderTotal = 0;
  const pointsAwarded = 0;

  const insert = `INSERT INTO Orders (customer_id, time_of_sale, order_subtotal, order_tax, order_total, points_awarded)  VALUES ('${customerID}', '${timeOfSale}','${orderSubtotal}', '${orderTax}', '${orderTotal}','${pointsAwarded}')`;
  


  db.pool.query(insert, function(err, rows, fields) {
    if (!err) {
          var lastInsertId = rows.insertId;
          res.redirect('/orders/' + lastInsertId + '/' + "success");
        } else {
          console.log(err);
          res.status(500).send('Internal server error');
        }
      });

};

function editOrderData(req, res) {
  let customerID = null;
  if (req.body.customer_id !== "") {
    customerID = `'${req.body.customer_id}'`;
  }

  const update = `UPDATE Orders SET customer_id=${customerID} WHERE order_id=${req.params.orderID}`;
  
  db.pool.query(update, function(err, rows, fields) {
    if (!err) {
      res.redirect('/orders');
    } else {
      console.log(err)
      res.status(500).send('Internal server error');
    }
  })
};

function deleteOrderData(req, res) {
  const delete_order = `DELETE FROM Orders WHERE order_id=${req.params.orderID}`;
  
  db.pool.query(delete_order, function(err, rows, fields) {
    if (!err) {
      res.redirect('/orders');
    } else {
      console.log(err)
      res.status(500).send('Internal server error');
    }
  })
};

///////////////////// SUBORDER SPECIFIC ///////////////////////////// 

//// Helper functions ////

function addSuborderData(req, res) {
  const orderID = req.body.order_id;
  const menuID = JSON.parse(req.body.menu_id)[0];
  const flavorID = req.body.flavor_id;

  let containerID = null;
  if (typeof req.body.container_id !== "undefined") {
    containerID = `'${JSON.parse(req.body.container_id)[0]}'`;
  }

  const quantityOrdered = req.body.quantity_ordered;
  const subtotal = req.body.subtotal;
  let action = req.body.action;
 
  console.log(`FOR ADD SUBORDER: Action is: ${action} for orderID: ${orderID}`)
  // Check for an existing suborder with the same menu_id, container_id, and flavor_id
  const check_existing_suborder = `SELECT * FROM Suborders WHERE order_id='${orderID}' AND menu_id='${menuID}' AND flavor_id='${flavorID}' AND (container_id=${containerID} OR (container_id IS NULL AND ${containerID} IS NULL))`;

  db.pool.query(check_existing_suborder, function (err, rows, fields) {
    if (!err) {
      if (rows.length > 0) {

        console.log("FOUND EXISTING SUBORDER THAT MATCHES INPUTTED ADD SUBORDER")
        // Update the existing suborder's quantity and subtotal
        const existingSuborderID = rows[0].suborder_item_id;
        const newQuantity = parseInt(rows[0].quantity_ordered) + parseInt(quantityOrdered);
        const newSubtotal = parseInt(rows[0].subtotal) + parseInt(subtotal);
        const update_existing_suborder = `UPDATE Suborders SET quantity_ordered=${newQuantity}, subtotal=${newSubtotal} WHERE suborder_item_id=${existingSuborderID}`;

        db.pool.query(update_existing_suborder, function (err, rows, fields) {
          if (!err) {
            handleRedirect(action, orderID, res);
          } else {
            console.log(err);
            res.status(500).send("Internal server error");
          }
        });
      } else {
        console.log("DID NOT FIND EXISTING SUBORDER THAT MATCHES INPUTTED ADD SUBORDER")
        // Insert a new suborder
        const insert_suborder = `INSERT INTO Suborders (order_id, menu_id, flavor_id, container_id, quantity_ordered, subtotal)  VALUES ('${orderID}', '${menuID}','${flavorID}', ${containerID}, '${quantityOrdered}','${subtotal}')`;

        db.pool.query(insert_suborder, function (err, rows, fields) {
          if (!err) {
            handleRedirect(action, orderID, res);
          } else {
            console.log(err);
            res.status(500).send("Internal server error");
          }
        });
      }
    } else {
      console.log(err);
      res.status(500).send("Internal server error");
    }
  });
};

function editSuborderData(req, res) {

  const orderID = req.body.order_id;
  const menuID = JSON.parse(req.body.menu_id)[0];
  const flavorID = req.body.flavor_id;

  let containerID = null
  if (typeof req.body.container_id !== "undefined") {
    containerID = `'${JSON.parse(req.body.container_id)[0]}'`
  }

  const quantityOrdered = req.body.quantity_ordered;
  const subtotal = req.body.subtotal;
  let action = req.body.action;
  
  // Check for an existing suborder with the same menu_id, container_id, and flavor_id
  const check_existing_suborder = `SELECT * FROM Suborders WHERE order_id='${orderID}' AND menu_id='${menuID}' AND flavor_id='${flavorID}' AND (container_id=${containerID} OR (container_id IS NULL AND ${containerID} IS NULL))`;

  db.pool.query(check_existing_suborder, function (err, rows, fields) {
    if (!err) {
      if (rows.length > 0 && rows[0].suborder_item_id != req.params.suborderID) {
        // if the existing suborder is not current suborder, 
        action = -1
        handleRedirect(action, orderID, res);
      } else {
        // Update the current suborder
        const update_suborder = `UPDATE Suborders SET order_id=${orderID}, menu_id='${menuID}', flavor_id='${flavorID}', container_id=${containerID}, quantity_ordered='${quantityOrdered}', subtotal='${subtotal}' WHERE order_id=${orderID} AND suborder_item_id=${req.params.suborderID}`;

  
        db.pool.query(update_suborder, function(err, rows, fields) {
          if (!err) {
            handleRedirect(action, orderID, res);
          } else {
            console.log(err)
            res.status(500).send('Internal server error');
          }
        });
      }
    } else {
      console.log(err);
      res.status(500).send("Internal server error");
    }
  });
};

function handleRedirect(action, orderID, res) {
  console.log(`Action is: ${action} for orderID: ${orderID}`)
  if (action == 1) {
    const showMessage = "success"
    res.redirect("/orders/" + orderID + "/" + showMessage);
  } else if (action == -1) {
    const showMessage = "dupe"
    res.redirect("/orders/" + orderID + "/" + showMessage);
  } else {
    res.redirect("/orders");
  }
};

function deleteSuborderData(req, res) {

  const orderID = req.params.orderID
  const delete_suborder = `DELETE FROM Suborders WHERE order_id=${orderID} AND suborder_item_id=${req.params.suborderID}`;
  let action = req.body.action;

  db.pool.query(delete_suborder, function(err, rows, fields) {
    if (!err) {
      if (action == 1) {
        res.redirect('/orders/' + orderID + '/' + "success");  
      } else {
        res.redirect('/orders');
      }
    } else {
      console.log(err)
      res.status(500).send('Internal server error');
    }
  });
};


// Start the server
let port = process.env.PORT;
if (port == null || port =="") {
  port = 52990;
}
app.listen(port, function() {
  console.log('Server started successfully');
});
