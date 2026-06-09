SELECT COUNT(*) FROM singer
SELECT T1.Name, COUNT(*) FROM stadium AS T1 JOIN concert AS T2 ON T1.Stadium_ID = T2.Stadium_ID GROUP BY T1.Stadium_ID
SELECT T1.Name, T1.Capacity FROM stadium AS T1 JOIN concert AS T2 ON T1.Stadium_ID = T2.Stadium_ID WHERE T2.Year >= 2014 GROUP BY T1.Stadium_ID ORDER BY COUNT(T2.concert_ID) DESC LIMIT 1
SELECT YEAR FROM concert GROUP BY YEAR ORDER BY count(*) DESC LIMIT 1
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT COUNT(*) FROM concert WHERE Stadium_ID = (SELECT stadium_ID FROM stadium ORDER BY capacity DESC LIMIT 1)
SELECT count(DISTINCT PetID) FROM Has_Pet AS HP JOIN Student AS S ON HP.StuID = S.StuID WHERE S.Age > 20
SELECT count(DISTINCT PetType) FROM Pets
SELECT count(DISTINCT PetType) FROM Pets
SELECT DISTINCT T1.Fname FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID = T2.StuID JOIN Pets AS T3 ON T2.PetID = T3.PetID WHERE T3.PetType IN ('cat', 'dog')
SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat'
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT avg(pet_age) , max(pet_age) , PetType FROM Pets GROUP BY PetType
SELECT PetType, AVG(weight) FROM Pets GROUP BY PetType
SELECT T1.PetID FROM Has_Pet AS T1 JOIN Student AS T2 ON T1.StuID = T2.StuID WHERE T2.LName = 'Smith'
SELECT count(*) FROM continents
SELECT COUNT(CountryId) FROM countries
SELECT Model FROM car_names WHERE MakeId IN (SELECT Id FROM cars_data WHERE Weight < (SELECT avg(Weight) FROM cars_data))
SELECT count(DISTINCT T1.Maker), T3.Continent FROM car_makers AS T1 JOIN countries AS T2 ON T1.Country = T2.CountryId JOIN continents AS T3 ON T2.Continent = T3.ContId GROUP BY T3.Continent
SELECT count(model_list.Model), car_makers.Id, car_makers.FullName FROM model_list JOIN car_makers ON model_list.Maker = car_makers.Id GROUP BY car_makers.Id, car_makers.FullName
SELECT T2.Model FROM cars_data AS T1 JOIN car_names AS T2 ON T1.Id = T2.MakeId ORDER BY T1.MPG DESC LIMIT 1
SELECT Model, COUNT(*) AS count FROM car_names GROUP BY Model ORDER BY count DESC LIMIT 1
SELECT COUNT(*) FROM cars_data WHERE YEAR = 1980
SELECT MakerId, Maker FROM car_makers WHERE Id IN ( SELECT Maker FROM car_names GROUP BY Maker HAVING COUNT(*) > 3 )
SELECT DISTINCT T3.Model FROM car_makers AS T1 JOIN model_list AS T2 ON T1.Id = T2.Maker JOIN car_names AS T3 ON T2.Model = T3.Model WHERE T1.Maker = 'General Motors' OR T3.Weight > 3500
SELECT Year FROM cars_data WHERE Weight BETWEEN 3000 AND 4000
SELECT DISTINCT Year FROM cars_data WHERE Weight < 4000 OR Weight > 3000
SELECT Horsepower FROM cars_data ORDER BY Accelerate DESC LIMIT 1
SELECT cars_data.Cylinders FROM car_names JOIN cars_data ON car_names.MakeId = cars_data.Id JOIN model_list ON car_names.Model = model_list.Model WHERE car_names.Model = 'volvo' ORDER BY cars_data.Accelerate ASC LIMIT 1
SELECT COUNT(*) FROM cars_data WHERE Cylinders > 6
SELECT T1.CountryId, T1.CountryName FROM countries AS T1 JOIN car_makers AS T2 ON T1.CountryId = T2.Country GROUP BY T1.CountryId, T1.CountryName HAVING COUNT(T2.Id) > 3 UNION SELECT T1.CountryId, T1.CountryName FROM countries AS T1 JOIN car_names AS T2 ON T1.CountryId = T2.MakeId JOIN model_list AS T3 ON T2.Model = T3.Model WHERE T3.Maker = 'Fiat' GROUP BY T1.CountryId, T1.CountryName
SELECT Country FROM airlines WHERE Airline = 'JetBlue Airways'
SELECT Abbreviation FROM airlines WHERE Airline = 'JetBlue Airways'
SELECT COUNT(*) FROM airlines
SELECT count(*) FROM flights
SELECT count(*) FROM airlines WHERE Country = 'USA'
SELECT City, Country FROM airports WHERE AirportName = 'Alton'
SELECT AirportName FROM airports WHERE AirportCode = 'AKO'
SELECT count(*) FROM flights AS T1 JOIN airports AS T2 ON T1.DestAirport = T2.AirportCode WHERE T2.City = 'Aberdeen'
SELECT COUNT(*) FROM flights AS f JOIN airports AS sa ON f.SourceAirport = sa.AirportCode JOIN airports AS da ON f.DestAirport = da.AirportCode WHERE sa.City = 'Aberdeen' AND da.City = 'Ashley'
SELECT T1.City FROM airports AS T1 JOIN flights AS T2 ON T1.AirportCode = T2.DestAirport GROUP BY T1.City ORDER BY count(*) DESC LIMIT 1
SELECT DestAirport FROM airports JOIN flights ON airports.AirportCode = flights.DestAirport GROUP BY DestAirport ORDER BY count(FlightNo) DESC LIMIT 1
SELECT airlines.Abbreviation, airlines.Country, COUNT(flights.FlightNo) AS flight_count FROM airlines JOIN flights ON airlines.uid = flights.Airline GROUP BY airlines.Abbreviation, airlines.Country ORDER BY flight_count ASC LIMIT 1
SELECT Airlines.Airline, COUNT(Flights.FlightNo) AS FlightCount FROM Flights JOIN Airlines ON Flights.Airline = Airlines.uid GROUP BY Airlines.Airline HAVING COUNT(Flights.FlightNo) >= 10
SELECT T1.FlightNo FROM flights AS T1 JOIN airports AS T2 ON T1.DestAirport = T2.AirportCode WHERE T2.AirportName = 'APG'
SELECT T1.FlightNo FROM flights AS T1 JOIN airports AS T2 ON T1.DestAirport = T2.AirportCode WHERE T2.City = 'Aberdeen'
SELECT count(*) FROM flights AS T1 JOIN airports AS T2 ON T1.DestAirport = T2.AirportCode WHERE T2.City = 'Aberdeen' OR T2.City = 'Abilene'
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
SELECT COUNT(Document_ID) FROM Documents
SELECT Document_Name, Template_ID FROM Documents WHERE Document_Description LIKE '%w%'
SELECT Document_ID, Template_ID, Document_Description FROM Documents WHERE Document_Name = 'Robbin CV'
SELECT T1.Template_ID, T1.Template_Type_Code FROM Templates AS T1 JOIN Documents AS T2 ON T1.Template_ID = T2.Template_ID GROUP BY T1.Template_ID, T1.Template_Type_Code ORDER BY COUNT(*) DESC LIMIT 1
SELECT Template_ID FROM Templates WHERE Template_ID IN (SELECT Template_ID FROM Documents GROUP BY Template_ID HAVING COUNT(*) > 1)
SELECT DISTINCT Template_Type_Code FROM Templates
SELECT DISTINCT Template_Type_Code FROM Ref_Template_Types
SELECT Template_ID FROM Templates WHERE Template_Type_Code = 'PP' OR Template_Type_Code = 'PPT'
SELECT Template_ID FROM Templates WHERE Template_Type_Code IN ('PP', 'PPT')
SELECT Version_Number, Template_Type_Code FROM Templates WHERE Version_Number > 5
SELECT Version_Number, Template_Type_Code FROM Templates WHERE Version_Number > 5
SELECT T2.Template_Type_Code, COUNT(T1.Template_ID) FROM Templates AS T1 JOIN Ref_Template_Types AS T2 ON T1.Template_Type_Code = T2.Template_Type_Code GROUP BY T2.Template_Type_Code
SELECT Template_Type_Code FROM Templates JOIN Ref_Template_Types ON Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code GROUP BY Template_Type_Code ORDER BY COUNT(*) DESC LIMIT 1
SELECT T1.Template_Type_Code FROM Ref_Template_Types AS T1 JOIN Templates AS T2 ON T1.Template_Type_Code = T2.Template_Type_Code GROUP BY T1.Template_Type_Code HAVING COUNT(*) < 3
SELECT T1.Template_Type_Code FROM Templates AS T1 JOIN Documents AS T2 ON T1.Template_ID = T2.Template_ID WHERE T2.Document_Name = 'Data base'
SELECT Template_Type_Code, Template_Type_Description FROM Ref_Template_Types
SELECT Paragraphs.Paragraph_Text FROM Documents JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID WHERE Documents.Document_Name = 'Customer reviews'
SELECT COUNT(*) FROM teacher
SELECT COUNT(*) FROM teacher
SELECT Name FROM teacher ORDER BY Age ASC
SELECT Age, Hometown FROM teacher
SELECT Name FROM teacher WHERE Hometown != 'Little Lever Urban District'
SELECT Hometown FROM teacher GROUP BY Hometown ORDER BY COUNT(*) DESC LIMIT 1
SELECT Hometown FROM teacher GROUP BY Hometown HAVING COUNT(*) >= 2
SELECT T1.Name FROM teacher AS T1 JOIN course_arrange AS T2 ON T1.Teacher_ID = T2.Teacher_ID JOIN course AS T3 ON T2.Course_ID = T3.Course_ID WHERE T3.Course = 'Math'
SELECT Name, Level_of_membership, Age FROM visitor WHERE Level_of_membership > 4 ORDER BY Age DESC
SELECT AVG(Num_of_Staff) FROM museum WHERE Open_Year < 2009
SELECT T1.Museum_ID, T1.Name, COUNT(*) AS visit_count FROM museum AS T1 JOIN visit AS T2 ON T1.Museum_ID = T2.Museum_ID GROUP BY T1.Museum_ID ORDER BY visit_count DESC LIMIT 1
SELECT sum(T1.Total_spent) FROM visit AS T1 JOIN visitor AS T2 ON T1.visitor_ID = T2.ID WHERE T2.Level_of_membership = 1
SELECT count(*) FROM players
SELECT first_name, birth_date FROM players WHERE country_code = 'USA'
SELECT COUNT(DISTINCT loser_name) FROM matches
SELECT count(DISTINCT T1.loser_name) FROM matches AS T1
SELECT T1.first_name, T1.last_name FROM players AS T1 JOIN matches AS T2 ON T1.player_id = T2.winner_id WHERE T2.year = 2016 INTERSECT SELECT T1.first_name, T1.last_name FROM players AS T1 JOIN matches AS T2 ON T1.player_id = T2.winner_id WHERE T2.year = 2013
SELECT first_name, country_code FROM players ORDER BY birth_date ASC LIMIT 1
SELECT avg(T1.ranking) , T2.first_name FROM rankings AS T1 JOIN players AS T2 ON T1.player_id = T2.player_id GROUP BY T2.player_id
SELECT T1.first_name, sum(T2.ranking_points) FROM players AS T1 JOIN rankings AS T2 ON T1.player_id = T2.player_id GROUP BY T1.player_id
SELECT players.first_name, players.country_code, players.birth_date FROM players JOIN matches ON players.player_id = matches.winner_id GROUP BY players.player_id ORDER BY SUM(matches.winner_rank_points) DESC LIMIT 1
SELECT AVG(injured) FROM death
SELECT COUNT(*) FROM Courses
SELECT department_name, department_id FROM Departments WHERE department_id = (SELECT department_id FROM Degree_Programs GROUP BY department_id ORDER BY count(*) DESC LIMIT 1)
SELECT T1.course_name, T1.course_id FROM Courses AS T1 JOIN Sections AS T2 ON T1.course_id = T2.course_id GROUP BY T1.course_id HAVING COUNT(T2.section_id) <= 2
SELECT semester_id, semester_name FROM Semesters WHERE semester_id = (SELECT semester_id FROM Student_Enrolment GROUP BY semester_id ORDER BY COUNT(*) DESC LIMIT 1)
SELECT department_description FROM Departments WHERE department_name LIKE '%the computer%'
SELECT student_id, COUNT(degree_program_id) AS program_count FROM Student_Enrolment GROUP BY student_id HAVING program_count = 2
SELECT T2.degree_program_id, T2.degree_summary_name FROM Student_Enrolment AS T1 JOIN Degree_Programs AS T2 ON T1.degree_program_id = T2.degree_program_id GROUP BY T2.degree_program_id ORDER BY COUNT(T1.student_enrolment_id) DESC LIMIT 1
SELECT semester_name FROM Semesters WHERE semester_id NOT IN (SELECT semester_id FROM Student_Enrolment)
SELECT course_name FROM Courses WHERE course_id IN (SELECT course_id FROM Student_Enrolment_Courses)
SELECT T1.transcript_date, T1.transcript_id FROM transcripts AS T1 JOIN transcript_contents AS T2 ON T1.transcript_id = T2.transcript_id GROUP BY T1.transcript_date, T1.transcript_id ORDER BY count(*) ASC LIMIT 1
SELECT semester_id FROM Student_Enrolment WHERE degree_program_id IN (SELECT degree_program_id FROM Degree_Programs WHERE degree_summary_name = 'Bachelors') AND semester_id IN (SELECT semester_id FROM Student_Enrolment WHERE degree_program_id IN (SELECT degree_program_id FROM Degree_Programs WHERE degree_summary_name = 'Masters'))
SELECT DISTINCT T1.line_1, T1.line_2, T1.line_3, T1.city, T1.zip_postcode, T1.state_province_county, T1.country, T1.other_address_details FROM Addresses AS T1 JOIN Students AS T2 ON T1.address_id = T2.current_address_id
SELECT other_student_details FROM Students ORDER BY last_name DESC
SELECT section_description FROM Sections WHERE section_name = 'h'
SELECT title FROM Cartoon ORDER BY title
SELECT COUNT(*) FROM Cartoon WHERE Written_by = 'Joseph Kuhr'
SELECT Country, COUNT(id) AS channel_count FROM TV_Channel GROUP BY Country
SELECT Country, COUNT(id) AS Channel_Count FROM TV_Channel GROUP BY Country ORDER BY Channel_Count DESC LIMIT 1
SELECT count(DISTINCT series_name) , count(DISTINCT content) FROM TV_Channel
SELECT Package_Option FROM TV_Channel WHERE series_name = 'Sky Radio'
SELECT Package_Option FROM TV_Channel WHERE series_name = 'Sky Radio'
SELECT Episode FROM TV_series ORDER BY Rating DESC
SELECT Weekly_Rank FROM TV_series WHERE Episode = 'A Love of a Lifetime'
SELECT Production_code, TV_Channel.id FROM Cartoon JOIN TV_Channel ON Cartoon.Channel = TV_Channel.id ORDER BY Cartoon.Original_air_date DESC LIMIT 1
SELECT T1.Package_Option, T2.series_name FROM TV_Channel AS T1 JOIN TV_series AS T2 ON T1.id = T2.Channel WHERE T1.Hight_definition_TV = true
SELECT DISTINCT T1.Country FROM TV_Channel AS T1 JOIN Cartoon AS T2 ON T1.id = T2.Channel WHERE T2.Written_by != 'Todd Casey'
SELECT id FROM TV_channel GROUP BY country HAVING COUNT(*) > 2
SELECT COUNT(Poker_Player_ID) FROM poker_player
SELECT AVG(Earnings) FROM poker_player
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID WHERE T2.Earnings > 300000
SELECT Name, COUNT(Final_Table_Made) AS Number_of_Final_Tables FROM poker_player JOIN people ON poker_player.People_ID = people.People_ID GROUP BY Name ORDER BY Number_of_Final_Tables ASC
SELECT T1.Birth_Date FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID ORDER BY T2.Earnings ASC LIMIT 1
SELECT T1.Money_Rank FROM poker_player AS T1 JOIN people AS T2 ON T1.People_ID = T2.People_ID WHERE T2.Height = (SELECT max(Height) FROM people)
SELECT T2.Name FROM poker_player AS T1 JOIN people AS T2 ON T1.People_ID = T2.People_ID ORDER BY T1.Earnings DESC
SELECT Nationality FROM people GROUP BY Nationality ORDER BY COUNT(*) DESC LIMIT 1
SELECT Nationality, COUNT(*) FROM people GROUP BY Nationality HAVING COUNT(*) >= 2
SELECT count(DISTINCT state) FROM AREA_CODE_STATE
SELECT VOTES.created FROM VOTES JOIN AREA_CODE_STATE ON VOTES.state = AREA_CODE_STATE.state WHERE AREA_CODE_STATE.state = 'CA' ORDER BY VOTES.created DESC LIMIT 1
SELECT count(*) FROM country WHERE GovernmentForm = 'republic'
SELECT sum(SurfaceArea) FROM country WHERE Region = 'Caribbean'
SELECT T1.Continent FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T1.Name = 'Anguilla'
SELECT AVG(LifeExpectancy) FROM country WHERE Region = 'Central Africa'
SELECT Name FROM country WHERE Continent = 'Asia' ORDER BY LifeExpectancy ASC LIMIT 1
SELECT SUM(T1.population), MAX(T1.GNP) FROM country AS T1 WHERE T1.continent = 'Asia'
SELECT count(DISTINCT Language) FROM countrylanguage
SELECT count(DISTINCT T1.GovernmentForm) FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T1.Continent = 'Africa'
SELECT T1.Language FROM countrylanguage AS T1 JOIN country AS T2 ON T1.CountryCode = T2.Code WHERE T2.GovernmentForm = 'republic' GROUP BY T1.Language HAVING COUNT(DISTINCT T1.CountryCode) = 1
SELECT Code FROM country WHERE HeadOfState = 'Beatrix'
SELECT COUNT(DISTINCT Language) FROM countrylanguage JOIN country ON countrylanguage.CountryCode = country.Code WHERE country.IndepYear < 1930 AND IsOfficial = 'T'
SELECT Name FROM country WHERE Continent = 'Asia' AND Population > (SELECT MAX(Population) FROM country WHERE Continent = 'Africa')
SELECT CountryCode FROM countrylanguage WHERE Language != 'English'
SELECT city.Name FROM city JOIN country ON city.CountryCode = country.Code JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE country.Continent = 'Asia' AND countrylanguage.Language = 'Chinese' AND countrylanguage.IsOfficial = 1
SELECT Name, IndepYear, SurfaceArea FROM country ORDER BY Population ASC LIMIT 1
SELECT Name, Population, HeadOfState FROM country ORDER BY SurfaceArea DESC LIMIT 1
SELECT District, COUNT(*) as NumberOfCities FROM city WHERE Population > (SELECT AVG(Population) FROM city) GROUP BY District
SELECT District, COUNT(*) as CityCount FROM city WHERE Population > (SELECT AVG(Population) FROM city) GROUP BY District
SELECT GovernmentForm, SUM(Population) AS total_population FROM country GROUP BY GovernmentForm HAVING AVG(LifeExpectancy) > 72
SELECT Name, SurfaceArea FROM country ORDER BY SurfaceArea DESC LIMIT 5
SELECT Name FROM country ORDER BY Population ASC LIMIT 3
SELECT CountryCode FROM countrylanguage WHERE Language = 'Spanish' AND IsOfficial = 'T'
SELECT COUNT(*) FROM conductor
SELECT Name FROM conductor ORDER BY Age ASC
SELECT Record_Company FROM orchestra ORDER BY Year_of_Founded DESC
SELECT max(Share) , min(Share) FROM performance WHERE TYPE != 'Live final'
SELECT Name FROM conductor ORDER BY Year_of_Work DESC LIMIT 1
SELECT T1.Name FROM conductor AS T1 JOIN performance AS T2 ON T1.Conductor_ID = T2.Orchestra_ID JOIN orchestra AS T3 ON T2.Orchestra_ID = T3.Orchestra_ID WHERE T3.Year_of_Founded > 2008
SELECT Record_Company, COUNT(Orchestra_ID) FROM orchestra GROUP BY Record_Company
SELECT Record_Company, COUNT(*) AS num_orchestras FROM orchestra GROUP BY Record_Company ORDER BY num_orchestras DESC LIMIT 1
SELECT orchestra FROM performance
SELECT orchestra.Year_of_Founded FROM orchestra JOIN performance ON orchestra.Orchestra_ID = performance.Orchestra_ID GROUP BY orchestra.Orchestra_ID HAVING COUNT(performance.Performance_ID) > 1
SELECT grade FROM Highschooler WHERE name = 'Kyle'
SELECT ID FROM Highschooler WHERE name = 'Kyle'
SELECT ID FROM Highschooler WHERE name = 'Kyle'
SELECT grade, COUNT(*) FROM Highschooler GROUP BY grade
SELECT grade FROM Highschooler GROUP BY grade ORDER BY count(*) DESC LIMIT 1
SELECT T1.name FROM Highschooler AS T1 JOIN Friend AS T2 ON T1.id = T2.student_id GROUP BY T1.id ORDER BY COUNT(T2.friend_id) DESC LIMIT 1
SELECT count(*) FROM Highschooler AS T1 JOIN Friend AS T2 ON T1.id = T2.student_id WHERE T1.name = 'Kyle'
SELECT student_id FROM Friend WHERE friend_id IN (SELECT ID FROM Highschooler) INTERSECT SELECT student_id FROM Likes WHERE liked_id IN (SELECT ID FROM Highschooler)
SELECT T1.name FROM Highschooler AS T1 JOIN Friend AS T2 ON T1.ID = T2.student_id INTERSECT SELECT T1.name FROM Highschooler AS T1 JOIN Likes AS T2 ON T1.ID = T2.student_id
SELECT grade FROM Highschooler WHERE ID NOT IN (SELECT student_id FROM Friend)
SELECT state FROM Owners INTERSECT SELECT state FROM Professionals
SELECT AVG(age) FROM Dogs WHERE dog_id IN (SELECT dog_id FROM Treatments)
SELECT AVG(age) FROM Dogs WHERE dog_id IN (SELECT dog_id FROM Treatments)
SELECT D.name FROM Dogs D JOIN Treatments T ON D.dog_id = T.dog_id GROUP BY D.dog_id HAVING SUM(T.cost_of_treatment) <= 1000
SELECT professional_id, role_code, email_address FROM professionals WHERE professional_id NOT IN (SELECT professional_id FROM treatments)
SELECT professional_id, cell_number FROM professionals JOIN treatments ON professionals.professional_id = treatments.professional_id GROUP BY professional_id HAVING COUNT(DISTINCT treatment_type_code) >= 2
SELECT Professionals.first_name, Professionals.last_name FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id WHERE Treatments.cost_of_treatment < (SELECT AVG(cost_of_treatment) FROM Treatments)
SELECT date_of_treatment, first_name FROM Treatments AS T1 JOIN Professionals AS T2 ON T1.professional_id = T2.professional_id
SELECT T1.cost_of_treatment, T2.treatment_type_description FROM Treatments AS T1 JOIN Treatment_Types AS T2 ON T1.treatment_type_code = T2.treatment_type_code
SELECT COUNT(DISTINCT dog_id) FROM Treatments
SELECT count(DISTINCT professional_id) FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id
SELECT first_name, last_name, email_address FROM Owners WHERE state LIKE '%North%'
SELECT (SELECT COUNT(DISTINCT dog_id) FROM Dogs) - (SELECT COUNT(DISTINCT dog_id) FROM Treatments) AS dogs_without_treatment
SELECT COUNT(professional_id) FROM Professionals WHERE professional_id NOT IN (SELECT professional_id FROM Treatments)
SELECT AVG(age) FROM Dogs
SELECT MAX(age) FROM Dogs
SELECT email_address, cell_number, home_phone FROM Professionals
SELECT Name FROM singer ORDER BY Net_Worth_Millions ASC
SELECT Birth_Year, Citizenship FROM singer
SELECT Name FROM singer WHERE Citizenship != 'France'
SELECT Name FROM singer ORDER BY Net_Worth_Millions DESC LIMIT 1
SELECT T1.Title, T2.Name FROM song AS T1 JOIN singer AS T2 ON T1.Singer_ID = T2.Singer_ID
SELECT T1.Name, sum(T2.Sales) FROM singer AS T1 JOIN song AS T2 ON T1.Singer_ID = T2.Singer_ID GROUP BY T1.Name
SELECT T1.property_name FROM Properties AS T1 JOIN Ref_Property_Types AS T2 ON T1.property_type_code = T2.property_type_code WHERE (T2.property_type_name = 'houses' OR T2.property_type_name = 'apartments') AND T1.room_count > 1 ORDER BY T1.property_name ASC
