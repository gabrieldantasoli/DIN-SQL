SELECT COUNT(*) FROM singer
SELECT T1.Name , count(distinct T2.concert_ID) FROM stadium AS T1 JOIN concert AS T2 ON T1.Stadium_ID = T2.Stadium_ID GROUP BY T1.Name
SELECT T1.Name, T1.Capacity FROM stadium AS T1 JOIN concert AS T2 ON T1.Stadium_ID = T2.Stadium_ID WHERE T2.Year >= 2014 GROUP BY T1.Name ORDER BY COUNT(*) DESC LIMIT 1
SELECT concert.Year FROM concert GROUP BY concert.Year ORDER BY COUNT(*) DESC LIMIT 1
SELECT T1.Name , T1.Country FROM singer AS T1 JOIN song AS T2 ON T1.Singer_ID = T2.Singer_ID WHERE T2.Song_Name LIKE '%Hey%'
SELECT COUNT(DISTINCT T1.concert_ID) FROM concert AS T1 JOIN stadium AS T2 ON T1.Stadium_ID = T2.Stadium_ID ORDER BY T2.Capacity DESC LIMIT 1
SELECT COUNT(*) FROM Has_Pet AS T1 JOIN Student AS T2 ON T1.StuID = T2.StuID WHERE T2.Age > 20
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT T1.Fname FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID = T2.StuID WHERE T2.PetType = 'cat' OR T2.PetType = 'dog'
SELECT StuID FROM Student WHERE NOT StuID IN (SELECT StuID FROM Has_Pet)
SELECT Pets.PetID, Pets.weight FROM Pets JOIN Has_Pet ON Pets.PetID = Has_Pet.PetID JOIN Student ON Has_Pet.StuID = Student.StuID WHERE Student.Age > 1
SELECT Pets.PetType, AVG(Pets.pet_age), MAX(Pets.pet_age) FROM Pets JOIN Has_Pet ON Pets.PetID = Has_Pet.PetID JOIN Student ON Has_Pet.StuID = Student.StuID GROUP BY Pets.PetType
SELECT Pets.PetType, AVG(Pets.weight) FROM Pets JOIN Has_Pet ON Pets.PetID = Has_Pet.PetID JOIN Student ON Has_Pet.StuID = Student.StuID GROUP BY Pets.PetType
SELECT T1.PetID FROM Has_Pet AS T1 JOIN Student AS T2 ON T1.StuID = T2.StuID WHERE T2.LName = 'Smith'
SELECT COUNT(DISTINCT ContId) FROM continents
SELECT COUNT(DISTINCT CountryId) FROM countries
SELECT Model FROM car_names JOIN cars_data ON car_names.MakeId = cars_data.Id WHERE cars_data.Weight < (SELECT AVG(Weight) FROM cars_data)
SELECT T1.Continent, COUNT(*) as num_car_makers FROM continents AS T1 JOIN countries AS T2 ON T1.ContId = T2.ContId JOIN car_makers AS T3 ON T2.CountryId = T3.Maker GROUP BY T1.ContId
SELECT Maker, count(Maker) as ModelCount, Id, FullName FROM model_list JOIN car_makers ON model_list.Maker = car_makers.Id GROUP BY Maker
SELECT Model FROM cars_data ORDER BY MPG DESC LIMIT 1
SELECT T1.Model , count(distinct T1.Make) as Version FROM car_names AS T1 JOIN model_list AS T2 ON T1.Model = T2.Model JOIN car_makers AS T3 ON T2.Maker = T3.Id GROUP BY T1.Model ORDER BY Version DESC LIMIT 1
SELECT COUNT(*) FROM cars_data WHERE Year = 1980
SELECT Maker , Id FROM car_makers JOIN model_list ON car_makers.Id = model_list.Maker GROUP BY car_makers.Id HAVING count(*) > 3
SELECT Model FROM car_names WHERE Model IN (SELECT T2.Model FROM cars_data AS T1 JOIN car_names AS T2 ON T1.Id = T2.MakeId WHERE T2.Maker = 'General Motors' UNION SELECT T2.Model FROM cars_data AS T1 JOIN car_names AS T2 ON T1.Id = T2.MakeId WHERE T2.Weight > 3500)
SELECT DISTINCT Year FROM cars_data WHERE Weight BETWEEN 3000 AND 4000
SELECT DISTINCT Year FROM cars_data WHERE Weight < 4000 INTERSECT SELECT DISTINCT Year FROM cars_data WHERE Weight > 3000
SELECT MAX(cars_data.Horsepower) FROM cars_data WHERE cars_data.Accelerate = (SELECT MAX(cars_data.Accelerate) FROM cars_data)
SELECT T1.Cylinders FROM cars_data AS T1 JOIN car_names AS T2 ON T1.Id = T2.MakeId JOIN model_list AS T3 ON T2.Model = T3.Model JOIN car_makers AS T4 ON T3.Maker = T4.Id WHERE T4.Maker = 'volvo' ORDER BY T1.Accelerate LIMIT 1
SELECT COUNT(*) FROM cars_data WHERE Cylinders > 6
SELECT countries.CountryId, countries.CountryName FROM countries JOIN car_makers ON countries.CountryId = car_makers.Country JOIN model_list ON car_makers.Maker = model_list.Maker WHERE (SELECT COUNT(*) FROM car_makers WHERE countries.CountryId = car_makers.Country) > 3 OR (SELECT model FROM model_list WHERE countries.CountryId = model_list.Maker) = 'Fiat'
SELECT Country FROM airlines WHERE Airline = "JetBlue Airways"
SELECT Abbreviation FROM airlines WHERE Airline = "JetBlue Airways"
SELECT COUNT (DISTINCT Airline) FROM airlines
SELECT COUNT(*) FROM flights
SELECT COUNT (DISTINCT T1.uid) FROM airlines AS T1 JOIN airports AS T2 ON T1.uid = T2.AirportCode WHERE T2.Country = 'USA'
SELECT T1.City, T1.Country FROM airports AS T1 JOIN flights AS T2 ON T1.AirportCode = T2.DestAirport WHERE T2.Airline = "Alton"
SELECT AirportName FROM airports WHERE AirportCode = "AKO"
SELECT COUNT(*) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen'
SELECT COUNT(*) FROM flights AS T1 JOIN airports AS T2 ON T1.DestAirport = T2.AirportCode JOIN airports AS T3 ON T1.SourceAirport = T3.AirportCode WHERE T2.City = "Ashley" AND T3.City = "Aberdeen"
SELECT City FROM city WHERE AirportCode IN (SELECT AirportCode FROM flights GROUP BY AirportCode ORDER BY COUNT(*) DESC LIMIT 1)
SELECT AirportCode FROM flights GROUP BY DestAirport ORDER BY count(*) DESC LIMIT 1
SELECT Abbreviation, Country FROM airlines WHERE uid IN (SELECT Airline FROM flights GROUP BY Airline ORDER BY COUNT(*) LIMIT 1)
SELECT Airline FROM airlines JOIN flights ON flights.Airline = airlines.Airline GROUP BY Airline HAVING COUNT(*) >= 10
SELECT T1.FlightNo FROM flights AS T1 JOIN airports AS T2 ON T1.DestAirport = T2.AirportCode WHERE T2.City = "APG"
SELECT T1.FlightNo FROM flights AS T1 JOIN airports AS T2 ON T1.DestAirport = T2.AirportCode WHERE T2.City = 'Aberdeen'
SELECT COUNT(flights.FlightNo) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City IN ('Aberdeen', 'Abilene')
SELECT COUNT(*) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode OR flights.SourceAirport = airports.AirportCode WHERE airports.City IN ('Aberdeen', 'Abilene')
SELECT Name FROM employee ORDER BY Age
SELECT employee.Name, employee.Age, employee.City, COUNT(*) FROM employee GROUP BY employee.City
SELECT Location, COUNT(*) FROM shop GROUP BY Location
SELECT min(Number_products), max(Number_products) FROM shop
SELECT MIN(Number_products), MAX(Number_products) FROM shop
SELECT Name, Location, District FROM shop ORDER BY Number_products DESC
SELECT SUM(Bonus) FROM evaluation
SELECT sum(Bonus) FROM evaluation
SELECT * FROM hiring
SELECT COUNT(Document_ID) FROM Documents
SELECT Document_Name , Template_ID FROM Documents JOIN Templates ON Documents.Template_ID = Templates.Template_ID WHERE Documents.Document_Description LIKE '%w%'
SELECT T1.Document_ID, T2.Template_ID, T1.Document_Description FROM Documents AS T1 JOIN Templates AS T2 ON T1.Template_ID = T2.Template_ID WHERE T1.Document_Name = 'Robbin CV'
SELECT Templates.Template_ID , Ref_Template_Types.Template_Type_Code
SELECT Template_ID FROM Templates GROUP BY Template_ID HAVING COUNT(*) = 1
SELECT DISTINCT T1.Template_Type_Code FROM Templates AS T1 JOIN Ref_Template_Types AS T2 ON T1.Template_Type_Code = T2.Template_Type_Code
SELECT DISTINCT Template_Type_Code FROM Ref_Template_Types
SELECT Template_ID FROM Templates WHERE Template_Type_Code = 'PP' OR Template_Type_Code = 'PPT'
SELECT Template_ID FROM Templates WHERE Template_Type_Code = 'PP' OR Template_Type_Code = 'PPT'
SELECT Version_Number , Template_Type_Code FROM Templates WHERE Version_Number > 5
SELECT Version_Number , Template_Type_Code FROM Templates WHERE Version_Number > 5
SELECT T1.Template_Type_Code , count(*) FROM Templates AS T1 JOIN Ref_Template_Types AS T2 ON T1.Template_Type_Code = T2.Template_Type_Code GROUP BY T1.Template_Type_Code
SELECT Ref_Template_Types.Template_Type_Code FROM Ref_Template_Types JOIN Templates ON Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code GROUP BY Ref_Template_Types.Template_Type_Code ORDER BY COUNT(*) DESC LIMIT 1
SELECT Ref_Template_Types.Template_Type_Code FROM Ref_Template_Types JOIN Templates ON Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code GROUP BY Ref_Template_Types.Template_Type_Code HAVING COUNT(*) < 3
SELECT T1.Template_Type_Code FROM Templates AS T1 JOIN Documents AS T2 ON T1.Template_ID = T2.Template_ID WHERE T2.Document_Name = "Data base"
SELECT Template_Type_Code, Template_Type_Description FROM Ref_Template_Types
SELECT T1.Paragraph_Text FROM Paragraphs AS T1 JOIN Documents AS T2 ON T1.Document_ID = T2.Document_ID WHERE T2.Document_Name = 'Customer reviews'
SELECT COUNT(DISTINCT teacher.Name) FROM teacher
SELECT COUNT(*) FROM teacher
SELECT Name FROM teacher ORDER BY Age
SELECT Age, Hometown FROM teacher
SELECT Name FROM teacher WHERE Hometown <> 'Little Lever Urban District'
SELECT Hometown FROM teacher GROUP BY Hometown ORDER BY COUNT(*) DESC LIMIT 1
SELECT
SELECT T1.Name FROM teacher AS T1 JOIN course AS T2 ON T1.Teacher_ID = T2.Teacher_ID JOIN course_arrange AS T3 ON T2.Course_ID = T3.Course_ID WHERE T2.Course = 'math'
SELECT museum.Name, visitor.Level_of_membership FROM museum JOIN visit ON museum.Museum_ID = visit.Museum_ID JOIN visitor ON visit.visitor_ID = visitor.ID WHERE visitor.Level_of_membership > 4 ORDER BY visitor.Age DESC
SELECT AVG(Num_of_Staff) FROM museum WHERE Open_Year < 2009
SELECT museum.Museum_ID, museum.Name FROM museum JOIN visit ON museum.Museum_ID = visit.Museum_ID GROUP BY museum.Museum_ID ORDER BY COUNT(*) DESC LIMIT 1
SELECT sum(Total_spent) FROM visit WHERE Level_of_membership = 1
SELECT COUNT(*) FROM players
SELECT first_name , birth_date FROM players WHERE country_code = 'USA'
SELECT COUNT(DISTINCT loser_name) FROM matches
SELECT COUNT(DISTINCT loser_name) FROM matches
SELECT first_name , last_name FROM players WHERE player_id IN (SELECT winner_id FROM matches WHERE year = 2013) INTERSECT SELECT first_name , last_name FROM players WHERE player_id IN (SELECT winner_id FROM matches WHERE year = 2016)
SELECT first_name , country_code FROM players ORDER BY birth_date LIMIT 1
SELECT rankings.ranking , players.first_name FROM rankings AS T1 JOIN players AS T2 ON T1.player_id = T2.player_id WHERE rankings.ranking is not null ORDER BY rankings.ranking
SELECT first_name, SUM(ranking_points) FROM players JOIN rankings ON players.player_id = rankings.player_id GROUP BY first_name
SELECT first_name , country_code , birth_date FROM players WHERE player_id IN (SELECT winner_id FROM matches WHERE winner_rank_points = (SELECT max(winner_rank_points) FROM matches))
SELECT AVG(injured) FROM death
SELECT COUNT(course_id) FROM course
SELECT T1.department_id , T2.department_name FROM Degree_Programs AS T1 JOIN Departments AS T2 ON T1.department_id = T2.department_id GROUP BY T2.department_name ORDER BY count(*) DESC LIMIT 1
SELECT T1.title , T1.course_id FROM course AS T1 JOIN section AS T2 ON T1.course_id = T2.course_id GROUP BY T1.course_id HAVING count(*) <= 2
SELECT T1.semester_name , T1.semester_id FROM Semesters AS T1 JOIN Student_Enrolment AS T2 ON T1.semester_id = T2.semester GROUP BY T1.semester_id ORDER BY count(*) DESC LIMIT 1
SELECT department_description FROM Departments WHERE department_name LIKE '%computer%'
SELECT first_name , middle_name , last_name , ID FROM student WHERE ID IN (SELECT student.ID FROM student JOIN Student_Enrolment ON student.ID = Student_Enrolment.student_id JOIN Degree_Programs ON Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id WHERE Student_Enrolment.semester_id = @.@ GROUP BY student.ID HAVING count(*) = 2)
SELECT T1.degree_program_id , T1.degree_summary_name FROM Degree_Programs AS T1 JOIN Student_Enrolment AS T2 ON T1.degree_program_id = T2.degree_program_id GROUP BY T2.degree_program_id ORDER BY count(*) DESC LIMIT 1
SELECT semester_name FROM Semesters WHERE NOT EXISTS ( SELECT 1 FROM Student_Enrolment WHERE Student_Enrolment.semester_id = Semesters.semester_id )
SELECT T1.course_name FROM Courses AS T1 JOIN Students AS T2 ON T1.course_id = T2.course_id WHERE EXISTS (SELECT T2.student_id FROM Students AS T2 WHERE T2.course_id = T1.course_id)
SELECT transcript_date , transcript_id FROM Transcripts GROUP BY transcript_id ORDER BY COUNT(*) DESC LIMIT 1
SELECT T1.semester_id FROM Semesters AS T1 JOIN Degree_Programs AS T2 ON T1.semester_id = T2.semester_id JOIN Students AS T3 ON T2.degree_summary_name = T3.student_id WHERE T3.student_id = 'Masters' AND T3.student_id = 'Bachelors'
SELECT DISTINCT T1.line_1 , T1.line_2 , T1.city , T1.zip_postcode , T1.state_province_county , T1.country FROM Addresses AS T1 JOIN Students AS T2 ON T1.address_id = T2.current_address_id
SELECT
SELECT
SELECT Title FROM Cartoon ORDER BY Title
SELECT COUNT(*) FROM Cartoon WHERE Writer = 'Joseph Kuhr'
SELECT Country , COUNT (id) FROM TV_Channel GROUP BY Country ORDER BY COUNT (id) DESC LIMIT 1
SELECT Country , COUNT (id) FROM TV_Channel GROUP BY Country ORDER BY COUNT (id) DESC LIMIT 1
SELECT COUNT(DISTINCT series_name), COUNT(DISTINCT Content) FROM TV_Channel
SELECT Package_Option FROM TV_Channel WHERE series_name = "Sky Radio"
SELECT Package_Option FROM TV_Channel WHERE series_name = 'Sky Radio'
SELECT Episode FROM TV_series ORDER BY Rating
SELECT Weekly_Rank FROM TV_series WHERE Episode = "A Love of a Lifetime"
SELECT Cartoon.Production_code , TV_Channel.Channel FROM Cartoon JOIN TV_Channel ON Cartoon.Channel = TV_Channel.id ORDER BY Cartoon.Original_air_date DESC LIMIT 1
SELECT T1.Package_Option , T2.Title FROM TV_Channel AS T1 JOIN TV_series AS T2 ON T1.id = T2.Channel WHERE T1.High_definition_TV = 'yes'
SELECT DISTINCT Country FROM TV_Channel WHERE Country NOT IN (SELECT Country FROM Cartoon WHERE Written_by = "Todd Casey")
SELECT id FROM TV_Channel GROUP BY Country HAVING COUNT(*) > 2
SELECT COUNT(DISTINCT Poker_Player_ID) FROM poker_player
SELECT AVG(Earnings) FROM poker_player
SELECT Name FROM poker_player WHERE Earnings > 300000
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID WHERE T2.Final_Table_Made IS NOT NULL ORDER BY T2.Final_Table_Made
SELECT Birth_Date FROM poker_player ORDER BY Earnings LIMIT 1
SELECT Money_Rank FROM poker_player JOIN people ON poker_player.People_ID = people.People_ID ORDER BY people.Height DESC LIMIT 1
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID WHERE T2.Earnings IS NOT NULL ORDER BY T2.Earnings DESC
SELECT Nationality FROM people GROUP BY Nationality ORDER BY COUNT(*) DESC LIMIT 1
SELECT Nationality FROM people GROUP BY Nationality HAVING count(*) >= 2
SELECT COUNT(DISTINCT(state)) FROM AREA_CODE_STATE; This query uses the COUNT function to count the number of distinct values in the state column of the AREA_CODE_STATE table. The DISTINCT keyword ensures that each state is only counted once, even if it appears in multiple rows. The result of this query is the total number of states in the table.
SELECT max(created) FROM VOTES JOIN AREA_CODE_STATE ON VOTES.state = AREA_CODE_STATE.state WHERE AREA_CODE_STATE.state = 'CA'
SELECT COUNT(*) FROM country WHERE GovernmentForm = "Republic"
SELECT SUM(SurfaceArea) FROM country WHERE Code IN (SELECT Code FROM country WHERE Continent = "Carribean")
SELECT Continent FROM country WHERE Name = "Anguilla"
SELECT AVG(LifeExpectancy) FROM country WHERE Region = "Central Africa"
SELECT Name FROM country WHERE Continent = "Asia" ORDER BY LifeExpectancy LIMIT 1
SELECT COUNT(*), MAX(GNP) FROM country WHERE CountryCode IN (SELECT CountryCode FROM country WHERE Continent = "Asia")
SELECT COUNT(DISTINCT Language) FROM countrylanguage
SELECT COUNT(DISTINCT GovernmentForm) FROM country WHERE Continent = "Africa"
SELECT Language FROM countrylanguage WHERE country.Name IN (SELECT country.Name FROM country WHERE country.GovernmentForm = 'Republic')
SELECT Language FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T1.HeadOfState = "Beatrix" AND T2.IsOfficial = "T"
SELECT COUNT(DISTINCT T1.Language) FROM countrylanguage AS T1 JOIN country AS T2 ON T1.CountryCode = T2.Code WHERE T2.IndepYear < 1930
SELECT Name FROM country WHERE Population > (SELECT min(Population) FROM country WHERE Continent = "Africa") AND Continent = "Asia"
SELECT Code FROM country WHERE Language != "English"
SELECT Name FROM city WHERE CountryCode IN (SELECT country.Code FROM country WHERE country.Language = "Chinese" AND country.Continent = "Asia")
SELECT Name, IndepYear, SurfaceArea FROM country ORDER BY Population DESC LIMIT 1
SELECT Name, Population, HeadOfState FROM country ORDER BY SurfaceArea DESC LIMIT 1
SELECT
SELECT COUNT(ID) FROM city WHERE Population > (SELECT AVG(Population) FROM city) GROUP BY District
SELECT GovernmentForm , Population FROM country GROUP BY GovernmentForm HAVING avg(LifeExpectancy) > 72
SELECT Name, Area FROM country ORDER BY Area DESC LIMIT 5
SELECT Name FROM country ORDER BY Population LIMIT 3
SELECT T1.Code FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T2.Language = "Spanish" AND T2.Percentage >= 80 GROUP BY T1.Code ORDER BY T1.Code
SELECT COUNT (DISTINCT T1.Conductor_ID) FROM Conductor AS T1
SELECT Name FROM conductor ORDER BY Age
SELECT Record_Company FROM orchestra ORDER BY Year_of_Founded DESC
SELECT max(Share), min(Share) FROM performance WHERE Type != "Live final"
SELECT Name FROM conductor ORDER BY Year_of_Work DESC LIMIT 1
SELECT T1.Name FROM conductor AS T1 JOIN orchestra AS T2 ON T1.Conductor_ID = T2.Conductor_ID WHERE T2.Year_of_Founded > 2008
SELECT Record_Company , COUNT (DISTINCT Orchestra_ID) FROM orchestra GROUP BY Record_Company
SELECT Record_Company FROM orchestra GROUP BY Record_Company ORDER BY COUNT(*) DESC LIMIT 1
SELECT Orchestra FROM orchestra WHERE Orchestra_ID NOT IN (SELECT Orchestra_ID FROM performance)
SELECT Year_of_Founded FROM orchestra GROUP BY Orchestra_ID HAVING COUNT(*) > 1
SELECT grade FROM Highschooler WHERE name = 'Kyle'
SELECT ID FROM Highschooler WHERE name = 'Kyle'
SELECT Kyle.ID FROM Highschooler AS Kyle JOIN Friend AS F ON Kyle.ID = F.student_id WHERE Kyle.name = "Kyle"
SELECT grade, COUNT(*) FROM Highschooler GROUP BY grade
SELECT grade FROM Highschooler GROUP BY grade ORDER BY COUNT(*) DESC LIMIT 1
SELECT T1.name FROM Highschooler AS T1 JOIN Friend AS T2 ON T1.ID = T2.student_id GROUP BY T2.student_id HAVING count(*) = (SELECT max (count(*)) FROM Friend GROUP BY student_id) ORDER BY count(*) DESC LIMIT 1
SELECT COUNT(*) FROM Friend WHERE student_id = (SELECT ID FROM Highschooler WHERE name = "Kyle")
SELECT ID FROM Highschooler WHERE ID IN (SELECT student_id FROM Friend) INTERSECT SELECT ID FROM Highschooler WHERE ID IN (SELECT liked_id FROM Likes)
SELECT name FROM Highschooler WHERE id IN (SELECT student_id FROM Friend) INTERSECT SELECT name FROM Highschooler WHERE id IN (SELECT liked_id FROM Likes)
SELECT min(grade) FROM Highschooler WHERE NOT ID IN (SELECT student_id FROM Friend)
SELECT city.State_County_Province FROM city WHERE city.Owner_Count > 0 AND city.Professional_Count > 0
SELECT AVG(age) FROM Dogs WHERE dog_id IN (SELECT dog_id FROM Treatments)
SELECT AVG(age) FROM Dogs WHERE dog_id IN (SELECT dog_id FROM Treatments)
SELECT name FROM Dogs WHERE NOT dog_id IN (SELECT dog_id FROM Treatments GROUP BY dog_id HAVING SUM(cost_of_treatment) > 1000)
SELECT professional_id , role_code , email_address FROM Professionals WHERE professional_id NOT IN (SELECT professional_id FROM Treatments)
SELECT professional_id , cell_phone FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id JOIN Treatment_Types ON Treatments.treatment_type_code = Treatment_Types.treatment_type_code GROUP BY professional_id HAVING count(*) > 1
SELECT first_name , last_name FROM Professionals JOIN Treatments ON Treatments.professional_id = Professionals.professional_id WHERE cost_of_treatment < (SELECT avg(cost_of_treatment) FROM Treatments)
SELECT T1.date_of_treatment , T2.first_name FROM Treatments AS T1 JOIN Professionals AS T2 ON T1.professional_id = T2.professional_id
SELECT T1.cost_of_treatment , T2.treatment_type_description FROM Treatments AS T1 JOIN Treatment_Types AS T2 ON T1.treatment_type_code = T2.treatment_type_code
SELECT COUNT(DISTINCT Dogs.dog_id) FROM Dogs JOIN Treatments ON Dogs.dog_id = Treatments.dog_id
SELECT COUNT(DISTINCT professional_id) FROM Professionals AS P JOIN Treatments AS T ON P.professional_id = T.professional_id
SELECT first_name, last_name, email_address FROM Owners JOIN city ON Owners.city_id = city.City_ID WHERE city.State_county_province LIKE '%North%'
SELECT COUNT(*) FROM Dogs WHERE NOT dog_id IN (SELECT dog_id FROM Treatments)
SELECT count(DISTINCT professional_id) FROM Professionals WHERE NOT EXISTS (SELECT professional_id FROM Treatments)
SELECT AVG(age) FROM Dogs
SELECT max(age) FROM Dogs
SELECT email_address , cell_number , home_phone FROM Professionals
SELECT Name FROM singer ORDER BY Net_Worth_Millions
SELECT Birth_Year , Citizenship FROM singer
SELECT Name FROM singer WHERE Citizenship <> "France"
SELECT Name FROM singer ORDER BY Net_Worth_Millions DESC LIMIT 1
SELECT T1.Title , T2.Name FROM song AS T1 JOIN singer AS T2 ON T1.Singer_ID = T2.Singer_ID
SELECT T1.Name , SUM(T2.Sales) FROM singer AS T1 JOIN song AS T2 ON T1.Singer_ID = T2.Singer_ID GROUP BY T1.Name
SELECT property_name FROM Properties JOIN Ref_Property_Types ON Properties.property_type_code = Ref_Property_Types.property_type_code WHERE Properties.room_count > 1 AND (Ref_Property_Types.property_type_name = 'house' OR Ref_Property_Types.property_type_name = 'apartment')
