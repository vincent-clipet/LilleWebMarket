DROP TABLE IF EXISTS users, market, logs, stock, sells;

-- USERS
CREATE TABLE users
(
	id_user SERIAL,
	CONSTRAINT pk_user PRIMARY KEY (id_user),
	
	login TEXT UNIQUE NOT NULL,
	password TEXT NOT NULL,
	role TEXT NOT NULL,
	money INTEGER NOT NULL
);

-- MARKET
CREATE TABLE market
(
	id_market SERIAL,
	CONSTRAINT pk_market PRIMARY KEY (id_market),
	
	info TEXT NOT NULL,
	oppposite_info TEXT NOT NULL,
	date_end DATE NOT NULL,
	result BOOL DEFAULT NULL,
	
	id_creator INTEGER NOT NULL,
	CONSTRAINT fk_market_id_creator FOREIGN KEY (id_creator) REFERENCES users(id_user)
);

-- STOCK
CREATE TABLE stock
(
	id_stock SERIAL,
	CONSTRAINT pk_stock PRIMARY KEY (id_stock),
	
	quantity INTEGER NOT NULL,
	opposite BOOL DEFAULT 'false',
	
	id_owner INTEGER NOT NULL,
	CONSTRAINT fk_stock_id_owner FOREIGN KEY (id_owner) REFERENCES users(id_user),
	
	id_market INTEGER NOT NULL,
	CONSTRAINT fk_stock_id_market FOREIGN KEY (id_market) REFERENCES market(id_market)
);

-- LOGS
CREATE TABLE logs
(
	id_log SERIAL,
	CONSTRAINT pk_log PRIMARY KEY (id_log),
	
	date_sell DATE NOT NULL,
	log_price INTEGER NOT NULL,
	log_quantity INTEGER NOT NULL,
	
	id_market INTEGER NOT NULL,
	CONSTRAINT fk_logs_id_market FOREIGN KEY (id_market) REFERENCES market(id_market)
);

-- SELL
CREATE TABLE sells
(
	id_sells SERIAL,
	CONSTRAINT pk_sells PRIMARY KEY (id_sells),
	
	date_sells DATE NOT NULL,
	price_sells INTEGER NOT NULL,
	
	id_stock INTEGER NOT NULL,
	CONSTRAINT fk_sells_id_stock FOREIGN KEY (id_stock) REFERENCES stock(id_stock)
);
