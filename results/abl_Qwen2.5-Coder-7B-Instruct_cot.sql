SELECT COUNT(*) FROM singer
SELECT stadium.Name, COUNT(concert.concert_ID) AS number_of_concerts FROM stadium JOIN concert ON stadium.Stadium_ID = concert.Stadium_ID GROUP BY stadium.Stadium_ID
SELECT T2.Name, T2.Capacity, COUNT(*) AS concert_count FROM concert AS T1 JOIN stadium AS T2 ON T1.Stadium_ID = T2.Stadium_ID WHERE T1.Year >= 2014 GROUP BY T2.Stadium_ID ORDER BY concert_count DESC LIMIT 1
SELECT YEAR, COUNT(*) AS concert_count FROM concert GROUP BY YEAR ORDER BY concert_count DESC LIMIT 1
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT COUNT(*) FROM concert WHERE Stadium_ID = (SELECT Stadium_ID FROM stadium ORDER BY capacity DESC LIMIT 1)
SELECT COUNT(*) FROM Student WHERE Age > 20
SELECT DISTINCT PetType FROM Pets
SELECT DISTINCT PetType FROM Pets
SELECT DISTINCT T1.Fname FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID = T2.StuID JOIN Pets AS T3 ON T2.PetID = T3.PetID WHERE T3.PetType = 'cat' OR T3.PetType = 'dog'
SELECT StuID FROM Has_Pet WHERE StuID NOT IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat')
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetType, AVG(pet_age) AS avg_age, MAX(pet_age) AS max_age FROM Pets GROUP BY PetType
SELECT PetType, AVG(weight) AS average_weight FROM Pets GROUP BY PetType
SELECT StuID FROM Student WHERE LName = 'Smith'
SELECT COUNT(*) FROM continents
SELECT COUNT(CountryId) FROM countries
SELECT Model FROM car_names WHERE MakeId IN (SELECT Id FROM cars_data WHERE Weight < (SELECT avg(Weight) FROM cars_data))
SELECT c.Continent, COUNT(cm.Maker) AS MakerCount FROM car_makers cm JOIN countries co ON cm.Country = co.CountryId JOIN continents c ON co.Continent = c.ContId GROUP BY c.Continent
SELECT car_makers.Id, car_makers.FullName, COUNT(car_names.Model) AS NumberOfModels FROM car_makers JOIN model_list ON car_makers.Id = model_list.Maker JOIN car_names ON model_list.ModelId = car_names.Model GROUP BY car_makers.Id, car_makers.FullName
SELECT T2.Model FROM cars_data AS T1 JOIN car_names AS T2 ON T1.Id = T2.MakeId ORDER BY T1.MPG DESC LIMIT 1
SELECT model, COUNT(*) AS version_count FROM car_names GROUP BY model ORDER BY version_count DESC LIMIT 1
SELECT COUNT(*) FROM cars_data WHERE Year = 1980
SELECT Maker, Id, COUNT(*) AS model_count FROM car_makers JOIN model_list ON car_makers.Id = model_list.Maker GROUP BY Maker, Id HAVING COUNT(*) > 3
SELECT T1.Model FROM car_names AS T1 JOIN model_list AS T2 ON T1.MakeId = T2.MakeId JOIN car_makers AS T3 ON T2.Maker = T3.Id WHERE T3.Maker = 'General Motors' OR T1.Weight > 3500
SELECT DISTINCT Year FROM cars_data WHERE Weight BETWEEN 3000 AND 4000
SELECT DISTINCT Year FROM cars_data WHERE Weight < 4000 OR Weight > 3000
SELECT Horsepower FROM cars_data ORDER BY Accelerate DESC LIMIT 1
SELECT MIN(Accelerate) FROM cars_data WHERE Id IN (SELECT MakeId FROM car_names WHERE Model = 'volvo')
SELECT COUNT(*) FROM cars_data WHERE Cylinders > 6
SELECT T1.CountryId, T1.CountryName FROM countries AS T1 JOIN car_makers AS T2 ON T1.CountryId = T2.Country GROUP BY T1.CountryId, T1.CountryName HAVING COUNT(T2.Id) > 3 UNION SELECT T1.CountryId, T1.CountryName FROM countries AS T1 JOIN car_names AS T2 ON T1.CountryId = T2.MakeId JOIN model_list AS T3 ON T2.Model = T3.Model WHERE T3.Maker = 'Fiat'
SELECT Country FROM airlines WHERE Airline = 'JetBlue Airways'
SELECT Abbreviation FROM airlines WHERE Airline = 'JetBlue Airways'
SELECT COUNT(*) FROM airlines
SELECT COUNT(*) FROM flights
SELECT COUNT(*) FROM airlines WHERE Country = 'USA'
SELECT City, Country FROM airports WHERE AirportName = 'Alton'
SELECT AirportName FROM airports WHERE AirportCode = 'AKO'
SELECT COUNT(*) FROM flights INNER JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen'
SELECT COUNT(*) FROM flights JOIN airports AS source ON flights.SourceAirport = source.AirportCode JOIN airports AS destination ON flights.DestAirport = destination.AirportCode WHERE source.City = 'Aberdeen' AND destination.City = 'Ashley'
SELECT T1.City FROM airports AS T1 JOIN flights AS T2 ON T1.AirportCode = T2.DestAirport GROUP BY T1.City ORDER BY COUNT(*) DESC LIMIT 1
SELECT DestAirport, COUNT(*) AS flight_count FROM flights GROUP BY DestAirport ORDER BY flight_count DESC LIMIT 1
SELECT T1.Airline, T1.Abbreviation, T1.Country FROM airlines AS T1 JOIN flights AS T2 ON T1.uid = T2.Airline GROUP BY T1.Airline ORDER BY COUNT(*) ASC LIMIT 1
SELECT Airline, COUNT(*) AS FlightCount FROM flights GROUP BY Airline HAVING COUNT(*) >= 10
SELECT FlightNo FROM flights WHERE DestAirport = (SELECT AirportCode FROM airports WHERE AirportName = 'APG')
SELECT FlightNo FROM flights WHERE DestAirport = (SELECT AirportCode FROM airports WHERE City = 'Aberdeen')
SELECT COUNT(*) FROM flights AS T1 JOIN airports AS T2 ON T1.DestAirport = T2.AirportCode WHERE T2.City IN ('Aberdeen', 'Abilene')
SELECT COUNT(*) FROM airports WHERE AirportName IN ('Aberdeen', 'Abilene')
SELECT Name FROM employee ORDER BY Age ASC
SELECT City, COUNT(Employee_ID) AS Number_of_Employees FROM employee GROUP BY City
SELECT Location, COUNT(*) AS Number_of_Shops FROM shop GROUP BY Location
SELECT min(Number_products), max(Number_products) FROM shop
SELECT min(Number_products), max(Number_products) FROM shop
SELECT Name, Location, District FROM shop ORDER BY Number_products DESC
SELECT sum(Bonus) FROM evaluation
SELECT sum(Bonus) FROM evaluation
SELECT * FROM hiring
SELECT COUNT(Documents.Document_ID) FROM Documents
SELECT Document_Name, Template_ID FROM Documents WHERE Document_Description LIKE '%w%'
SELECT Document_ID, Template_ID, Document_Description FROM Documents WHERE Document_Name = 'Robbin CV'
SELECT Templates.Template_ID, Templates.Template_Type_Code, COUNT(Documents.Document_ID) AS Document_Count FROM Templates JOIN Documents ON Templates.Template_ID = Documents.Template_ID GROUP BY Templates.Template_ID, Templates.Template_Type_Code ORDER BY Document_Count DESC LIMIT 1
SELECT Template_ID FROM Documents GROUP BY Template_ID HAVING COUNT(*) > 1
SELECT DISTINCT Template_Type_Code FROM Templates
SELECT DISTINCT Template_Type_Code FROM Templates
SELECT Template_ID FROM Templates WHERE Template_Type_Code IN ('PP', 'PPT')
SELECT Template_ID FROM Templates WHERE Template_Type_Code IN ('PP', 'PPT')
SELECT Version_Number, Template_Type_Code FROM Templates WHERE Version_Number > 5
SELECT Version_Number, Template_Type_Code FROM Templates WHERE Version_Number > 5
SELECT Templates.Template_Type_Code, COUNT(Templates.Template_ID) AS Number_of_Templates FROM Templates JOIN Ref_Template_Types ON Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code GROUP BY Templates.Template_Type_Code
SELECT Template_Type_Code, COUNT(*) AS template_count FROM Templates GROUP BY Template_Type_Code ORDER BY template_count DESC LIMIT 1
SELECT Template_Type_Code, COUNT(*) AS template_count FROM Templates GROUP BY Template_Type_Code HAVING COUNT(*) < 3
SELECT Templates.Template_Type_Code FROM Documents JOIN Templates ON Documents.Template_ID = Templates.Template_ID WHERE Documents.Document_Name = 'Data base'
SELECT Template_Type_Code, Template_Type_Description FROM Ref_Template_Types
SELECT Paragraphs.Paragraph_Text FROM Paragraphs JOIN Documents ON Paragraphs.Document_ID = Documents.Document_ID WHERE Documents.Document_Name = 'Customer reviews'
SELECT COUNT(*) FROM teacher
SELECT COUNT(*) FROM teacher
SELECT Name FROM teacher ORDER BY Age ASC
SELECT Age, Hometown FROM teacher
SELECT Name FROM teacher WHERE Hometown != 'Little Lever Urban District'
SELECT Hometown FROM teacher GROUP BY Hometown ORDER BY COUNT(*) DESC LIMIT 1
SELECT Hometown FROM teacher GROUP BY Hometown HAVING COUNT(*) >= 2
SELECT T1.Name FROM teacher AS T1 JOIN course_arrange AS T2 ON T1.Teacher_ID = T2.Teacher_ID JOIN course AS T3 ON T2.Course_ID = T3.Course_ID WHERE T3.Course = 'Math'
SELECT Name, Level_of_membership FROM visitor WHERE Level_of_membership > 4 ORDER BY Age DESC
SELECT avg(Num_of_Staff) FROM museum WHERE Open_Year < 2009
SELECT Museum_ID, Name FROM museum WHERE Museum_ID = (SELECT Museum_ID FROM visit GROUP BY Museum_ID ORDER BY COUNT(*) DESC LIMIT 1)
SELECT SUM(Total_spent) FROM visit WHERE visitor_ID IN (SELECT ID FROM visitor WHERE Level_of_membership = 1)
SELECT COUNT(*) FROM players
SELECT first_name, birth_date FROM players WHERE country_code = 'USA'
SELECT COUNT(DISTINCT loser_name) FROM matches
SELECT COUNT(DISTINCT loser_name) FROM matches
SELECT winner_id FROM matches WHERE YEAR = 2013
SELECT first_name, country_code FROM players ORDER BY birth_date ASC LIMIT 1
SELECT AVG(rankings.ranking), players.first_name FROM rankings JOIN players ON rankings.player_id = players.player_id GROUP BY players.player_id, players.first_name
SELECT players.first_name, SUM(rankings.ranking_points) AS total_ranking_points FROM players JOIN rankings ON players.player_id = rankings.player_id GROUP BY players.player_id
SELECT T1.first_name, T1.country_code, T1.birth_date FROM players AS T1 JOIN matches AS T2 ON T1.player_id = T2.winner_id GROUP BY T1.player_id ORDER BY SUM(T2.winner_rank_points) DESC LIMIT 1
SELECT AVG(injured) FROM death
SELECT COUNT(course_id) FROM Courses
SELECT department_id, department_name, COUNT(degree_program_id) AS degree_count FROM Degree_Programs JOIN Departments ON Degree_Programs.department_id = Departments.department_id GROUP BY department_id, department_name ORDER BY degree_count DESC LIMIT 1
SELECT T1.course_name, T1.course_id FROM Courses AS T1 JOIN Sections AS T2 ON T1.course_id = T2.course_id GROUP BY T1.course_id HAVING COUNT(*) <= 2
SELECT semester_id, semester_name FROM semesters WHERE semester_id = (SELECT semester_id FROM student_enrolment GROUP BY semester_id ORDER BY COUNT(*) DESC LIMIT 1)
SELECT department_description FROM Departments WHERE department_name LIKE '%the computer%'
SELECT first_name, middle_name, last_name, student_id FROM students JOIN student_enrolment ON students.student_id = student_enrolment.student_id GROUP BY student_id HAVING COUNT(degree_program_id) = 2
SELECT degree_program_id, degree_summary_name AS program_summary FROM Degree_Programs JOIN Student_Enrolment ON Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id GROUP BY degree_program_id ORDER BY student_count DESC LIMIT 1
SELECT semester_name FROM Semesters WHERE semester_id NOT IN (SELECT semester_id FROM Student_Enrolment)
SELECT course_id FROM Student_Enrolment_Courses
SELECT transcript_id, COUNT(*) AS result_count FROM Transcript_Contents GROUP BY transcript_id ORDER BY result_count ASC LIMIT 1
SELECT semester_id FROM Student_Enrolment WHERE degree_program_id IN ( SELECT degree_program_id FROM Degree_Programs WHERE degree_summary_name IN ('Masters', 'Bachelors') ) GROUP BY semester_id HAVING COUNT(DISTINCT degree_program_id) = 2
SELECT DISTINCT address_id, line_1, line_2, line_3, city, zip_postcode, state_province_county, country, other_address_details FROM Addresses WHERE address_id IN (SELECT current_address_id FROM Students) OR address_id IN (SELECT permanent_address_id FROM Students)
SELECT * FROM Students ORDER BY last_name DESC
SELECT section_description FROM Sections WHERE section_name = 'h'
SELECT Title FROM Cartoon ORDER BY Title ASC
SELECT COUNT(*) FROM Cartoon WHERE Written_by = 'Joseph Kuhr'
SELECT Country, COUNT(id) AS Number_of_Channels FROM TV_Channel GROUP BY Country
SELECT Country, COUNT(id) AS Channel_Count FROM TV_Channel GROUP BY Country ORDER BY Channel_Count DESC LIMIT 1
SELECT DISTINCT series_name, content FROM TV_Channel
SELECT Package_Option FROM TV_Channel WHERE series_name = 'Sky Radio'
SELECT Package_Option FROM TV_Channel WHERE series_name = 'Sky Radio'
SELECT Episode FROM TV_series ORDER BY Rating DESC
SELECT Weekly_Rank FROM TV_series WHERE Episode = 'A Love of a Lifetime'
SELECT Cartoon.Production_code, TV_Channel.Channel FROM Cartoon JOIN TV_Channel ON Cartoon.Channel = TV_Channel.id ORDER BY Cartoon.Original_air_date DESC LIMIT 1
SELECT TV_Channel.Package_Option, TV_series.series_name FROM TV_Channel JOIN TV_series ON TV_Channel.id = TV_series.Channel WHERE TV_Channel.Hight_definition_TV = True
SELECT T1.Country FROM TV_Channel AS T1 JOIN Cartoon AS T2 ON T1.id = T2.Channel WHERE T2.Written_by != 'Todd Casey'
SELECT id FROM TV_Channel GROUP BY Country HAVING COUNT(*) > 2
SELECT COUNT(*) FROM poker_player
SELECT avg(Earnings) FROM poker_player
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID WHERE T2.Earnings > 300000
SELECT T1.Name, COUNT(T2.Final_Table_Made) AS Final_Table_Count FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID GROUP BY T1.Name ORDER BY Final_Table_Count ASC
SELECT birth_date FROM poker_player ORDER BY earnings ASC LIMIT 1
SELECT Money_Rank FROM poker_player WHERE People_ID IN (SELECT People_ID FROM people ORDER BY Height DESC LIMIT 1)
SELECT T2.Name FROM poker_player AS T1 JOIN people AS T2 ON T1.People_ID = T2.People_ID ORDER BY T1.Earnings DESC
SELECT Nationality, COUNT(*) AS Count FROM people GROUP BY Nationality ORDER BY Count DESC LIMIT 1
SELECT Nationality FROM people GROUP BY Nationality HAVING COUNT(*) >= 2
SELECT COUNT(DISTINCT state) FROM AREA_CODE_STATE
SELECT created FROM VOTES WHERE state = 'CA' ORDER BY created DESC LIMIT 1
SELECT COUNT(Code) FROM country WHERE GovernmentForm = 'Republic'
SELECT SUM(SurfaceArea) FROM country WHERE Region = 'Caribbean'
SELECT T2.Continent FROM city AS T1 JOIN country AS T2 ON T1.CountryCode = T2.Code WHERE T1.Name = 'Anguilla'
SELECT avg(LifeExpectancy) FROM country WHERE Region = 'Central Africa'
SELECT Name FROM country WHERE Continent = 'Asia' ORDER BY LifeExpectancy ASC LIMIT 1
SELECT SUM(Population) AS TotalPopulation, MAX(GNP) AS LargestGNP FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language = 'Chinese' AND countrylanguage.IsOfficial = 1 AND country.Continent = 'Asia'
SELECT COUNT(DISTINCT Language) FROM countrylanguage
SELECT DISTINCT GovernmentForm FROM country WHERE Continent = 'Africa'
SELECT T1.Language FROM countrylanguage AS T1 JOIN country AS T2 ON T1.CountryCode = T2.Code WHERE T2.GovernmentForm = 'republic' GROUP BY T1.Language HAVING COUNT(T1.CountryCode) = 1
SELECT Code FROM country WHERE HeadOfState = 'Beatrix'
SELECT COUNT(DISTINCT Language) FROM countrylanguage WHERE CountryCode IN (SELECT Code FROM country WHERE IndepYear < 1930)
SELECT Name FROM country WHERE Continent = 'Asia' AND Population > (SELECT max(Population) FROM country WHERE Continent = 'Africa')
SELECT CountryCode FROM countrylanguage WHERE Language != 'English'
SELECT DISTINCT T1.Name FROM city AS T1 JOIN country AS T2 ON T1.CountryCode = T2.Code JOIN countrylanguage AS T3 ON T2.Code = T3.CountryCode WHERE T2.Continent = 'Asia' AND T3.Language = 'Chinese' AND T3.IsOfficial = 1
SELECT Name, IndepYear, SurfaceArea FROM country ORDER BY Population ASC LIMIT 1
SELECT Name, Population, HeadOfState FROM country ORDER BY SurfaceArea DESC LIMIT 1
SELECT District, COUNT(*) FROM city WHERE Population > (SELECT AVG(Population) FROM city) GROUP BY District
SELECT District, COUNT(*) FROM city WHERE Population > (SELECT AVG(Population) FROM city) GROUP BY District
SELECT GovernmentForm, SUM(Population) AS TotalPopulation FROM country GROUP BY GovernmentForm HAVING AVG(LifeExpectancy) > 72
SELECT Name, Area FROM country ORDER BY Area DESC LIMIT 5
SELECT Name FROM country ORDER BY Population ASC LIMIT 3
SELECT CountryCode FROM countrylanguage WHERE Language = 'Spanish' AND Percentage > 50
SELECT COUNT(*) FROM conductor
SELECT Name FROM conductor ORDER BY Age ASC
SELECT Record_Company, Year_of_Founded FROM orchestra ORDER BY Year_of_Founded DESC
SELECT max(Share), min(Share) FROM performance WHERE Type != 'Live final'
SELECT Name FROM conductor ORDER BY Year_of_Work DESC LIMIT 1
SELECT T1.Name FROM conductor AS T1 JOIN orchestra AS T2 ON T1.Conductor_ID = T2.Conductor_ID WHERE T2.Year_of_Founded > 2008
SELECT Record_Company, COUNT(Orchestra_ID) AS Number_of_Orchestras FROM orchestra GROUP BY Record_Company
SELECT Record_Company FROM orchestra GROUP BY Record_Company ORDER BY COUNT(*) DESC LIMIT 1
SELECT Orchestra FROM orchestra WHERE Orchestra_ID NOT IN (SELECT Orchestra_ID FROM performance)
SELECT T1.Year_of_Founded FROM orchestra AS T1 JOIN performance AS T2 ON T1.Orchestra_ID = T2.Orchestra_ID GROUP BY T1.Year_of_Founded HAVING COUNT(*) > 1
SELECT grade FROM Highschooler WHERE name = 'Kyle'
SELECT ID FROM Highschooler WHERE name = 'Kyle'
SELECT ID FROM Highschooler WHERE name = 'Kyle'
SELECT grade, COUNT(*) AS number_of_students FROM Highschooler GROUP BY grade
SELECT grade, COUNT(*) AS count FROM Highschooler GROUP BY grade ORDER BY count DESC LIMIT 1
SELECT name FROM Highschooler WHERE ID = (SELECT student_id FROM Friend GROUP BY student_id ORDER BY COUNT(friend_id) DESC LIMIT 1)
SELECT COUNT(friend_id) FROM Friend WHERE student_id = (SELECT ID FROM Highschooler WHERE name = 'Kyle')
SELECT student_id FROM Friend INTERSECT SELECT student_id FROM Likes
SELECT T1.name FROM Highschooler AS T1 JOIN Friend AS T2 ON T1.ID = T2.student_id JOIN Likes AS T3 ON T1.ID = T3.student_id
SELECT MIN(grade) FROM Highschooler WHERE ID NOT IN (SELECT student_id FROM Friend)
SELECT state FROM Owners INTERSECT SELECT state FROM Professionals
SELECT AVG(Dogs.age) FROM Dogs JOIN Treatments ON Dogs.dog_id = Treatments.dog_id
SELECT AVG(Dogs.age) FROM Dogs JOIN Treatments ON Dogs.dog_id = Treatments.dog_id
SELECT D.dog_id, D.name, SUM(T.cost_of_treatment) AS total_cost FROM Treatments AS T JOIN Dogs AS D ON T.dog_id = D.dog_id GROUP BY D.dog_id, D.name HAVING SUM(T.cost_of_treatment) <= 1000
SELECT professional_id, role_code, email_address FROM professionals WHERE professional_id NOT IN (SELECT professional_id FROM treatments)
SELECT professional_id, cell_number FROM Professionals WHERE professional_id IN ( SELECT professional_id FROM Treatments GROUP BY professional_id HAVING COUNT(DISTINCT treatment_type_code) >= 2 )
SELECT first_name, last_name FROM Professionals WHERE professional_id IN ( SELECT professional_id FROM Treatments WHERE cost_of_treatment < ( SELECT AVG(cost_of_treatment) FROM Treatments ) )
SELECT Treatments.date_of_treatment, Professionals.first_name FROM Treatments JOIN Professionals ON Treatments.professional_id = Professionals.professional_id
SELECT T1.cost_of_treatment, T2.treatment_type_description FROM treatments AS T1 JOIN treatment_types AS T2 ON T1.treatment_type_code = T2.treatment_type_code
SELECT COUNT(DISTINCT dog_id) FROM Treatments
SELECT COUNT(DISTINCT Professionals.professional_id) FROM Treatments JOIN Professionals ON Treatments.professional_id = Professionals.professional_id
SELECT first_name, last_name, email_address FROM Owners WHERE state LIKE '%North%'
SELECT COUNT(dog_id) FROM Dogs WHERE dog_id NOT IN (SELECT dog_id FROM Treatments)
SELECT professional_id FROM Professionals WHERE professional_id NOT IN (SELECT professional_id FROM Treatments)
SELECT AVG(age) FROM Dogs
SELECT MAX(age) AS oldest_dog_age FROM Dogs
SELECT email_address, cell_number, home_phone FROM Professionals
SELECT Name FROM singer ORDER BY Net_Worth_Millions ASC
SELECT T1.Birth_Year, T1.Citizenship FROM singer AS T1 JOIN song AS T2 ON T1.Singer_ID = T2.Singer_ID GROUP BY T1.Singer_ID
SELECT Name FROM singer WHERE Citizenship != 'France'
SELECT Name FROM singer ORDER BY Net_Worth_Millions DESC LIMIT 1
SELECT T1.Title, T2.Name FROM song AS T1 JOIN singer AS T2 ON T1.Singer_ID = T2.Singer_ID
SELECT singer.Name, SUM(song.Sales) AS Total_Sales FROM singer JOIN song ON singer.Singer_ID = song.Singer_ID GROUP BY singer.Name
SELECT T1.property_name FROM Properties AS T1 JOIN Ref_Property_Types AS T2 ON T1.property_type_code = T2.property_type_code WHERE (T2.property_type_description = 'house' OR T2.property_type_description = 'apartment') AND T1.room_count > 1
