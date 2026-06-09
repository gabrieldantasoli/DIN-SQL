SELECT COUNT(*) FROM singer
SELECT T1.Name, count(T2.concert_ID) FROM stadium AS T1 LEFT JOIN concert AS T2 ON T1.Stadium_ID = T2.Stadium_ID GROUP BY T1.Stadium_ID
SELECT T1.Name , T1.Capacity FROM stadium AS T1 JOIN concert AS T2 ON T1.Stadium_ID = T2.Stadium_ID WHERE T2.Year >= 2014 GROUP BY T1.Name, T1.Capacity ORDER BY count(*) DESC LIMIT 1
SELECT Year FROM concert GROUP BY Year ORDER BY count(*) DESC LIMIT 1
SELECT T1.Name , T1.Country FROM singer AS T1 WHERE T1.Song_Name LIKE '%Hey%'
SELECT count(DISTINCT concert.concert_ID) FROM concert JOIN stadium ON concert.Stadium_ID = stadium.Stadium_ID WHERE stadium.Capacity = (SELECT max(Capacity) FROM stadium)
SELECT count(T1.PetID) FROM Has_Pet AS T1 JOIN Student AS T2 ON T1.StuID = T2.StuID WHERE T2.Age > 20
SELECT count(distinct T2.PetType) FROM Has_Pet AS T1 JOIN Pets AS T2 ON T1.PetID = T2.PetID
SELECT count(distinct T2.PetType) FROM Has_Pet AS T1 JOIN Pets AS T2 ON T1.PetID = T2.PetID
SELECT DISTINCT T1.Fname FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID = T2.StuID JOIN Pets AS T3 ON T2.PetID = T3.PetID WHERE T3.PetType = 'cat' OR T3.PetType = 'dog'
SELECT StuID FROM Student WHERE StuID NOT IN (SELECT T1.StuID FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID = T2.StuID JOIN Pets AS T3 ON T2.PetID = T3.PetID WHERE T3.PetType = 'cat')
SELECT T2.PetID, T2.weight FROM Pets AS T2 JOIN Has_Pet AS T1 ON T1.PetID = T2.PetID WHERE T2.pet_age > 1
SELECT avg(pet_age), max(pet_age), PetType FROM Pets GROUP BY PetType
SELECT avg(weight), PetType FROM Pets GROUP BY PetType
SELECT T2.PetID FROM Pets AS T1 JOIN Has_Pet AS T2 ON T1.PetID = T2.PetID JOIN Student AS T3 ON T2.StuID = T3.StuID WHERE T3.LName = 'Smith'
SELECT COUNT(*) FROM continents
SELECT COUNT(*) FROM countries
SELECT Model FROM car_names WHERE Id IN (SELECT Id FROM cars_data WHERE Weight < (SELECT avg(Weight) FROM cars_data))
SELECT count(DISTINCT T1.Id), T3.Continent FROM car_makers AS T1 JOIN countries AS T2 ON T1.Country = T2.CountryId JOIN continents AS T3 ON T2.Continent = T3.ContId GROUP BY T3.Continent
SELECT count(T1.ModelId), T2.Id, T2.FullName FROM model_list AS T1 JOIN car_makers AS T2 ON T1.Maker = T2.Id GROUP BY T2.Id
SELECT T1.Model FROM car_names AS T1 JOIN cars_data AS T2 ON T1.MakeId = T2.Id WHERE T2.MPG = (SELECT max(MPG) FROM cars_data)
SELECT T1.Make, count(T1.Model) as model_count FROM car_names AS T1 JOIN model_list AS T2 ON T1.Model = T2.Model GROUP BY T1.Make ORDER BY model_count DESC LIMIT 1
SELECT COUNT(*) FROM cars_data WHERE Year = 1980
SELECT T1.Id , T1.Maker FROM car_makers AS T1 JOIN model_list AS T2 ON T1.Id = T2.Maker GROUP BY T2.Maker HAVING count(*) > 3
SELECT DISTINCT T1.Model FROM car_names AS T1 JOIN car_makers AS T2 ON T1.Maker = T2.Id JOIN cars_data AS T3 ON T3.Id = T1.MakeId JOIN model_list AS T4 ON T1.Model = T4.Model WHERE T2.Maker = 'General Motors' OR T3.Weight > 3500
SELECT Year FROM cars_data WHERE Weight BETWEEN 3000 AND 4000 GROUP BY Year
SELECT DISTINCT Year FROM cars_data WHERE Weight < 4000 INTERSECT SELECT DISTINCT Year FROM cars_data WHERE Weight > 3000
SELECT MAX(Horsepower) FROM cars_data WHERE Accelerate = (SELECT MAX(Accelerate) FROM cars_data)
SELECT min(T1.Accelerate), T1.Cylinders FROM cars_data AS T1 JOIN car_names AS T2 ON T1.Id = T2.MakeId JOIN model_list AS T3 ON T2.Model = T3.ModelId WHERE T3.Model = 'volvo' Note: The SQL query might need to be adjusted based on the actual structure and relationships of the tables in the database.
SELECT COUNT(*) FROM cars_data WHERE Cylinders > 6
SELECT T1.CountryId , T1.CountryName FROM countries AS T1 JOIN car_makers AS T2 ON T1.CountryId = T2.Country GROUP BY T1.CountryId HAVING count(*) > 3 UNION SELECT T1.CountryId , T1.CountryName FROM countries AS T1 JOIN car_names AS T3 ON T1.CountryId = T3.CountryId JOIN model_list AS T4 ON T3.Model = T4.Model WHERE T4.Maker = 'Fiat'
SELECT Country FROM airlines WHERE Airline = 'JetBlue Airways'
SELECT Abbreviation FROM airlines WHERE Airline = 'JetBlue Airways'
SELECT COUNT(*) FROM airlines
SELECT COUNT(*) FROM flights
SELECT COUNT(*) FROM airlines WHERE Country = 'USA'
SELECT City, Country FROM airports WHERE AirportName = 'Alton'
SELECT AirportName FROM airports WHERE AirportCode = 'AKO'
SELECT count(*) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen'
SELECT count(*) FROM flights AS T1 JOIN airports AS T2 ON T1.SourceAirport = T2.AirportCode JOIN airports AS T3 ON T1.DestAirport = T3.AirportCode WHERE T2.City = 'Aberdeen' AND T3.City = 'Ashley'
SELECT T2.City, count(T1.DestAirport) as frequency FROM flights AS T1 JOIN airports AS T2 ON T1.DestAirport = T2.AirportCode GROUP BY T2.City ORDER BY frequency DESC LIMIT 1
SELECT T1.AirportCode FROM airports AS T1 JOIN flights AS T2 ON T1.AirportCode = T2.DestAirport OR T1.AirportCode = T2.SourceAirport GROUP BY T1.AirportCode ORDER BY count(T2.*) DESC LIMIT 1
SELECT T1.Abbreviation, T1.Country FROM airlines AS T1 JOIN flights AS T2 ON T1.Airline = T2.Airline GROUP BY T2.Airline HAVING count(*) = (SELECT min(flight_count) FROM (SELECT count(*) as flight_count FROM flights GROUP BY Airline))
SELECT Airline FROM flights GROUP BY Airline HAVING count(*) >= 10
SELECT FlightNo FROM flights WHERE DestAirport = 'APG'
SELECT T1.FlightNo FROM flights AS T1 JOIN airports AS T2 ON T1.DestAirport = T2.AirportCode WHERE T2.City = 'Aberdeen'
SELECT count(*) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen' OR airports.City = 'Abilene'
SELECT count(*) FROM flights AS T1 JOIN airports AS T2 ON T1.DestAirport = T2.AirportCode WHERE T2.City = 'Aberdeen' OR T2.City = 'Abilene'
SELECT Name FROM employee ORDER BY Age ASC
SELECT COUNT(*), City FROM employee GROUP BY City
SELECT count(shop.Shop_ID), shop.Location FROM shop JOIN hiring ON shop.Shop_ID = hiring.Shop_ID GROUP BY shop.Location
SELECT MIN(Number_products), MAX(Number_products) FROM shop
SELECT min(Number_products), max(Number_products) FROM shop
SELECT Name, Location, District FROM shop ORDER BY Number_products DESC
SELECT SUM(evaluation.Bonus) FROM evaluation JOIN employee ON evaluation.Employee_ID = employee.Employee_ID JOIN hiring ON evaluation.Employee_ID = hiring.Employee_ID JOIN shop ON hiring.Shop_ID = shop.Shop_ID
SELECT SUM(Bonus) FROM evaluation
SELECT * FROM hiring JOIN employee ON hiring.Employee_ID = employee.Employee_ID JOIN shop ON hiring.Shop_ID = shop.Shop_ID JOIN evaluation ON hiring.Employee_ID = evaluation.Employee_ID
SELECT COUNT(*) FROM Documents
SELECT Document_Name, Template_ID FROM Documents WHERE Document_Description LIKE '%w%'
SELECT Document_ID, Template_ID, Document_Description FROM Documents WHERE Document_Name = 'Robbin CV'
SELECT T1.Template_ID , T1.Template_Type_Code FROM Templates AS T1 JOIN Documents AS T2 ON T1.Template_ID = T2.Template_ID GROUP BY T2.Template_ID ORDER BY count(*) DESC LIMIT 1
SELECT T1.Template_ID FROM Templates AS T1 JOIN Documents AS T2 ON T1.Template_ID = T2.Template_ID GROUP BY T2.Template_ID HAVING count(*) > 1
SELECT DISTINCT Templates.Template_Type_Code FROM Templates JOIN Ref_Template_Types ON Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code
SELECT DISTINCT Template_Type_Code FROM Ref_Template_Types
SELECT Template_ID FROM Templates WHERE Template_Type_Code = 'PP' OR Template_Type_Code = 'PPT'
SELECT Template_ID FROM Templates WHERE Template_Type_Code IN ('PP', 'PPT')
SELECT Version_Number, Template_Type_Code FROM Templates WHERE Version_Number > 5
SELECT Version_Number, Template_Type_Code FROM Templates WHERE Version_Number > 5
SELECT T1.Template_Type_Code, count(T2.Template_ID) FROM Ref_Template_Types AS T1 JOIN Templates AS T2 ON T1.Template_Type_Code = T2.Template_Type_Code GROUP BY T1.Template_Type_Code
SELECT Template_Type_Code FROM Templates GROUP BY Template_Type_Code ORDER BY count(*) DESC LIMIT 1
SELECT T1.Template_Type_Code , count(T2.Template_ID) FROM Ref_Template_Types AS T1 JOIN Templates AS T2 ON T1.Template_Type_Code = T2.Template_Type_Code GROUP BY T1.Template_Type_Code HAVING count(*) < 3
SELECT T2.Template_Type_Code FROM Documents AS T1 JOIN Templates AS T2 ON T1.Template_ID = T2.Template_ID WHERE T1.Document_Name = 'Data base'
SELECT Template_Type_Code, Template_Type_Description FROM Ref_Template_Types
SELECT T2.Paragraph_Text FROM Documents AS T1 JOIN Paragraphs AS T2 ON T1.Document_ID = T2.Document_ID WHERE T1.Document_Name = 'Customer reviews'
SELECT COUNT(*) FROM teacher
SELECT COUNT(*) FROM teacher
SELECT teacher.Name FROM teacher INNER JOIN course_arrange ON teacher.Teacher_ID = course_arrange.Teacher_ID ORDER BY teacher.Age ASC
SELECT Age, Hometown FROM teacher
SELECT Name FROM teacher WHERE Hometown != 'Little Lever Urban District'
SELECT T1.Hometown FROM teacher AS T1 JOIN course_arrange AS T2 ON T1.Teacher_ID = T2.Teacher_ID GROUP BY T2.Teacher_ID ORDER BY count(*) DESC LIMIT 1
SELECT Hometown FROM teacher GROUP BY Hometown HAVING count(*) >= 2
SELECT T1.Name FROM teacher AS T1 JOIN course_arrange AS T2 ON T1.Teacher_ID = T2.Teacher_ID JOIN course AS T3 ON T2.Course_ID = T3.Course_ID WHERE T3.Course = 'Math'
SELECT T1.Name, T1.Level_of_membership, T1.Age FROM visitor AS T1 JOIN visit AS T2 ON T1.ID = T2.visitor_ID WHERE T1.Level_of_membership > 4 ORDER BY T1.Age DESC
SELECT avg(Num_of_Staff) FROM museum WHERE Open_Year < 2009
SELECT T1.Museum_ID , T1.Name FROM museum AS T1 JOIN visit AS T2 ON T1.Museum_ID = T2.Museum_ID GROUP BY T2.Museum_ID ORDER BY count(*) DESC LIMIT 1
SELECT sum(visit.Num_of_Ticket) FROM visit INNER JOIN visitor ON visit.visitor_ID = visitor.ID WHERE visitor.Level_of_membership = 1
SELECT COUNT(*) FROM players
SELECT first_name, birth_date FROM players WHERE country_code = 'USA'
SELECT count(distinct T1.loser_name) FROM matches AS T1 JOIN players AS T2 ON T1.loser_id = T2.player_id
SELECT count(distinct T1.loser_name) FROM matches AS T1 JOIN players AS T2 ON T1.loser_id = T2.player_id
SELECT first_name, last_name FROM players WHERE player_id IN (SELECT winner_id FROM matches WHERE year = 2013) AND player_id IN (SELECT winner_id FROM matches WHERE year = 2016)
SELECT first_name, country_code FROM players ORDER BY birth_date ASC LIMIT 1
SELECT avg(T2.ranking_points), T1.first_name FROM players AS T1 JOIN rankings AS T2 ON T1.player_id = T2.player_id GROUP BY T1.first_name
SELECT T1.first_name , sum(T2.ranking_points) FROM players AS T1 JOIN rankings AS T2 ON T1.player_id = T2.player_id GROUP BY T1.player_id
SELECT T1.first_name , T1.country_code , T1.birth_date FROM players AS T1 JOIN matches AS T2 ON T2.winner_id = T1.player_id WHERE T2.winner_rank_points = (SELECT max(winner_rank_points) FROM matches) AND T2.winner_id = T1.player_id GROUP BY T1.player_id
SELECT avg(injured) FROM death WHERE caused_by_ship_id = ship.id
SELECT COUNT(*) FROM Courses
SELECT T2.department_id , T2.department_name FROM Departments AS T1 JOIN Degree_Programs AS T2 ON T1.department_id = T2.department_id GROUP BY T2.department_id ORDER BY count(*) DESC LIMIT 1
SELECT T1.course_id , T1.course_name FROM Courses AS T1 JOIN Sections AS T2 ON T1.course_id = T2.course_id GROUP BY T1.course_id HAVING count(*) <= 2
SELECT T1.semester_id , T1.semester_name FROM Semesters AS T1 JOIN Student_Enrolment AS T2 ON T1.semester_id = T2.semester_id GROUP BY T2.semester_id ORDER BY count(T2.student_enrolment_id) DESC LIMIT 1
SELECT department_description FROM Departments WHERE department_name LIKE '%the computer%'
SELECT first_name , middle_name , last_name , student_id FROM students WHERE student_id IN ( SELECT student_id FROM Student_Enrolment GROUP BY semester_id, student_id HAVING COUNT(degree_program_id) = 2 )
SELECT T1.degree_program_id , T1.degree_summary_name FROM Degree_Programs AS T1 JOIN Student_Enrolment AS T2 ON T1.degree_program_id = T2.degree_program_id GROUP BY T2.degree_program_id ORDER BY count(T2.student_id) DESC LIMIT 1
SELECT semester_name FROM Semesters WHERE semester_id NOT IN (SELECT semester_id FROM Student_Enrolment GROUP BY semester_id)
SELECT DISTINCT T1.course_name FROM Courses AS T1 JOIN Student_Enrolment_Courses AS T2 ON T1.course_id = T2.course_id
SELECT min(counts) FROM ( SELECT T1.transcript_id, count(*) as counts FROM Transcripts AS T1 JOIN Transcript_Contents AS T2 ON T1.transcript_id = T2.transcript_id GROUP BY T1.transcript_id ) )
SELECT semester_id FROM Semesters WHERE semester_id IN (SELECT semester_id FROM Student_Enrolment WHERE degree_program_id IN (SELECT degree_program_id FROM Degree_Programs WHERE degree_summary_name = 'Masters') AND semester_id IN (SELECT semester_id FROM Student_Enrolment WHERE degree_program_id IN (SELECT degree_program_id FROM Degree_Programs WHERE degree_summary_name = 'Bachelors')))
SELECT DISTINCT T1.address_id FROM Addresses AS T1 JOIN Students AS T2 ON T1.address_id = T2.current_address_id OR T1.address_id = T2.permanent_address_id
SELECT other_student_details FROM Students ORDER BY first_name DESC, last_name DESC
SELECT section_description FROM Sections WHERE section_name = 'h'
SELECT Title FROM Cartoon ORDER BY Title ASC
SELECT COUNT(*) FROM Cartoon WHERE Written_by = 'Joseph Kuhr' This SQL query is already correct. It is using the correct table and column names, and the WHERE clause is filtering for the correct condition. There are no issues with this query.
SELECT Country, COUNT(*) as Number_of_Channels FROM TV_Channel GROUP BY Country ORDER BY Number_of_Channels DESC LIMIT 1
SELECT Country, COUNT(id) as Total_Channels FROM TV_Channel GROUP BY Country ORDER BY Total_Channels DESC LIMIT 1
SELECT count(DISTINCT series_name), count(DISTINCT Content) FROM TV_Channel
SELECT Package_Option FROM TV_Channel WHERE series_name = 'Sky Radio'
SELECT T1.Package_Option FROM TV_Channel AS T1 WHERE T1.series_name = 'Sky Radio'
SELECT TV_series.Episode FROM TV_series INNER JOIN TV_Channel ON TV_series.Channel = TV_Channel.id ORDER BY TV_series.Rating
SELECT T1.Weekly_Rank FROM TV_series AS T1 JOIN TV_Channel AS T2 ON T1.Channel = T2.id WHERE T1.Episode = 'A Love of a Lifetime'
SELECT Production_code , Channel FROM Cartoon ORDER BY Original_air_date DESC LIMIT 1
SELECT T1.Package_Option , T1.series_name FROM TV_Channel AS T1 WHERE T1.Hight_definition_TV = 'high definition TV'
SELECT Country FROM TV_Channel WHERE id NOT IN (SELECT Channel FROM Cartoon WHERE Written_by = 'Todd Casey')
SELECT id FROM TV_Channel GROUP BY Country HAVING count(*) > 2
SELECT COUNT(*) FROM poker_player
SELECT avg(Earnings) FROM poker_player WHERE People_ID = People_ID
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID WHERE T2.Earnings > 300000
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID ORDER BY T2.Final_Table_Made ASC
SELECT T1.Birth_Date FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID WHERE T2.Earnings = (SELECT min(Earnings) FROM poker_player)
SELECT T1.Money_Rank FROM poker_player AS T1 JOIN people AS T2 ON T1.People_ID = T2.People_ID WHERE T2.Height = (SELECT max(T2.Height) FROM people)
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID ORDER BY T2.Earnings DESC
SELECT Nationality FROM people GROUP BY Nationality ORDER BY count(*) DESC LIMIT 1
SELECT Nationality FROM people GROUP BY Nationality HAVING count(*) >= 2
SELECT COUNT(DISTINCT state) FROM AREA_CODE_STATE
SELECT MAX(created) FROM VOTES WHERE state = 'CA'
SELECT COUNT(*) FROM country WHERE GovernmentForm = 'republic'
SELECT SUM(SurfaceArea) FROM country WHERE Region = 'Caribbean'
SELECT T2.Continent FROM city AS T1 JOIN country AS T2 ON T1.CountryCode = T2.Code WHERE T1.Name = 'Anguilla'
SELECT AVG(LifeExpectancy) FROM country WHERE Region = 'Central Africa'
SELECT Name FROM country WHERE Continent = 'Asia' ORDER BY LifeExpectancy ASC LIMIT 1
SELECT sum(Population) , max(GNP) FROM country WHERE Continent = 'Asia'
SELECT count(distinct Language) FROM countrylanguage
SELECT COUNT(DISTINCT GovernmentForm) FROM country WHERE Continent = 'Africa'
SELECT Language FROM countrylanguage WHERE CountryCode IN (SELECT Code FROM country WHERE GovernmentForm = 'Republic') GROUP BY Language HAVING count(CountryCode) = 1
SELECT T2.Language FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T1.HeadOfState = 'Beatrix'
SELECT count(distinct T2.Language) FROM countrylanguage AS T1 JOIN country AS T2 ON T1.CountryCode = T2.Code WHERE T2.IndepYear < 1930
SELECT Name FROM country WHERE Continent = 'Asia' AND Population > ANY (SELECT Population FROM country WHERE Continent = 'Africa')
SELECT T1.Code FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T2.Language != 'English'
SELECT DISTINCT T1.Name FROM city AS T1 JOIN country AS T2 ON T1.CountryCode = T2.Code JOIN countrylanguage AS T3 ON T2.Code = T3.CountryCode WHERE T2.Continent = 'Asia' AND T3.Language = 'Chinese' AND T3.IsOfficial = 'T'
SELECT Name, IndepYear, SurfaceArea FROM country ORDER BY Population ASC LIMIT 1
SELECT Name , Population , HeadOfState FROM country WHERE SurfaceArea = (SELECT max(SurfaceArea) FROM country)
SELECT District , count(*) FROM city WHERE Population > (SELECT avg(Population) FROM city) GROUP BY District
SELECT District , count(*) FROM city WHERE Population > (SELECT avg(Population) FROM city) GROUP BY District
SELECT GovernmentForm , sum(Population) FROM country GROUP BY GovernmentForm HAVING avg(LifeExpectancy) > 72
SELECT Name, SurfaceArea FROM country ORDER BY SurfaceArea DESC LIMIT 5
SELECT Name FROM country ORDER BY Population ASC LIMIT 3
SELECT T1.Code FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T2.Language = 'Spanish' ORDER BY T2.Percentage DESC LIMIT 1
SELECT COUNT(*) FROM conductor
SELECT Name FROM conductor ORDER BY Age ASC
SELECT Record_Company FROM orchestra ORDER BY Year_of_Founded DESC
SELECT max(T1.Share), min(T1.Share) FROM performance AS T1 JOIN orchestra AS T2 ON T1.Orchestra_ID = T2.Orchestra_ID WHERE T1.Type != 'Live final'
SELECT Name FROM conductor ORDER BY Year_of_Work DESC LIMIT 1
SELECT T2.Name FROM orchestra AS T1 JOIN conductor AS T2 ON T1.Conductor_ID = T2.Conductor_ID WHERE T1.Year_of_Founded > 2008
SELECT orchestra.Record_Company, COUNT(orchestra.Orchestra) FROM orchestra JOIN performance ON orchestra.Orchestra_ID = performance.Orchestra_ID JOIN show ON performance.Performance_ID = show.Performance_ID JOIN conductor ON orchestra.Conductor_ID = conductor.Conductor_ID GROUP BY orchestra.Record_Company
SELECT Record_Company FROM orchestra GROUP BY Record_Company ORDER BY count(*) DESC LIMIT 1
SELECT Orchestra FROM orchestra WHERE Orchestra_ID NOT IN (SELECT Orchestra_ID FROM performance)
SELECT T2.Year_of_Founded FROM performance AS T1 JOIN orchestra AS T2 ON T1.Orchestra_ID = T2.Orchestra_ID GROUP BY T2.Year_of_Founded HAVING count(T1.Performance_ID) > 1
SELECT grade FROM Highschooler WHERE name = 'Kyle'
SELECT ID FROM Highschooler WHERE name = 'Kyle'
SELECT ID FROM Highschooler WHERE name = 'Kyle'
SELECT count(*), grade FROM Highschooler GROUP BY grade
SELECT grade, COUNT(*) as high_schooler_count FROM Highschooler GROUP BY grade ORDER BY high_schooler_count DESC LIMIT 1
SELECT T1.name FROM Highschooler AS T1 JOIN Friend AS T2 ON T1.ID = T2.student_id GROUP BY T1.name ORDER BY count(*) DESC LIMIT 1
SELECT count(*) FROM Friend WHERE student_id = (SELECT ID FROM Highschooler WHERE name = 'Kyle')
SELECT T1.ID FROM Highschooler AS T1 WHERE EXISTS (SELECT * FROM Friend AS T2 WHERE T1.ID = T2.student_id) AND EXISTS (SELECT * FROM Likes AS T3 WHERE T1.ID = T3.student_id)
SELECT DISTINCT T1.name FROM Highschooler AS T1 WHERE EXISTS (SELECT * FROM Friend AS T2 WHERE T1.ID = T2.student_id) AND EXISTS (SELECT * FROM Likes AS T3 WHERE T1.ID = T3.student_id)
SELECT min(grade) FROM Highschooler WHERE ID NOT IN (SELECT student_id FROM Friend)
SELECT DISTINCT T1.state FROM Owners AS T1 WHERE T1.state IN (SELECT DISTINCT T2.state FROM Professionals AS T2)
SELECT avg(age) FROM Dogs WHERE dog_id IN (SELECT dog_id FROM Treatments)
SELECT avg(age) FROM Dogs WHERE dog_id IN (SELECT dog_id FROM Treatments)
SELECT T1.name FROM Dogs AS T1 JOIN Treatments AS T2 ON T1.dog_id = T2.dog_id GROUP BY T1.name HAVING sum(T2.cost_of_treatment) <= 1000
SELECT professional_id , role_code , email_address FROM Professionals WHERE professional_id NOT IN (SELECT professional_id FROM Treatments)
SELECT T1.professional_id, T1.cell_number FROM Professionals AS T1 JOIN Treatments AS T2 ON T1.professional_id = T2.professional_id GROUP BY T2.professional_id HAVING count(T2.treatment_type_code) >= 2
SELECT T1.first_name , T1.last_name FROM Professionals AS T1 JOIN Treatments AS T2 ON T1.professional_id = T2.professional_id WHERE T2.cost_of_treatment < (SELECT avg(cost_of_treatment) FROM Treatments) GROUP BY T1.first_name, T1.last_name
SELECT T1.date_of_treatment , T2.first_name FROM Treatments AS T1 JOIN Professionals AS T2 ON T1.professional_id = T2.professional_id GROUP BY T1.date_of_treatment, T2.first_name
SELECT T1.cost_of_treatment , T2.treatment_type_description FROM Treatments AS T1 JOIN Treatment_Types AS T2 ON T1.treatment_type_code = T2.treatment_type_code
SELECT count(distinct T1.dog_id) FROM Dogs AS T1 WHERE exists (SELECT * FROM Treatments AS T2 WHERE T2.dog_id = T1.dog_id)
SELECT count(distinct T1.professional_id) FROM Professionals AS T1 JOIN Treatments AS T2 ON T2.professional_id = T1.professional_id
SELECT first_name, last_name, email_address FROM Owners WHERE state LIKE '%North%'
SELECT count(*) FROM Dogs WHERE dog_id NOT IN (SELECT dog_id FROM Treatments)
SELECT count(professional_id) FROM Professionals WHERE professional_id NOT IN (SELECT professional_id FROM Treatments)
SELECT AVG(age) FROM Dogs
SELECT MAX(age) FROM Dogs
SELECT email_address, cell_number, home_phone FROM Professionals
SELECT Name FROM singer ORDER BY Net_Worth_Millions ASC
SELECT Birth_Year, Citizenship FROM singer
SELECT Name FROM singer WHERE Citizenship != 'France'
SELECT Name FROM singer ORDER BY Net_Worth_Millions DESC LIMIT 1
SELECT song.Title, singer.Name FROM song JOIN singer ON song.Singer_ID = singer.Singer_ID
SELECT T1.Name , sum(T2.Sales) FROM singer AS T1 JOIN song AS T2 ON T1.Singer_ID = T2.Singer_ID GROUP BY T2.Singer_ID
SELECT T1.property_name FROM Properties AS T1 JOIN Ref_Property_Types AS T2 ON T1.property_type_code = T2.property_type_code WHERE (T2.property_type_description = 'house' OR T2.property_type_description = 'apartment') AND T1.room_count > 1
