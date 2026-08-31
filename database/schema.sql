-- База данных для системы контроля электроспоживання в готелі
-- Варіант №2

-- Створення бази даних
CREATE DATABASE IF NOT EXISTS hotel_energy;
USE hotel_energy;

-- Таблиця номерів готелю
CREATE TABLE rooms (
    room_id VARCHAR(10) PRIMARY KEY,
    room_name VARCHAR(50) NOT NULL,
    floor INT NOT NULL,
    meter_limit_kwh DECIMAL(10,3) DEFAULT 50.000,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблиця показань лічильників
CREATE TABLE meter_readings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    room_id VARCHAR(10) NOT NULL,
    timestamp DATETIME NOT NULL,
    kwh_total DECIMAL(10,3) NOT NULL,
    kwh_hour DECIMAL(10,3) NOT NULL,
    pulse_count INT NOT NULL,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

-- Таблиця погодинної статистики
CREATE TABLE hourly_stats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    room_id VARCHAR(10) NOT NULL,
    hour_start DATETIME NOT NULL,
    hour_end DATETIME NOT NULL,
    total_kwh DECIMAL(10,3) NOT NULL,
    max_kwh DECIMAL(10,3) NOT NULL,
    avg_kwh DECIMAL(10,3) NOT NULL,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

-- Таблиця сповіщень
CREATE TABLE alerts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    room_id VARCHAR(10) NOT NULL,
    alert_type VARCHAR(50) NOT NULL,
    message TEXT NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_sent BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

-- Додавання тестових номерів (10 номерів для прикладу)
INSERT INTO rooms (room_id, room_name, floor, meter_limit_kwh) VALUES
('101', 'Номер 101', 1, 50.000),
('102', 'Номер 102', 1, 50.000),
('103', 'Номер 103', 1, 50.000),
('201', 'Номер 201', 2, 50.000),
('202', 'Номер 202', 2, 50.000),
('203', 'Номер 203', 2, 50.000),
('301', 'Номер 301', 3, 50.000),
('302', 'Номер 302', 3, 50.000),
('303', 'Номер 303', 3, 50.000),
('401', 'Номер 401', 4, 50.000);

-- Індекси для швидкого пошуку
CREATE INDEX idx_readings_room ON meter_readings(room_id);
CREATE INDEX idx_readings_time ON meter_readings(timestamp);
CREATE INDEX idx_stats_room ON hourly_stats(room_id);
CREATE INDEX idx_alerts_room ON alerts(room_id);














