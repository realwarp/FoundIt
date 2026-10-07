CREATE DATABASE IF NOT EXISTS foundit_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE foundit_db;

CREATE TABLE IF NOT EXISTS staff (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(150) NOT NULL,
    photo VARCHAR(255) NOT NULL,
    found_location VARCHAR(150) NOT NULL,
    given_by VARCHAR(100) NOT NULL,
    date_found DATE NOT NULL,
    status ENUM('AVAILABLE', 'COLLECTED') NOT NULL DEFAULT 'AVAILABLE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO staff (username, password)
VALUES ('staff', 'foundit123')
ON DUPLICATE KEY UPDATE username = username;
