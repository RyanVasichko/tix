BEGIN TRANSACTION;

-- Ticket Types
CREATE TABLE IF NOT EXISTS new_ticket_types (
    id INTEGER PRIMARY KEY,
    venue_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    convenience_fee DECIMAL(8, 2),
    convenience_fee_type TEXT,
    default_price DECIMAL(8, 2) NOT NULL,
    venue_commission DECIMAL(8, 2) NOT NULL,
    dinner_included BOOLEAN DEFAULT FALSE NOT NULL,
    active BOOLEAN DEFAULT TRUE NOT NULL,
    payment_method TEXT,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL
);

INSERT INTO new_ticket_types (id, venue_id, name, convenience_fee, convenience_fee_type, default_price, venue_commission, dinner_included, active, payment_method, created_at, updated_at)
SELECT id, venue_id, name, convenience_fee, 
       CASE convenience_fee_type WHEN 0 THEN 'flat_rate' ELSE 'percentage' END, 
       default_price, venue_commission, dinner_included, active, 
       CASE payment_method WHEN 0 THEN 'deposit' ELSE 'cover' END, 
       created_at, updated_at 
FROM ticket_types;

DROP TABLE ticket_types;
ALTER TABLE new_ticket_types RENAME TO ticket_types;

-- Show Sections
CREATE TABLE IF NOT EXISTS new_show_sections (
    id INTEGER PRIMARY KEY,
    show_id INTEGER NOT NULL,
    ticket_price DECIMAL(10, 2) NOT NULL,
    convenience_fee_type TEXT NOT NULL,
    payment_method TEXT NOT NULL,
    convenience_fee DECIMAL(10, 2) NOT NULL,
    venue_commission DECIMAL(10, 2) DEFAULT '0.0' NOT NULL,
    ticket_quantity INTEGER,
    name TEXT NOT NULL,
    type TEXT NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL
);

INSERT INTO new_show_sections (id, show_id, ticket_price, convenience_fee_type, payment_method, convenience_fee, venue_commission, ticket_quantity, name, type, created_at, updated_at)
SELECT id, show_id, ticket_price, 
       CASE convenience_fee_type WHEN 0 THEN 'flat_rate' ELSE 'percentage' END, 
       CASE payment_method WHEN 0 THEN 'deposit' ELSE 'cover' END, 
       convenience_fee, venue_commission, ticket_quantity, name, type, created_at, updated_at 
FROM show_sections;

DROP TABLE show_sections;
ALTER TABLE new_show_sections RENAME TO show_sections;

COMMIT;

