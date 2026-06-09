SELECT count(*) FROM singer
SELECT T1.Name , count(*) FROM stadium AS T1 JOIN concert AS T2 ON T1.Stadium_ID = T2.Stadium_ID GROUP BY T1.Stadium_ID
SELECT T1.Name, T1.Capacity FROM stadium AS T1 JOIN concert AS T2 ON T1.Stadium_ID = T2.Stadium_ID WHERE T2.Year >= 2014 GROUP BY T1.Stadium_ID ORDER BY COUNT(T2.concert_ID) DESC LIMIT 1
SELECT YEAR FROM concert GROUP BY YEAR ORDER BY count(*) DESC LIMIT 1
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT COUNT(*) FROM concert WHERE Stadium_ID = (SELECT Stadium_ID FROM stadium ORDER BY Capacity DESC LIMIT 1)
SELECT count(DISTINCT T2.PetID) FROM student AS T1 JOIN has_pet AS T2 ON T1.StuID = T2.StuID JOIN pets AS T3 ON T2.PetID = T3.PetID WHERE T1.age > 20
SELECT count(DISTINCT PetType) FROM Pets
SELECT count(DISTINCT pettype) FROM pets
SELECT DISTINCT T1.Fname FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID = T2.StuID JOIN Pets AS T3 ON T2.PetID = T3.PetID WHERE T3.PetType IN ('cat', 'dog')
SELECT T1.StuID FROM Has_Pet AS T1 JOIN Pets AS T2 ON T1.PetID = T2.PetID WHERE T2.PetType = 'cat'
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT avg(pet_age) , max(pet_age) , PetType FROM Pets GROUP BY PetType
SELECT PetType , AVG(weight) FROM Pets GROUP BY PetType
SELECT T3.PetID FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID = T2.StuID JOIN Pets AS T3 ON T2.PetID = T3.PetID WHERE T1.LName = 'Smith'
SELECT count(DISTINCT continent) FROM continents
SELECT count(*) FROM countries
SELECT AVG(Weight) FROM cars_data
SELECT C2.Continent, COUNT(DISTINCT C1.Maker) AS MakerCount FROM car_makers AS C1 JOIN countries AS C2 ON C1.Country = C2.CountryId JOIN continents AS C3 ON C2.Continent = C3.ContId GROUP BY C2.Continent
SELECT COUNT(model_list.Model) AS num_models, car_makers.Maker, car_makers.Id, car_makers.FullName FROM car_makers JOIN model_list ON car_makers.Id = model_list.Maker GROUP BY car_makers.Id
SELECT Model FROM cars_data JOIN car_names ON cars_data.Id = car_names.MakeId ORDER BY MPG DESC LIMIT 1
SELECT Model, COUNT(*) AS ModelCount FROM car_names GROUP BY Model ORDER BY ModelCount DESC LIMIT 1
SELECT count(*) FROM cars_data WHERE YEAR = 1980
SELECT Maker, Id FROM model_list GROUP BY Maker, Id HAVING COUNT(*) <= 3
SELECT DISTINCT Model FROM car_names JOIN car_makers ON car_names.MakeId = car_makers.Id WHERE car_makers.Maker = 'General Motors' UNION SELECT DISTINCT Model FROM car_names JOIN cars_data ON car_names.MakeId = cars_data.Id WHERE cars_data.Weight > 3500
SELECT Year FROM cars_data WHERE Weight BETWEEN 3000 AND 4000
SELECT DISTINCT Year FROM cars_data WHERE Weight < 4000 OR Weight > 3000
SELECT Horsepower FROM cars_data ORDER BY accelerate DESC LIMIT 1
SELECT T4.Cylinders FROM car_names AS T1 JOIN model_list AS T2 ON T1.Model = T2.Model JOIN car_makers AS T3 ON T2.Maker = T3.Id JOIN cars_data AS T4 ON T1.MakeId = T4.Id WHERE T1.Model = 'volvo' ORDER BY T4.Accelerate ASC LIMIT 1
SELECT count(*) FROM cars_data WHERE Cylinders > 6
SELECT T1.CountryId, T1.CountryName FROM countries AS T1 JOIN car_makers AS T2 ON T1.CountryId = T2.Country GROUP BY T1.CountryId, T1.CountryName HAVING COUNT(T2.Maker) > 3 UNION SELECT T1.CountryId, T1.CountryName FROM countries AS T1 JOIN car_names AS T2 ON T1.CountryId = T2.Model JOIN model_list AS T3 ON T2.Model = T3.Model WHERE T3.Maker = 'Fiat' GROUP BY T1.CountryId, T1.CountryName
SELECT Country FROM airlines WHERE Airline = 'JetBlue Airways'
SELECT Abbreviation FROM Airlines WHERE Airline = 'JetBlue Airways'
SELECT count(*) FROM airlines
SELECT count(*) FROM flights
SELECT count(*) FROM airlines WHERE Country = 'USA'
SELECT City, Country FROM airports WHERE AirportName = 'Alton airport'
SELECT AirportName FROM airports WHERE AirportCode = 'AKO'
SELECT COUNT(*) FROM flights AS T1 JOIN airports AS T2 ON T1.DestAirport = T2.AirportCode WHERE T2.City = 'Aberdeen'
SELECT COUNT(*) FROM flights JOIN airports AS source_airport ON flights.SourceAirport = source_airport.AirportCode JOIN airports AS dest_airport ON flights.DestAirport = dest_airport.AirportCode WHERE source_airport.City = 'Aberdeen' AND dest_airport.City = 'Ashley'
SELECT T2.City, COUNT(*) as Frequency FROM flights AS T1 JOIN airports AS T2 ON T1.DestAirport = T2.AirportCode GROUP BY T2.City ORDER BY Frequency DESC LIMIT 1
SELECT DestAirport FROM flights GROUP BY DestAirport ORDER BY count(*) DESC LIMIT 1
SELECT T1.Abbreviation, T1.Country FROM airlines AS T1 JOIN flights AS T2 ON T1.Airline = T2.Airline GROUP BY T1.Airline ORDER BY COUNT(*) ASC LIMIT 1
SELECT T1.Airline, COUNT(T1.FlightNo) AS FlightCount FROM Airlines AS T1 JOIN Flights AS T2 ON T1.uid = T2.Airline GROUP BY T1.Airline
SELECT T1.FlightNo FROM flights AS T1 JOIN airports AS T2 ON T1.DestAirport = T2.AirportCode WHERE T2.AirportName = 'APG'
SELECT T2.FlightNo FROM airports AS T1 JOIN flights AS T2 ON T2.DestAirport = T1.AirportCode WHERE T1.City = 'Aberdeen'
SELECT COUNT(flights.FlightNo) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City IN ('Aberdeen', 'Abilene')
SELECT count(*) FROM flights AS T1 JOIN airports AS T2 ON T1.DestAirport = T2.AirportCode WHERE T2.City = 'Aberdeen' OR T2.City = 'Abilene'
SELECT Name FROM employee ORDER BY Age ASC
SELECT count(*) , City FROM employee GROUP BY City
SELECT count(*) , LOCATION FROM shop GROUP BY LOCATION
SELECT min(Number_products), max(Number_products) FROM shop
SELECT min(Number_products), max(Number_products) FROM shop
SELECT Name, Location, District FROM shop ORDER BY Number_products DESC
SELECT sum(Bonus) FROM evaluation
SELECT sum(Bonus) FROM evaluation
SELECT * FROM hiring
SELECT COUNT(*) FROM Documents
SELECT Document_Name, Template_ID FROM Documents WHERE Document_Description LIKE '%w%'
SELECT Document_ID, Template_ID, Document_Description FROM Documents WHERE Document_Name = 'Robbin CV'
SELECT template_id, COUNT(document_id) AS document_count FROM Documents GROUP BY template_id
SELECT template_id FROM Documents GROUP BY template_id HAVING COUNT(*) > 1
SELECT DISTINCT Template_Type_Code FROM Templates
SELECT DISTINCT Template_Type_Code FROM Templates
SELECT Template_ID FROM Templates WHERE Template_Type_Code = 'PP' OR Template_Type_Code = 'PPT'
SELECT Template_ID FROM Templates WHERE Template_Type_Code = 'PP' OR Template_Type_Code = 'PPT'
SELECT Version_Number, Template_Type_Code FROM Templates WHERE Version_Number > 5
SELECT Version_Number, Template_Type_Code FROM Templates WHERE Version_Number > 5
SELECT T2.Template_Type_Code , count(T1.Template_ID) FROM Templates AS T1 JOIN Ref_Template_Types AS T2 ON T1.Template_Type_Code = T2.Template_Type_Code GROUP BY T2.Template_Type_Code
SELECT T2.Template_Type_Code FROM Templates AS T1 JOIN Ref_Template_Types AS T2 ON T1.Template_Type_Code = T2.Template_Type_Code GROUP BY T2.Template_Type_Code ORDER BY COUNT(T1.Template_ID) DESC LIMIT 1
SELECT Ref_Template_Types.Template_Type_Code, COUNT(Templates.Template_ID) AS template_count FROM Templates JOIN Ref_Template_Types ON Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code GROUP BY Ref_Template_Types.Template_Type_Code HAVING COUNT(Templates.Template_ID) < 3
SELECT T1.Template_Type_Code FROM Templates AS T1 JOIN Documents AS T2 ON T1.Template_ID = T2.Template_ID WHERE T2.Document_Name = 'Data base'
SELECT Template_Type_Code, Template_Type_Description FROM Ref_Template_Types
SELECT Paragraphs.Paragraph_Text FROM Documents JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID WHERE Documents.Document_Name = 'Customer reviews'
SELECT count(*) FROM teaches
SELECT COUNT(Teacher_ID) FROM teacher
SELECT Name FROM teacher ORDER BY Age ASC
SELECT Age, Hometown FROM teacher
SELECT Name FROM teacher WHERE Hometown != 'Little Lever Urban District'
SELECT Hometown FROM teacher GROUP BY Hometown ORDER BY COUNT(*) DESC LIMIT 1
SELECT Hometown FROM teacher GROUP BY Hometown HAVING COUNT(*) >= 2
SELECT T1.Name FROM teacher AS T1 JOIN course_arrange AS T2 ON T1.Teacher_ID = T2.Teacher_ID JOIN course AS T3 ON T2.Course_ID = T3.Course_ID WHERE T3.Course = 'Math'
SELECT Name, Level_of_membership, Age FROM visitor WHERE Level_of_membership > 4 ORDER BY Age DESC
SELECT AVG(Num_of_Staff) FROM museum WHERE Open_Year < 2009
SELECT T1.Museum_ID, T1.Name FROM museum AS T1 JOIN visit AS T2 ON T1.Museum_ID = T2.Museum_ID GROUP BY T1.Museum_ID ORDER BY COUNT(T2.visitor_ID) DESC LIMIT 1
SELECT sum(T2.Total_spent) FROM visitor AS T1 JOIN visit AS T2 ON T1.ID = T2.visitor_ID WHERE T1.Level_of_membership = 1
SELECT count(*) FROM players
SELECT first_name, birth_date FROM players WHERE country_code = 'USA'
SELECT COUNT(DISTINCT loser_name) FROM matches
SELECT COUNT(DISTINCT loser_name) FROM matches
SELECT players.first_name, players.last_name FROM players JOIN matches ON players.player_id = matches.winner_id WHERE YEAR(matches.tourney_date) = 2013 INTERSECT SELECT players.first_name, players.last_name FROM players JOIN matches ON players.player_id = matches.winner_id WHERE YEAR(matches.tourney_date) = 2016
SELECT first_name, country_code FROM players ORDER BY birth_date ASC LIMIT 1
SELECT avg(T1.ranking) , T2.first_name, T2.last_name FROM rankings AS T1 JOIN players AS T2 ON T1.player_id = T2.player_id GROUP BY T2.player_id
SELECT T2.first_name, SUM(T1.ranking_points) FROM rankings AS T1 JOIN players AS T2 ON T1.player_id = T2.player_id GROUP BY T2.player_id
SELECT p.first_name, p.country_code, p.birth_date, SUM(r.rank_points) AS total_rank_points FROM players AS p JOIN matches AS m ON p.player_id = m.winner_id JOIN rankings AS r ON p.player_id = r.player_id GROUP BY p.player_id ORDER BY total_rank_points DESC LIMIT 1
SELECT AVG(injured) FROM death
SELECT COUNT(*) FROM Courses
SELECT department.department_name, department.department_id, COUNT(degree_program.degree_program_id) AS degree_count FROM departments AS department JOIN degree_programs AS degree_program ON department.department_id = degree_program.department_id GROUP BY department.department_id ORDER BY degree_count DESC LIMIT 1
SELECT T1.course_name, T1.course_id FROM Courses AS T1 JOIN Sections AS T2 ON T1.course_id = T2.course_id GROUP BY T1.course_id HAVING COUNT(T2.section_id) > 2
SELECT T2.semester_name, T2.semester_id FROM Students AS T1 JOIN Student_Enrolment AS T2 ON T1.student_id = T2.student_id JOIN Semesters AS T3 ON T2.semester_id = T3.semester_id GROUP BY T2.semester_id ORDER BY COUNT(*) DESC LIMIT 1
SELECT department_description FROM Departments WHERE department_name LIKE '%the computer%'
SELECT s.student_id, s.first_name, s.middle_name, s.last_name FROM Students s JOIN Student_Enrolment se ON s.student_id = se.student_id GROUP BY s.student_id, s.first_name, s.middle_name, s.last_name HAVING COUNT(DISTINCT se.degree_program_id) = 2
SELECT T2.degree_program_id, T2.degree_summary_name, COUNT(T1.student_id) AS student_count FROM Student_Enrolment AS T1 JOIN Degree_Programs AS T2 ON T1.degree_program_id = T2.degree_program_id GROUP BY T2.degree_program_id ORDER BY student_count DESC LIMIT 1
SELECT semester_name FROM Semesters
SELECT DISTINCT Courses.course_name FROM Courses JOIN Student_Enrolment_Courses ON Courses.course_id = Student_Enrolment_Courses.course_id
SELECT T2.transcript_date, T2.transcript_id FROM Transcript_Contents AS T1 JOIN Transcripts AS T2 ON T1.transcript_id = T2.transcript_id GROUP BY T2.transcript_id ORDER BY COUNT(T1.student_course_id) ASC LIMIT 1
SELECT semester_id FROM Student_Enrolment WHERE degree_program_id IN ( SELECT degree_program_id FROM Degree_Programs WHERE degree_summary_name IN ('Masters', 'Bachelors') ) GROUP BY semester_id HAVING COUNT(DISTINCT degree_program_id) = 2
SELECT DISTINCT Addresses.address_id, Addresses.line_1, Addresses.line_2, Addresses.line_3, Addresses.city, Addresses.zip_postcode, Addresses.state_province_county, Addresses.country, Addresses.other_address_details FROM Students JOIN Addresses ON Students.current_address_id = Addresses.address_id UNION SELECT DISTINCT Addresses.address_id, Addresses.line_1, Addresses.line_2, Addresses.line_3, Addresses.city, Addresses.zip_postcode, Addresses.state_province_county, Addresses.country, Addresses.other_address_details FROM Students JOIN Addresses ON Students.permanent_address_id = Addresses.address_id
SELECT other_student_details FROM Students ORDER BY last_name DESC
SELECT section_description FROM Sections WHERE section_name = 'h'
SELECT title FROM cartoon ORDER BY title
SELECT COUNT(*) FROM Cartoon WHERE written_by = 'Joseph Kuhr'
SELECT Country, COUNT(id) AS channel_count FROM TV_Channel GROUP BY Country
SELECT Country, COUNT(*) AS NumberOfChannels FROM TV_Channel GROUP BY Country ORDER BY NumberOfChannels DESC LIMIT 1
SELECT count(DISTINCT series_name) , count(DISTINCT content) FROM TV_Channel
SELECT Package_Option FROM TV_Channel WHERE series_name = 'Sky Radio'
SELECT Package_Option FROM TV_Channel WHERE id = (SELECT Channel FROM TV_series WHERE series_name = 'Sky Radio')
SELECT Episode FROM TV_series ORDER BY Rating
SELECT Weekly_Rank FROM TV_series WHERE Episode = 'A Love of a Lifetime'
SELECT Production_code, TV_Channel.id FROM Cartoon JOIN TV_Channel ON Cartoon.Channel = TV_Channel.id ORDER BY Cartoon.Original_air_date DESC LIMIT 1
SELECT T1.series_name, T1.Package_Option FROM TV_Channel AS T1 JOIN TV_series AS T2 ON T1.id = T2.Channel WHERE T1.Hight_definition_TV = True
select all distinct countries from the `TV_Channel` table and exclude those countries that have cartoons written by Todd Casey. Here's the corrected SQL query:
SELECT id FROM TV_Channel GROUP BY country HAVING COUNT(*) > 2
SELECT COUNT (Poker_Player_ID) FROM poker_player
SELECT AVG(Earnings) FROM poker_player
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID WHERE T2.Earnings > 300000
SELECT T1.Name, T1.Final_Table_Made FROM poker_player AS T1 JOIN people AS T2 ON T1.People_ID = T2.People_ID ORDER BY T1.Final_Table_Made ASC
SELECT T1.Birth_Date FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID ORDER BY T2.Earnings ASC LIMIT 1
SELECT T1.Money_Rank FROM poker_player AS T1 JOIN people AS T2 ON T1.People_ID = T2.People_ID WHERE T2.Height = (SELECT max(Height) FROM people)
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID ORDER BY T2.Earnings DESC
SELECT Nationality FROM people GROUP BY Nationality ORDER BY COUNT(*) DESC LIMIT 1
SELECT Nationality FROM people GROUP BY Nationality HAVING COUNT(*) >= 2
SELECT count(DISTINCT state) FROM AREA_CODE_STATE
SELECT MAX(VOTES.created) FROM VOTES JOIN AREA_CODE_STATE ON VOTES.state = AREA_CODE_STATE.state WHERE AREA_CODE_STATE.state = 'CA'
SELECT count(*) FROM country WHERE GovernmentForm = 'Republic'
SELECT sum(SurfaceArea) FROM country WHERE Region = 'Caribbean'
SELECT T1.continent FROM country AS T1 JOIN city AS T2 ON T1.Code = T2.CountryCode WHERE T2.Name = 'Anguilla'
SELECT AVG(LifeExpectancy) FROM country WHERE Region = 'Central Africa'
SELECT Name, MIN(LifeExpectancy) AS LifeExpectancy FROM country WHERE Continent = 'Asia'
SELECT SUM(Population) AS total_population, MAX(GNP) AS max_gnp FROM country WHERE Continent = 'Asia'
SELECT count(DISTINCT Language) FROM countrylanguage
SELECT COUNT(DISTINCT T1.GovernmentForm) FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T1.Continent = 'Africa'
SELECT T1.Language FROM countrylanguage AS T1 JOIN country AS T2 ON T1.CountryCode = T2.Code WHERE T2.GovernmentForm = 'republic'
SELECT Code FROM country WHERE HeadOfState = 'Beatrix'
SELECT count(DISTINCT T2.Language) FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T2.IsOfficial = 'T' AND T1.IndepYear < 1930
SELECT name FROM country WHERE continent = 'Asia' AND population > (SELECT MAX(population) FROM country WHERE continent = 'Africa')
SELECT CountryCode FROM countrylanguage WHERE Language = 'English'
SELECT DISTINCT T1.Name FROM city AS T1 JOIN country AS T2 ON T1.CountryCode = T2.Code JOIN countrylanguage AS T3 ON T2.Code = T3.CountryCode WHERE T3.Language = 'Chinese' AND T2.Region = 'Asia'
SELECT Name, IndepYear, SurfaceArea FROM country ORDER BY Population ASC LIMIT 1
SELECT Name, Population, HeadOfState FROM country ORDER BY Area DESC LIMIT 1
SELECT AVG(Population) FROM city
SELECT District, COUNT(*) AS num_cities FROM city WHERE Population > (SELECT AVG(Population) FROM city) GROUP BY District
SELECT GovernmentForm, AVG(LifeExpectancy) AS AverageLifeExpectancy FROM country GROUP BY GovernmentForm
SELECT Name, SurfaceArea FROM country ORDER BY SurfaceArea DESC LIMIT 5
SELECT Name FROM country ORDER BY Population ASC LIMIT 3
SELECT countrylanguage.CountryCode FROM countrylanguage WHERE countrylanguage.Language = 'Spanish' AND countrylanguage.Percentage = ( SELECT MAX(Percentage) FROM countrylanguage WHERE Language = 'Spanish' )
SELECT count(*) FROM conductor
SELECT Name FROM conductor ORDER BY Age ASC
SELECT Record_Company FROM orchestra ORDER BY Year_of_Founded DESC
SELECT max(Share), min(Share) FROM performance WHERE TYPE != 'Live final'
SELECT Name FROM conductor ORDER BY Year_of_Work DESC LIMIT 1
SELECT conductor.Name FROM conductor JOIN orchestra ON conductor.Conductor_ID = orchestra.Conductor_ID WHERE orchestra.Year_of_Founded > 2008
SELECT Record_Company, COUNT(Orchestra_ID) FROM orchestra GROUP BY Record_Company
SELECT Record_Company FROM orchestra GROUP BY Record_Company ORDER BY COUNT(*) DESC LIMIT 1
SELECT orchestra FROM performance AS T1 JOIN orchestra AS T2 ON T1.orchestra_id = T2.orchestra_id
SELECT T1.Year_of_Founded FROM orchestra AS T1 JOIN performance AS T2 ON T1.Orchestra_ID = T2.Orchestra_ID GROUP BY T1.Year_of_Founded HAVING COUNT(*) = 1
SELECT grade FROM Highschooler WHERE name = 'Kyle'
SELECT ID FROM Highschooler WHERE name = 'Kyle'
SELECT ID FROM Highschooler WHERE name = 'Kyle'
SELECT grade, COUNT(*) FROM Highschooler GROUP BY grade
SELECT grade FROM Highschooler GROUP BY grade ORDER BY count(*) DESC LIMIT 1
SELECT H1.name, COUNT(F1.friend_id) AS friend_count FROM Highschooler AS H1 JOIN Friend AS F1 ON H1.ID = F1.student_id GROUP BY H1.ID ORDER BY friend_count DESC LIMIT 1
SELECT COUNT(DISTINCT T2.friend_id) FROM Highschooler AS T1 JOIN Friend AS T2 ON T1.ID = T2.student_id WHERE T1.name = 'Kyle'
SELECT student_id FROM Friend JOIN Likes ON Friend.student_id = Likes.student_id
SELECT DISTINCT h1.name FROM Highschooler AS h1 JOIN Friend AS f ON h1.ID = f.student_id JOIN Likes AS l ON h1.ID = l.student_id
SELECT student_id FROM Friend
SELECT state FROM Owners INTERSECT SELECT state FROM Professionals
SELECT AVG(Dogs.age) FROM Dogs JOIN Treatments ON Dogs.dog_id = Treatments.dog_id
SELECT AVG(Dogs.age) FROM Dogs JOIN Treatments ON Dogs.dog_id = Treatments.dog_id
SELECT D.name FROM Dogs AS D WHERE D.owner_id NOT IN ( SELECT T.dog_id FROM Treatments AS T GROUP BY T.dog_id HAVING SUM(T.cost_of_treatment) > 1000 )
select the professionals from the `Professionals` table and exclude those who appear in the `Treatments` table. This can be achieved using a `LEFT JOIN` and filtering with `WHERE` clause.
SELECT professional_id, treatment_type_code FROM treatments GROUP BY professional_id, treatment_type_code
SELECT AVG(cost_of_treatment) FROM Treatments
SELECT T1.date_of_treatment, T2.first_name FROM Treatments AS T1 JOIN Professionals AS T2 ON T1.professional_id = T2.professional_id
SELECT T1.cost_of_treatment, T2.treatment_type_description FROM Treatments AS T1 JOIN Treatment_Types AS T2 ON T1.treatment_type_code = T2.treatment_type_code
SELECT COUNT(DISTINCT dog_id) AS number_of_dogs_with_treatments FROM Treatments
SELECT count(DISTINCT professionals.professional_id) FROM treatments JOIN professionals ON treatments.professional_id = professionals.professional_id
SELECT first_name, last_name, email_address FROM Owners WHERE state LIKE '%North%'
SELECT COUNT(*) FROM Dogs
select the professionals who do not have any records in the `Treatments` table. This can be achieved by using a `LEFT JOIN` between the `Professionals` table and the `Treatments` table, and then filtering out the professionals who have no corresponding records in the `Treatments` table.
SELECT AVG(age) AS average_age FROM dogs
SELECT MAX(age) AS oldest_dog_age FROM Dogs
SELECT email_address , cell_number , home_phone FROM Professionals
SELECT Name FROM singer ORDER BY Net_Worth_Millions
SELECT Birth_Year, Citizenship FROM singer
SELECT Name FROM singer WHERE Citizenship != 'France'
SELECT Name FROM singer ORDER BY Net_Worth_Millions DESC LIMIT 1
SELECT song.Title, singer.Name FROM song JOIN singer ON song.Singer_ID = singer.Singer_ID
SELECT T1.Name, sum(T2.Sales) FROM singer AS T1 JOIN song AS T2 ON T1.Singer_ID = T2.Singer_ID GROUP BY T1.Name
SELECT T1.property_name FROM Properties AS T1 JOIN Ref_Property_Types AS T2 ON T1.property_type_code = T2.property_type_code WHERE (T2.property_type_name = 'house' OR T2.property_type_name = 'apartment') AND T1.room_count > 1
