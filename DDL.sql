-- =================================================== --
--                  Database Project
--        Sabrina Estrada | Derrick Macaranas 
-- =================================================== --

SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

-- =============== --
--  CREATE TABLES  --
-- =============== --

CREATE OR REPLACE TABLE Customers (
    customer_id INT(12) NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(255) DEFAULT NULL,
    last_name VARCHAR(255) DEFAULT NULL,
    reward_point_total INT(12) DEFAULT NULL,
    total_sale DECIMAL(12,2) NOT NULL,
    phone_number VARCHAR(15) DEFAULT NULL,
    UNIQUE KEY customer_id (customer_id),
    PRIMARY KEY (customer_id)
);

CREATE OR REPLACE TABLE Orders (
   order_id INT(12) NOT NULL AUTO_INCREMENT,
   customer_id INT(12) NULL,
   time_of_sale DATETIME NOT NULL,
   order_subtotal DECIMAL(12,2) NOT NULL,
   order_tax DECIMAL(12,2) NOT NULL,
   order_total DECIMAL (12,2) NOT NULL,
   points_awarded INT(12) DEFAULT NULL,
   UNIQUE KEY order_id (order_id),
   PRIMARY KEY (order_id),
   FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE SET NULL
);

CREATE OR REPLACE TABLE Suborders (
    suborder_item_id INT(12) NOT NULL AUTO_INCREMENT,
    order_id INT(12) NOT NULL,
    menu_id INT(12) NOT NULL,
    flavor_id INT(12) NOT NULL,
    container_id INT(12) DEFAULT NULL,
    quantity_ordered INT(12) NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL,
    UNIQUE suborder_item_id (suborder_item_id),
    PRIMARY KEY (suborder_item_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (menu_id) REFERENCES Menu_Items(menu_id) ON DELETE CASCADE,
    FOREIGN KEY (flavor_id) REFERENCES Flavors(flavor_id) ON DELETE CASCADE,
    FOREIGN KEY (container_id) REFERENCES Containers(container_id) ON DELETE CASCADE
);

CREATE OR REPLACE TABLE Menu_Items (
    menu_id INT(12) NOT NULL AUTO_INCREMENT,
    menu_name VARCHAR(255) NOT NULL,
    price_per_unit DECIMAL(12,2) NOT NULL,
    description VARCHAR(255) NULL,
    PRIMARY KEY (menu_id)
);

CREATE OR REPLACE TABLE Flavors (
    flavor_id INT(12) NOT NULL AUTO_INCREMENT,
    flavor_name VARCHAR(255) NOT NULL,
    qty_in_stock INT(12) NOT NULL,
    PRIMARY KEY (flavor_id)
);

CREATE OR REPLACE TABLE Containers (
    container_id INT(12) NOT NULL AUTO_INCREMENT,
    container_name VARCHAR(255) NOT NULL,
    price_per_unit DECIMAL(12,2) NOT NULL,
    qty_in_stock INT(12) NOT NULL,
    PRIMARY KEY (container_id)
);

-- ================================== --
--  INSERT DATA EXAMPLES INTO TABLES  --
-- ================================== --

INSERT INTO Customers (first_name, last_name, reward_point_total, total_sale, phone_number)
VALUES
    ('Noll', 'Gymblett', 61, 61.61, '477-441-7685'),
    ('Lewiss', 'Kinghorn', 23, 23.18, '802-849-9913'),
    ('Luigi', 'Gilloran', 84, 84.48, '837-759-4127'),
    ('Eldridge', 'Faber', 311, 311.01, '685-131-4127'),
    ('Marlin', 'Zuann', 317, 317.09, '328-486-8634');

INSERT INTO Menu_Items (menu_name, price_per_unit, description)
VALUES
    ('One Scoop', 3.00, 'A single scoop of ice cream served in a cup or cone'),
    ('Double Scoop', 6.00, 'Two scoops of ice cream served in a cup or cone'),
    ('Shake', 6.00, 'A creamy, frozen drink made with ice cream and milk in your choice of flavor');

INSERT INTO Flavors (flavor_name, qty_in_stock) 
VALUES 
    ('Vanilla', 10),
    ('Chocolate', 60),
    ('Strawberry', 70);

INSERT INTO Containers (container_name, price_per_unit, qty_in_stock)
VALUES 
    ('Cup', 1.00, 100),
    ('Sugar Cone', 2.00, 120),
    ('Waffle Cone', 3.00, 150);

INSERT INTO Orders (customer_id, time_of_sale, order_subtotal, order_tax, order_total, points_awarded) 
VALUES 
    ((SELECT customer_id FROM Customers WHERE first_name='Noll' AND last_name='Gymblett'), '2022-12-01 12:30:00', 14.00, 0.91, 14.91, 14),
    ((SELECT customer_id FROM Customers WHERE first_name='Eldridge' AND last_name='Faber'), '2022-12-02 13:45:00', 5.00, 0.33, 5.33, 5),
    ((SELECT customer_id FROM Customers WHERE first_name='Eldridge' AND last_name='Faber'), '2022-12-03 14:30:00', 6.00, 0.39, 6.39, 6),
    ((SELECT customer_id FROM Customers WHERE first_name='Marlin' AND last_name='Zuann'), '2022-12-04 15:15:00', 8.00, 0.52, 8.52, 8),
    ((SELECT customer_id FROM Customers WHERE first_name='Marlin' AND last_name='Zuann'), '2022-12-05 16:00:00', 6.00, 0.39, 6.39, 6);

INSERT INTO Suborders (order_id, menu_id, flavor_id, container_id, quantity_ordered, subtotal)
VALUES 
    ((SELECT order_id FROM Orders WHERE order_id=1), (SELECT menu_id FROM Menu_Items WHERE menu_name='One Scoop'), (SELECT flavor_id FROM Flavors WHERE flavor_name='Vanilla'), (SELECT container_id FROM Containers WHERE container_name='Sugar Cone'), 1, 5.00),
    ((SELECT order_id FROM Orders WHERE order_id=1), (SELECT menu_id FROM Menu_Items WHERE menu_name='Double Scoop'), (SELECT flavor_id FROM Flavors WHERE flavor_name='Chocolate'), (SELECT container_id FROM Containers WHERE container_name='Waffle Cone'), 1, 9.00),
    ((SELECT order_id FROM Orders WHERE order_id=2), (SELECT menu_id FROM Menu_Items WHERE menu_name='One Scoop'), (SELECT flavor_id FROM Flavors WHERE flavor_name='Strawberry'), (SELECT container_id FROM Containers WHERE container_name='Sugar Cone'), 1, 5.00),
    ((SELECT order_id FROM Orders WHERE order_id=3), (SELECT menu_id FROM Menu_Items WHERE menu_name='Shake'), (SELECT flavor_id FROM Flavors WHERE flavor_name='Strawberry'), NULL, 1, 6.00),
    ((SELECT order_id FROM Orders WHERE order_id=4), (SELECT menu_id FROM Menu_Items WHERE menu_name='Double Scoop'), (SELECT flavor_id FROM Flavors WHERE flavor_name='Vanilla'), (SELECT container_id FROM Containers WHERE container_name='Sugar Cone'), 1, 8.00),
    ((SELECT order_id FROM Orders WHERE order_id=5), (SELECT menu_id FROM Menu_Items WHERE menu_name='One Scoop'), (SELECT flavor_id FROM Flavors WHERE flavor_name='Chocolate'), (SELECT container_id FROM Containers WHERE container_name='Waffle Cone'), 1, 6.00);

-- ====================================== --
-- CREATE TRIGGER STATEMENTS 
-- ====================================== --

-- ORDER TRIGGER STATEMENTS --

DELIMITER $$
CREATE TRIGGER update_Customer_After_Order_DELETE AFTER DELETE ON Orders FOR EACH ROW UPDATE Customers
  SET total_sale = total_sale - OLD.order_total,
      reward_point_total = reward_point_total - OLD.points_awarded
  WHERE customer_id = OLD.customer_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER update_NEW_Customers_After_Order_Change AFTER UPDATE ON Orders FOR EACH ROW IF NEW.customer_id IS NOT NULL THEN
    UPDATE Customers
    SET total_sale = total_sale + NEW.order_total,
        reward_point_total = reward_point_total + NEW.points_awarded
    WHERE customer_id = NEW.customer_id;
  END IF
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER update_NULL_Order_to_Customer AFTER UPDATE ON Orders FOR EACH ROW IF OLD.customer_id != NEW.customer_id THEN
    UPDATE Customers
    SET total_sale = total_sale - OLD.order_total + NEW.order_total,
        reward_point_total = reward_point_total - OLD.points_awarded + NEW.points_awarded
    WHERE customer_id = NEW.customer_id;
  END IF
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER update_OLD_Customers_After_Order_Change AFTER UPDATE ON Orders FOR EACH ROW IF OLD.customer_id IS NOT NULL THEN
    UPDATE Customers
    SET total_sale = total_sale - OLD.order_total,
        reward_point_total = reward_point_total - OLD.points_awarded
    WHERE customer_id = OLD.customer_id;
  END IF
$$
DELIMITER ;

-- SUBORDER TRIGGER STATEMENTS --

DELIMITER $$
CREATE TRIGGER after_suborder_delete AFTER DELETE ON Suborders FOR EACH ROW UPDATE Orders
    SET order_subtotal = order_subtotal - OLD.subtotal,
        order_tax = order_subtotal * 0.065,
        order_total = order_subtotal + order_tax,
        points_awarded = FLOOR(order_total / 1.00)
    WHERE order_id = OLD.order_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER after_suborder_edit AFTER UPDATE ON Suborders FOR EACH ROW UPDATE Orders
    SET order_subtotal = order_subtotal - OLD.subtotal + NEW.subtotal,
        order_tax = order_tax - (OLD.subtotal * 0.065) + (NEW.subtotal * 0.065),
        order_total = order_subtotal + order_tax,
        points_awarded = FLOOR(order_total / 1.00)
    WHERE order_id = NEW.order_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER after_suborder_insert AFTER INSERT ON Suborders FOR EACH ROW UPDATE Orders
    SET order_subtotal = order_subtotal + NEW.subtotal,
        order_tax = order_tax + (NEW.subtotal * 0.065),
        order_total = order_total + NEW.subtotal + (NEW.subtotal * 0.065),
        points_awarded = FLOOR(order_total / 1.00)
    WHERE order_id = NEW.order_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER reduce_qty_containers_delete AFTER DELETE ON Suborders FOR EACH ROW UPDATE Containers
  SET qty_in_stock = qty_in_stock + OLD.quantity_ordered
  WHERE container_id = OLD.container_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER reduce_qty_containers_insert AFTER INSERT ON Suborders FOR EACH ROW UPDATE Containers
  SET qty_in_stock = qty_in_stock - NEW.quantity_ordered
  WHERE container_id = NEW.container_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER reduce_qty_containers_update AFTER UPDATE ON Suborders FOR EACH ROW UPDATE Containers
  SET qty_in_stock = qty_in_stock - (NEW.quantity_ordered - OLD.quantity_ordered)
  WHERE container_id = NEW.container_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER reduce_qty_flavors_delete AFTER DELETE ON Suborders FOR EACH ROW UPDATE Flavors SET qty_in_stock = qty_in_stock +
      (CASE 
        WHEN EXISTS (SELECT * FROM Menu_Items WHERE menu_id = OLD.menu_id AND menu_name = 'Double Scoop') THEN 2
        WHEN EXISTS (SELECT * FROM Menu_Items WHERE menu_id = OLD.menu_id AND menu_name = 'Shake') THEN 3
        ELSE 1
      END * OLD.quantity_ordered)
    WHERE flavor_id = OLD.flavor_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER reduce_qty_flavors_insert AFTER INSERT ON Suborders FOR EACH ROW UPDATE Flavors 
SET qty_in_stock = qty_in_stock - 
  (CASE 
    WHEN EXISTS (SELECT * FROM Menu_Items WHERE menu_id = NEW.menu_id AND menu_name = 'Double Scoop') THEN 2
    WHEN EXISTS (SELECT * FROM Menu_Items WHERE menu_id = NEW.menu_id AND menu_name = 'Shake') THEN 3
    ELSE 1
  END * NEW.quantity_ordered)
WHERE flavor_id = NEW.flavor_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER reduce_qty_flavors_update AFTER UPDATE ON Suborders FOR EACH ROW UPDATE Flavors SET qty_in_stock = qty_in_stock +
      (CASE 
        WHEN EXISTS (SELECT * FROM Menu_Items WHERE menu_id = NEW.menu_id AND menu_name = 'Double Scoop') THEN 2
        WHEN EXISTS (SELECT * FROM Menu_Items WHERE menu_id = NEW.menu_id AND menu_name = 'Shake') THEN 3
        ELSE 1
      END * (OLD.quantity_ordered - NEW.quantity_ordered))
    WHERE flavor_id = NEW.flavor_id
$$
DELIMITER ;

    
SET FOREIGN_KEY_CHECKS=1;
COMMIT;
