CREATE DATABASE IF NOT EXISTS foundit_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE foundit_db;

CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(512) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    item_type ENUM('LOST', 'FOUND') NOT NULL,
    location VARCHAR(150) NOT NULL,
    description TEXT,
    contact VARCHAR(150) NOT NULL,
    status ENUM('ACTIVE', 'RETURNED') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_items_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE INDEX idx_items_status_type ON items(status, item_type);
CREATE INDEX idx_items_user ON items(user_id);
