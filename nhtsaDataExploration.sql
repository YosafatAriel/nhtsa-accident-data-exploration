/*
PA 1 GRUP 9 BATCH 10
Data Cleaning: Yosafat
case #1: Heru
case #2: Moh. Dzikron
case #3: Ade
case #4: Aradoni
case #5: Yosafat
case #6 + tambahan: Heru
*/

--Cleaning data ‘timestamp_of_crash’
-- ALTER 'crash' TABLE AND ADD NEW COLUMN 'converted_timestamp'
ALTER TABLE crash
Add converted_timestamp timestamp;

-- UPDATE 'converted_timestamp' COLUMN
UPDATE crash
SET converted_timestamp =
	CASE
	WHEN state_name in ('Alaska') THEN timestamp_of_crash AT TIME ZONE 'AKST'
	WHEN state_name in ('Hawaii') THEN timestamp_of_crash AT TIME ZONE 'HST'
	WHEN state_name in 
	('Oklahoma', 'Mississippi',
	'Louisiana',
	'Arkansas',
	'Missouri',
	'South Dakota',
	'Iowa',
	'Minnesota',
	'Wisconsin',
	'Illinois',
	'North Dakota',
	'Nebraska',
	'Kansas',
	'Texas',
	'Alabama'
	) THEN timestamp_of_crash AT TIME ZONE 'CST'
	WHEN state_name in ('North Carolina',
	'Florida',
	'Vermont',
	'Delaware',
	'New York',
	'West Virginia',
	'South Carolina',
	'New Jersey',
	'Connecticut',
	'District of Columbia',
	'Indiana',
	'Massachusetts',
	'Rhode Island',
	'Ohio',
	'Michigan',
	'Pennsylvania',
	'Kentucky',
	'Virginia',
	'Maryland',
	'Georgia',
	'New Hampshire',
	'Maine',
	'Tennessee'
	) THEN timestamp_of_crash AT TIME ZONE 'EST'
	WHEN state_name in ('Colorado',
	'New Mexico',
	'Montana',
	'Arizona',
	'Utah',
	'Wyoming',
	'Idaho'
	) THEN timestamp_of_crash AT TIME ZONE 'MST'
	WHEN state_name in ('Nevada',
	'Washington',
	'California',
	'Oregon'
	) THEN timestamp_of_crash AT TIME ZONE 'PST'
END

--1.Kondisi yang meningkatkan risiko kecelakaan
select land_use_name, type_of_intersection_name, count (consecutive_number)
from crash
where extract(year from converted_timestamp)=2021
group by 1,2
order by 1, 3 desc;

--2. 10 Negara Bagian teratas dengan angka kecelakaan tertinggi
SELECT state_name, COUNT (*) AS total_accident
FROM crash
WHERE EXTRACT (YEAR FROM converted_timestamp) = 2021
GROUP BY state_name
ORDER BY total_accident DESC
limit 10;

--3. Rata-rata jumlah kecelakaan per jam
SELECT
CASE
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 0 
	THEN '00:00 - 00:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 1 
	THEN '01:00 - 01:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 2 
	THEN '02:00 - 02:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 3 
	THEN '03:00 - 03:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 4 
	THEN '04:00 - 04:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 5 
	THEN '05:00 - 05:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 6 
	THEN '06:00 - 06:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 7 
	THEN '07:00 - 07:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 8 
	THEN '08:00 - 08:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 9 
	THEN '09:00 - 09:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 10 
	THEN '10:00 - 10:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 11 
	THEN '11:00 - 11:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 12 
	THEN '12:00 - 12:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 13 
	THEN '13:00 - 13:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 14 
	THEN '14:00 - 14:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 15 
	THEN '15:00 - 15:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 16 
	THEN '16:00 - 16:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 17 
	THEN '17:00 - 17:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 18 
	THEN '18:00 - 18:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 19 
	THEN '19:00 - 19:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 20 
	THEN '20:00 - 20:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 21 
	THEN '21:00 - 21:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 22 
	THEN '22:00 - 22:59'
	WHEN EXTRACT(HOUR FROM converted_timestamp) = 23 
	THEN '23:00 - 23:59'
END AS jam_terjadinya_kecelakaan,
COUNT(CASE WHEN EXTRACT(DOW FROM converted_timestamp) = 0 THEN consecutive_number END) AS minggu,
COUNT(CASE WHEN EXTRACT(DOW FROM converted_timestamp) = 1 THEN consecutive_number END) AS senin,
COUNT(CASE WHEN EXTRACT(DOW FROM converted_timestamp) = 2 THEN consecutive_number END) AS selasa,
COUNT(CASE WHEN EXTRACT(DOW FROM converted_timestamp) = 3 THEN consecutive_number END) AS rabu,
COUNT(CASE WHEN EXTRACT(DOW FROM converted_timestamp) = 4 THEN consecutive_number END) AS kamis,
COUNT(CASE WHEN EXTRACT(DOW FROM converted_timestamp) = 5 THEN consecutive_number END) AS jumat,
COUNT(CASE WHEN EXTRACT(DOW FROM converted_timestamp) = 6 THEN consecutive_number END) AS sabtu,
COUNT(consecutive_number) AS total_crash,
COUNT(consecutive_number)/7 AS avg_per_day
FROM crash
WHERE EXTRACT(YEAR FROM converted_timestamp) = 2021
GROUP BY 1;

-- NO.4 Persentase Kecelakaan Yang Mabuk (Total Persentase didapatkan di Google Sheet)
WITH cte_1 AS 
(SELECT DISTINCT state_name, COUNT(consecutive_number) AS total_accident, 
SUM(number_of_drunk_drivers) AS total_drunk_accident,
COUNT(consecutive_number) - SUM(number_of_drunk_drivers) AS total_not_drunk_accident
FROM crash
WHERE EXTRACT(YEAR FROM converted_timestamp) = 2021
GROUP BY state_name)
-- Parent Query
SELECT cte_1.state_name, cte_1.total_not_drunk_accident, cte_1.total_drunk_accident,
ROUND((cte_1.total_not_drunk_accident::decimal / cte_1.total_accident * 100)) || '%' AS percentage_not_drunk_drivers_accident,
ROUND((cte_1.total_drunk_accident::decimal / cte_1.total_accident * 100)) || '%' AS percentage_drunk_drivers
FROM cte_1
ORDER BY 5 DESC;


--5.Persentase kecelakaan di daerah pedesaan dan perkotaan
--5.1 Presentase kecelakan Rural VS Urban per negara bagian
WITH rural_accidents AS (
    SELECT ROUND(COUNT(converted_timestamp) * 100.0 / (
        SELECT COUNT(converted_timestamp) AS TotalAccidents
        FROM crash)) AS accidents_percentage, state_name,
    land_use_name
    FROM crash
    WHERE land_use_name = 'Rural' 
        AND EXTRACT(YEAR from converted_timestamp) = 2021
    GROUP BY 2,3
),
urban_accidents AS (
    SELECT ROUND(COUNT(converted_timestamp) * 100.0 / (
        SELECT COUNT(converted_timestamp) AS TotalAccidents
        FROM crash)) AS accidents_percentage, state_name,
    land_use_name
    FROM crash
    WHERE land_use_name = 'Urban' 
        AND EXTRACT(YEAR from converted_timestamp) = 2021
    GROUP BY 2,3
)
SELECT 
       rural_accidents.state_name,
	   rural_accidents.accidents_percentage AS rural_percentage,
       urban_accidents.accidents_percentage AS urban_percentage
FROM rural_accidents
JOIN urban_accidents ON rural_accidents.state_name = urban_accidents.state_name
ORDER BY rural_accidents.accidents_percentage DESC, urban_accidents.accidents_percentage DESC;

--5.2  Presentase kecelakan keseluruhan berdasarkan rural dan urban area
SELECT ROUND(COUNT(converted_timestamp) * 100.0 / (
        SELECT COUNT(converted_timestamp) AS TotalAccidents
        FROM crash)) AS accidents_percentage,
    land_use_name
FROM crash
WHERE land_use_name = 'Rural' 
	AND EXTRACT(YEAR from converted_timestamp) = 2021
GROUP BY 2
UNION
SELECT ROUND(COUNT(converted_timestamp) * 100.0 / (
        SELECT COUNT(converted_timestamp) AS TotalAccidents
        FROM crash)) AS accidents_percentage,
    land_use_name
FROM crash
WHERE land_use_name = 'Urban' 
	AND EXTRACT(YEAR from converted_timestamp) = 2021
GROUP BY 2
ORDER BY 1 DESC;

--6.Jumlah kecelakaan berdasarkan hari			  
SELECT to_char(converted_timestamp, 'Day') as Days,
extract(dow from converted_timestamp),
count(1) number_of_crash
from crash GROUP BY 1,2
ORDER BY extract(dow from converted_timestamp) asc;
--tambahan: negara dengan jumlah kecelakaan terbesar akibat pengemudi mabuk
select state_name, count(consecutive_number) crash,
count(case when number_of_drunk_drivers > 0 then consecutive_number end )crash_by_drunk_driver,
count(case when number_of_drunk_drivers > 0 then consecutive_number end )*100/
count(consecutive_number) percentage_of_crash
from crash
group by 1
order by 4 desc;
