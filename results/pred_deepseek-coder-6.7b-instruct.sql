SELECT COUNT(*) FROM singer
SELECT T1.Name, count(T2.concert_ID) FROM stadium AS T1 JOIN concert AS T2 ON T1.Stadium_ID = T2.Stadium_ID GROUP BY T1.Name
SELECT T1.Name, T1.Capacity FROM stadium AS T1 JOIN concert AS T2 ON T1.Stadium_ID = T2.Stadium_ID WHERE T2.Year >= 2014 GROUP BY T1.Stadium_ID ORDER BY count(T2.concert_ID) DESC LIMIT 1
SELECT Year FROM concert GROUP BY Year ORDER BY count(concert_ID) DESC LIMIT 1
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT count(concert_ID) FROM concert WHERE Stadium_ID = (SELECT Stadium_ID FROM stadium ORDER BY Capacity DESC LIMIT 1)
SELECT count(T2.PetID) FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID = T2.StuID WHERE T1.Age > 20
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT COUNT(DISTINCT PetType) FROM Pets, Has_Pet WHERE Has_Pet.PetID = Pets.PetID
SELECT DISTINCT T1.Fname FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID = T2.StuID JOIN Pets AS T3 ON T2.PetID = T3.PetID WHERE T3.PetType = 'cat' OR T3.PetType = 'dog'
SELECT DISTINCT T1.StuID FROM Student AS T1 WHERE T1.StuID NOT IN ( SELECT T2.StuID FROM Has_Pet AS T2 JOIN Pets AS T3 ON T2.PetID = T3.PetID WHERE T3.PetType = 'Cat' )
SELECT PetID, weight FROM Pets WHERE pet_age >1
SELECT PetType, AVG(pet_age) as average_age, MAX(pet_age) as max_age FROM Pets GROUP BY PetType
SELECT PetType, AVG(weight) FROM Pets, Has_Pet WHERE Pets.PetID = Has_Pet.PetID GROUP BY PetType
SELECT PetID FROM Has_Pet WHERE StuID = (SELECT StuID FROM Student WHERE LName = 'Smith')
SELECT COUNT(DISTINCT ContId) FROM continents
SELECT COUNT(DISTINCT CountryId) FROM countries
SELECT T1.Model FROM car_names AS T1 JOIN cars_data AS T2 ON T1.MakeId = T2.Id WHERE T2.Weight < (SELECT avg(Weight) FROM cars_data)
SELECT T3.Continent, count(T1.Id) FROM car_makers AS T1 JOIN countries AS T2 ON T1.Country = T2.CountryId JOIN continents AS T3 ON T2.Continent = T3.ContId GROUP BY T3.Continent
SELECT count(T2.Model) as Number_of_Models, T1.Id, T1.FullName FROM car_makers AS T1 JOIN model_list AS T2 ON T1.Id = T2.Maker GROUP BY T1.Id, T1.FullName
SELECT T1.Model FROM car_names AS T1 JOIN cars_data AS T2 ON T1.MakeId = T2.Id WHERE T2.MPG = (SELECT max(MPG) FROM cars_data)
SELECT T1.Model, count(T2.Make) FROM car_names AS T1 JOIN model_list AS T2 ON T1.Model = T2.Model GROUP BY T1.Model ORDER BY count(T2.Make) DESC
SELECT count(T1.Id) FROM cars_data AS T1 JOIN car_names AS T2 ON T1.Id = T2.MakeId WHERE T1.Year = 1980
SELECT T1.Id, T1.Maker FROM car_makers AS T1 JOIN model_list AS T2 ON T1.Id = T2.Maker GROUP BY T1.Id, T1.Maker HAVING count(T2.Maker) > 3
SELECT DISTINCT model_list.Model FROM model_list JOIN car_makers ON model_list.Maker = car_makers.Id JOIN cars_data ON car_names.MakeId = cars_data.Id WHERE (car_makers.Maker = 'General Motors' OR cars_data.Weight > 3500)
SELECT Year FROM cars_data WHERE Weight BETWEEN 3000 AND 4000
SELECT Year FROM cars_data WHERE Weight < 4000 UNION SELECT Year FROM cars_data WHERE Weight > 3000
SELECT Horsepower FROM cars_data WHERE Accelerate = (SELECT max(Accelerate) FROM cars_data)
SELECT T1.Cylinders FROM cars_data AS T1 JOIN car_names AS T2 ON T1.Id = T2.MakeId JOIN model_list AS T3 ON T2.Model = T3.Model WHERE T3.Model = 'volvo' ORDER BY T1.Accelerate ASC LIMIT 1
SELECT count(T1.Id) FROM cars_data AS T1 JOIN car_names AS T2 ON T1.Id = T2.MakeId WHERE T1.Cylinders > 6
SELECT DISTINCT T1.CountryId, T1.CountryName FROM countries AS T1 JOIN car_makers AS T2 ON T1.CountryId = T2.Country JOIN model_list AS T3 ON T1.CountryId = T3.Maker WHERE (T2.Country IN (SELECT CountryId FROM car_makers GROUP BY CountryId HAVING COUNT(*) > 3) OR T3.Maker = 'Fiat')
SELECT Country FROM airlines WHERE Airline = 'JetBlue Airways'
SELECT Abbreviation FROM airlines WHERE Airline = 'JetBlue Airways'
SELECT COUNT(*) FROM airlines
SELECT COUNT(*) FROM flights
SELECT COUNT(*) FROM airlines WHERE Country = 'USA'
SELECT City, Country FROM airports WHERE AirportName = 'Alton'
SELECT AirportName FROM airports WHERE AirportCode = 'AKO'
SELECT count(FlightNo) FROM flights WHERE DestAirport = 'ABZ'
SELECT count(FlightNo) FROM flights WHERE SourceAirport = (SELECT AirportCode FROM airports WHERE City = 'Aberdeen') AND DestAirport = (SELECT AirportCode FROM airports WHERE City = 'Ashley')
SELECT T1.City, count(T2.DestAirport) as Destination_Count FROM airports AS T1 JOIN flights AS T2 ON T1.AirportCode = T2.DestAirport GROUP BY T1.City ORDER BY Destination_Count DESC LIMIT 1
SELECT AirportCode FROM airports JOIN flights ON airports.AirportCode = flights.SourceAirport OR airports.AirportCode = flights.DestAirport GROUP BY AirportCode ORDER BY COUNT(FlightNo) DESC LIMIT 1
SELECT flights.Airline FROM flights GROUP BY flights.Airline HAVING count(*) = ( SELECT min(count(*)) FROM flights GROUP BY flights.Airline ) )
SELECT T1.Airline FROM airlines AS T1 JOIN flights AS T2 ON T1.uid = T2.Airline GROUP BY T1.Airline HAVING count(*) >= 10
SELECT FlightNo FROM flights WHERE DestAirport = 'APG'
SELECT FlightNo FROM flights WHERE DestAirport = 'ABZ'
SELECT COUNT(DISTINCT FlightNo) FROM flights WHERE DestAirport IN ('Aberdeen', 'Abilene')
SELECT COUNT(DISTINCT FlightNo) FROM flights WHERE DestAirport IN ('ABR', 'ABI')
SELECT Name, Age FROM employee ORDER BY Age ASC
SELECT City, COUNT(*) FROM employee GROUP BY City
SELECT T1.Location, count(T2.Shop_ID) FROM shop AS T1 JOIN hiring AS T2 ON T1.Shop_ID = T2.Shop_ID GROUP BY T1.Location
SELECT MIN(Number_products) as Min_Products, MAX(Number_products) as Max_Products FROM shop
SELECT MIN(Number_products) as Min_Products, MAX(Number_products) as Max_Products FROM shop
SELECT Name, Location, District FROM shop ORDER BY Number_products DESC
SELECT sum(Bonus) FROM evaluation
SELECT sum(Bonus) FROM evaluation
SELECT hiring.Employee_ID, hiring.Shop_ID, hiring.Start_from, hiring.Is_full_time, employee.Name, employee.Age, employee.City, shop.Name AS Shop_Name, shop.Location, shop.District, shop.Number_products, shop.Manager_name FROM hiring JOIN employee ON hiring.Employee_ID = employee.Employee_ID JOIN shop ON hiring.Shop_ID = shop.Shop_ID
SELECT count(*) FROM Documents
SELECT Document_Name, Template_ID FROM Documents WHERE Document_Description LIKE '%w%'
SELECT Documents.Document_ID, Templates.Template_ID, Documents.Document_Description FROM Documents JOIN Templates ON Documents.Template_ID = Templates.Template_ID WHERE Documents.Document_Name = 'Robbin CV'
SELECT Templates.Template_ID, Templates.Template_Type_Code, count(Documents.Document_ID) as Document_Count FROM Templates JOIN Documents ON Templates.Template_ID = Documents.Template_ID GROUP BY Templates.Template_ID, Templates.Template_Type_Code ORDER BY Document_Count DESC LIMIT 1
SELECT Template_ID FROM Templates JOIN Documents ON Templates.Template_ID = Documents.Template_ID GROUP BY Template_ID HAVING count(*) > 1
SELECT DISTINCT Template_Type_Code FROM Templates
SELECT DISTINCT Template_Type_Code FROM Ref_Template_Types
SELECT Template_ID FROM Templates WHERE Template_Type_Code = 'PP' OR Template_Type_Code = 'PPT'
SELECT Template_ID FROM Templates WHERE Template_Type_Code = 'PP' OR Template_Type_Code = 'PPT'
SELECT Version_Number, Template_Type_Code FROM Templates INNER JOIN Ref_Template_Types ON Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code WHERE Version_Number > 5
SELECT Version_Number, Template_Type_Code FROM Templates INNER JOIN Ref_Template_Types ON Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code WHERE Version_Number > 5
SELECT T1.Template_Type_Code, count(T2.Template_ID) FROM Ref_Template_Types AS T1 JOIN Templates AS T2 ON T1.Template_Type_Code = T2.Template_Type_Code GROUP BY T1.Template_Type_Code
SELECT T1.Template_Type_Code FROM Templates AS T2 JOIN Ref_Template_Types AS T1 ON T2.Template_Type_Code = T1.Template_Type_Code GROUP BY T2.Template_Type_Code ORDER BY count(T2.Template_ID) DESC LIMIT 1
SELECT T1.Template_Type_Code FROM Ref_Template_Types AS T1 JOIN Templates AS T2 ON T1.Template_Type_Code = T2.Template_Type_Code GROUP BY T1.Template_Type_Code HAVING count(*) < 3
SELECT Template_Type_Code FROM Templates JOIN Documents ON Templates.Template_ID = Documents.Template_ID WHERE Documents.Document_Name = 'Data base'
SELECT Template_Type_Code, Template_Type_Description FROM Ref_Template_Types
SELECT Paragraph_Text FROM Paragraphs JOIN Documents ON Paragraphs.Document_ID = Documents.Document_ID WHERE Document_Name = 'Customer reviews'
SELECT COUNT(*) FROM teacher
SELECT COUNT(*) FROM teacher
SELECT Name FROM teacher ORDER BY Age ASC
SELECT Age, Hometown FROM teacher
SELECT Name FROM teacher WHERE Hometown != ' Little Lever Urban District'
SELECT Hometown FROM teacher GROUP BY Hometown ORDER BY count(*) DESC LIMIT 1
SELECT Hometown FROM teacher GROUP BY Hometown HAVING count(*) >= 2
SELECT DISTINCT T1.Name FROM teacher AS T1 JOIN course_arrange AS T2 ON T1.Teacher_ID = T2.Teacher_ID JOIN course AS T3 ON T2.Course_ID = T3.Course_ID WHERE T3.Course = 'math'
SELECT Name, Level_of_membership FROM visitor WHERE Level_of_membership > 4 ORDER BY Age DESC
SELECT AVG(museum.Num_of_Staff) FROM museum WHERE museum.Open_Year < 2009
SELECT T1.Museum_ID, T1.Name FROM museum AS T1 JOIN visit AS T2 ON T1.Museum_ID = T2.Museum_ID GROUP BY T1.Museum_ID, T1.Name ORDER BY count(T2.Museum_ID) DESC LIMIT 1
SELECT SUM(visit.Total_spent) FROM visit JOIN visitor ON visit.visitor_ID = visitor.ID WHERE visitor.Level_of_membership = 1
SELECT COUNT(*) FROM players
SELECT first_name, birth_date FROM players WHERE country_code = 'USA'
SELECT count(DISTINCT T2.player_id) FROM matches AS T1 JOIN players AS T2 ON T1.loser_id = T2.player_id
SELECT COUNT(DISTINCT loser_name) FROM matches
SELECT T1.first_name, T1.last_name FROM players AS T1 WHERE T1.player_id IN ( SELECT T2.winner_id FROM matches AS T2 WHERE T2.year = 2013 ) AND T1.player_id IN ( SELECT T3.winner_id FROM matches AS T3 WHERE T3.year = 2016 )
SELECT first_name, country_code FROM players ORDER BY birth_date ASC LIMIT 1
SELECT AVG(T2.ranking) as average_ranking, T1.first_name FROM players AS T1 JOIN rankings AS T2 ON T1.player_id = T2.player_id GROUP BY T1.first_name
SELECT T1.first_name, sum(T2.ranking_points) FROM players AS T1 JOIN rankings AS T2 ON T1.player_id = T2.player_id GROUP BY T1.first_name
SELECT T1.first_name, T1.country_code, T1.birth_date FROM players AS T1 JOIN rankings AS T2 ON T1.player_id = T2.player_id WHERE T2.ranking_points = (SELECT max(ranking_points) FROM rankings)
SELECT AVG(injured) FROM death AS T1 JOIN ship AS T2 ON T1.caused_by_ship_id = T2.id
SELECT COUNT(*) FROM Courses
SELECT T1.department_name, T1.department_id FROM Departments AS T1 JOIN Degree_Programs AS T2 ON T1.department_id = T2.department_id GROUP BY T1.department_id ORDER BY count(T2.degree_program_id) DESC LIMIT 1
SELECT T1.course_id, T1.course_name FROM Courses AS T1 JOIN Sections AS T2 ON T1.course_id = T2.course_id GROUP BY T1.course_id, T1.course_name HAVING count(T2.course_id) <= 2
SELECT T2.semester_name, T2.semester_id FROM Student_Enrolment AS T1 JOIN Semesters AS T2 ON T1.semester_id = T2.semester_id GROUP BY T1.semester_id ORDER BY count(T1.student_id) DESC LIMIT 1 This SQL query will return the semester name and id that has the most students registered in.
SELECT department_description FROM Departments WHERE department_name LIKE '%computer%'
SELECT Students.first_name, Students.middle_name, Students.last_name, Students.student_id FROM Students JOIN Student_Enrolment ON Students.student_id = Student_Enrolment.student_id JOIN Degree_Programs ON Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id JOIN Semesters ON Student_Enrolment.semester_id = Semesters.semester_id GROUP BY Students.student_id HAVING COUNT(DISTINCT Degree_Programs.degree_program_id) = 2
SELECT T1.degree_program_id, T1.degree_summary_name, count(T2.student_id) as student_count FROM Degree_Programs AS T1 JOIN Student_Enrolment AS T2 ON T1.degree_program_id = T2.degree_program_id GROUP BY T1.degree_program_id, T1.degree_summary_name ORDER BY student_count DESC LIMIT 1
SELECT T1.semester_name FROM Semesters AS T1 LEFT JOIN Student_Enrolment AS T2 ON T1.semester_id = T2.semester_id WHERE T2.semester_id IS NULL
SELECT DISTINCT Courses.course_name FROM Courses JOIN Student_Enrolment_Courses ON Courses.course_id = Student_Enrolment_Courses.course_id
SELECT Transcripts.transcript_date, Transcripts.transcript_id FROM Transcripts JOIN Transcript_Contents ON Transcripts.transcript_id = Transcript_Contents.transcript_id GROUP BY Transcripts.transcript_id HAVING count(Transcript_Contents.student_course_id) = ( SELECT min(count(Transcript_Contents.student_course_id)) FROM Transcript_Contents GROUP BY Transcript_Contents.transcript_id )
SELECT semester_id FROM Semesters WHERE semester_id IN ( SELECT semester_id FROM Student_Enrolment WHERE degree_program_id IN ( SELECT degree_program_id FROM Degree_Programs WHERE degree_summary_name = 'Masters' ) ) AND semester_id IN ( SELECT semester_id FROM Student_Enrolment WHERE degree_program_id IN ( SELECT degree_program_id FROM Degree_Programs WHERE degree_summary_name = 'Bachelors' ) )
SELECT current_address_id FROM Students) UNION SELECT DISTINCT line_1, line_2, line_3, city, zip_postcode, state_province_county, country FROM Addresses WHERE address_id IN (SELECT permanent_address_id FROM Students)
SELECT Students.student_id, Students.first_name, Students.middle_name, Students.last_name, Students.cell_mobile_number, Students.email_address, Students.ssn, Students.date_first_registered, Students.date_left, Students.other_student_details, Addresses.address_id, Addresses.line_1, Addresses.line_2, Addresses.line_3, Addresses.city, Addresses.zip_postcode, Addresses.state_province_county, Addresses.country, Addresses.other_address_details FROM Students INNER JOIN Addresses ON Students.current_address_id = Addresses.address_id ORDER BY Students.last_name DESC, Students.first_name DESC, Students.middle_name DESC
SELECT section_description FROM Sections WHERE section_name = 'h'
SELECT Title FROM Cartoon JOIN TV_Channel ON Cartoon.Channel = TV_Channel.id ORDER BY Title ASC
SELECT COUNT(id) FROM Cartoon WHERE Written_by = 'Joseph Kuhr'
SELECT Country, COUNT(id) FROM TV_Channel GROUP BY Country ORDER BY COUNT(id) DESC LIMIT 1
SELECT Country, COUNT(id) FROM TV_Channel GROUP BY Country ORDER BY COUNT(id) DESC LIMIT 1
SELECT COUNT(DISTINCT series_name), COUNT(DISTINCT Content) FROM TV_Channel
SELECT Package_Option FROM TV_Channel WHERE series_name = 'Sky Radio'
SELECT Package_Option FROM TV_Channel JOIN TV_series ON TV_Channel.id = TV_series.Channel WHERE series_name = 'Sky Radio'
SELECT Episode FROM TV_series ORDER BY Rating ASC
SELECT Weekly_Rank FROM TV_series WHERE Episode = "A Love of a Lifetime"
SELECT T1.Production_code, T2.id FROM Cartoon AS T1 JOIN TV_Channel AS T2 ON T1.Channel = T2.id WHERE T1.Original_air_date = (SELECT max(Original_air_date) FROM Cartoon)
SELECT Package_Option, series_name FROM TV_Channel WHERE Hight_definition_TV = True
SELECT DISTINCT T1.Country FROM TV_Channel AS T1 LEFT JOIN Cartoon AS T2 ON T1.id = T2.Channel WHERE T2.Channel IS NULL OR T2.Written_by != 'Todd Casey'
SELECT T1.id FROM TV_Channel AS T1 WHERE T1.Country IN ( SELECT T2.Country FROM TV_Channel AS T2 GROUP BY T2.Country HAVING COUNT(T2.id) > 2 )
SELECT COUNT(*) FROM poker_player
SELECT
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID WHERE T2.Earnings > 300000
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID ORDER BY T2.Final_Table_Made ASC
SELECT T1.Birth_Date FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID WHERE T2.Earnings = (SELECT min(Earnings) FROM poker_player)
SELECT T1.Money_Rank FROM poker_player AS T1 JOIN people AS T2 ON T1.People_ID = T2.People_ID WHERE T2.Height = (SELECT max(Height) FROM people)
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID ORDER BY T2.Earnings DESC
SELECT Nationality FROM people GROUP BY Nationality ORDER BY count(*) DESC LIMIT 1
SELECT Nationality FROM people GROUP BY Nationality HAVING count(*) >= 2
SELECT count(DISTINCT state) FROM AREA_CODE_STATE
SELECT max(created) FROM VOTES WHERE state = 'CA'
SELECT count(*) FROM country WHERE GovernmentForm = 'republic'
SELECT SUM(SurfaceArea) FROM country WHERE Region = 'Caribbean'
SELECT Continent FROM country WHERE Name = 'Anguilla'
SELECT avg(LifeExpectancy) FROM country WHERE Region = 'Central Africa'
SELECT Name FROM country WHERE Continent = 'Asia' ORDER BY LifeExpectancy ASC LIMIT 1
SELECT sum(T1.Population), max(T1.GNP) FROM country AS T1 WHERE T1.Continent = 'Asia'
SELECT count(DISTINCT Language) FROM countrylanguage
SELECT count(DISTINCT T1.GovernmentForm) FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T1.Continent = 'Africa'
SELECT Language FROM countrylanguage WHERE CountryCode IN ( SELECT Code FROM country WHERE GovernmentForm = 'Republic' AND Continent IN ('Asia', 'Europe', 'North America', 'Africa', 'Oceania', 'Antarctica', 'South America') ) GROUP BY Language HAVING count(*) = 1
SELECT Language FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE HeadOfState = 'Beatrix'
SELECT count(DISTINCT T2.Language) FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T1.IndepYear < 1930
Select the countries in Asia and Africa. WITH countries AS ( SELECT Code, Name, Continent, Population FROM country WHERE Continent = 'Asia' OR Continent = 'Africa' ), -- Step 2: Select the population of each country. populations AS ( SELECT Code, MAX(Population) AS Population FROM country GROUP BY Code ), -- Step 3: Select the country with the maximum population in Asia and Africa. max_populations AS ( SELECT Continent, MAX(Population) AS Population FROM countries GROUP BY Continent ), -- Step 4: Compare the population of the country with the maximum population in Asia and Africa with the population of any country in Africa. comparison AS ( SELECT c.Name, c.Population FROM countries c JOIN max_populations mp ON c.Continent = mp.Continent WHERE c.Population > mp.Population ) -- Final result SELECT * FROM comparison
SELECT DISTINCT T1.Code FROM country AS T1 LEFT JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T2.CountryCode IS NULL
SELECT DISTINCT T1.Name FROM city AS T1 JOIN country AS T2 ON T1.CountryCode = T2.Code JOIN countrylanguage AS T3 ON T2.Code = T3.CountryCode WHERE T2.Continent = 'Asia' AND T3.Language = 'Chinese' AND T3.IsOfficial = 'T'
SELECT Name, IndepYear, SurfaceArea FROM country WHERE Population = (SELECT min(Population) FROM country)
SELECT Name, Population, HeadOfState FROM country ORDER BY SurfaceArea DESC LIMIT 1
SELECT count(T1.ID) as num_cities, T1.District FROM city AS T1 JOIN country AS T2 ON T1.CountryCode = T2.Code GROUP BY T1.District HAVING T1.Population > (SELECT avg(Population) FROM city)
SELECT T1.District, COUNT(T1.Name) FROM city AS T1 JOIN country AS T2 ON T1.CountryCode = T2.Code WHERE T1.Population > (SELECT AVG(Population) FROM city) GROUP BY T1.District
SELECT statement is also correctly used to select the government form and the total population.
SELECT Name, SurfaceArea FROM country ORDER BY SurfaceArea DESC LIMIT 5
SELECT T1.Name FROM country AS T1 JOIN city AS T2 ON T1.Code = T2.CountryCode GROUP BY T1.Name ORDER BY sum(T2.Population) ASC LIMIT 3
SELECT T1.Code FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T2.Language = 'Spanish' AND T2.IsOfficial = 'T' GROUP BY T1.Code
SELECT COUNT(*) FROM conductor
SELECT Name FROM conductor ORDER BY Age ASC
SELECT Record_Company FROM orchestra ORDER BY Year_of_Founded DESC
SELECT MAX(T1.Share) as max_share, MIN(T1.Share) as min_share FROM performance AS T1 JOIN orchestra AS T2 ON T1.Orchestra_ID = T2.Orchestra_ID JOIN show AS T3 ON T1.Performance_ID = T3.Performance_ID WHERE T1.Type != "Live final"
SELECT Name FROM conductor ORDER BY Year_of_Work DESC LIMIT 1
SELECT T1.Name FROM conductor AS T1 JOIN orchestra AS T2 ON T1.Conductor_ID = T2.Conductor_ID WHERE T2.Year_of_Founded > 2008
SELECT Record_Company, COUNT(Orchestra_ID) FROM orchestra GROUP BY Record_Company
SELECT Record_Company FROM orchestra GROUP BY Record_Company ORDER BY count(Conductor_ID) DESC LIMIT 1
SELECT Orchestra FROM orchestra LEFT JOIN performance ON orchestra.Orchestra_ID = performance.Orchestra_ID WHERE performance.Orchestra_ID IS NULL
SELECT T1.Year_of_Founded FROM orchestra AS T1 JOIN performance AS T2 ON T1.Orchestra_ID = T2.Orchestra_ID JOIN show AS T3 ON T2.Performance_ID = T3.Performance_ID GROUP BY T1.Year_of_Founded HAVING count(DISTINCT T2.Orchestra_ID) > 1
SELECT grade FROM Highschooler WHERE name = 'Kyle'
SELECT ID FROM Highschooler WHERE name = 'Kyle'
SELECT ID FROM Highschooler WHERE name = 'Kyle'
SELECT grade, COUNT(*) FROM Highschooler GROUP BY grade
SELECT grade, COUNT(*) FROM Highschooler GROUP BY grade ORDER BY COUNT(*) DESC LIMIT 1
SELECT student_id, COUNT(*) AS num_friends FROM Friend GROUP BY student_id ) AS FriendCount ON Highschooler.ID = FriendCount.student_id ORDER BY FriendCount.num_friends DESC LIMIT 1
SELECT count(*) FROM Friend WHERE student_id = (SELECT ID FROM Highschooler WHERE name = 'Kyle')
SELECT DISTINCT T1.ID FROM Highschooler AS T1 JOIN Friend AS T2 ON T1.ID = T2.student_id JOIN Likes AS T3 ON T1.ID = T3.student_id
SELECT T1.name FROM Highschooler AS T1 WHERE T1.ID IN ( SELECT T2.friend_id FROM Friend AS T2 WHERE T2.student_id IN ( SELECT T3.liked_id FROM Likes AS T3 WHERE T3.student_id = T1.ID ) )
SELECT Friend.friend_id FROM Friend)
SELECT DISTINCT Owners.state FROM Owners INNER JOIN Professionals ON Owners.state = Professionals.state
SELECT AVG(T1.age) FROM Dogs AS T1 WHERE T1.dog_id IN (SELECT T2.dog_id FROM Treatments AS T2)
SELECT AVG(T1.age) FROM Dogs AS T1 WHERE T1.dog_id IN (SELECT T2.dog_id FROM Treatments AS T2)
SELECT T1.name FROM Dogs AS T1 JOIN Treatments AS T2 ON T1.dog_id = T2.dog_id JOIN Professionals AS T3 ON T2.professional_id = T3.professional_id GROUP BY T1.dog_id HAVING sum(T2.cost_of_treatment) <= 1000
SELECT T1.professional_id, T1.role_code, T1.email_address FROM Professionals AS T1 LEFT JOIN Treatments AS T2 ON T1.professional_id = T2.professional_id WHERE T2.professional_id IS NULL
SELECT T1.professional_id, T1.cell_number FROM Professionals AS T1 JOIN Treatments AS T2 ON T1.professional_id = T2.professional_id JOIN Treatment_Types AS T3 ON T2.treatment_type_code = T3.treatment_type_code GROUP BY T1.professional_id HAVING COUNT(DISTINCT T3.treatment_type_code) >= 2
SELECT Professionals.first_name, Professionals.last_name FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id WHERE Treatments.cost_of_treatment < (SELECT AVG(Treatments.cost_of_treatment) FROM Treatments)
SELECT Treatments.date_of_treatment, Professionals.first_name FROM Treatments JOIN Professionals ON Treatments.professional_id = Professionals.professional_id
SELECT T1.cost_of_treatment, T2.treatment_type_description FROM Treatments AS T1 JOIN Treatment_Types AS T2 ON T1.treatment_type_code = T2.treatment_type_code
SELECT COUNT(DISTINCT T1.dog_id) FROM Dogs AS T1 LEFT JOIN Treatments AS T2 ON T1.dog_id = T2.dog_id WHERE T2.dog_id IS NOT NULL
SELECT COUNT(DISTINCT professional_id) FROM Treatments JOIN Professionals ON Treatments.professional_id = Professionals.professional_id
SELECT first_name, last_name, email_address FROM Owners WHERE state LIKE '%North%'
SELECT count(dog_id) FROM Dogs WHERE dog_id NOT IN (SELECT dog_id FROM Treatments)
SELECT COUNT(DISTINCT professional_id) FROM Professionals WHERE professional_id NOT IN (SELECT professional_id FROM Treatments)
SELECT AVG(age) AS average_age FROM Dogs
SELECT MAX(age) FROM Dogs
SELECT email_address, home_phone, cell_number FROM Professionals
SELECT Name FROM singer ORDER BY Net_Worth_Millions ASC
SELECT Birth_Year, Citizenship FROM singer
SELECT Name FROM singer WHERE Citizenship != 'France'
SELECT Name FROM singer ORDER BY Net_Worth_Millions DESC LIMIT 1
SELECT song.Title, singer.Name FROM song JOIN singer ON song.Singer_ID = singer.Singer_ID
SELECT T1.Name, sum(T2.Sales) FROM singer AS T1 JOIN song AS T2 ON T1.Singer_ID = T2.Singer_ID GROUP BY T1.Name
SELECT property_name FROM Properties JOIN Ref_Property_Types ON Properties.property_type_code = Ref_Property_Types.property_type_code WHERE (Ref_Property_Types.property_type_name = 'House' OR Ref_Property_Types.property_type_name = 'Apartment') AND room_count > 1
