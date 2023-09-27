-- =================================================== --
--                  Database Project
--        Sabrina Estrada | Derrick Macaranas 
-- =================================================== --


-- =================================================== --
--                  Customers Queries                  --
-- =================================================== --

-------------------- SELECT QUERIES ---------------------

-- Query for a select Customers functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Select/display all data from Customers table --

SELECT * FROM CUSTOMERS;

-- Query needed to check whether phone number exists in the DB to avoid duplicate phone numbers --
SELECT * FROM Customers WHERE phone_number=:phoneNumber_from_add_customer_form;

-------------------- INSERT QUERIES ---------------------

-- Query for a insert Customers functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Adds a new customer when the user clicks on the button at the top of the Customers page --

INSERT INTO Customers (first_name, last_name, reward_point_total, total_sale, phone_number)
VALUES
    (:first_nameInput, 
    :last_nameInput, 
    :reward_point_totalInput, 
    :total_saleInput, 
    :phone_numberInput);

-------------------- UPDATE QUERIES ---------------------

-- Query for a update Customers functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Update a customer's data based on the submission of edit/update customer form, customer info is populated --

UPDATE Customers 
SET first_name=:first_nameInput,
    last_name=:last_nameInput,
    reward_point_total=:reward_point_totalInput,
    phone_number=:phone_numberInput
WHERE customer_id=:customer_id_from_the_update_form;

-------------------- DELETE QUERIES ---------------------

-- Query for a delete Customers functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Delete a customer when user selects the button on the customers row --

DELETE FROM Customers WHERE customer_id=:customer_id_from_delete_form;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =================================================== --
--                  Menu_Items Queries                 --
-- =================================================== --

-------------------- SELECT QUERIES ---------------------

-- Query for a select Menu_Items functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Select/display all the menu items, the price and their descriptions --

SELECT * FROM Menu_Items;

-------------------- INSERT QUERIES ---------------------

-- Query for a insert Menu_Items functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Adds a new menu item when user selects the add menu item on top of the Menu_Items page --

INSERT INTO Menu_Items (menu_name, price_per_unit, description)
VALUES
    (:menu_nameInput, 
    :menu_nameInput, 
    :descriptionInput);

-------------------- UPDATE QUERIES ---------------------

-- Query for a update Menu_Items functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Updates a menu items's contents based on the submission of edit/update form with the contents populated --

UPDATE Menu_Items 
SET menu_name=:menu_nameInput,
    price_per_unit=:price_per_unitInput,
    description=:descriptionInput, 
WHERE menu_id=:menu_id_from_the_update_form;

-------------------- DELETE QUERIES ---------------------

-- Query for a delete Menu_Items functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Delete a menu item when user selects the delete button on the menu item's row --

DELETE FROM Menu_Items WHERE menu_id=:menu_id_from_delete_form;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =================================================== --
--                  Flavors Queries                    --
-- =================================================== --

-------------------- SELECT QUERIES ---------------------

-- Query for a select Flavors functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Select/display all the contents in the Flavors table --

SELECT * FROM Flavors;

-------------------- INSERT QUERIES ---------------------

-- Query for a insert Flavors functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Adds a new Flavor when user selects the add button on top of the Flavors page --

INSERT INTO Flavors (flavor_name, qty_in_stock) 
VALUES 
    (:flavor_nameInput, 
    :qty_in_stockInput);

-------------------- UPDATE QUERIES ---------------------

-- Query for a update Flavors functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Update a Flavor's contents based on the submission of edit/update form with the data populated --

UPDATE Flavors
SET flavor_name=:flavor_nameInput,
    qty_in_stock=:qty_in_stockInput, 
WHERE flavor_id=:flavor_id_from_the_update_form;

-------------------- DELETE QUERIES ---------------------

-- Query for a delete Flavors functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Delete a flavor from Flavors when user clicks on the delete button on the flavor's row --

DELETE FROM Flavors WHERE flavor_id=:flavor_id_from_delete_form;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =================================================== --
--                  Containers Queries                 --
-- =================================================== --

-------------------- SELECT QUERIES ---------------------

-- Query for a select Containers functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Select/display all the containers and their prices --

SELECT * FROM Containers;

-------------------- INSERT QUERIES ---------------------

-- Query for a insert Containers functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Adds a new Containers when user selects the add button on top of the Containers page --

INSERT INTO Containers (container_name, price_per_unit, qty_in_stock) 
VALUES 
    (:container_nameInput, 
    :price_per_unitInput, 
    :qty_in_stockInput);

-------------------- UPDATE QUERIES ---------------------

-- Query for a update Containers functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Update a Container's contents based on the submission of edit/update form with the contents populated --

UPDATE Containers
SET container_name=:container_nameInput,
    price_per_unit=:price_per_unitInput,
    qty_in_stock=:qty_in_stockInput
WHERE container_id=:container_id_from_the_update_form;


-------------------- DELETE QUERIES ---------------------

-- Query for a delete Containers functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Delete container from Containers --

DELETE FROM Containers WHERE container_id=:container_id_from_the_delete_form;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =================================================== --
--                  Orders Queries                     --
-- =================================================== --

-------------------- SELECT QUERIES ---------------------

-- Query for a select Orders functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Select/display the orderID, customerID, time of sale and order total for all orders --

SELECT Orders.*, COUNT(Suborders.suborder_item_id) AS suborder_count
FROM Orders
LEFT JOIN Suborders ON Orders.order_id = Suborders.order_id
GROUP BY Orders.order_id

-- Query needed so we can get the specific row for the Add More _ button feature --

SELECT Orders.*, COUNT(Suborders.suborder_item_id) AS suborder_count
FROM Orders
LEFT JOIN Suborders ON Orders.order_id = Suborders.order_id
WHERE Orders.order_id=:order_idInput
GROUP BY Orders.order_id;

-------------------- INSERT QUERIES ---------------------

-- Query for a add Orders functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Adds a new Order when user selects the add button on top of the Orders page --

INSERT INTO Orders (customer_id, time_of_sale, order_subtotal, order_tax, order_total, points_awarded) 
VALUES 
    (:customer_idInput, 
    :time_of_saleInput, 
    :order_subtotalInput, 
    :order_taxInput, 
    :order_totalInput, 
    :points_awardedInput);

-------------------- UPDATE QUERIES ---------------------

-- Query for a update Orders functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Update an Order's contents based on the submission of edit/update form with the contents populated --
-- Updates for Orders is restricted to only changes to the Customer that the Order is associated with. Allows option to customer_id to NULL.  

UPDATE Orders
SET customer_id=:customer_idInput
WHERE order_id=:order_id_from_the_update_form;

-------------------- DELETE QUERIES ---------------------

-- Query for a delete Order functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Delete an order from Orders when user clicks the delete button on the order's row --

DELETE FROM Orders WHERE order_id=:order_id_from_delete_form

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =================================================== --
--                  Suborders Queries                  --
-- =================================================== --

-------------------- SELECT QUERIES ---------------------

-- Query for a select Suborder functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Select/display all data from Suborders table when user navigates to a order on the page --

SELECT Suborders.suborder_item_id, Menu_Items.menu_name, Flavors.flavor_name, Containers.container_name, Suborders.quantity_ordered, Suborders.subtotal
FROM Suborders
JOIN Menu_Items ON Suborders.menu_id = Menu_Items.menu_id
JOIN Flavors ON Suborders.flavor_id = Flavors.flavor_id
LEFT JOIN Containers ON Suborders.container_id = Containers.container_id
JOIN Orders ON Suborders.order_id = Orders.order_id
ORDER BY Orders.order_id, Suborders.suborder_item_id ASC;

-- Query needed to get the values necessary to auto-calculate subtotals and to pre-populate Suborder's Edit Form fields --

SELECT Suborders.suborder_item_id, Menu_Items.menu_name, Flavors.flavor_name, Flavors.flavor_id, Containers.container_name, Containers.container_id, Menu_Items.menu_id, Suborders.quantity_ordered, Suborders.subtotal, Orders.order_id,
Containers.price_per_unit AS cont_price, Menu_Items.price_per_unit AS menu_price, Menu_Items.menu_name AS menu_name
FROM Suborders
JOIN Menu_Items ON Suborders.menu_id = Menu_Items.menu_id
JOIN Flavors ON Suborders.flavor_id = Flavors.flavor_id
LEFT JOIN Containers ON Suborders.container_id = Containers.container_id
JOIN Orders ON Suborders.order_id = Orders.order_id
ORDER BY Orders.order_id, Suborders.suborder_item_id ASC;

-- Query needed to get a specific suborder when the user uses Add More _ button on the Orders page, get the values necessary to auto-calculate subtotals, and to pre-populate Suborder's Edit Form fields  --

SELECT Suborders.suborder_item_id, Menu_Items.menu_name, Flavors.flavor_name, Flavors.flavor_id, Containers.container_name, Containers.container_id, Menu_Items.menu_id, Suborders.quantity_ordered, Suborders.subtotal, Orders.order_id, 
Containers.price_per_unit AS cont_price, Menu_Items.price_per_unit AS menu_price, Menu_Items.menu_name AS menu_name
FROM Suborders
JOIN Menu_Items ON Suborders.menu_id = Menu_Items.menu_id
JOIN Flavors ON Suborders.flavor_id = Flavors.flavor_id
LEFT JOIN Containers ON Suborders.container_id = Containers.container_id
JOIN Orders ON Suborders.order_id = Orders.order_id
WHERE Orders.order_id=:order_idInput
ORDER BY Orders.order_id, Suborders.suborder_item_id ASC;

-- Query needed to check for duplicate suborders --

SELECT * FROM Suborders WHERE order_id=:order_idInput AND menu_id=:menu_idInput AND flavor_id=:flavor_idInput AND (container_id=:container_idInput OR (container_id IS NULL AND :container_idInput IS NULL))

-------------------- INSERT QUERIES ---------------------

-- Query for a new Suborder functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Adds a new suborder to the corresponding order, drop down input will be used for menu item, flavor, and containers --


INSERT INTO Suborders (order_id, menu_id, flavor_id, container_id, quantity_ordered, subtotal)
VALUES 
    (:order_id_selected_from_orders_page, 
    (SELECT menu_id FROM Menu_Items WHERE menu_name = :menu_name_dropdown_menu), 
    (SELECT flavor_id FROM Flavors WHERE flavor_name = :flavor_name_dropdown_menu), 
    (SELECT container_id FROM Containers WHERE container_name = :container_name_dropdown_menu), 
    :quantity_ordered_dropdown_menu, 
    :subtotalInput);


-------------------- UPDATE QUERIES ---------------------

-- Query for a update Suborder functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Populate the previous suborder info when user selects the suborder item id from the dropdown menu corresponding to a order on the orders page --

UPDATE Suborders
SET 
    menu_id = (SELECT menu_id FROM Menu_Items WHERE menu_name = :menu_name_dropdown_menu), 
    flavor_id = (SELECT flavor_id FROM Flavors WHERE flavor_name = :flavor_name_dropdown_menu), 
    container_id = (SELECT container_id FROM Containers WHERE container_name = :container_name_dropdown_menu), 
    quantity_ordered = :quantity_ordered_dropdown_menu, 
    subtotal = :subtotalInput
WHERE suborder_item_id = :suborder_item_id_to_update and order_id = :order_id_selected_from_orders_page;

-- query needed to update existing suborders, if a suborder with matching menu item, flavor, container was added to the order. -- 

UPDATE Suborders SET quantity_ordered=:quantity_ordered_dropdown_menu, subtotal=:subtotalInput WHERE suborder_item_id=:suborder_item_id_to_update

-------------------- DELETE QUERIES ---------------------

-- Query for a delete Suborder functionality with colon : character being used to denote the variables that will have data from the backend programming language --
-- Delete an order from suborders from the corresponding order row, user will select which suborder to delete via drop down menu --

DELETE FROM Suborders WHERE order_id=:order_selected_from_orders_page AND suborder_item_id=:suborder_item_id_drop_down_from_orders;









