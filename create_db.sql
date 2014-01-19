DROP TABLE IF EXISTS users, users_roles, markets, logs, stocks, sells;

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
	end_date DATE NOT NULL,
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
	CONSTRAINT fk_stock_market_id FOREIGN KEY (market_id) REFERENCES markets(market_id)
);

-- LOGS
CREATE TABLE logs
(
	log_id SERIAL,
	CONSTRAINT pk_log PRIMARY KEY (log_id),
	
	sell_date DATE NOT NULL,
	log_price INTEGER NOT NULL,
	log_quantity INTEGER NOT NULL,
	
	market_id INTEGER NOT NULL,
	CONSTRAINT fk_logs_market_id FOREIGN KEY (market_id) REFERENCES markets(market_id)
);

-- SELL
CREATE TABLE sells
(
	sell_id SERIAL,
	CONSTRAINT pk_sells PRIMARY KEY (sell_id),
	
	sell_date DATE NOT NULL,
	price_sell INTEGER NOT NULL,
	
	stock_id INTEGER NOT NULL,
	CONSTRAINT fk_sells_stock_id FOREIGN KEY (stock_id) REFERENCES stocks(stock_id)
);

----------------------------------------------------------------------

-- USERS
INSERT INTO users(login, password) VALUES('user1', 'user1');
INSERT INTO users(login, password) VALUES('user2', 'user2');
INSERT INTO users(login, password) VALUES('admin1', 'admin1');

-- ROLES
INSERT INTO users_roles(login) VALUES('user1');
INSERT INTO users_roles(login) VALUES('user2');
INSERT INTO users_roles(login, role) VALUES('admin1', 'marketmaker');

-- MARKETS
INSERT INTO markets(info, opposite_info, end_date, creator_id) VALUES ('On aura une bonne note à ce projet', 'On n aura pas une bonne note à ce projet', '01-01-2016 00:00:00', 3);
INSERT INTO markets(info, opposite_info, end_date, creator_id, winner) VALUES ('On va galérer cette année', 'Tout va être easy cette année', '01-01-2014 01:00:00', 3, 'false');

-- STOCKS
INSERT INTO stocks(quantity, opposite, owner_id, market_id) VALUES (5, 'false', 1, 1);
INSERT INTO stocks(quantity, opposite, owner_id, market_id) VALUES (12, 'true', 2, 1);
INSERT INTO stocks(quantity, opposite, owner_id, market_id) VALUES (1, 'false', 3, 1);
INSERT INTO stocks(quantity, opposite, owner_id, market_id) VALUES (5, 'false', 1, 1);
INSERT INTO stocks(quantity, opposite, owner_id, market_id) VALUES (8, 'true', 2, 1);

-- SELLS
INSERT INTO sells(sell_date, price_sell, stock_id) VALUES ('02-01-2014 23:05:49', 70, 4);
INSERT INTO sells(sell_date, price_sell, stock_id) VALUES ('03-01-2014 20:50:01', 65, 5);
