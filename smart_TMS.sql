-- ============================================================
--   SMART TOURISM MANAGEMENT SYSTEM
--   Senior SQL Developer Build | Full MySQL Project
--   Modules: Users, Places, Hotels, Transport, Reviews, Packages
-- ============================================================

-- ─────────────────────────────────────────────
--  0. DATABASE SETUP
-- ─────────────────────────────────────────────
CREATE DATABASE IF NOT EXISTS smart_tourism;
USE smart_tourism;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS package_places, travel_packages, reviews,
                     transport_bookings, hotel_bookings,
                     tourist_places, hotels, transport,
                     users;
SET FOREIGN_KEY_CHECKS = 1;


-- ============================================================
--  MODULE 1 – USER MANAGEMENT
-- ============================================================

CREATE TABLE users (
    user_id      INT           AUTO_INCREMENT PRIMARY KEY,
    full_name    VARCHAR(100)  NOT NULL,
    email        VARCHAR(150)  UNIQUE NOT NULL,
    phone        VARCHAR(15),
    password_hash VARCHAR(255) NOT NULL,
    role         ENUM('tourist','admin','agent') DEFAULT 'tourist',
    city         VARCHAR(100),
    created_at   DATETIME      DEFAULT CURRENT_TIMESTAMP
);

-- ─── Sample Data ───
INSERT INTO users (full_name, email, phone, password_hash, role, city) VALUES
('Sathiya Narayanan',  'sathiya@mail.com',   '9876543210', SHA2('pass123',256), 'tourist', 'Chennai'),
('Riya Sharma',        'riya@mail.com',       '9123456780', SHA2('pass456',256), 'tourist', 'Mumbai'),
('Admin Kumar',        'admin@tourism.com',   '9000000001', SHA2('admin@1',256),  'admin',   'Delhi'),
('Agent Priya',        'priya@agent.com',     '9000000002', SHA2('agent1',256),   'agent',   'Bangalore'),
('Karthik Raj',        'karthik@mail.com',    '9988776655', SHA2('kart99',256),   'tourist', 'Coimbatore'),
('Meena Devi',         'meena@mail.com',      '9871234560', SHA2('meena1',256),   'tourist', 'Trichy'),
('Arun Patel',         'arun@mail.com',       '9112233445', SHA2('arun22',256),   'tourist', 'Ahmedabad');


-- ============================================================
--  MODULE 2 – TOURIST PLACES
-- ============================================================

CREATE TABLE tourist_places (
    place_id      INT           AUTO_INCREMENT PRIMARY KEY,
    place_name    VARCHAR(150)  NOT NULL,
    state         VARCHAR(100)  NOT NULL,
    country       VARCHAR(100)  DEFAULT 'India',
    category      ENUM('heritage','beach','hill','wildlife','religious','adventure') NOT NULL,
    entry_fee     DECIMAL(8,2)  DEFAULT 0.00,
    best_season   VARCHAR(50),
    description   TEXT,
    image_url     VARCHAR(255),
    created_at    DATETIME      DEFAULT CURRENT_TIMESTAMP
);

-- Index for fast search by state / category
CREATE INDEX idx_place_state    ON tourist_places(state);
CREATE INDEX idx_place_category ON tourist_places(category);

-- ─── Sample Data ───
INSERT INTO tourist_places (place_name, state, category, entry_fee, best_season, description) VALUES
('Mahabalipuram',        'Tamil Nadu',    'heritage',   50.00,  'Oct-Feb',  'UNESCO shore temple complex'),
('Marina Beach',         'Tamil Nadu',    'beach',       0.00,  'Nov-Jan',  'World''s second longest urban beach'),
('Ooty',                 'Tamil Nadu',    'hill',       30.00,  'Apr-Jun',  'Queen of Nilgiris hill station'),
('Ranthambore',          'Rajasthan',     'wildlife',  200.00,  'Oct-Jun',  'Famous tiger reserve'),
('Varanasi Ghats',       'Uttar Pradesh', 'religious',   0.00,  'Oct-Mar',  'Holy Ganges ghats'),
('Coorg',                'Karnataka',     'hill',        0.00,  'Oct-Mar',  'Scotland of India – coffee country'),
('Andaman Islands',      'Andaman & N.', 'beach',       50.00,  'Nov-May',  'Crystal-clear coral-reef beaches'),
('Manali',               'Himachal Pradesh','adventure',  0.00,  'Jun-Sep',  'Snow, rivers and trekking hub'),
('Ajanta Caves',         'Maharashtra',   'heritage',   40.00,  'Oct-Mar',  'Ancient Buddhist rock-cut monuments'),
('Kaziranga',            'Assam',         'wildlife',  100.00,  'Nov-Apr',  'One-horned rhino sanctuary');


-- ============================================================
--  MODULE 3 – HOTELS
-- ============================================================

CREATE TABLE hotels (
    hotel_id     INT           AUTO_INCREMENT PRIMARY KEY,
    hotel_name   VARCHAR(150)  NOT NULL,
    place_id     INT           NOT NULL,
    address      VARCHAR(250),
    star_rating  TINYINT       CHECK (star_rating BETWEEN 1 AND 5),
    price_per_night DECIMAL(10,2) NOT NULL,
    total_rooms  INT           DEFAULT 10,
    amenities    SET('wifi','pool','spa','gym','restaurant','parking') DEFAULT 'wifi',
    contact_email VARCHAR(150),
    created_at   DATETIME      DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (place_id) REFERENCES tourist_places(place_id) ON DELETE CASCADE
);

CREATE INDEX idx_hotel_place ON hotels(place_id);

-- ─── Sample Data ───
INSERT INTO hotels (hotel_name, place_id, address, star_rating, price_per_night, total_rooms, amenities) VALUES
('Sea Shell Resort',        2,  'Marina Beach Rd, Chennai',       4, 3500.00,  50, 'wifi,pool,restaurant'),
('Heritage Mahabalipuram',  1,  'Shore Temple Rd, Mahabalipuram', 3, 2200.00,  30, 'wifi,parking'),
('Nilgiri Mountain Lodge',  3,  'Ooty Lake Rd, Ooty',             3, 1800.00,  25, 'wifi,restaurant'),
('Tiger Trail Resort',      4,  'Ranthambore Gate 2',             5, 8000.00,  20, 'wifi,pool,spa,gym,restaurant,parking'),
('Ganga View Inn',          5,  'Dashashwamedh Ghat, Varanasi',   2,  900.00,  15, 'wifi'),
('Coorg Coffee Estate',     6,  'Madikeri Main Rd, Coorg',        4, 4200.00,  18, 'wifi,pool,spa,restaurant,parking'),
('Andaman Pearl',           7,  'Port Blair Jetty Rd',            5, 9500.00,  40, 'wifi,pool,spa,gym,restaurant,parking'),
('Snow Peak Manali',        8,  'Mall Rd, Manali',                3, 2500.00,  35, 'wifi,parking,restaurant'),
('Ajanta Heritage Inn',     9,  'Near Ajanta Caves, Aurangabad',  3, 1600.00,  22, 'wifi,restaurant'),
('Rhino Retreat Kaziranga', 10, 'Kohora, Kaziranga',              4, 5000.00,  16, 'wifi,restaurant,pool');


-- ============================================================
--  MODULE 4A – HOTEL BOOKINGS
-- ============================================================

CREATE TABLE hotel_bookings (
    booking_id     INT           AUTO_INCREMENT PRIMARY KEY,
    user_id        INT           NOT NULL,
    hotel_id       INT           NOT NULL,
    check_in       DATE          NOT NULL,
    check_out      DATE          NOT NULL,
    rooms_booked   INT           DEFAULT 1,
    total_amount   DECIMAL(10,2),
    status         ENUM('pending','confirmed','cancelled','completed') DEFAULT 'pending',
    booked_at      DATETIME      DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)  REFERENCES users(user_id)  ON DELETE CASCADE,
    FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id) ON DELETE CASCADE
);

CREATE INDEX idx_hbooking_user  ON hotel_bookings(user_id);
CREATE INDEX idx_hbooking_hotel ON hotel_bookings(hotel_id);

-- ─── Sample Data ───
INSERT INTO hotel_bookings (user_id, hotel_id, check_in, check_out, rooms_booked, total_amount, status) VALUES
(1, 1, '2025-12-01', '2025-12-04', 1, 10500.00, 'completed'),
(2, 4, '2025-11-15','2025-11-18', 2, 48000.00, 'completed'),
(5, 3, '2026-01-10', '2026-01-13', 1,  5400.00, 'confirmed'),
(6, 2, '2026-02-05', '2026-02-07', 1,  4400.00, 'pending'),
(1, 7, '2026-03-20', '2026-03-25', 2, 95000.00, 'confirmed'),
(7, 5, '2025-10-01', '2025-10-03', 1,  1800.00, 'cancelled'),
(3, 8, '2026-06-01', '2026-06-05', 2, 20000.00, 'pending');


-- ============================================================
--  MODULE 4B – TRANSPORT
-- ============================================================

CREATE TABLE transport (
    transport_id   INT           AUTO_INCREMENT PRIMARY KEY,
    transport_type ENUM('bus','train','flight','cab','ferry') NOT NULL,
    operator_name  VARCHAR(150)  NOT NULL,
    from_city      VARCHAR(100)  NOT NULL,
    to_city        VARCHAR(100)  NOT NULL,
    departure_time DATETIME,
    arrival_time   DATETIME,
    price_per_seat DECIMAL(8,2)  NOT NULL,
    total_seats    INT           DEFAULT 40,
    available_seats INT          DEFAULT 40
);

CREATE INDEX idx_transport_route ON transport(from_city, to_city);

-- ─── Sample Data ───
INSERT INTO transport (transport_type, operator_name, from_city, to_city, departure_time, arrival_time, price_per_seat, total_seats, available_seats) VALUES
('flight', 'IndiGo',           'Chennai',    'Port Blair',  '2026-03-20 06:00', '2026-03-20 08:30',  4500.00, 180, 160),
('train',  'Indian Railways',  'Chennai',    'Ooty',        '2026-01-10 06:30', '2026-01-10 13:30',   450.00,  60,  42),
('bus',    'TNSTC',            'Chennai',    'Mahabalipuram','2026-02-05 07:00', '2026-02-05 09:30',   120.00,  52,  30),
('cab',    'Ola Outstation',   'Coimbatore', 'Ooty',        '2026-01-10 08:00', '2026-01-10 10:30',   900.00,   4,   4),
('train',  'Indian Railways',  'Mumbai',     'Aurangabad',  '2026-02-20 22:00', '2026-02-21 04:00',   350.00,  72,  55),
('flight', 'Air India',        'Delhi',      'Manali',      '2026-06-01 09:00', '2026-06-01 11:00',  5200.00, 120,  98),
('ferry',  'A&N Shipping',     'Port Blair', 'Havelock Is', '2026-03-21 08:00', '2026-03-21 10:30',   600.00,  80,  60);

-- ─── Transport Bookings ───
CREATE TABLE transport_bookings (
    tbooking_id    INT           AUTO_INCREMENT PRIMARY KEY,
    user_id        INT           NOT NULL,
    transport_id   INT           NOT NULL,
    seats_booked   INT           DEFAULT 1,
    total_amount   DECIMAL(10,2),
    status         ENUM('pending','confirmed','cancelled') DEFAULT 'pending',
    booked_at      DATETIME      DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)       REFERENCES users(user_id)      ON DELETE CASCADE,
    FOREIGN KEY (transport_id)  REFERENCES transport(transport_id) ON DELETE CASCADE
);

-- ─── Sample Data ───
INSERT INTO transport_bookings (user_id, transport_id, seats_booked, total_amount, status) VALUES
(1, 1, 2,  9000.00, 'confirmed'),
(2, 5, 1,   350.00, 'confirmed'),
(5, 2, 1,   450.00, 'confirmed'),
(6, 3, 2,   240.00, 'pending'),
(1, 7, 2,  1200.00, 'confirmed'),
(7, 4, 1,   900.00, 'cancelled');


-- ============================================================
--  MODULE 5 – REVIEWS & RATINGS
-- ============================================================

CREATE TABLE reviews (
    review_id     INT           AUTO_INCREMENT PRIMARY KEY,
    user_id       INT           NOT NULL,
    place_id      INT           NOT NULL,
    hotel_id      INT,                     -- optional: review a hotel too
    rating        TINYINT       NOT NULL CHECK (rating BETWEEN 1 AND 5),
    title         VARCHAR(200),
    review_text   TEXT,
    visit_date    DATE,
    helpful_count INT           DEFAULT 0,
    created_at    DATETIME      DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)  REFERENCES users(user_id)        ON DELETE CASCADE,
    FOREIGN KEY (place_id) REFERENCES tourist_places(place_id) ON DELETE CASCADE,
    FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id)      ON DELETE SET NULL
);

CREATE INDEX idx_review_place ON reviews(place_id);
CREATE INDEX idx_review_rating ON reviews(rating);

-- ─── Sample Data ───
INSERT INTO reviews (user_id, place_id, hotel_id, rating, title, review_text, visit_date) VALUES
(1, 2, 1, 5, 'Stunning Beach!',       'Marina at sunrise is breathtaking. Sea Shell Resort made it even better.',     '2025-12-02'),
(2, 4, 4, 5, 'Saw 3 tigers!',         'Tiger Trail Resort is world-class. Jeep safari was unforgettable.',            '2025-11-16'),
(5, 3, 3, 4, 'Refreshing hill air',   'Nilgiri Lodge was cozy. Ooty Lake views are stunning.',                        '2026-01-11'),
(6, 1, 2, 4, 'Historical Charm',      'Shore Temple at golden hour – magical. Heritage hotel was decent.',             '2026-02-06'),
(7, 5, 5, 3, 'Spiritual but noisy',   'Ghats are spiritual but very crowded. Inn was basic.',                          '2025-10-02'),
(1, 7, 7, 5, 'Best trip ever!',       'Andaman waters are unreal. Pearl hotel staff were exceptional.',               '2026-03-22'),
(2, 9, 9, 4, 'History lover must-go', 'Ajanta paintings are incredible. Hotel was clean and comfortable.',            '2026-02-22');


-- ============================================================
--  MODULE 6 – TRAVEL PACKAGES
-- ============================================================

CREATE TABLE travel_packages (
    package_id    INT           AUTO_INCREMENT PRIMARY KEY,
    package_name  VARCHAR(200)  NOT NULL,
    duration_days INT           NOT NULL,
    price_per_person DECIMAL(10,2) NOT NULL,
    max_people    INT           DEFAULT 20,
    inclusions    TEXT,           -- hotels, transport, guide, etc.
    agent_id      INT,
    is_active     TINYINT(1)    DEFAULT 1,
    created_at    DATETIME      DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (agent_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- Junction table: which places are in each package
CREATE TABLE package_places (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    package_id  INT NOT NULL,
    place_id    INT NOT NULL,
    visit_order TINYINT DEFAULT 1,
    FOREIGN KEY (package_id) REFERENCES travel_packages(package_id) ON DELETE CASCADE,
    FOREIGN KEY (place_id)   REFERENCES tourist_places(place_id)   ON DELETE CASCADE
);

-- ─── Sample Data ───
INSERT INTO travel_packages (package_name, duration_days, price_per_person, max_people, inclusions, agent_id) VALUES
('Tamil Nadu Heritage Trail',  5, 12000.00, 15, 'Hotel + Transport + Guide + Entry Fees', 4),
('South India Wildlife Tour',  7, 22000.00, 10, 'Eco Resort + Jeep Safari + All Meals',   4),
('Andaman Dream Holiday',      6, 35000.00, 12, 'Beach Resort + Ferry + Snorkeling Kit',  4),
('Himalayan Adventure',        8, 28000.00, 20, 'Hotel + Cab + Trekking Guide + Gear',    4),
('Spiritual India Yatra',      5, 10500.00, 25, 'Guesthouse + Train + Guide',             4);

INSERT INTO package_places (package_id, place_id, visit_order) VALUES
(1, 1, 1), (1, 2, 2), (1, 3, 3),   -- Tamil Nadu trail
(2, 4, 1), (2, 10, 2),              -- Wildlife
(3, 7, 1),                           -- Andaman
(4, 8, 1), (4, 6, 2),               -- Himalayan
(5, 5, 1), (5, 9, 2);               -- Spiritual


-- ============================================================
--  SECTION A – VIEWS
-- ============================================================

-- View 1: Tourist Places with average rating
CREATE OR REPLACE VIEW vw_place_ratings AS
SELECT
    tp.place_id,
    tp.place_name,
    tp.state,
    tp.category,
    tp.entry_fee,
    ROUND(AVG(r.rating), 2)  AS avg_rating,
    COUNT(r.review_id)        AS total_reviews
FROM tourist_places tp
LEFT JOIN reviews r ON tp.place_id = r.place_id
GROUP BY tp.place_id, tp.place_name, tp.state, tp.category, tp.entry_fee;

-- View 2: Hotel booking summary with user & hotel name
CREATE OR REPLACE VIEW vw_hotel_booking_summary AS
SELECT
    hb.booking_id,
    u.full_name      AS tourist_name,
    u.email,
    h.hotel_name,
    tp.place_name,
    hb.check_in,
    hb.check_out,
    DATEDIFF(hb.check_out, hb.check_in) AS nights,
    hb.rooms_booked,
    hb.total_amount,
    hb.status
FROM hotel_bookings hb
JOIN users          u  ON hb.user_id  = u.user_id
JOIN hotels         h  ON hb.hotel_id = h.hotel_id
JOIN tourist_places tp ON h.place_id  = tp.place_id;

-- View 3: Transport booking details
CREATE OR REPLACE VIEW vw_transport_booking_details AS
SELECT
    tb.tbooking_id,
    u.full_name      AS passenger,
    t.transport_type,
    t.operator_name,
    t.from_city,
    t.to_city,
    t.departure_time,
    tb.seats_booked,
    tb.total_amount,
    tb.status
FROM transport_bookings tb
JOIN users     u ON tb.user_id      = u.user_id
JOIN transport t ON tb.transport_id = t.transport_id;

-- View 4: Full package overview
CREATE OR REPLACE VIEW vw_package_overview AS
SELECT
    pkg.package_id,
    pkg.package_name,
    pkg.duration_days,
    pkg.price_per_person,
    pkg.max_people,
    GROUP_CONCAT(tp.place_name ORDER BY pp.visit_order SEPARATOR ' → ') AS itinerary,
    u.full_name AS agent_name
FROM travel_packages  pkg
JOIN package_places   pp  ON pkg.package_id = pp.package_id
JOIN tourist_places   tp  ON pp.place_id    = tp.place_id
JOIN users            u   ON pkg.agent_id   = u.user_id
WHERE pkg.is_active = 1
GROUP BY pkg.package_id, pkg.package_name, pkg.duration_days,
         pkg.price_per_person, pkg.max_people, u.full_name;


-- ============================================================
--  SECTION B – STORED PROCEDURES
-- ============================================================
-- drop procedure sp_book_hotel
DELIMITER $$

-- Procedure 1: Book a Hotel
CREATE PROCEDURE sp_book_hotel (
    IN p_user_id     INT,
    IN p_hotel_id    INT,
    IN p_check_in    DATE,
    IN p_check_out   DATE,
    IN p_rooms       INT,
    OUT p_booking_id INT,
    OUT p_message    VARCHAR(200)
)
BEGIN
    DECLARE v_price     DECIMAL(10,2);
    DECLARE v_nights    INT;
    DECLARE v_amount    DECIMAL(10,2);
    DECLARE v_avail     INT;

    -- Get price per night
    SELECT price_per_night, total_rooms INTO v_price, v_avail
    FROM hotels WHERE hotel_id = p_hotel_id;

    IF v_avail IS NULL THEN
        SET p_message = 'ERROR: Hotel not found.';
        SET p_booking_id = -1;
    ELSEIF p_check_in >= p_check_out THEN
        SET p_message = 'ERROR: Check-out must be after check-in.';
        SET p_booking_id = -1;
    ELSE
        SET v_nights = DATEDIFF(p_check_out, p_check_in);
        SET v_amount = v_price * p_rooms * v_nights;

        INSERT INTO hotel_bookings (user_id, hotel_id, check_in, check_out, rooms_booked, total_amount, status)
        VALUES (p_user_id, p_hotel_id, p_check_in, p_check_out, p_rooms, v_amount, 'confirmed');

        SET p_booking_id = LAST_INSERT_ID();
        SET p_message = CONCAT('SUCCESS: Booking confirmed. Amount = ₹', v_amount);
    END IF;
END$$

-- Procedure 2: Book Transport
CREATE PROCEDURE sp_book_transport (
    IN p_user_id       INT,
    IN p_transport_id  INT,
    IN p_seats         INT,
    OUT p_tbooking_id  INT,
    OUT p_message      VARCHAR(200)
)
BEGIN
    DECLARE v_price   DECIMAL(8,2);
    DECLARE v_avail   INT;
    DECLARE v_amount  DECIMAL(10,2);

    SELECT price_per_seat, available_seats INTO v_price, v_avail
    FROM transport WHERE transport_id = p_transport_id;

    IF v_avail IS NULL THEN
        SET p_message = 'ERROR: Transport not found.';
        SET p_tbooking_id = -1;
    ELSEIF v_avail < p_seats THEN
        SET p_message = CONCAT('ERROR: Only ', v_avail, ' seats available.');
        SET p_tbooking_id = -1;
    ELSE
        SET v_amount = v_price * p_seats;

        INSERT INTO transport_bookings (user_id, transport_id, seats_booked, total_amount, status)
        VALUES (p_user_id, p_transport_id, p_seats, v_amount, 'confirmed');

        UPDATE transport
        SET available_seats = available_seats - p_seats
        WHERE transport_id = p_transport_id;

        SET p_tbooking_id = LAST_INSERT_ID();
        SET p_message = CONCAT('SUCCESS: Seats booked. Amount = ₹', v_amount);
    END IF;
END$$

-- Procedure 3: Get all bookings for a user
CREATE PROCEDURE sp_get_user_bookings (IN p_user_id INT)
BEGIN
    SELECT 'HOTEL BOOKING' AS booking_type,
           booking_id      AS id,
           h.hotel_name    AS detail,
           check_in        AS start_date,
           check_out       AS end_date,
           total_amount,
           status
    FROM hotel_bookings hb
    JOIN hotels h ON hb.hotel_id = h.hotel_id
    WHERE hb.user_id = p_user_id

    UNION ALL

    SELECT 'TRANSPORT'      AS booking_type,
           tb.tbooking_id   AS id,
           CONCAT(t.from_city,' → ',t.to_city) AS detail,
           DATE(t.departure_time) AS start_date,
           DATE(t.arrival_time)   AS end_date,
           tb.total_amount,
           tb.status
    FROM transport_bookings tb
    JOIN transport t ON tb.transport_id = t.transport_id
    WHERE tb.user_id = p_user_id
    ORDER BY start_date;
END$$

-- Procedure 4: Revenue Report
CREATE PROCEDURE sp_revenue_report ()
BEGIN
    SELECT 'Hotels'     AS source,
           SUM(total_amount) AS total_revenue,
           COUNT(*)          AS total_bookings
    FROM hotel_bookings
    WHERE status IN ('confirmed','completed')

    UNION ALL

    SELECT 'Transport'  AS source,
           SUM(total_amount),
           COUNT(*)
    FROM transport_bookings
    WHERE status = 'confirmed';
END$$

DELIMITER ;


-- ============================================================
--  SECTION C – TRIGGERS
-- ============================================================

DELIMITER $$

-- Trigger 1: Auto-calculate hotel booking amount before insert
CREATE TRIGGER trg_hotel_booking_amount
BEFORE INSERT ON hotel_bookings
FOR EACH ROW
BEGIN
    DECLARE v_price   DECIMAL(10,2);
    DECLARE v_nights  INT;

    SELECT price_per_night INTO v_price
    FROM hotels WHERE hotel_id = NEW.hotel_id;

    SET v_nights       = DATEDIFF(NEW.check_out, NEW.check_in);
    SET NEW.total_amount = v_price * NEW.rooms_booked * v_nights;
END$$

-- Trigger 2: Reduce available seats when transport is booked
CREATE TRIGGER trg_transport_seats_after_booking
AFTER INSERT ON transport_bookings
FOR EACH ROW
BEGIN
    UPDATE transport
    SET available_seats = available_seats - NEW.seats_booked
    WHERE transport_id = NEW.transport_id;
END$$

-- Trigger 3: Restore seats if transport booking is cancelled
CREATE TRIGGER trg_transport_seats_on_cancel
AFTER UPDATE ON transport_bookings
FOR EACH ROW
BEGIN
    IF NEW.status = 'cancelled' AND OLD.status != 'cancelled' THEN
        UPDATE transport
        SET available_seats = available_seats + OLD.seats_booked
        WHERE transport_id = OLD.transport_id;
    END IF;
END$$

-- Trigger 4: Prevent review if user never visited (no completed hotel booking)
CREATE TRIGGER trg_validate_review
BEFORE INSERT ON reviews
FOR EACH ROW
BEGIN
    DECLARE v_count INT;

    SELECT COUNT(*) INTO v_count
    FROM hotel_bookings hb
    JOIN hotels h ON hb.hotel_id = h.hotel_id
    WHERE hb.user_id  = NEW.user_id
      AND h.place_id  = NEW.place_id
      AND hb.status   IN ('confirmed','completed');

    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Review denied: No confirmed booking found for this place.';
    END IF;
END$$

DELIMITER ;


-- ============================================================
--  SECTION D – JOINS (Analytical Queries)
-- ============================================================

-- Q1: All tourist places with hotel count and avg room price
SELECT
    tp.place_name,
    tp.state,
    tp.category,
    COUNT(h.hotel_id)        AS hotel_count,
    ROUND(AVG(h.price_per_night),2) AS avg_room_price
FROM tourist_places tp
LEFT JOIN hotels h ON tp.place_id = h.place_id
GROUP BY tp.place_id, tp.place_name, tp.state, tp.category
ORDER BY hotel_count DESC;

-- Q2: Tourists who booked both hotel AND transport
SELECT DISTINCT
    u.full_name,
    u.email,
    u.city
FROM users u
JOIN hotel_bookings     hb ON u.user_id = hb.user_id
JOIN transport_bookings tb ON u.user_id = tb.user_id;

-- Q3: Full travel history per user (INNER JOINs)
SELECT
    u.full_name,
    tp.place_name,
    h.hotel_name,
    hb.check_in,
    hb.check_out,
    hb.total_amount,
    hb.status
FROM hotel_bookings hb
JOIN users          u  ON hb.user_id  = u.user_id
JOIN hotels         h  ON hb.hotel_id = h.hotel_id
JOIN tourist_places tp ON h.place_id  = tp.place_id
ORDER BY u.full_name, hb.check_in;

-- Q4: Reviews with place and reviewer info (LEFT JOIN)
SELECT
    r.review_id,
    u.full_name    AS reviewer,
    tp.place_name,
    h.hotel_name,
    r.rating,
    r.title,
    r.created_at
FROM reviews r
JOIN users          u  ON r.user_id  = u.user_id
JOIN tourist_places tp ON r.place_id = tp.place_id
LEFT JOIN hotels    h  ON r.hotel_id = h.hotel_id
ORDER BY r.rating DESC;


-- ============================================================
--  SECTION E – SUBQUERIES
-- ============================================================

-- SQ1: Places with above-average rating
SELECT place_name, state, category
FROM tourist_places
WHERE place_id IN (
    SELECT place_id
    FROM reviews
    GROUP BY place_id
    HAVING AVG(rating) > (SELECT AVG(rating) FROM reviews)
);

-- SQ2: Hotels never booked
SELECT hotel_name, price_per_night
FROM hotels
WHERE hotel_id NOT IN (
    SELECT DISTINCT hotel_id FROM hotel_bookings
);

-- SQ3: Top spender tourist
SELECT full_name, email, city
FROM users
WHERE user_id = (
    SELECT user_id
    FROM hotel_bookings
    WHERE status IN ('confirmed','completed')
    GROUP BY user_id
    ORDER BY SUM(total_amount) DESC
    LIMIT 1
);

-- SQ4: Most popular place (most hotel bookings)
SELECT place_name, state
FROM tourist_places
WHERE place_id = (
    SELECT h.place_id
    FROM hotel_bookings hb
    JOIN hotels h ON hb.hotel_id = h.hotel_id
    GROUP BY h.place_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- SQ5: Tourists who spent more than average
SELECT u.full_name, u.email, SUM(hb.total_amount) AS total_spent
FROM users u
JOIN hotel_bookings hb ON u.user_id = hb.user_id
WHERE hb.status IN ('confirmed','completed')
GROUP BY u.user_id, u.full_name, u.email
HAVING total_spent > (
    SELECT AVG(sub.total)
    FROM (
        SELECT SUM(total_amount) AS total
        FROM hotel_bookings
        WHERE status IN ('confirmed','completed')
        GROUP BY user_id
    ) sub
);


-- ============================================================
--  SECTION F – CALLING STORED PROCEDURES
-- ============================================================

-- Book a hotel
CALL sp_book_hotel(5, 7, '2026-04-01', '2026-04-05', 1, @bid, @msg);
SELECT @bid AS booking_id, @msg AS message;

-- Book transport seats
CALL sp_book_transport(6, 1, 2, @tid, @tmsg);
SELECT @tid AS tbooking_id, @tmsg AS message;

-- Get all bookings for user 1 (Sathiya)
CALL sp_get_user_bookings(1);

-- Revenue report
CALL sp_revenue_report();


-- ============================================================
--  SECTION G – SAMPLE SELECT QUERIES ON VIEWS
-- ============================================================

-- Top rated places
SELECT * FROM vw_place_ratings
ORDER BY avg_rating DESC, total_reviews DESC;

-- All hotel bookings in a readable format
SELECT * FROM vw_hotel_booking_summary
ORDER BY check_in;

-- Transport booking details
SELECT * FROM vw_transport_booking_details;

-- Package itineraries
SELECT * FROM vw_package_overview
ORDER BY price_per_person;


-- ============================================================
--  SECTION H – EXTRA ANALYTICAL QUERIES
-- ============================================================

-- Monthly hotel revenue
SELECT
    DATE_FORMAT(booked_at, '%Y-%m') AS month,
    SUM(total_amount)               AS revenue,
    COUNT(*)                        AS bookings
FROM hotel_bookings
WHERE status IN ('confirmed','completed')
GROUP BY month
ORDER BY month;

-- Category-wise average entry fee
SELECT
    category,
    COUNT(*)                         AS place_count,
    ROUND(AVG(entry_fee), 2)        AS avg_entry_fee,
    MIN(entry_fee)                   AS min_fee,
    MAX(entry_fee)                   AS max_fee
FROM tourist_places
GROUP BY category
ORDER BY avg_entry_fee DESC;

-- Packages with place count
SELECT
    pkg.package_name,
    pkg.duration_days,
    pkg.price_per_person,
    COUNT(pp.place_id) AS num_places
FROM travel_packages pkg
JOIN package_places  pp ON pkg.package_id = pp.package_id
GROUP BY pkg.package_id, pkg.package_name, pkg.duration_days, pkg.price_per_person
ORDER BY pkg.price_per_person;

-- Transport availability status
SELECT
    transport_type,
    operator_name,
    CONCAT(from_city, ' → ', to_city)            AS route,
    departure_time,
    available_seats,
    total_seats,
    ROUND(available_seats / total_seats * 100, 1) AS availability_pct
FROM transport
ORDER BY departure_time;

-- ============================================================
-- END OF SMART TOURISM MANAGEMENT SYSTEM
-- ============================================================
