SELECT COUNT(*) FROM singer
SELECT count(*) , T2.name FROM concert AS T1 JOIN stadium AS T2 ON T1.stadium_id = T2.stadium_id GROUP BY T2.stadium_id
SELECT T2.name, T2.capacity FROM concert AS T1 JOIN stadium AS T2 ON T1.stadium_id = T2.stadium_id WHERE T1.year >= 2014 GROUP BY T2.stadium_id ORDER BY count(*) DESC LIMIT 1
SELECT YEAR FROM concert GROUP BY YEAR ORDER BY count(*) DESC LIMIT 1
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT count(*) FROM concert WHERE concert.stadium_id = (SELECT stadium_id FROM stadium ORDER BY capacity DESC LIMIT 1)
SELECT count(*) FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid = T2.stuid WHERE T1.age > 20
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT DISTINCT T1.Fname FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID = T2.StuID JOIN Pets AS T3 ON T2.PetID = T3.PetID WHERE T3.PetType = 'cat' OR T3.PetType = 'dog'
SELECT StuID FROM Has_Pet AS HP JOIN Pets AS P ON HP.PetID = P.PetID WHERE PetType != 'cat'
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetType, avg(pet_age) , max(pet_age) FROM pets GROUP BY PetType
SELECT PetType, AVG(weight) FROM Pets GROUP BY PetType
SELECT Pets.PetID FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Student.LName = 'Smith'
SELECT COUNT(*) FROM continents
SELECT COUNT(CountryId) FROM countries
SELECT T2.Model FROM cars_data AS T1 JOIN car_names AS T2 ON T1.Id = T2.MakeId WHERE T1.Weight < (SELECT AVG(Weight) FROM cars_data)
SELECT c.Continent, COUNT(m.Id) AS NumberOfCarMakers FROM continents c JOIN countries co ON c.ContId = co.Continent JOIN model_list ml ON co.CountryId = ml.CountryId JOIN car_makers m ON ml.Maker = m.Id GROUP BY c.Continent
SELECT car_makers.Id, car_makers.FullName, COUNT(car_names.Model) AS NumberOfModels FROM car_makers JOIN model_list ON car_makers.Id = model_list.Maker JOIN car_names ON model_list.ModelId = car_names.Model GROUP BY car_makers.Id, car_makers.FullName
SELECT T1.Model FROM car_names AS T1 JOIN cars_data AS T2 ON T1.MakeId = T2.Id ORDER BY T2.MPG DESC LIMIT 1
SELECT Model, COUNT(*) AS Count FROM car_names GROUP BY Model ORDER BY Count DESC LIMIT 1
SELECT COUNT(*) FROM cars_data WHERE Year = 1980
SELECT Maker, Id FROM car_makers WHERE Id IN (SELECT Maker FROM car_names GROUP BY Maker HAVING COUNT(*) > 3)
SELECT DISTINCT model FROM car_names JOIN car_makers ON car_names.MakeId = car_makers.Id WHERE car_makers.Maker = 'General Motors' UNION SELECT DISTINCT model FROM car_names JOIN cars_data ON car_names.MakeId = cars_data.Id WHERE cars_data.weight > 3500
SELECT Year FROM cars_data WHERE Weight >= 3000 AND Weight <= 4000
SELECT DISTINCT Year FROM cars_data WHERE Weight < 4000 OR Weight > 3000
SELECT Horsepower FROM cars_data ORDER BY Accelerate DESC LIMIT 1
SELECT T1.Cylinders FROM cars_data AS T1 JOIN car_names AS T2 ON T1.Id = T2.MakeId JOIN model_list AS T3 ON T2.Model = T3.Model WHERE T3.Model = 'volvo' ORDER BY T1.Accelerate ASC LIMIT 1
SELECT COUNT(*) FROM cars_data WHERE Cylinders > 6
SELECT c.CountryId, c.CountryName FROM car_makers m JOIN countries c ON m.Country = c.CountryId WHERE c.CountryName IN ( SELECT c.CountryName FROM car_makers m JOIN countries c ON m.Country = c.CountryId GROUP BY c.CountryName HAVING COUNT(m.Id) > 3 ) OR EXISTS ( SELECT 1 FROM car_makers m JOIN countries c ON m.Country = c.CountryId JOIN car_names cn ON m.Id = cn.MakeId WHERE cn.Model = 'Fiat' )
SELECT Country FROM airlines WHERE Airline = 'JetBlue Airways'
SELECT Abbreviation FROM airlines WHERE Airline = 'JetBlue Airways'
SELECT COUNT(*) FROM airlines
SELECT COUNT(*) FROM flights
SELECT COUNT(*) FROM airlines WHERE Country = 'USA'
SELECT City, Country FROM airports WHERE AirportName = 'Alton'
SELECT AirportName FROM airports WHERE AirportCode = 'AKO'
SELECT COUNT(*) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen'
SELECT COUNT(*) FROM flights JOIN airports AS source_airport ON flights.SourceAirport = source_airport.AirportCode JOIN airports AS dest_airport ON flights.DestAirport = dest_airport.AirportCode WHERE source_airport.City = 'Aberdeen' AND dest_airport.City = 'Ashley'
SELECT T1.City FROM airports AS T1 JOIN flights AS T2 ON T1.AirportCode = T2.DestAirport GROUP BY T1.City ORDER BY COUNT(*) DESC LIMIT 1
SELECT airports.AirportCode, COUNT(flights.FlightNo) AS flight_count FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode GROUP BY airports.AirportCode ORDER BY flight_count DESC LIMIT 1
SELECT T1.abbreviation, T1.country FROM airlines AS T1 JOIN flights AS T2 ON T1.uid = T2.Airline GROUP BY T1.uid ORDER BY count(*) ASC LIMIT 1
SELECT T1.Airline, COUNT(*) AS flight_count FROM airlines AS T1 JOIN flights AS T2 ON T1.uid = T2.Airline GROUP BY T1.Airline HAVING COUNT(*) >= 10
SELECT DISTINCT flights.FlightNo FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.AirportName = 'APG'
SELECT DISTINCT T1.FlightNo FROM flights AS T1 JOIN airports AS T2 ON T1.DestAirport = T2.AirportCode WHERE T2.City = 'Aberdeen'
SELECT COUNT(*) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen' OR airports.City = 'Abilene'
SELECT COUNT(*) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City IN ('Aberdeen', 'Abilene')
SELECT name FROM employee ORDER BY age ASC
SELECT COUNT(Employee_ID), City FROM employee GROUP BY City
SELECT Location, COUNT(*) FROM shop GROUP BY Location
SELECT min(Number_products) , max(Number_products) FROM shop
SELECT min(Number_products) , max(Number_products) FROM shop
SELECT name, location, district FROM shop ORDER BY number_products DESC
SELECT sum(bonus) FROM evaluation
SELECT sum(bonus) FROM evaluation
SELECT * FROM hiring
SELECT COUNT(*) FROM Documents
SELECT document_name, template_id FROM Documents WHERE document_description LIKE '%w%'
SELECT Document_ID, Template_ID, Document_Description FROM Documents WHERE Document_Name = 'Robbin CV'
SELECT T2.template_id, T2.template_type_code FROM documents AS T1 JOIN templates AS T2 ON T1.template_id = T2.template_id GROUP BY T2.template_id, T2.template_type_code ORDER BY COUNT(*) DESC LIMIT 1
SELECT template_id FROM documents GROUP BY template_id HAVING COUNT(*) > 1
SELECT DISTINCT Template_Type_Code FROM Templates
SELECT DISTINCT Template_Type_Code FROM Ref_Template_Types
SELECT Template_ID FROM Templates WHERE Template_Type_Code IN ('PP', 'PPT')
SELECT Template_ID FROM Templates WHERE Template_Type_Code IN ('PP', 'PPT')
SELECT Version_Number, Template_Type_Code FROM Templates WHERE Version_Number > 5
SELECT Version_Number, Template_Type_Code FROM Templates WHERE Version_Number > 5
SELECT Template_Type_Code, COUNT(*) FROM Templates GROUP BY Template_Type_Code
SELECT Template_Type_Code FROM Templates GROUP BY Template_Type_Code ORDER BY COUNT(*) DESC LIMIT 1
SELECT Template_Type_Code FROM Ref_Template_Types WHERE Template_Type_Code IN ( SELECT Template_Type_Code FROM Templates GROUP BY Template_Type_Code HAVING COUNT(*) < 3 )
SELECT T1.Template_Type_Code FROM Templates AS T1 JOIN Documents AS T2 ON T1.Template_ID = T2.Template_ID WHERE T2.Document_Name = 'Data base'
SELECT Template_Type_Code, Template_Type_Description FROM Ref_Template_Types
SELECT T2.Paragraph_Text FROM Documents AS T1 JOIN Paragraphs AS T2 ON T1.Document_ID = T2.Document_ID WHERE T1.Document_Name = 'Customer reviews'
SELECT COUNT(Teacher_ID) FROM teacher
SELECT COUNT(*) FROM teacher
SELECT Name FROM teacher ORDER BY Age ASC
SELECT Age, Hometown FROM teacher
SELECT Name FROM teacher WHERE Hometown != 'Little Lever Urban District'
SELECT Hometown FROM teacher GROUP BY Hometown ORDER BY COUNT(*) DESC LIMIT 1
SELECT hometown FROM teacher GROUP BY hometown HAVING COUNT(*) >= 2
SELECT DISTINCT T1.Name FROM teacher AS T1 JOIN course_arrange AS T2 ON T1.Teacher_ID = T2.Teacher_ID JOIN course AS T3 ON T2.Course_ID = T3.Course_ID WHERE T3.Course = 'Math'
SELECT name, Level_of_membership FROM visitor WHERE Level_of_membership > 4 ORDER BY Age DESC
SELECT AVG(Num_of_Staff) FROM museum WHERE Open_Year < 2009
SELECT T1.Museum_ID, T1.Name FROM museum AS T1 JOIN visit AS T2 ON T1.Museum_ID = T2.Museum_ID GROUP BY T1.Museum_ID, T1.Name ORDER BY COUNT(T2.Num_of_Ticket) DESC LIMIT 1
SELECT sum(T1.Total_spent) FROM visit AS T1 JOIN visitor AS T2 ON T1.visitor_ID = T2.ID WHERE T2.Level_of_membership = 1
SELECT COUNT(*) FROM players
SELECT first_name, birth_date FROM players WHERE country_code = 'USA'
SELECT COUNT(DISTINCT loser_name) FROM matches
SELECT COUNT(DISTINCT loser_name) FROM matches
SELECT p.first_name, p.last_name FROM players AS p JOIN matches AS m ON p.player_id = m.winner_id WHERE m.year = 2013
SELECT first_name, country_code FROM players ORDER BY birth_date ASC LIMIT 1
SELECT T1.first_name, AVG(T2.ranking) AS avg_ranking FROM players AS T1 JOIN rankings AS T2 ON T1.player_id = T2.player_id GROUP BY T1.player_id
SELECT P.first_name, SUM(R.ranking_points) AS total_ranking_points FROM players AS P JOIN rankings AS R ON P.player_id = R.player_id GROUP BY P.player_id, P.first_name
SELECT P.first_name, P.country_code, P.birth_date FROM players AS P JOIN matches AS M ON P.player_id = M.winner_id GROUP BY P.player_id ORDER BY SUM(M.winner_rank_points) DESC LIMIT 1
SELECT AVG(injured) AS average_injuries FROM death
SELECT COUNT(*) FROM Courses
SELECT department_id, COUNT(degree_program_id) AS degree_count FROM Degree_Programs GROUP BY department_id ORDER BY degree_count DESC LIMIT 1
SELECT course_id, course_name FROM Courses WHERE course_id IN ( SELECT course_id FROM Sections GROUP BY course_id HAVING COUNT(*) <= 2 )
SELECT semester_name, semester_id FROM Student_Enrolment JOIN Semesters ON Student_Enrolment.semester_id = Semesters.semester_id GROUP BY semester_name ORDER BY count(*) DESC LIMIT 1
SELECT department_description FROM Departments WHERE department_name LIKE '%the computer%'
SELECT DISTINCT S.first_name, S.middle_name, S.last_name, SE.student_id FROM Student_Enrolment SE JOIN Students S ON SE.student_id = S.student_id WHERE SE.degree_program_id IN ( SELECT SE2.degree_program_id FROM Student_Enrolment SE2 WHERE SE2.student_id = SE.student_id GROUP BY SE2.semester_id HAVING COUNT(DISTINCT SE2.degree_program_id) = 2 ) GROUP BY SE.student_id
SELECT degree_program_id, degree_summary_name FROM Degree_Programs WHERE degree_program_id = (SELECT degree_program_id FROM Student_Enrolment GROUP BY degree_program_id ORDER BY COUNT(*) DESC LIMIT 1)
SELECT semester_name FROM Semesters WHERE semester_id NOT IN (SELECT semester_id FROM Student_Enrolment)
SELECT course_name FROM Courses WHERE course_id IN (SELECT course_id FROM Student_Enrolment_Courses)
SELECT T1.transcript_date, T1.transcript_id FROM transcripts AS T1 JOIN transcript_contents AS T2 ON T1.transcript_id = T2.transcript_id GROUP BY T1.transcript_id ORDER BY COUNT(*) ASC LIMIT 1
SELECT semester_id FROM student_enrolment WHERE student_id IN ( SELECT student_id FROM students WHERE degree_program_id IN ( SELECT degree_program_id FROM degree_programs WHERE degree_summary_name IN ('Masters', 'Bachelors') ) )
SELECT DISTINCT address_id FROM Students JOIN Addresses ON Students.permanent_address_id = Addresses.address_id OR Students.current_address_id = Addresses.address_id
SELECT DISTINCT other_student_details FROM Students ORDER BY last_name DESC, first_name DESC
SELECT section_description FROM Sections WHERE section_name = 'h'
SELECT title FROM Cartoon ORDER BY title
SELECT COUNT(*) FROM Cartoon WHERE Written_by = 'Joseph Kuhr'
SELECT Country, COUNT(*) AS num_channels FROM TV_Channel GROUP BY Country ORDER BY num_channels DESC LIMIT 1
SELECT Country, COUNT(id) as channel_count FROM TV_Channel GROUP BY Country ORDER BY channel_count DESC LIMIT 1
SELECT COUNT(DISTINCT series_name) , COUNT(DISTINCT Content) FROM TV_Channel
SELECT Package_Option FROM TV_Channel WHERE series_name = 'Sky Radio'
SELECT Package_Option FROM TV_Channel WHERE series_name = 'Sky Radio'
SELECT Episode FROM TV_series ORDER BY Rating DESC
SELECT Weekly_Rank FROM TV_series WHERE Episode = 'A Love of a Lifetime'
SELECT production_code, channel FROM cartoon ORDER BY original_air_date DESC LIMIT 1
SELECT DISTINCT T1.Package_Option, T2.series_name FROM TV_Channel AS T1 JOIN TV_series AS T2 ON T1.id = T2.Channel WHERE T1.Hight_definition_TV = 'High Definition TV'
SELECT country FROM TV_channel WHERE id NOT IN ( SELECT channel FROM cartoon WHERE Written_by = 'Todd Casey' )
SELECT id FROM TV_Channel WHERE Country IN ( SELECT Country FROM TV_Channel GROUP BY Country HAVING COUNT(id) > 2 )
SELECT COUNT(Poker_Player_ID) FROM poker_player
SELECT AVG(Earnings) FROM poker_player
SELECT DISTINCT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID WHERE T2.Earnings > 300000
SELECT T2.Name FROM poker_player AS T1 JOIN people AS T2 ON T1.People_ID = T2.People_ID ORDER BY T1.Final_Table_Made ASC
SELECT T2.Birth_Date FROM poker_player AS T1 JOIN people AS T2 ON T1.People_ID = T2.People_ID ORDER BY T1.Earnings ASC LIMIT 1
SELECT Money_Rank FROM poker_player WHERE People_ID = (SELECT People_ID FROM people ORDER BY Height DESC LIMIT 1)
SELECT T2.Name FROM poker_player AS T1 JOIN people AS T2 ON T1.People_ID = T2.People_ID ORDER BY T1.Earnings DESC
SELECT Nationality FROM people GROUP BY Nationality ORDER BY count(*) DESC LIMIT 1
SELECT Nationality FROM people GROUP BY Nationality HAVING COUNT(*) >= 2
SELECT COUNT(DISTINCT state) FROM AREA_CODE_STATE
SELECT max(created) FROM VOTES WHERE state = 'CA'
SELECT COUNT(Code) FROM country WHERE GovernmentForm = 'Republic'
SELECT sum(SurfaceArea) FROM country WHERE Region = 'Caribbean'
SELECT DISTINCT T1.Continent FROM country AS T1 JOIN city AS T3 ON T1.Code = T3.CountryCode WHERE T3.Name = 'Anguilla'
SELECT AVG(LifeExpectancy) FROM country WHERE Region = 'Central Africa'
SELECT name FROM country WHERE continent = 'Asia' ORDER BY life_expectancy ASC LIMIT 1
SELECT sum(Population) , max(GNP) FROM country WHERE Continent = 'Asia'
SELECT COUNT(DISTINCT Language) AS distinct_languages FROM countrylanguage
SELECT COUNT(DISTINCT GovernmentForm) FROM country WHERE Continent = 'Africa'
SELECT T1.Language FROM countrylanguage AS T1 JOIN country AS T2 ON T1.CountryCode = T2.Code WHERE T2.GovernmentForm = 'republic' GROUP BY T1.Language HAVING COUNT(DISTINCT T2.Code) = 1
SELECT Official FROM countrylanguage WHERE CountryCode = (SELECT Code FROM country WHERE HeadOfState = 'Beatrix') AND IsOfficial = 'T'
SELECT COUNT(DISTINCT countrylanguage.Language) FROM countrylanguage JOIN country ON countrylanguage.CountryCode = country.Code WHERE country.IndepYear < 1930 AND countrylanguage.IsOfficial = 'T'
SELECT max(Population) FROM country WHERE Continent = 'Africa'
SELECT CountryCode FROM countrylanguage WHERE Language != 'English'
SELECT DISTINCT T1.Name FROM city AS T1 JOIN country AS T2 ON T1.CountryCode = T2.Code JOIN countrylanguage AS T3 ON T2.Code = T3.CountryCode WHERE T2.Continent = 'Asia' AND T3.Language = 'Chinese' AND T3.IsOfficial = 'T'
SELECT Name, IndepYear, SurfaceArea FROM country ORDER BY Population ASC LIMIT 1
SELECT Name, Population, HeadOfState FROM country ORDER BY SurfaceArea DESC LIMIT 1
SELECT district, COUNT(*) AS num_cities FROM city WHERE population > (SELECT AVG(population) FROM city) GROUP BY district
SELECT district, COUNT(*) AS num_cities_above_average FROM city WHERE population > (SELECT AVG(population) FROM city) GROUP BY district
SELECT c.GovernmentForm, SUM(ci.Population) AS TotalPopulation FROM country c JOIN countrylanguage cl ON c.Code = cl.CountryCode JOIN city ci ON c.Code = ci.CountryCode WHERE c.LifeExpectancy > 72 GROUP BY c.GovernmentForm
SELECT Name, Area FROM country ORDER BY Area DESC LIMIT 5
SELECT Name FROM country ORDER BY Population ASC LIMIT 3
SELECT country.Code FROM countrylanguage JOIN country ON countrylanguage.CountryCode = country.Code WHERE countrylanguage.Language = 'Spanish' AND countrylanguage.IsOfficial = 1 AND countrylanguage.Percentage > 50
SELECT COUNT(*) FROM conductor
SELECT Name FROM conductor ORDER BY Age ASC
SELECT Record_Company FROM orchestra ORDER BY Year_of_Founded DESC
SELECT max(Share) , min(Share) FROM performance WHERE TYPE != 'Live final'
SELECT name FROM conductor ORDER BY year_of_work DESC LIMIT 1
SELECT DISTINCT T1.Name FROM conductor AS T1 JOIN performance AS T2 ON T1.Conductor_ID = T2.Conductor_ID JOIN orchestra AS T3 ON T2.Orchestra_ID = T3.Orchestra_ID WHERE T3.Year_of_Founded > 2008
SELECT Record_Company, COUNT(*) AS Number_of_Orchestras FROM orchestra GROUP BY Record_Company
SELECT record_company FROM orchestra GROUP BY record_company ORDER BY COUNT(*) DESC LIMIT 1
SELECT orchestra FROM orchestra WHERE orchestra_id NOT IN (SELECT orchestra_id FROM performance)
SELECT T1.year_of_founded FROM orchestra AS T1 JOIN performance AS T2 ON T1.orchestra_id = T2.orchestra_id GROUP BY T1.year_of_founded HAVING COUNT(*) > 1
SELECT grade FROM Highschooler WHERE name = 'Kyle'
SELECT ID FROM Highschooler WHERE name = 'Kyle'
SELECT ID FROM Highschooler WHERE name = 'Kyle'
SELECT grade, COUNT(*) FROM Highschooler GROUP BY grade
SELECT grade, COUNT(*) AS high_schooler_count FROM Highschooler GROUP BY grade ORDER BY high_schooler_count DESC LIMIT 1
SELECT T1.name FROM highschooler AS T1 JOIN friend AS T2 ON T1.id = T2.student_id GROUP BY T1.id ORDER BY COUNT(*) DESC LIMIT 1
SELECT count(*) FROM friend WHERE student_id = (SELECT id FROM highschooler WHERE name = 'Kyle')
SELECT student_id FROM Friend INTERSECT SELECT student_id FROM Likes
SELECT T1.name FROM Highschooler AS T1 JOIN Friend AS T2 ON T1.ID = T2.student_id JOIN Likes AS T3 ON T1.ID = T3.student_id GROUP BY T1.name
SELECT MIN(grade) FROM Highschooler WHERE ID NOT IN (SELECT student_id FROM Friend)
SELECT DISTINCT state FROM Owners WHERE state IN ( SELECT DISTINCT state FROM Professionals )
SELECT AVG(age) FROM Dogs WHERE dog_id IN (SELECT dog_id FROM Treatments)
SELECT AVG(age) FROM Dogs WHERE dog_id IN (SELECT dog_id FROM Treatments)
SELECT D.name FROM Dogs D JOIN Owners O ON D.owner_id = O.owner_id JOIN Treatments T ON D.dog_id = T.dog_id GROUP BY D.name HAVING SUM(T.cost_of_treatment) <= 1000
SELECT professional_id, role_code, email_address FROM professionals WHERE professional_id NOT IN (SELECT professional_id FROM treatments)
SELECT professional_id, cell_number FROM Professionals WHERE professional_id IN ( SELECT professional_id FROM Treatments GROUP BY professional_id HAVING COUNT(DISTINCT treatment_type_code) >= 2 )
SELECT DISTINCT Professionals.first_name, Professionals.last_name FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id WHERE Treatments.cost_of_treatment < (SELECT AVG(cost_of_treatment) FROM Treatments)
SELECT Treatments.date_of_treatment, Professionals.first_name FROM Treatments JOIN Professionals ON Treatments.professional_id = Professionals.professional_id
SELECT Treatment_Types.treatment_type_description, Treatments.charge_amount FROM Treatment_Types JOIN Treatments ON Treatment_Types.treatment_type_code = Treatments.treatment_type_code
SELECT count(DISTINCT dog_id) FROM treatments
SELECT count(DISTINCT professional_id) FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id
SELECT first_name, last_name, email_address FROM owners WHERE state LIKE '%North%'
SELECT COUNT(*) FROM dogs WHERE dog_id NOT IN (SELECT dog_id FROM treatments)
SELECT COUNT(*) FROM professionals WHERE professional_id NOT IN (SELECT professional_id FROM treatments)
SELECT AVG(age) FROM Dogs
SELECT max(age) FROM Dogs
SELECT email_address, cell_number, home_phone FROM Professionals
SELECT Name FROM singer ORDER BY Net_Worth_Millions ASC
SELECT Birth_Year, Citizenship FROM singer
SELECT Name FROM singer WHERE Citizenship != 'France'
SELECT Name FROM singer ORDER BY Net_Worth_Millions DESC LIMIT 1
SELECT song.Title, singer.Name FROM song JOIN singer ON song.Singer_ID = singer.Singer_ID
SELECT singer.Name, SUM(song.Sales) AS Total_Sales FROM singer JOIN song ON singer.Singer_ID = song.Singer_ID GROUP BY singer.Name
SELECT DISTINCT P.property_name FROM Properties AS P JOIN Ref_Property_Types AS RPT ON P.property_type_code = RPT.property_type_code WHERE (RPT.property_type_name = 'house' OR RPT.property_type_name = 'apartment') AND P.room_count > 1
