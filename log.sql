-- Keep a log of any SQL queries you execute as you solve the mystery.

-- FIND CRIME DESCRIPTION
SELECT description FROM crime_scene_reports
WHERE year = 2024 AND month = 7 AND day = 28
AND street = 'Humphrey Street';

-- Theft of the CS50 duck took place at 10:15am at the Humphrey Street bakery. Interviews were conducted today with three witnesses who were present at the time – each of their interview transcripts mentions the bakery. --

-- GET INTERVIEW TRANSCRIPTS
SELECT name, transcript FROM interviews
WHERE year = 2024 AND month = 7 AND day = 28;


-- | Ruth    | Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away. If you have security footage from the bakery parking lot, you might want to look for cars that left the parking lot in that time frame.
-- | Eugene  | I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at Emma's bakery, I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.
-- | Raymond | As the thief was leaving the bakery, they called someone who talked to them for less than a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief then asked the person on the other end of the phone to purchase the flight ticket.

-- FIND LICENSE PLATES OF SUSPECTS
SELECT * FROM bakery_security_logs
 WHERE year = 2024 AND month = 7 AND day = 28 and hour = 10 AND minute >=15 AND minute <=25;

-- +-----+------+-------+-----+------+--------+----------+---------------+
-- | id  | year | month | day | hour | minute | activity | license_plate |
-- +-----+------+-------+-----+------+--------+----------+---------------+
-- | 260 | 2024 | 7     | 28  | 10   | 16     | exit     | 5P2BI95       |
-- | 261 | 2024 | 7     | 28  | 10   | 18     | exit     | 94KL13X       |
-- | 262 | 2024 | 7     | 28  | 10   | 18     | exit     | 6P58WS2       |
-- | 263 | 2024 | 7     | 28  | 10   | 19     | exit     | 4328GD8       |
-- | 264 | 2024 | 7     | 28  | 10   | 20     | exit     | G412CB7       |
-- | 265 | 2024 | 7     | 28  | 10   | 21     | exit     | L93JTIZ       |
-- | 266 | 2024 | 7     | 28  | 10   | 23     | exit     | 322W7JE       |
-- | 267 | 2024 | 7     | 28  | 10   | 23     | exit     | 0NTHK55       |
-- +-----+------+-------+-----+------+--------+----------+---------------+

-- FIND PHONE NUMBERS OF SUSPECT (CALLER) AND ACCOMPLICE (RECEIVER)
SELECT * FROM phone_calls
WHERE year = 2024 AND month = 7 AND day = 28 AND duration < 60;

-- +-----+----------------+----------------+------+-------+-----+----------+
-- | id  |     caller     |    receiver    | year | month | day | duration |
-- +-----+----------------+----------------+------+-------+-----+----------+
-- | 221 | (130) 555-0289 | (996) 555-8899 | 2024 | 7     | 28  | 51       |
-- | 224 | (499) 555-9472 | (892) 555-8872 | 2024 | 7     | 28  | 36       |
-- | 233 | (367) 555-5533 | (375) 555-8161 | 2024 | 7     | 28  | 45       |
-- | 251 | (499) 555-9472 | (717) 555-1342 | 2024 | 7     | 28  | 50       |
-- | 254 | (286) 555-6063 | (676) 555-6554 | 2024 | 7     | 28  | 43       |
-- | 255 | (770) 555-1861 | (725) 555-3243 | 2024 | 7     | 28  | 49       |
-- | 261 | (031) 555-6622 | (910) 555-3251 | 2024 | 7     | 28  | 38       |
-- | 279 | (826) 555-1652 | (066) 555-9701 | 2024 | 7     | 28  | 55       |
-- | 281 | (338) 555-6650 | (704) 555-2131 | 2024 | 7     | 28  | 54       |
-- +-----+----------------+----------------+------+-------+-----+----------+

-- FIND LIST OF SUSPECTS USING LICENSE PLATE AND PHONE NUMBER
SELECT people.id, people.name, people.phone_number, people.passport_number, people.license_plate, calls.receiver
FROM people
JOIN (SELECT * FROM bakery_security_logs WHERE year = 2024 AND month = 7 AND day = 28 and hour = 10 AND minute >=15 AND minute <=25) AS logs
ON logs.license_plate = people.license_plate
JOIN (SELECT * FROM phone_calls WHERE year = 2024 AND month = 7 AND day = 28 AND duration < 60) AS calls
ON people.phone_number = calls.caller;

-- +--------+--------+----------------+-----------------+---------------+----------------+
-- |   id   |  name  |  phone_number  | passport_number | license_plate |    receiver    |
-- +--------+--------+----------------+-----------------+---------------+----------------+
-- | 686048 | Bruce  | (367) 555-5533 | 5773159633      | 94KL13X       | (375) 555-8161 |
-- | 398010 | Sofia  | (130) 555-0289 | 1695452385      | G412CB7       | (996) 555-8899 |
-- | 514354 | Diana  | (770) 555-1861 | 3592750733      | 322W7JE       | (725) 555-3243 |
-- | 560886 | Kelsey | (499) 555-9472 | 8294398571      | 0NTHK55       | (717) 555-1342 |
-- | 560886 | Kelsey | (499) 555-9472 | 8294398571      | 0NTHK55       | (892) 555-8872 |
-- +--------+--------+----------------+-----------------+---------------+----------------+

-- FIND ATM TRANSACTIONS ON LEGGETT STREET ON DAY OF THEFT TO NARROW SUSPECTS
SELECT * FROM atm_transactions
WHERE year = 2024 AND month = 7 AND day = 28 AND atm_location = "Leggett Street";

-- +-----+----------------+------+-------+-----+----------------+------------------+--------+
-- | id  | account_number | year | month | day |  atm_location  | transaction_type | amount |
-- +-----+----------------+------+-------+-----+----------------+------------------+--------+
-- | 246 | 28500762       | 2024 | 7     | 28  | Leggett Street | withdraw         | 48     |
-- | 264 | 28296815       | 2024 | 7     | 28  | Leggett Street | withdraw         | 20     |
-- | 266 | 76054385       | 2024 | 7     | 28  | Leggett Street | withdraw         | 60     |
-- | 267 | 49610011       | 2024 | 7     | 28  | Leggett Street | withdraw         | 50     |
-- | 269 | 16153065       | 2024 | 7     | 28  | Leggett Street | withdraw         | 80     |
-- | 275 | 86363979       | 2024 | 7     | 28  | Leggett Street | deposit          | 10     |
-- | 288 | 25506511       | 2024 | 7     | 28  | Leggett Street | withdraw         | 20     |
-- | 313 | 81061156       | 2024 | 7     | 28  | Leggett Street | withdraw         | 30     |
-- | 336 | 26013199       | 2024 | 7     | 28  | Leggett Street | withdraw         | 35     |
-- +-----+----------------+------+-------+-----+----------------+------------------+--------+

-- USE ATM ACCOUNT_NUMBERS (SUSPECT LIST) WITH BANK ACCOUNT NUMBERS LINKED TO PEOPLE.ID (SUSPECT LIST) TO FIND OVERLAP OF LISTS
SELECT *
FROM bank_accounts
JOIN (SELECT * FROM atm_transactions WHERE year = 2024 AND month = 7 AND day = 28 AND atm_location = "Leggett Street") AS atm
ON atm.account_number = bank_accounts.account_number
JOIN (SELECT people.id, people.name, people.phone_number, people.passport_number, people.license_plate, calls.receiver
FROM people
JOIN (SELECT * FROM bakery_security_logs WHERE year = 2024 AND month = 7 AND day = 28 and hour = 10 AND minute >=15 AND minute <=25) AS logs
ON logs.license_plate = people.license_plate
JOIN (SELECT * FROM phone_calls WHERE year = 2024 AND month = 7 AND day = 28 AND duration < 60) AS calls
ON people.phone_number = calls.caller) AS people
ON people.id = bank_accounts.person_id;

-- +----------------+-----------+---------------+-----+----------------+------+-------+-----+----------------+------------------+--------+--------+-------+----------------+-----------------+---------------+----------------+
-- | account_number | person_id | creation_year | id  | account_number | year | month | day |  atm_location  | transaction_type | amount |   id   | name  |  phone_number  | passport_number | license_plate |    receiver    |
-- +----------------+-----------+---------------+-----+----------------+------+-------+-----+----------------+------------------+--------+--------+-------+----------------+-----------------+---------------+----------------+
-- | 49610011       | 686048    | 2010          | 267 | 49610011       | 2024 | 7     | 28  | Leggett Street | withdraw         | 50     | 686048 | Bruce | (367) 555-5533 | 5773159633      | 94KL13X       | (375) 555-8161 |
-- | 26013199       | 514354    | 2012          | 336 | 26013199       | 2024 | 7     | 28  | Leggett Street | withdraw         | 35     | 514354 | Diana | (770) 555-1861 | 3592750733      | 322W7JE       | (725) 555-3243 |
-- +----------------+-----------+---------------+-----+----------------+------+-------+-----+----------------+------------------+--------+--------+-------+----------------+-----------------+---------------+----------------+

-- USE EARLIEST FLIGHT OUT OF FIFTYVILLE TO TRACK SUSPECT

SELECT *
FROM flights
WHERE year = 2024 AND month = 7 AND day = 29 ORDER BY hour ASC LIMIT 1;

-- +----+-------------------+------------------------+------+-------+-----+------+--------+
-- | id | origin_airport_id | destination_airport_id | year | month | day | hour | minute |
-- +----+-------------------+------------------------+------+-------+-----+------+--------+
-- | 36 | 8                 | 4                      | 2024 | 7     | 29  | 8    | 20     |
-- +----+-------------------+------------------------+------+-------+-----+------+--------+

SELECT * FROM airports WHERE id = 8 OR id = 4;

-- +----+--------------+-----------------------------+---------------+
-- | id | abbreviation |          full_name          |     city      |
-- +----+--------------+-----------------------------+---------------+
-- | 4  | LGA          | LaGuardia Airport           | New York City |
-- | 8  | CSF          | Fiftyville Regional Airport | Fiftyville    |
-- +----+--------------+-----------------------------+---------------+

SELECT *
FROM passengers
WHERE passengers.flight_id = 36
AND (passport_number = '5773159633' OR passport_number = '3592750733');

-- +-----------+-----------------+------+
-- | flight_id | passport_number | seat |
-- +-----------+-----------------+------+
-- | 36        | 5773159633      | 4A   |
-- +-----------+-----------------+------+

-- THIEF IS BRUCE, FLED TO LaGuardia Airport, NOW NEED TO FIND ACCOMPLICE THROUGH RECEIVER NUMBER (375) 555-8161

SELECT *
FROM people
WHERE phone_number = '(375) 555-8161';

-- +--------+-------+----------------+-----------------+---------------+
-- |   id   | name  |  phone_number  | passport_number | license_plate |
-- +--------+-------+----------------+-----------------+---------------+
-- | 864400 | Robin | (375) 555-8161 | NULL            | 4V16VO0       |
-- +--------+-------+----------------+-----------------+---------------+
