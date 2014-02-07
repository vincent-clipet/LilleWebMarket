DROP TABLE IF EXISTS users, users_roles, markets, logs, stocks, sells CASCADE;

-- USERS
CREATE TABLE users
(
	user_id SERIAL,
	CONSTRAINT pk_user PRIMARY KEY (user_id),
	
	login TEXT UNIQUE NOT NULL,
	password TEXT NOT NULL,
	money INTEGER NOT NULL DEFAULT 10000
);

-- ROLES
CREATE TABLE users_roles
(
	login TEXT NOT NULL,
	role TEXT NOT NULL DEFAULT 'user',
	CONSTRAINT pk_users_role PRIMARY KEY (login, role)
);

-- MARKET
CREATE TABLE markets
(
	market_id SERIAL,
	CONSTRAINT pk_market PRIMARY KEY (market_id),
	
	info TEXT NOT NULL,
	opposite_info TEXT NOT NULL,
	end_date TIMESTAMP NOT NULL,
	winner BOOL DEFAULT NULL,
	
	creator_id INTEGER NOT NULL,
	CONSTRAINT fk_market_creator_id FOREIGN KEY (creator_id) REFERENCES users(user_id)
);

-- STOCK
CREATE TABLE stocks
(
	stock_id SERIAL,
	CONSTRAINT pk_stock PRIMARY KEY (stock_id),
	
	quantity INTEGER NOT NULL,
	opposite BOOL DEFAULT 'false',
	
	owner_id INTEGER NOT NULL,
	CONSTRAINT fk_stock_owner_id FOREIGN KEY (owner_id) REFERENCES users(user_id),
	
	market_id INTEGER NOT NULL,
	CONSTRAINT fk_stock_market_id FOREIGN KEY (market_id) REFERENCES markets(market_id) ON DELETE CASCADE
);

-- LOGS
CREATE TABLE logs
(
	log_id SERIAL,
	CONSTRAINT pk_log PRIMARY KEY (log_id),
	
	sell_date TIMESTAMP NOT NULL,
	log_price INTEGER NOT NULL,
	log_quantity INTEGER NOT NULL,
	
	market_id INTEGER NOT NULL,
	CONSTRAINT fk_logs_market_id FOREIGN KEY (market_id) REFERENCES markets(market_id) ON DELETE CASCADE
);

-- SELL
CREATE TABLE sells
(
	sell_id SERIAL,
	CONSTRAINT pk_sells PRIMARY KEY (sell_id),
	
	sell_date TIMESTAMP NOT NULL,
	price_sell INTEGER NOT NULL,
	
	stock_id INTEGER NOT NULL,
	CONSTRAINT fk_sells_stock_id FOREIGN KEY (stock_id) REFERENCES stocks(stock_id) ON DELETE CASCADE
);

----------------------------------------------------------------------

-- USERS
INSERT INTO users(login, password) VALUES('user1', 'user1');
INSERT INTO users(login, password) VALUES('user2', 'user2');
INSERT INTO users(login, password) VALUES('admin1', 'admin1');
INSERT INTO users(login, password) VALUES('pierre', 'pierre');
INSERT INTO users(login, password) VALUES('jean', 'jean');


-- ROLES
INSERT INTO users_roles(login) VALUES('user1');
INSERT INTO users_roles(login) VALUES('user2');
INSERT INTO users_roles(login) VALUES('pierre');
INSERT INTO users_roles(login) VALUES('jean');
INSERT INTO users_roles(login, role) VALUES('admin1', 'marketmaker');

-- MARKETS
INSERT INTO markets(info, opposite_info, end_date, creator_id) VALUES ('On aura une bonne note à ce projet', 'On n''aura pas une bonne note à ce projet', TIMESTAMP '2016-01-01 00:00:00', 3);
INSERT INTO markets(info, opposite_info, end_date, creator_id, winner) VALUES ('On va galérer en système cette année', 'Tout va être easy en système cette année', TIMESTAMP '2014-01-01 01:00:00', 3, 'false');
INSERT INTO markets(info, opposite_info, end_date, creator_id) VALUES ('Demode arrivera 1 fois à l''heure cette année', 'Demode n''arrivera jamais à l''heure cette année', TIMESTAMP '2014-03-30 01:00:00', 3);
INSERT INTO markets(info, opposite_info, end_date, creator_id) VALUES ('Marche +', 'Marche -', TIMESTAMP '2014-03-30 01:00:00', 3);
INSERT INTO markets(info, opposite_info, end_date, creator_id) VALUES ('Marche test fin +', 'Marche test fin -', TIMESTAMP '2014-01-30 12:00:00', 3);


-- STOCKS
INSERT INTO stocks(quantity, opposite, owner_id, market_id) VALUES (5, 'false', 1, 1);
INSERT INTO stocks(quantity, opposite, owner_id, market_id) VALUES (12, 'true', 2, 1);
INSERT INTO stocks(quantity, opposite, owner_id, market_id) VALUES (1, 'false', 3, 1);
INSERT INTO stocks(quantity, opposite, owner_id, market_id) VALUES (5, 'false', 1, 1);
INSERT INTO stocks(quantity, opposite, owner_id, market_id) VALUES (8, 'true', 2, 1);

INSERT INTO stocks(quantity, opposite, owner_id, market_id) VALUES (2, 'false', 4, 4);
INSERT INTO stocks(quantity, opposite, owner_id, market_id) VALUES (5, 'false', 4, 4);
INSERT INTO stocks(quantity, opposite, owner_id, market_id) VALUES (3, 'false', 4, 4);

INSERT INTO stocks(quantity, opposite, owner_id, market_id) VALUES (3, 'true', 1, 5);
INSERT INTO stocks(quantity, opposite, owner_id, market_id) VALUES (5, 'true', 1, 5);
INSERT INTO stocks(quantity, opposite, owner_id, market_id) VALUES (8, 'false', 2, 5);
INSERT INTO stocks(quantity, opposite, owner_id, market_id) VALUES (7, 'false', 2, 5);
INSERT INTO stocks(quantity, opposite, owner_id, market_id) VALUES (9, 'true', 1, 5);
INSERT INTO stocks(quantity, opposite, owner_id, market_id) VALUES (1, 'false', 2, 5);


-- SELLS
INSERT INTO sells(sell_date, price_sell, stock_id) VALUES (TIMESTAMP '2014-01-02 23:05:49', 70, 4);
INSERT INTO sells(sell_date, price_sell, stock_id) VALUES (TIMESTAMP '2014-01-03 20:50:01', 65, 5);
INSERT INTO sells(sell_date, price_sell, stock_id) VALUES (TIMESTAMP '2014-01-04 20:50:01', 90, 6);
INSERT INTO sells(sell_date, price_sell, stock_id) VALUES (TIMESTAMP '2014-01-05 20:50:01', 80, 7);
INSERT INTO sells(sell_date, price_sell, stock_id) VALUES (TIMESTAMP '2014-01-06 20:50:01', 60, 8);

INSERT INTO sells(sell_date, price_sell, stock_id) VALUES (TIMESTAMP '2014-01-06 20:50:01', 60, 9);
INSERT INTO sells(sell_date, price_sell, stock_id) VALUES (TIMESTAMP '2014-01-06 20:50:01', 60, 10);

-- LOGS
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-9', 84, 16, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-25', 18, 49, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-15', 91, 27, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-19', 57, 34, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-18', 85, 5, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-1', 72, 11, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-21', 89, 76, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-28', 38, 90, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-6', 99, 17, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-29', 71, 11, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-22', 8, 52, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-20', 45, 4, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-2', 16, 40, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-21', 27, 47, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-29', 9, 46, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-4', 2, 24, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-24', 87, 38, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-26', 94, 59, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-13', 90, 16, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-15', 22, 12, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-10', 11, 43, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-24', 49, 99, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-23', 95, 52, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-25', 1, 29, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-13', 87, 96, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-17', 24, 78, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-6', 47, 93, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-12', 35, 21, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-18', 44, 88, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-27', 84, 64, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-1', 61, 93, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-13', 25, 98, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-25', 85, 28, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-5', 76, 38, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-20', 56, 21, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-13', 64, 95, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-2', 96, 33, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-17', 55, 71, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-8', 72, 45, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-2', 90, 85, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-24', 12, 46, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-11', 97, 50, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-27', 35, 77, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-10', 66, 92, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-17', 3, 71, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-19', 24, 95, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-7', 37, 2, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-13', 37, 28, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-9', 5, 81, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-4', 86, 48, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-9', 54, 4, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-14', 11, 23, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-1', 28, 87, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-8', 26, 72, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-16', 92, 16, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-5', 91, 31, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-6', 52, 9, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-11', 87, 23, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-2', 12, 95, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-17', 21, 42, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-15', 18, 53, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-20', 50, 31, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-24', 81, 41, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-9', 57, 58, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-12', 65, 83, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-30', 66, 44, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-20', 71, 75, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-11', 38, 75, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-4', 72, 100, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-24', 44, 10, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-17', 42, 52, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-19', 77, 31, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-15', 32, 53, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-22', 52, 37, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-25', 25, 55, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-17', 24, 49, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-28', 94, 10, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-29', 80, 93, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-1', 69, 63, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-22', 99, 20, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-21', 56, 37, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-6', 37, 8, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-12', 85, 19, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-21', 23, 89, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-18', 43, 50, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-26', 84, 3, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-19', 63, 16, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-23', 8, 22, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-15', 25, 58, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-16', 1, 13, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-25', 72, 31, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-20', 91, 91, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-25', 37, 31, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-28', 37, 56, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-6', 4, 34, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-24', 53, 70, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-15', 97, 25, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-23', 73, 5, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-23', 48, 74, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-5', 11, 32, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-12', 14, 14, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-14', 93, 38, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-2', 12, 100, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-25', 15, 17, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-19', 25, 88, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-12', 35, 89, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-22', 44, 55, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-3', 83, 43, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-14', 81, 41, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-4', 93, 18, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-22', 58, 31, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-9', 62, 62, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-6', 26, 42, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-2', 68, 55, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-10', 22, 14, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-9', 10, 63, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-23', 57, 30, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-1', 73, 80, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-12', 19, 35, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-2', 76, 52, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-27', 8, 81, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-14', 36, 23, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-14', 38, 4, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-19', 67, 21, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-22', 47, 34, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-6', 96, 89, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-5', 17, 10, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-23', 92, 23, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-7', 68, 29, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-28', 82, 98, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-17', 70, 22, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-5', 20, 69, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-1', 62, 7, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-25', 6, 12, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-5', 49, 77, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-19', 37, 70, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-7', 68, 78, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-10', 81, 59, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-19', 54, 16, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-18', 98, 62, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-16', 4, 65, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-25', 88, 50, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-7', 21, 95, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-13', 3, 83, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-26', 57, 6, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-23', 68, 70, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-21', 26, 19, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-18', 80, 40, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-3', 41, 40, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-2', 55, 53, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-7', 97, 70, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-30', 31, 80, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-29', 33, 63, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-25', 69, 25, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-14', 85, 9, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-14', 92, 12, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-11', 33, 49, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-29', 3, 72, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-26', 35, 93, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-2', 38, 22, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-1', 3, 42, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-10', 90, 19, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-10', 14, 78, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-20', 96, 81, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-28', 28, 63, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-17', 70, 88, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-20', 72, 68, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-3', 35, 85, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-10', 85, 39, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-17', 89, 80, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-16', 97, 13, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-8', 84, 71, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-11', 16, 77, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-7', 72, 64, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-2', 28, 7, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-9', 28, 24, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-20', 46, 58, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-12', 97, 91, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-1', 73, 13, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-5', 29, 28, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-17', 82, 5, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-19', 36, 45, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-21', 46, 25, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-26', 80, 13, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-28', 66, 80, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-2', 83, 64, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-7', 16, 1, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-12', 77, 29, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-3', 98, 85, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-17', 4, 79, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-2', 50, 66, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-17', 31, 80, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-16', 86, 56, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-29', 34, 56, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-30', 97, 88, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-9', 4, 77, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-17', 89, 11, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-15', 61, 91, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-14', 30, 88, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-8', 29, 61, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-2', 63, 48, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-13', 91, 89, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-8', 43, 59, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-24', 46, 88, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-16', 47, 72, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-20', 76, 68, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-16', 70, 23, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-2', 62, 66, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-23', 34, 76, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-9', 31, 98, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-30', 94, 75, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-11', 44, 68, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-25', 80, 58, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-23', 31, 86, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-2', 50, 98, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-8', 88, 1, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-4', 53, 26, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-29', 19, 29, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-12', 3, 1, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-14', 65, 83, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-5', 9, 7, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-27', 18, 37, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-29', 39, 45, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-4', 30, 79, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-9', 19, 40, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-18', 22, 48, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-12', 64, 82, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-11', 59, 27, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-13', 20, 45, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-11', 11, 35, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-23', 71, 42, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-26', 38, 61, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-17', 43, 93, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-7', 3, 17, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-19', 26, 23, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-30', 42, 77, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-29', 10, 69, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-17', 74, 77, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-2', 26, 78, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-19', 48, 86, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-3', 59, 100, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-2', 62, 72, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-16', 81, 29, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-6', 98, 82, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-20', 71, 44, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-10', 40, 57, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-30', 4, 27, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-11', 51, 7, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-8', 12, 29, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-1', 98, 13, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-6', 53, 10, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-5', 32, 11, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-2', 24, 5, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-21', 11, 72, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-4', 18, 36, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-29', 1, 77, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-22', 39, 43, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-7', 19, 60, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-27', 67, 49, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-24', 64, 78, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-21', 75, 23, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-27', 13, 47, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-19', 28, 70, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-15', 63, 2, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-19', 32, 50, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-25', 92, 63, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-5', 92, 33, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-30', 85, 54, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-9', 21, 13, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-20', 73, 52, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-16', 42, 75, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-24', 25, 75, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-28', 6, 69, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-12', 84, 44, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-27', 39, 88, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-14', 34, 74, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-26', 5, 55, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-29', 50, 28, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-20', 96, 40, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-25', 25, 88, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-8', 75, 27, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-26', 71, 96, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-26', 58, 49, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-5', 77, 7, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-26', 36, 53, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-6', 58, 72, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-11', 66, 10, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-8', 74, 52, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-2', 27, 12, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-18', 73, 21, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-29', 3, 5, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-2', 60, 9, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-1', 87, 59, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-26', 37, 12, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-19', 25, 60, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-16', 52, 93, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-28', 76, 86, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-18', 4, 55, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-1', 12, 5, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-5', 14, 53, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-2', 2, 33, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-23', 72, 76, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-8', 43, 11, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-4', 79, 45, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-6', 7, 21, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-21', 51, 9, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-13', 38, 7, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-17', 99, 4, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-1', 9, 93, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-14', 16, 22, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-12', 11, 42, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-19', 1, 7, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-27', 65, 18, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-17', 92, 57, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-24', 12, 19, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-30', 3, 10, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-14', 93, 3, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-15', 70, 81, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-3', 2, 32, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-6', 86, 81, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-12', 94, 3, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-2', 88, 49, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-10', 12, 95, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-26', 30, 87, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-17', 75, 11, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-25', 3, 25, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-9', 59, 64, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-22', 18, 6, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-5', 37, 37, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-24', 97, 24, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-7', 70, 71, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-4', 84, 96, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-24', 14, 48, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-25', 85, 97, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-12', 33, 43, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-25', 13, 55, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-17', 2, 49, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-27', 86, 51, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-18', 38, 10, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-19', 3, 57, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-16', 57, 64, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-16', 34, 9, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-2', 77, 20, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-25', 61, 41, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-10', 45, 44, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-26', 69, 48, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-4', 12, 1, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-5', 88, 75, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-7', 61, 30, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-10', 35, 13, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-12', 70, 4, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-3', 47, 44, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-19', 91, 39, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-4', 91, 8, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-1', 88, 71, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-22', 15, 28, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-4', 62, 99, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-6', 42, 79, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-24', 10, 24, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-15', 86, 58, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-11', 90, 59, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-22', 54, 39, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-6', 20, 8, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-6', 80, 80, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-24', 82, 88, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-25', 72, 21, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-10', 91, 87, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-15', 24, 78, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-28', 3, 74, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-14', 75, 50, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-27', 52, 84, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-29', 31, 78, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-21', 40, 1, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-25', 63, 6, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-21', 39, 46, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-28', 37, 53, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-10', 20, 54, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-1', 52, 95, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-21', 99, 23, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-10', 22, 100, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-15', 1, 67, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-11', 20, 66, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-11', 4, 14, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-12', 1, 73, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-23', 2, 13, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-7', 57, 82, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-10', 9, 39, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-28', 55, 39, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-7', 91, 44, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-15', 79, 94, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-13', 18, 66, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-17', 9, 55, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-3', 54, 26, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-13', 1, 63, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-25', 93, 79, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-9', 32, 86, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-29', 64, 64, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-17', 36, 58, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-6', 82, 11, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-28', 96, 43, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-8', 57, 25, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-24', 54, 48, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-21', 64, 13, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-12', 70, 3, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-7', 7, 15, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-1', 75, 51, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-17', 52, 70, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-8', 37, 54, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-1', 24, 48, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-22', 12, 53, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-1', 80, 17, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-9', 71, 24, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-17', 86, 75, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-25', 27, 63, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-14', 40, 16, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-19', 16, 89, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-30', 56, 23, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-19', 84, 60, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-27', 78, 70, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-14', 96, 43, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-18', 40, 56, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-9', 71, 80, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-5', 21, 64, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-19', 94, 12, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-11', 48, 60, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-22', 73, 32, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-1', 44, 41, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-12', 25, 74, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-12', 65, 62, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-12', 81, 31, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-12', 97, 35, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-21', 93, 70, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-17', 20, 23, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-23', 32, 13, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-28', 42, 3, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-1', 65, 10, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-23', 15, 26, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-20', 78, 78, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-17', 68, 8, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-29', 79, 4, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-13', 76, 28, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-29', 55, 72, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-7', 15, 93, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-19', 82, 82, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-5', 29, 41, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-11', 15, 34, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-16', 92, 5, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-13', 57, 96, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-22', 41, 5, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-7', 79, 87, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-3', 59, 84, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-5', 23, 77, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-16', 96, 65, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-3', 75, 8, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-9', 40, 32, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-19', 90, 17, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-13', 94, 40, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-7', 18, 31, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-5', 23, 62, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-3', 6, 43, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-11', 32, 94, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-4', 91, 87, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-23', 27, 59, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-4', 49, 55, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-21', 38, 88, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-1', 7, 88, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-9-24', 81, 39, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-12', 92, 62, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-9', 8, 69, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-14', 97, 80, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-16', 18, 99, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-30', 11, 16, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-22', 55, 96, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-17', 20, 27, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-5', 23, 10, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-21', 36, 64, 4);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-24', 45, 36, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-9', 69, 6, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-1', 96, 69, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-21', 36, 44, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-10-11', 59, 72, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-23', 86, 92, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-4', 16, 37, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-1-2', 16, 52, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-23', 99, 30, 1);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-17', 83, 45, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-14', 82, 12, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-6-18', 43, 53, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-7-7', 94, 17, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-23', 77, 19, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-7', 29, 42, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-5-3', 55, 85, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-10', 15, 90, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-11-18', 57, 66, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-4-7', 55, 88, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-16', 39, 45, 3);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-8-5', 62, 21, 5);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-12-7', 26, 85, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-3-20', 64, 84, 2);
INSERT INTO logs(sell_date, log_price, log_quantity, market_id) VALUES (TIMESTAMP '2014-2-7', 50, 1, 3);
