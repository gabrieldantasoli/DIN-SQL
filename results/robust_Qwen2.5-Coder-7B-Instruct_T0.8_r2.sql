SELECT count(*) FROM singer
SELECT T2.Name, COUNT(T1.concert_ID) FROM concert AS T1 JOIN stadium AS T2 ON T1.Stadium_ID = T2.Stadium_ID GROUP BY T2.Name
SELECT T2.Name, T2.Capacity FROM concert AS T1 JOIN stadium AS T2 ON T1.Stadium_ID = T2.Stadium_ID WHERE T1.Year >= 2014 GROUP BY T2.Stadium_ID ORDER BY COUNT(*) DESC LIMIT 1
SELECT YEAR FROM concert GROUP BY YEAR ORDER BY count(*) DESC LIMIT 1
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT COUNT(*) FROM concert AS T1 JOIN stadium AS T2 ON T1.stadium_id = T2.stadium_id WHERE T2.capacity = (SELECT MAX(capacity) FROM stadium)
SELECT COUNT(Has_Pet.PetID) FROM Has_Pet JOIN Student ON Has_Pet.StuID = Student.StuID WHERE Student.Age > 20
SELECT count(DISTINCT PetType) FROM Pets
SELECT count(DISTINCT PetType) FROM Pets
SELECT DISTINCT T3.Fname FROM Pets AS T1 JOIN Has_Pet AS T2 ON T1.PetID = T2.PetID JOIN Student AS T3 ON T2.StuID = T3.StuID WHERE T1.PetType IN ('cat', 'dog')
SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType != 'cats'
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetType , AVG(pet_age) , MAX(pet_age) FROM Pets GROUP BY PetType
SELECT PetType, AVG(weight) FROM Pets GROUP BY PetType
SELECT PetID FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID WHERE Student.LName = 'Smith'
SELECT count(*) FROM continents
SELECT count(*) FROM countries
SELECT Model FROM car_names JOIN cars_data ON car_names.MakeId = cars_data.Id WHERE Weight < (SELECT AVG(Weight) FROM cars_data)
SELECT T3.continent, COUNT(DISTINCT T1.Id) AS CarMakerCount FROM car_makers AS T1 JOIN countries AS T2 ON T1.Country = T2.CountryId JOIN continents AS T3 ON T2.Continent = T3.ContId GROUP BY T3.continent
SELECT count(T1.Model), T2.Id, T2.FullName FROM car_names AS T1 JOIN car_makers AS T2 ON T1.MakeId = T2.Id JOIN model_list AS T3 ON T1.Model = T3.Model GROUP BY T2.Id, T2.FullName
SELECT T1.Model FROM car_names AS T1 JOIN cars_data AS T2 ON T1.MakeId = T2.Id ORDER BY T2.MPG DESC LIMIT 1
SELECT T1.Model FROM model_list AS T1 JOIN car_names AS T2 ON T1.Model = T2.Model GROUP BY T1.Model ORDER BY COUNT(T2.MakeId) DESC LIMIT 1
SELECT COUNT(*) FROM cars_data WHERE YEAR = 1980
SELECT Maker, COUNT(*) AS model_count FROM model_list GROUP BY Maker HAVING COUNT(*) > 3
SELECT DISTINCT T2.Model FROM car_makers AS T1 JOIN model_list AS T2 ON T1.Id = T2.Maker JOIN car_names AS T3 ON T2.Model = T3.Model WHERE T1.Maker = 'General Motors' OR T3.Weight > 3500
SELECT Year FROM cars_data WHERE Weight BETWEEN 3000 AND 4000
SELECT DISTINCT Year FROM cars_data WHERE Weight < 4000 INTERSECT SELECT DISTINCT Year FROM cars_data WHERE Weight > 3000
SELECT Horsepower FROM cars_data ORDER BY Accelerate DESC LIMIT 1
SELECT Cylinders FROM cars_data AS CD JOIN car_names AS CN ON CD.Id = CN.MakeId JOIN model_list AS ML ON CN.Model = ML.Model WHERE ML.Model = 'volvo' ORDER BY Accelerate ASC LIMIT 1
SELECT COUNT(*) FROM cars_data WHERE Cylinders > 6
SELECT T1.CountryId, T1.CountryName FROM countries AS T1 JOIN car_makers AS T2 ON T1.CountryId = T2.Country GROUP BY T1.CountryId, T1.CountryName HAVING COUNT(*) > 3
SELECT Country FROM airlines WHERE Airline = 'JetBlue Airways'
SELECT Abbreviation FROM Airlines WHERE Airline = 'JetBlue Airways'
SELECT count(*) FROM airlines
SELECT count(*) FROM flights
SELECT COUNT(*) FROM airlines WHERE Country = 'USA'
SELECT city, country FROM airports WHERE airportname = 'Alton'
SELECT AirportName FROM airports WHERE AirportCode = 'AKO'
SELECT COUNT(*) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen'
SELECT COUNT(*) FROM flights AS F JOIN airports AS SA ON F.SourceAirport = SA.AirportCode JOIN airports AS DA ON F.DestAirport = DA.AirportCode WHERE SA.City = 'Aberdeen' AND DA.City = 'Ashley'
SELECT T2.City FROM flights AS T1 JOIN airports AS T2 ON T1.DestAirport = T2.AirportCode GROUP BY T2.City ORDER BY COUNT(flights.DestAirport) DESC LIMIT 1
SELECT airports.AirportCode FROM airports JOIN flights ON airports.AirportCode = flights.SourceAirport GROUP BY airports.AirportCode ORDER BY COUNT(*) DESC LIMIT 1
SELECT airlines.Abbreviation, airlines.Country, COUNT(flights.FlightNo) AS FlightCount FROM airlines JOIN flights ON airlines.Airline = flights.Airline GROUP BY airlines.Airline ORDER BY FlightCount ASC LIMIT 1
SELECT Airline FROM flights GROUP BY Airline HAVING count(*) >= 10
SELECT FlightNo FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.AirportName = 'APG'
SELECT T1.FlightNo FROM flights AS T1 JOIN airports AS T2 ON T1.DestAirport = T2.AirportCode WHERE T2.City = 'Aberdeen'
SELECT COUNT(*) FROM flights AS T1 JOIN airports AS T2 ON T1.DestAirport = T2.AirportCode WHERE T2.City IN ('Aberdeen', 'Abilene')
SELECT count(*) FROM airports AS T1 JOIN flights AS T2 ON T1.AirportCode = T2.DestAirport WHERE T1.City = 'Aberdeen' OR T1.City = 'Abilene'
SELECT Name FROM employee ORDER BY Age ASC
SELECT count(*) , city FROM employee GROUP BY city
SELECT Location, COUNT(*) FROM shop GROUP BY Location
SELECT min(Number_products) , max(Number_products) FROM shop
SELECT min(Number_products) , max(Number_products) FROM shop
SELECT Name, Location, District FROM shop ORDER BY Number_products DESC
SELECT sum(Bonus) FROM evaluation
SELECT sum(bonus) FROM evaluation
SELECT * FROM hiring
SELECT count(*) FROM Documents
SELECT Document_Name, Template_ID FROM Documents WHERE Document_Description LIKE '%w%'
SELECT Document_ID, Template_ID, Document_Description FROM Documents JOIN Templates ON Documents.Template_ID = Templates.Template_ID WHERE Document_Name = 'Robbin CV'
SELECT Templates.Template_ID, Templates.Template_Type_Code, COUNT(Documents.Document_ID) AS Document_Count FROM Templates JOIN Documents ON Templates.Template_ID = Documents.Template_ID GROUP BY Templates.Template_ID, Templates.Template_Type_Code ORDER BY Document_Count DESC LIMIT 1
SELECT Template_ID FROM Templates JOIN Documents ON Templates.Template_ID = Documents.Template_ID GROUP BY Template_ID HAVING COUNT(DISTINCT Document_ID) > 1
SELECT DISTINCT Template_Type_Code FROM Templates
SELECT DISTINCT Template_Type_Code FROM Templates
SELECT Template_ID FROM Templates WHERE Template_Type_Code IN ('PP', 'PPT')
SELECT Template_ID FROM Templates WHERE Template_Type_Code IN ('PP', 'PPT')
SELECT Version_Number, Template_Type_Code FROM Templates WHERE Version_Number > 5
SELECT Version_Number, Template_Type_Code FROM Templates WHERE Version_Number > 5
SELECT T1.Template_Type_Code, COUNT(T2.Template_ID) AS Number_of_Templates FROM Ref_Template_Types AS T1 JOIN Templates AS T2 ON T1.Template_Type_Code = T2.Template_Type_Code GROUP BY T1.Template_Type_Code
SELECT T2.Template_Type_Code FROM Templates AS T1 JOIN Ref_Template_Types AS T2 ON T1.Template_Type_Code = T2.Template_Type_Code GROUP BY T2.Template_Type_Code ORDER BY COUNT(T1.Template_ID) DESC LIMIT 1
SELECT Template_Type_Code FROM Templates GROUP BY Template_Type_Code HAVING COUNT(*) < 3
SELECT T1.Template_Type_Code FROM Templates AS T1 JOIN Documents AS T2 ON T1.Template_ID = T2.Template_ID WHERE T2.Document_Name = 'Data base'
SELECT Template_Type_Code, Template_Type_Description FROM Ref_Template_Types ORDER BY Template_Type_Code DESC
SELECT Paragraphs.Paragraph_Text FROM Documents JOIN Templates ON Documents.Template_ID = Templates.Template_ID JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID WHERE Documents.Document_Name = 'Customer reviews'
SELECT count(*) FROM teacher
SELECT count(*) FROM teacher
SELECT Name FROM teacher ORDER BY Age ASC
SELECT Age, Hometown FROM teacher
SELECT Name FROM teacher WHERE Hometown != 'Little Lever Urban District'
SELECT Hometown, COUNT(*) as NumberOfTeachers FROM teacher GROUP BY Hometown ORDER BY NumberOfTeachers DESC LIMIT 1
SELECT Hometown, COUNT(*) as TeacherCount FROM teacher GROUP BY Hometown HAVING COUNT(*) >= 2
SELECT DISTINCT T3.Name FROM course AS T1 JOIN course_arrange AS T2 ON T1.Course_ID = T2.Course_ID JOIN teacher AS T3 ON T2.Teacher_ID = T3.Teacher_ID WHERE T1.Course = 'Math'
SELECT Name, Level_of_membership, Age FROM visitor WHERE Level_of_membership > 4 ORDER BY Age DESC
SELECT AVG(Num_of_Staff) FROM museum WHERE Open_Year < 2009
SELECT museum.Museum_ID, museum.Name FROM museum JOIN visit ON museum.Museum_ID = visit.Museum_ID GROUP BY museum.Museum_ID ORDER BY COUNT(visit.visitor_ID) DESC LIMIT 1
SELECT sum(T1.Total_spent) FROM visit AS T1 JOIN visitor AS T2 ON T1.visitor_ID = T2.ID WHERE T2.Level_of_membership = 1
SELECT count(*) FROM players
SELECT first_name, birth_date FROM players WHERE country_code = 'USA'
SELECT count(DISTINCT T1.loser_name) FROM matches AS T1 JOIN players AS T2 ON T1.loser_id = T2.player_id
SELECT COUNT(DISTINCT loser_name) FROM matches
SELECT p.first_name, p.last_name FROM players p JOIN matches m ON p.player_id = m.winner_id WHERE m.year = 2016
SELECT first_name, country_code FROM players ORDER BY birth_date ASC LIMIT 1
SELECT T1.first_name, AVG(T2.ranking) AS average_ranking FROM players AS T1 JOIN rankings AS T2 ON T1.player_id = T2.player_id GROUP BY T1.player_id
SELECT T1.first_name, SUM(T2.ranking_points) as total_ranking_points FROM players AS T1 JOIN rankings AS T2 ON T1.player_id = T2.player_id GROUP BY T1.player_id
SELECT T1.first_name, T1.country_code, T1.birth_date FROM players AS T1 JOIN rankings AS T2 ON T1.player_id = T2.player_id JOIN matches AS T3 ON T3.winner_id = T1.player_id GROUP BY T1.player_id ORDER BY SUM(T2.winner_rank_points) DESC LIMIT 1
SELECT AVG(injured) FROM death
SELECT count(*) FROM Courses
SELECT D.department_name, D.department_id FROM Departments D JOIN Degree_Programs DP ON D.department_id = DP.department_id GROUP BY D.department_name ORDER BY COUNT(DP.degree_program_id) DESC LIMIT 1
SELECT T2.course_name, T2.course_id FROM Sections AS T1 JOIN Courses AS T2 ON T1.course_id = T2.course_id GROUP BY T2.course_id HAVING COUNT(T1.section_id) <= 2
SELECT T1.semester_name, T1.semester_id FROM semesters AS T1 JOIN student_enrolment AS T2 ON T1.semester_id = T2.semester_id GROUP BY T1.semester_id, T1.semester_name ORDER BY COUNT(*) DESC LIMIT 1
SELECT department_description FROM Departments WHERE department_name LIKE '%the computer%'
SELECT student_id, first_name, middle_name, last_name FROM students JOIN student_enrolment ON students.student_id = student_enrolment.student_id WHERE semester_id = 'specific_semester' GROUP BY student_id HAVING COUNT(DISTINCT degree_program_id) = 2
SELECT degree_program_id, degree_summary_name, count(*) as student_count FROM Degree_Programs JOIN Student_Enrolment ON Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id GROUP BY degree_program_id ORDER BY student_count DESC LIMIT 1
SELECT semester_name FROM Semesters WHERE semester_id NOT IN (SELECT semester_id FROM Student_Enrolment)
SELECT T1.course_name FROM Courses AS T1 JOIN Student_Enrolment_Courses AS T2 ON T1.course_id = T2.course_id
SELECT T2.transcript_id, T2.transcript_date, COUNT(*) AS course_count FROM transcript_contents AS T1 JOIN transcripts AS T2 ON T1.transcript_id = T2.transcript_id GROUP BY T2.transcript_id ORDER BY course_count ASC LIMIT 1
SELECT semester_id FROM Student_Enrolment WHERE semester_id IN ( SELECT semester_id FROM Student_Enrolment WHERE degree_program_id IN ( SELECT degree_program_id FROM Degree_Programs WHERE degree_summary_description LIKE '%Bachelors%' ) ) INTERSECT SELECT semester_id FROM Student_Enrolment WHERE semester_id IN ( SELECT semester_id FROM Student_Enrolment WHERE degree_program_id IN ( SELECT degree_program_id FROM Degree_Programs WHERE degree_summary_description LIKE '%Masters%' ) )
SELECT DISTINCT T1.address_id, T1.line_1, T1.line_2, T1.line_3, T1.city, T1.zip_postcode, T1.state_province_county, T1.country, T1.other_address_details FROM Addresses AS T1 JOIN Students AS T2 ON T1.address_id = T2.permanent_address_id OR T1.address_id = T2.current_address_id
SELECT other_student_details FROM Students ORDER BY last_name DESC
SELECT section_description FROM Sections WHERE section_name = 'h'
SELECT Title FROM Cartoon ORDER BY Title
SELECT COUNT(*) FROM Cartoon WHERE Written_by = 'Joseph Kuhr'
SELECT Country, COUNT(id) AS NumberOfChannels FROM TV_channels GROUP BY Country
SELECT Country, COUNT(id) AS channel_count FROM TV_Channel GROUP BY Country ORDER BY channel_count DESC LIMIT 1
SELECT COUNT(DISTINCT Content) FROM TV_Channel
SELECT Package_Option FROM TV_Channel WHERE series_name = 'Sky Radio'
SELECT Package_Option FROM TV_Channel WHERE series_name = 'Sky Radio'
SELECT Episode FROM TV_series ORDER BY Rating DESC
SELECT Weekly_Rank FROM TV_series WHERE Episode = 'A Love of a Lifetime'
SELECT Production_code, Channel FROM Cartoon ORDER BY Original_air_date DESC LIMIT 1
SELECT T2.Series_name, T1.Package_Option FROM TV_Channel AS T1 JOIN TV_series AS T2 ON T1.id = T2.Channel WHERE T1.Hight_definition_TV = 'high definition TV'
SELECT TV_Channel.Country FROM TV_Channel JOIN Cartoon ON TV_Channel.id = Cartoon.Channel WHERE Cartoon.Written_by != 'Todd Casey'
SELECT id FROM TV_Channel GROUP BY Country HAVING COUNT(*) > 2
SELECT count(*) FROM poker_player
SELECT AVG(Earnings) FROM poker_player
SELECT T2.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID WHERE T2.Earnings > 300000
SELECT T2.Name FROM poker_player AS T1 JOIN people AS T2 ON T1.People_ID = T2.People_ID ORDER BY T1.Final_Table_Made ASC
SELECT T2.Birth_Date FROM poker_player AS T1 JOIN people AS T2 ON T1.People_ID = T2.People_ID ORDER BY T1.Earnings ASC LIMIT 1
SELECT MAX(Money_Rank) FROM people JOIN poker_player ON people.People_ID = poker_player.People_ID ORDER BY Height DESC LIMIT 1
SELECT T2.Name FROM poker_player AS T1 JOIN people AS T2 ON T1.People_ID = T2.People_ID ORDER BY T1.Earnings DESC
SELECT Nationality FROM people GROUP BY Nationality ORDER BY COUNT(*) DESC LIMIT 1
SELECT Nationality FROM people GROUP BY Nationality HAVING COUNT(*) >= 2
SELECT COUNT(DISTINCT state) FROM AREA_CODE_STATE
SELECT max(created) FROM VOTES JOIN AREA_CODE_STATE ON VOTES.state = AREA_CODE_STATE.state WHERE AREA_CODE_STATE.state = 'CA'
SELECT COUNT(Code) FROM country WHERE GovernmentForm = 'Republic'
SELECT SUM(T1.SurfaceArea) FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T1.Continent = 'Caribbean'
SELECT T1.Continent FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T1.Name = 'Anguilla'
SELECT AVG(LifeExpectancy) FROM country WHERE Region = 'Central Africa'
SELECT min(LifeExpectancy) FROM country WHERE Continent = 'Asia'
SELECT SUM(Population), MAX(GNP) FROM country WHERE Continent = 'Asia'
SELECT COUNT(DISTINCT Language) FROM countrylanguage
SELECT COUNT(DISTINCT GovernmentForm) FROM country WHERE Continent = 'Africa'
SELECT Language FROM countrylanguage WHERE CountryCode IN ( SELECT Code FROM country WHERE GovernmentForm = 'republic' ) GROUP BY Language HAVING COUNT(DISTINCT CountryCode) = 1
SELECT T2.Language FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T1.HeadOfState = 'Beatrix' AND T2.IsOfficial = 'T'
SELECT COUNT(DISTINCT Language) FROM countrylanguage WHERE IsOfficial = 'TRUE' AND CountryCode IN (SELECT Code FROM country WHERE IndepYear < 1930)
SELECT MAX(T1.population) FROM country AS T1 JOIN countrylanguage AS T2 ON T1.code = T2.countrycode WHERE T2.language = 'English' AND T1.continent = 'Asia' AND T1.population > (SELECT MAX(T3.population) FROM country AS T3 JOIN countrylanguage AS T4 ON T3.code = T4.countrycode WHERE T4.language = 'English' AND T3.continent = 'Africa')
SELECT countrylanguage.CountryCode FROM countrylanguage WHERE countrylanguage.Language != 'English'
SELECT DISTINCT T3.Name FROM countrylanguage AS T1 JOIN country AS T2 ON T1.CountryCode = T2.Code JOIN city AS T3 ON T2.Code = T3.CountryCode WHERE T2.Region = 'Asia' AND T1.Language = 'Chinese' AND T1.IsOfficial = 'Yes'
SELECT Name, IndepYear, SurfaceArea FROM country ORDER BY Population ASC LIMIT 1
SELECT Name, Population, HeadOfState FROM country ORDER BY SurfaceArea DESC LIMIT 1
SELECT District, COUNT(*) FROM city WHERE Population > (SELECT AVG(Population) FROM city) GROUP BY District
SELECT District, COUNT(*) FROM city WHERE Population > (SELECT AVG(Population) FROM city) GROUP BY District
SELECT GovernmentForm, SUM(Population) AS TotalPopulation FROM country GROUP BY GovernmentForm HAVING AVG(LifeExpectancy) > 72
SELECT Name, Area FROM country ORDER BY Area DESC LIMIT 5
SELECT Name FROM country ORDER BY Population ASC LIMIT 3
SELECT CountryCode FROM countrylanguage WHERE Language = 'Spanish' AND Percentage > 50
SELECT count(*) FROM conductor
SELECT Name FROM conductor ORDER BY Age ASC
SELECT Record_Company FROM orchestra ORDER BY Year_of_Founded DESC
SELECT max(Share) , min(Share) FROM performance WHERE TYPE != 'Live final'
SELECT Name FROM conductor ORDER BY Year_of_Work DESC LIMIT 1
SELECT C.Name FROM conductor AS C JOIN orchestra AS O ON C.Conductor_ID = O.Conductor_ID WHERE O.Year_of_Founded > 2008 ORDER BY C.Name ASC
SELECT Record_Company , COUNT(*) FROM orchestra GROUP BY Record_Company
SELECT Record_Company FROM orchestra GROUP BY Record_Company ORDER BY COUNT(*) DESC LIMIT 1
SELECT Orchestra FROM orchestra WHERE Orchestra_ID NOT IN (SELECT Orchestra_ID FROM performance)
SELECT T1.Year_of_Founded FROM orchestra AS T1 JOIN performance AS T2 ON T1.Orchestra_ID = T2.Orchestra_ID GROUP BY T1.Year_of_Founded HAVING COUNT(*) > 1
SELECT grade FROM Highschooler WHERE name = 'Kyle'
SELECT ID FROM Highschooler WHERE name = 'Kyle'
SELECT ID FROM Highschooler WHERE name = 'Kyle'
SELECT grade, count(*) FROM Highschooler GROUP BY grade
SELECT grade FROM Highschooler GROUP BY grade ORDER BY count(*) DESC LIMIT 1
SELECT T1.name FROM Highschooler AS T1 JOIN Friend AS T2 ON T1.ID = T2.student_id GROUP BY T1.ID ORDER BY COUNT(T2.friend_id) DESC LIMIT 1
SELECT COUNT(*) FROM Friend JOIN Highschooler ON Friend.student_id = Highschooler.ID WHERE Highschooler.name = 'Kyle'
SELECT student_id FROM Friend WHERE student_id IN ( SELECT student_id FROM Likes )
SELECT DISTINCT H1.name FROM Highschooler AS H1 JOIN Friend AS F ON H1.ID = F.student_id JOIN Likes AS L ON H1.ID = L.student_id
SELECT MIN(grade) FROM Highschooler WHERE id NOT IN (SELECT student_id FROM Friend)
SELECT state FROM Owners INTERSECT SELECT state FROM Professionals
SELECT AVG(Dogs.age) FROM Dogs JOIN Treatments ON Dogs.dog_id = Treatments.dog_id
SELECT AVG(Dogs.age) FROM Dogs JOIN Treatments ON Dogs.dog_id = Treatments.dog_id
SELECT d.dog_id, d.name FROM Dogs d JOIN Treatments t ON d.dog_id = t.dog_id GROUP BY d.dog_id, d.name HAVING SUM(t.cost_of_treatment) <= 1000
SELECT professional_id, role_code, email_address FROM Professionals WHERE professional_id NOT IN (SELECT professional_id FROM Treatments)
SELECT professional_id, cell_number FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id GROUP BY professional_id HAVING COUNT(DISTINCT treatment_type_code) >= 2
SELECT Professionals.first_name, Professionals.last_name FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id WHERE Treatments.cost_of_treatment < (SELECT AVG(cost_of_treatment) FROM Treatments)
SELECT date_of_treatment, Professionals.first_name FROM Treatments JOIN Professionals ON Treatments.professional_id = Professionals.professional_id
SELECT T1.cost_of_treatment, T2.treatment_type_description FROM Treatments AS T1 JOIN Treatment_Types AS T2 ON T1.treatment_type_code = T2.treatment_type_code
SELECT COUNT(DISTINCT dog_id) FROM Treatments
SELECT COUNT(DISTINCT professional_id) FROM Treatments
SELECT first_name, last_name, email_address FROM Owners WHERE state LIKE '%North%'
SELECT count(*) FROM dogs WHERE dog_id NOT IN (SELECT dog_id FROM treatments)
SELECT count(professional_id) FROM Professionals LEFT JOIN Treatments ON Professionals.professional_id = Treatments.professional_id WHERE Treatments.treatment_id IS NULL
SELECT AVG(age) FROM Dogs
SELECT max(age) FROM Dogs
SELECT email_address , cell_number , home_phone FROM Professionals
SELECT Name FROM singer ORDER BY Net_Worth_Millions ASC
SELECT Birth_Year, Citizenship FROM singer
SELECT Name FROM singer WHERE Citizenship != 'France'
SELECT Name FROM singer ORDER BY Net_Worth_Millions DESC LIMIT 1
SELECT T1.Title, T2.Name FROM song AS T1 JOIN singer AS T2 ON T1.Singer_ID = T2.Singer_ID
SELECT singer.Name, SUM(song.Sales) as Total_Sales FROM singer JOIN song ON singer.Singer_ID = song.Singer_ID GROUP BY singer.Name
SELECT T1.property_name FROM Properties AS T1 JOIN Ref_Property_Types AS T2 ON T1.property_type_code = T2.property_type_code WHERE (T2.property_type_description = 'house' OR T2.property_type_description = 'apartment') AND T1.room_count > 1
