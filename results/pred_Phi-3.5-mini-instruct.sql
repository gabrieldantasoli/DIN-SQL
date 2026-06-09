SELECT COUNT(DISTINCT Singer_ID) FROM singer
SELECT S.Name, COUNT(C.concert_ID) AS NumberOfConcerts FROM stadium AS S JOIN concert AS C ON S.Stadium_ID = C.Stadium_ID GROUP BY S.Name ORDER BY S.Name ASC
SELECT S1.Name, S1.Capacity FROM stadium AS S1 JOIN concert AS C1 ON S1.Stadium_ID = C1.Stadium_ID WHERE C1.Year >= 2014 GROUP BY S1.Stadium_ID ORDER BY COUNT(*) DESC LIMIT 1
SELECT Year, COUNT(*) as num_concerts FROM concert GROUP BY Year ORDER BY num_concerts DESC LIMIT 1
SELECT singer.Name, singer.Country FROM singer JOIN singer_in_concert ON singer.Singer_ID = singer_in_concert.Singer_ID JOIN concert ON singer_in_concert.concert_ID = concert.concert_ID WHERE singer.Song_Name LIKE '%Hey%'
SELECT COUNT(DISTINCT concert.concert_ID) FROM concert JOIN stadium ON concert.Stadium_ID = stadium.Stadium_ID WHERE stadium.Capacity = (SELECT MAX(Capacity) FROM stadium)
SELECT COUNT(DISTINCT T1.PetID) FROM Has_Pet AS T1 JOIN Student AS T2 ON T1.StuID = T2.StuID WHERE T2.Age > 20
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT DISTINCT Fname FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType IN ('cat', 'dog')
SELECT Has_Pet.StuID FROM Has_Pet LEFT JOIN Pets ON Has_Pet.PetID = Pets.PetID AND Pets.PetType = 'cats' WHERE Pets.PetID IS NULL
SELECT Pets.PetID, Pets.weight FROM Pets WHERE Pets.pet_age > 1
SELECT Pets.PetType, AVG(Pets.pet_age) AS average_age, MAX(Pets.pet_age) AS maximum_age FROM Pets GROUP BY Pets.PetType
SELECT PetType, AVG(weight) FROM Pets GROUP BY PetType
SELECT PetID FROM Has_Pet WHERE StuID IN (SELECT StuID FROM Student WHERE LName = 'Smith')
SELECT COUNT(*) FROM continents
SELECT COUNT(DISTINCT countries.CountryName) FROM countries
SELECT model_list.Model FROM model_list JOIN car_names ON model_list.Model = car_names.Model JOIN car_makers ON car_names.Make = car_makers.Id JOIN cars_data ON car_names.MakeId = cars_data.Id WHERE cars_data.Weight < (SELECT AVG(Weight) FROM cars_data)
SELECT continents.Continent, COUNT(DISTINCT car_makers.FullName) AS NumberOfCarMakers FROM car_makers JOIN countries ON car_makers.Country = countries.CountryId JOIN continents ON countries.Continent = continents.ContId GROUP BY continents.Continent This fixed SQL query correctly joins the `car_makers` table with the `countries` table using the foreign key relationship, then joins the `countries` table with the `continents` table using the foreign key relationship. It groups the results by the continent and counts the distinct car makers in each continent. The `DISTINCT` keyword ensures that each car maker is counted only once per continent.
SELECT car_makers.Id, car_makers.FullName, COUNT(car_names.Model) AS model_count FROM car_makers JOIN car_names ON car_makers.Id = car_names.MakeId GROUP BY car_makers.Id, car_makers.FullName This fixed SQL query correctly groups the results by the maker's Id and FullName, and counts the number of car models produced by each maker. The JOIN is correctly performed using the foreign key relationship between car_makers and car_names. The GROUP BY clause is also correctly specified to include only the necessary columns.
SELECT model_list.Model FROM model_list JOIN car_names ON model_list.ModelId = car_names.Model JOIN cars_data ON car_names.MakeId = cars_data.Id WHERE cars_data.MPG = (SELECT MAX(MPG) FROM cars_data)
SELECT model_list.Model, COUNT(DISTINCT car_names.Make) AS version_count FROM model_list JOIN car_names ON model_list.Model = car_names.Model JOIN car_makers ON car_names.Make = car_makers.Id GROUP BY model_list.Model ORDER BY version_count DESC LIMIT 1
SELECT COUNT(DISTINCT cars_data.Id) FROM cars_data JOIN car_names ON cars_data.Id = car_names.MakeId JOIN model_list ON car_names.Model = model_list.Model JOIN car_makers ON model_list.Maker = car_makers.Id JOIN countries ON car_makers.Country = countries.CountryId JOIN continents ON countries.Continent = continents.ContId WHERE cars_data.Year = 1980
SELECT car_makers.Name, car_makers.Id FROM car_makers JOIN model_list ON car_makers.Id = model_list.Maker GROUP BY car_makers.Id HAVING COUNT(DISTINCT model_list.Model) > 3
SELECT DISTINCT model_list.Model FROM model_list JOIN car_makers ON model_list.Maker = car_makers.Id JOIN countries ON car_makers.Country = countries.CountryId JOIN cars_data ON car_names.MakeId = cars_data.Id WHERE car_makers.Country = (SELECT CountryId FROM countries WHERE CountryName = 'General Motors') AND cars_data.Weight > 3500
SELECT DISTINCT Year FROM cars_data WHERE Weight BETWEEN 3000 AND 4000
SELECT DISTINCT Year FROM cars_data WHERE Weight < 4000 UNION SELECT DISTINCT Year FROM cars_data WHERE Weight > 3000
SELECT cars_data.Horsepower FROM cars_data JOIN ( SELECT car_names.MakeId FROM cars_data JOIN car_names ON cars_data.Id = car_names.MakeId ORDER BY cars_data.Accelerate DESC LIMIT 1 ) AS top_accelerate_car ON cars_data.Id = top_accelerate_car.MakeId
SELECT min(C2.Cylinders) FROM cars_data AS C2 JOIN car_names AS C3 ON C2.Id = C3.MakeId WHERE C3.Model = 'Volvo' AND C2.Accelerate = ( SELECT min(C2_inner.Accelerate) FROM cars_data AS C2_inner JOIN car_names AS C3_inner ON C2_inner.Id = C3_inner.MakeId WHERE C3_inner.Model = 'Volvo' )
SELECT COUNT(DISTINCT cars_data.Id) FROM cars_data JOIN car_names ON cars_data.Id = car_names.MakeId WHERE cars_data.Cylinders > 6
SELECT countries.CountryId, countries.CountryName FROM countries JOIN car_makers ON countries.CountryId = car_makers.Country WHERE countries.CountryId IN ( SELECT DISTINCT countries.CountryId FROM countries JOIN car_makers ON countries.CountryId = car_makers.Country GROUP BY countries.CountryId HAVING COUNT(car_makers.Id) > 3 ) OR countries.CountryId IN ( SELECT DISTINCT countries.CountryId FROM countries JOIN car_makers ON countries.CountryId = car_makers.Country JOIN car_names ON car_makers.Id = car_names.MakeId WHERE car_names.Make = 'Fiat' ) GROUP BY countries.CountryId, countries.CountryName
SELECT airlines.Country FROM airlines WHERE airlines.Airline = 'JetBlue Airways'
SELECT Abbreviation FROM airlines WHERE Airline = 'JetBlue Airways'
SELECT COUNT(DISTINCT Airline) FROM airlines
SELECT COUNT(*) FROM flights
SELECT COUNT(DISTINCT airlines.uid) FROM airlines JOIN airports ON airlines.Abbreviation = airports.CountryAbbrev WHERE airports.Country = 'USA'
SELECT City, Country FROM airports WHERE AirportCode = 'Alton'
SELECT AirportName FROM airports WHERE AirportCode = 'AKO'
SELECT COUNT(*) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen'
SELECT COUNT(*) FROM flights JOIN airports AS DestAirport ON flights.DestAirport = DestAirport.AirportCode WHERE DestAirport.City = 'Ashley' AND flights.SourceAirport IN ( SELECT AirportCode FROM airports WHERE City = 'Aberdeen' )
SELECT airports.City, COUNT(*) as frequency FROM airports JOIN flights ON airports.AirportCode = flights.DestAirport GROUP BY airports.City ORDER BY frequency DESC LIMIT 1
SELECT airports.AirportCode FROM airports JOIN flights ON airports.AirportCode = flights.DestAirport GROUP BY airports.AirportCode ORDER BY COUNT(*) DESC LIMIT 1
SELECT A1.Abbreviation, A1.Country FROM airlines AS A1 JOIN ( SELECT airline, COUNT(*) AS flight_count FROM flights GROUP BY airline ORDER BY flight_count ASC LIMIT 1 ) AS A2 ON A1.Airline = A2.airline
SELECT Airline FROM airlines JOIN (SELECT Airline FROM flights GROUP BY Airline HAVING COUNT(*) >= 10) AS subquery ON airlines.Airline = subquery.Airline
SELECT DISTINCT flights.FlightNo FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.AirportName = 'APG'
SELECT DISTINCT flights.FlightNo FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen'
SELECT COUNT(DISTINCT flights.FlightNo) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City IN ('Aberdeen', 'Abilene')
SELECT COUNT(DISTINCT flights.FlightNo) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City IN ('Aberdeen', 'Abilene')
SELECT Name FROM employee ORDER BY Age ASC
SELECT City, COUNT(DISTINCT employee.Employee_ID) AS NumberOfEmployees FROM employee GROUP BY City
SELECT Location, COUNT(*) AS NumberOfShops FROM shop GROUP BY Location
SELECT MIN(Number_products), MAX(Number_products) FROM shop
SELECT MIN(Number_products), MAX(Number_products) FROM shop
SELECT Name, Location, District FROM shop ORDER BY Number_products DESC
SELECT SUM(evaluation.Bonus) AS TotalBonus FROM evaluation
SELECT SUM(Bonus) FROM evaluation
SELECT * FROM hiring
SELECT COUNT(*) FROM Documents
SELECT Documents.Document_Name, Templates.Template_ID FROM Documents JOIN Templates ON Documents.Template_ID = Templates.Template_ID WHERE Documents.Document_Description LIKE '%w%'
SELECT D.Document_ID, T.Template_ID, T.Template_Description FROM Documents AS D JOIN Templates AS T ON D.Template_ID = T.Template_ID WHERE D.Document_Name = 'Robbin CV'
SELECT T1.Template_ID, T1.Template_Type_Code FROM Templates AS T1 INNER JOIN Documents AS T2 ON T1.Template_ID = T2.Template_ID GROUP BY T1.Template_ID, T1.Template_Type_Code HAVING COUNT(T2.Template_ID) = ( SELECT MAX(counts) FROM ( SELECT COUNT(T2.Template_ID) AS counts FROM Templates AS T1 INNER JOIN Documents AS T2 ON T1.Template_ID = T2.Template_ID GROUP BY T1.Template_ID, T1.Template_Type_Code ) AS subquery )
SELECT T1.Template_ID FROM Templates AS T1 GROUP BY T1.Template_ID HAVING COUNT(DISTINCT T1.Template_ID) > 1
SELECT DISTINCT Ref_Template_Types.Template_Type_Code FROM Ref_Template_Types JOIN Templates ON Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code
SELECT DISTINCT Template_Type_Code FROM Ref_Template_Types
SELECT Template_ID FROM Templates WHERE Template_Type_Code IN ('PP', 'PPT')
SELECT Template_ID FROM Templates WHERE Template_Type_Code IN ('PP', 'PPT')
SELECT Version_Number, Template_Type_Code FROM Templates WHERE Version_Number > 5
SELECT Version_Number, Template_Type_Code FROM Templates WHERE Version_Number > 5
SELECT Ref_Template_Types.Template_Type_Code, COUNT(Templates.Template_ID) AS NumberOfTemplates FROM Ref_Template_Types JOIN Templates ON Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code GROUP BY Ref_Template_Types.Template_Type_Code This query correctly lists all template type codes and the number of templates associated with each code, using the GROUP BY clause on the Template_Type_Code column from the Ref_Template_Types table. The COUNT function is used to count the number of Template_ID entries for each Template_Type_Code, and the result is aliased as NumberOfTemplates for clarity.
SELECT Ref_Template_Types.Template_Type_Code, COUNT(*) as Template_Count FROM Templates JOIN Ref_Template_Types ON Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code GROUP BY Ref_Template_Types.Template_Type_Code ORDER BY Template_Count DESC LIMIT 1
SELECT Template_Type_Code FROM (SELECT Template_Type_Code, COUNT(*) AS template_count FROM Templates GROUP BY Template_Type_Code HAVING template_count < 3) AS subquery
SELECT Ref_Template_Types.Template_Type_Code FROM Templates JOIN Documents ON Templates.Template_ID = Documents.Template_ID WHERE Documents.Document_Name = 'Data base'
SELECT Template_Type_Code, Template_Type_Description FROM Ref_Template_Types
SELECT DISTINCT Paragraphs.Paragraph_Text FROM Paragraphs JOIN Documents ON Paragraphs.Document_ID = Documents.Document_ID WHERE Documents.Document_Name = 'Customer reviews'
SELECT COUNT(DISTINCT teacher.Teacher_ID) FROM teacher
SELECT COUNT(DISTINCT teacher.Teacher_ID) FROM teacher
SELECT name FROM teacher ORDER BY age ASC
SELECT teacher.Age, teacher.Hometown FROM teacher
SELECT DISTINCT Name FROM teacher WHERE Hometown != 'Little Lever Urban District'
SELECT t.hometown, COUNT(*) as frequency FROM teacher t JOIN course_arrange ca ON t.Teacher_ID = ca.Teacher_ID GROUP BY t.hometown ORDER BY frequency DESC LIMIT 1
SELECT t1.Hometown FROM teacher t1 JOIN course_arrange ca ON t1.Teacher_ID = ca.Teacher_ID GROUP BY t1.Hometown HAVING COUNT(DISTINCT t1.Teacher_ID) > 1
SELECT DISTINCT T1.Name FROM teacher AS T1 JOIN course_arrange AS T2 ON T1.Teacher_ID = T2.Teacher_ID JOIN course AS T3 ON T2.Course_ID = T3.Course_ID WHERE T3.Course = 'Math'
SELECT visitor.Name, visitor.Level_of_membership FROM visitor JOIN visit ON visitor.ID = visit.visitor_ID WHERE visitor.Level_of_membership > 4 ORDER BY visitor.Age DESC
SELECT AVG(Num_of_Staff) FROM museum WHERE Open_Year < 2009
SELECT T1.Museum_ID, T1.Name FROM museum AS T1 JOIN ( SELECT Museum_ID, COUNT(*) AS visit_count FROM visit GROUP BY Museum_ID ) AS T2 ON T1.Museum_ID = T2.Museum_ID WHERE T2.visit_count = ( SELECT MAX(visit_count) FROM ( SELECT Museum_ID, COUNT(*) AS visit_count FROM visit GROUP BY Museum_ID ) AS subquery ) This fixed query correctly joins the `museum` table with a subquery that calculates the number of visits (`visit_count`) for each museum. It then filters the results to only include the museum(s) with the maximum number of visits by comparing `visit_count` with the maximum value obtained from the same subquery. The `GROUP BY` clause is used only once in the subquery, and the `SELECT` statement returns the `Museum_ID` and `Name` of the museum(s) visited most times.
SELECT SUM(visit.Num_of_Ticket) AS Total_Ticket_Expense FROM visit JOIN visitor ON visit.visitor_ID = visitor.ID WHERE visitor.Level_of_membership = 1
SELECT COUNT(*) FROM players
SELECT first_name, birth_date FROM players WHERE country_code = 'USA'
SELECT COUNT(DISTINCT loser_name) FROM matches JOIN players ON matches.loser_id = players.player_id GROUP BY loser_name
SELECT COUNT(DISTINCT loser_name) FROM matches
SELECT first_name, last_name FROM players WHERE player_id IN ( SELECT winner_id FROM matches WHERE tourney_year IN (2013, 2016) GROUP BY winner_id HAVING COUNT(DISTINCT tourney_year) = 2 )
SELECT first_name, country_code FROM players ORDER BY birth_date ASC LIMIT 1
SELECT players.first_name, AVG(rankings.ranking) AS average_ranking FROM rankings JOIN players ON rankings.player_id = players.player_id GROUP BY players.first_name ORDER BY players.first_name ASC
SELECT T1.first_name, SUM(T2.ranking_points) AS total_ranking_points FROM players AS T1 JOIN rankings AS T2 ON T1.player_id = T2.player_id GROUP BY T1.first_name
SELECT players.first_name, players.country_code, players.birth_date FROM players JOIN ( SELECT winner_id, MAX(winner_rank_points) AS max_rank_points FROM matches GROUP BY winner_id ) AS max_winners ON players.player_id = max_winners.winner_id ORDER BY max_winners.max_rank_points DESC LIMIT 1
SELECT AVG(killed) FROM death JOIN ship ON death.caused_by_ship_id = ship.id WHERE death.caused_by_ship_id IN (SELECT battle.id FROM battle JOIN ship ON battle.id = ship.lost_in_battle)
SELECT COUNT(DISTINCT course_id) FROM Courses
SELECT D.department_name, D.department_id FROM Departments D INNER JOIN ( SELECT DP.department_id, COUNT(*) AS num_degrees FROM Degree_Programs DP GROUP BY DP.department_id ORDER BY num_degrees DESC LIMIT 1 ) AS T1 ON D.department_id = T1.department_id This fixed SQL query correctly joins the Departments table with a subquery that counts the number of degrees per department, orders the results by the count in descending order, and limits the result to the top department. It then selects the department name and id of the department with the most degrees.
SELECT Courses.course_name, Courses.course_id FROM Courses JOIN ( SELECT course_id FROM Sections GROUP BY course_id HAVING COUNT(section_id) <= 2 ) AS SubQuery ON Courses.course_id = SubQuery.course_id
SELECT Semesters.semester_name, Semesters.semester_id FROM Semesters INNER JOIN ( SELECT Student_Enrolment.semester_id, COUNT(*) AS enrolment_count FROM Student_Enrolment GROUP BY Student_Enrolment.semester_id ORDER BY enrolment_count DESC LIMIT 1 ) AS MostEnrolledSemester ON Semesters.semester_id = MostEnrolledSemester.semester_id This fixed SQL query correctly joins the Semesters table with a subquery that calculates the number of student enrolments per semester, orders the results by the count in descending order, and limits the result to the top semester. It then selects the semester name and ID from the Semesters table where the semester ID matches the ID from the subquery. This ensures that we get the semester with the most student registrations, along with its name and ID.
SELECT department_description FROM Departments WHERE department_name LIKE '%the computer%'
SELECT S.student_id, S.first_name, S.middle_name, S.last_name FROM Students S JOIN Student_Enrolment E ON S.student_id = E.student_id JOIN Semesters SE ON E.semester_id = SE.semester_id GROUP BY S.student_id, S.first_name, S.middle_name, S.last_name HAVING COUNT(DISTINCT E.degree_program_id) = 2
SELECT D1.degree_program_id, D1.degree_summary_name, COUNT(SE.degree_program_id) AS enrolment_count FROM Degree_Programs AS D1 JOIN Student_Enrolment AS SE ON D1.degree_program_id = SE.degree_program_id GROUP BY D1.degree_program_id, D1.degree_summary_name ORDER BY enrolment_count DESC LIMIT 1
SELECT Semesters.semester_name FROM Semesters WHERE NOT EXISTS ( SELECT 1 FROM Student_Enrolment WHERE Student_Enrolment.semester_id = Semesters.semester_id )
SELECT Courses.course_name FROM Courses WHERE EXISTS ( SELECT 1 FROM Student_Enrolment_Courses WHERE Student_Enrolment_Courses.course_id = Courses.course_id )
SELECT Transcripts.transcript_id, Transcripts.transcript_date FROM Transcripts JOIN Transcript_Contents ON Transcripts.transcript_id = Transcript_Contents.transcript_id GROUP BY Transcripts.transcript_date ORDER BY COUNT(Transcript_Contents.transcript_id) ASC LIMIT 1
SELECT DISTINCT Semesters.semester_id FROM Semesters JOIN Student_Enrolment ON Semesters.semester_id = Student_Enrolment.semester_id JOIN Degree_Programs ON Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id WHERE Degree_Programs.degree_summary_name IN ('Masters', 'Bachelors') GROUP BY Semesters.semester_id HAVING COUNT(DISTINCT Degree_Programs.degree_summary_name) = 2
SELECT DISTINCT T1.city FROM Addresses AS T1 JOIN Students AS T2 ON T1.address_id = T2.permanent_address_id OR T1.address_id = T2.current_address_id
SELECT last_name, first_name, cell_mobile_number, email_address, ssn, date_first_registered, date_left, other_student_details FROM Students ORDER BY last_name DESC, first_name DESC
SELECT section_description FROM Sections WHERE section_name = 'h'
SELECT Title FROM Cartoon ORDER BY Title ASC
SELECT COUNT(DISTINCT Cartoon.id) FROM Cartoon WHERE Directed_by = 'Joseph Kuhr'
SELECT Country, COUNT(id) AS NumberOfTVChannels FROM TV_Channel GROUP BY Country ORDER BY COUNT(id) DESC LIMIT 1
SELECT Country, COUNT(id) AS num_channels FROM TV_Channel GROUP BY Country ORDER BY num_channels DESC LIMIT 1
SELECT COUNT(DISTINCT series_name, Content) FROM TV_Channel
SELECT Package_Option FROM TV_Channel WHERE series_name = 'Sky Radio'
SELECT DISTINCT Package_Option FROM TV_Channel WHERE series_name = 'Sky Radio'
SELECT Episode FROM TV_series ORDER BY Rating
SELECT DISTINCT Weekly_Rank FROM TV_series WHERE Episode = 'A Love of a Lifetime'
SELECT Cartoon.Production_code, TV_Channel.id FROM Cartoon JOIN TV_Channel ON Cartoon.Channel = TV_Channel.id JOIN TV_series ON Cartoon.id = TV_series.Cartoon_id ORDER BY TV_series.Air_Date DESC LIMIT 1
SELECT TV_Channel.Package_Option, TV_Channel.series_name FROM TV_Channel JOIN TV_series ON TV_Channel.id = TV_series.Channel WHERE TV_Channel.Hight_definition_TV = 1
SELECT DISTINCT Country FROM TV_Channel JOIN Cartoon ON TV_Channel.id = Cartoon.Channel WHERE Cartoon.Directed_by = 'Todd Casey'
SELECT TV_Channel.id FROM TV_Channel GROUP BY TV_Channel.Country HAVING COUNT(*) > 2
SELECT COUNT(DISTINCT poker_player.People_ID) FROM poker_player
SELECT AVG(poker_player.Earnings) FROM poker_player
SELECT DISTINCT T2.Name FROM poker_player AS T1 JOIN people AS T2 ON T1.People_ID = T2.People_ID WHERE T1.Earnings > 300000
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID GROUP BY T1.Name ORDER BY COUNT(T2.Poker_Player_ID) ASC
SELECT people.Birth_Date FROM people JOIN poker_player ON people.People_ID = poker_player.People_ID ORDER BY poker_player.Earnings ASC LIMIT 1
SELECT DISTINCT poker_player.Money_Rank FROM poker_player JOIN people ON poker_player.People_ID = people.People_ID WHERE people.Height = (SELECT MAX(height) FROM people)
SELECT T1.Name FROM poker_player AS T1 JOIN people AS T2 ON T1.People_ID = T2.People_ID ORDER BY T1.earnings DESC
SELECT Nationality, COUNT(*) as frequency FROM people GROUP BY Nationality ORDER BY frequency DESC LIMIT 1
SELECT Nationality FROM people GROUP BY Nationality HAVING COUNT(*) > 1
SELECT COUNT(DISTINCT AREA_CODE_STATE.state) FROM AREA_CODE_STATE
SELECT MAX(created) FROM VOTES JOIN AREA_CODE_STATE ON VOTES.state = AREA_CODE_STATE.state WHERE AREA_CODE_STATE.state = 'CA'
SELECT COUNT(DISTINCT country.Code) FROM country WHERE FormOfGovernment = 'Republic'
SELECT SUM(country.SurfaceArea) FROM country WHERE Region = 'Caribbean'
SELECT country.Continent FROM country JOIN city ON country.Code = city.CountryCode WHERE city.CountryCode = 'Anguilla'
SELECT AVG(LifeExpectancy) FROM country WHERE Continent = 'Central Africa'
SELECT c.Name FROM country c JOIN ( SELECT CountryCode FROM countrylanguage GROUP BY CountryCode ORDER BY MIN(LifeExpectancy) ASC ) cl ON c.Code = cl.CountryCode WHERE c.Continent = "Asia" LIMIT 1
SELECT COUNT(DISTINCT c.Population) AS population_in_asia, MAX(co.GNP) AS largest_gnp FROM city AS c JOIN country AS co ON c.CountryCode = co.Code WHERE co.Continent = 'Asia' GROUP BY co.Code
SELECT COUNT(DISTINCT Language) FROM countrylanguage
SELECT COUNT(DISTINCT T2.GovernmentForm) FROM countrylanguage AS T1 JOIN country AS T2 ON T1.CountryCode = T2.Code WHERE T2.Continent = 'Africa'
SELECT Language FROM countrylanguage WHERE IsOfficial = 1 AND CountryCode IN ( SELECT Code FROM country WHERE GovernmentForm = 'republic' ) GROUP BY Language HAVING COUNT(*) = 1
SELECT DISTINCT countrylanguage.Language FROM countrylanguage JOIN country ON countrylanguage.CountryCode = country.Code WHERE country.Name = 'Beatrix' AND countrylanguage.IsOfficial = 1
SELECT COUNT(DISTINCT Language) FROM countrylanguage JOIN country ON countrylanguage.CountryCode = country.Code WHERE country.IndepYear < 1930
SELECT c.Name FROM country AS c JOIN ( SELECT MAX(Population) AS MaxPopulationAfrica FROM country WHERE Continent = 'Africa' ) AS max_africa ON c.Population > max_africa.MaxPopulationAfrica WHERE c.Continent = 'Asia'
SELECT country.Code FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.IsOfficial = 1 AND countrylanguage.Percentage < 1 AND countrylanguage.Language != 'English'
SELECT DISTINCT city.Name FROM city JOIN countrylanguage ON city.CountryCode = countrylanguage.CountryCode JOIN country ON city.CountryCode = country.Code WHERE countrylanguage.IsOfficial = 1 AND country.Continent = 'Asia'
SELECT Name, IndependYear, SurfaceArea FROM country WHERE Population = (SELECT min(Population) FROM country)
SELECT Name, Population, HeadOfState FROM country WHERE Code = (SELECT Code FROM country ORDER BY Area_km_2 DESC LIMIT 1)
SELECT COUNT(DISTINCT city.ID) AS NumberOfCities, city.District FROM city WHERE city.Population > (SELECT AVG(Population) FROM city) GROUP BY city.District ORDER BY NumberOfCities DESC
SELECT District, COUNT(*) FROM city WHERE Population > (SELECT AVG(Population) FROM city) GROUP BY District
SELECT GovernmentForm, SUM(Population) FROM country WHERE GovernmentForm IN ( SELECT GovernmentForm FROM country GROUP BY GovernmentForm HAVING AVG(LifeExpectancy) > 72 ) GROUP BY GovernmentForm
SELECT country.Name, country.SurfaceArea FROM country ORDER BY country.SurfaceArea DESC LIMIT 5
SELECT DISTINCT country.Name FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode ORDER BY country.Population ASC LIMIT 3
SELECT DISTINCT T2.Code FROM countrylanguage AS T1 JOIN country AS T2 ON T1.CountryCode = T2.Code WHERE T1.Language = 'Spanish'
SELECT COUNT(DISTINCT conductor.Conductor_ID) FROM conductor
SELECT Name FROM conductor ORDER BY Age ASC
SELECT Record_Company FROM orchestra ORDER BY Year_of_Founded DESC
SELECT MAX(Share), MIN(Share) FROM performance WHERE Type != 'Live final'
SELECT Name FROM conductor ORDER BY Year_of_Work DESC LIMIT 1
SELECT DISTINCT T1.Name FROM conductor AS T1 JOIN orchestra AS T2 ON T1.Conductor_ID = T2.Conductor_ID WHERE T2.Year_of_Founded > 2008
SELECT Record_Company, COUNT(DISTINCT Orchestra_ID) AS NumberOfOrchestras FROM orchestra GROUP BY Record_Company ORDER BY NumberOfOrchestras DESC
SELECT Record_Company FROM orchestra GROUP BY Record_Company ORDER BY COUNT(*) DESC LIMIT 1
SELECT Orchestra FROM orchestra WHERE Orchestra_ID NOT IN (SELECT Orchestra_ID FROM performance)
SELECT Year_of_Founded FROM orchestra WHERE Orchestra_ID IN ( SELECT Orchestra_ID FROM performance GROUP BY Orchestra_ID HAVING COUNT(*) > 1 )
SELECT grade FROM Highschooler WHERE name = 'Kyle'
SELECT ID FROM Highschooler WHERE name = 'Kyle'
SELECT Highschooler.ID FROM Highschooler WHERE Highschooler.name = 'Kyle'
SELECT grade, COUNT(*) AS num_highschoolers FROM Highschooler GROUP BY grade
SELECT Highschooler.grade, COUNT(*) as num_students FROM Highschooler GROUP BY Highschooler.grade ORDER BY num_students DESC LIMIT 1
SELECT T1.name FROM Highschooler AS T1 JOIN ( SELECT F.student_id, COUNT(*) AS friend_count FROM Friend AS F GROUP BY F.student_id ORDER BY friend_count DESC LIMIT 1 ) AS T2 ON T1.ID = T2.student_id
SELECT COUNT(*) FROM Friend WHERE friend_id = (SELECT ID FROM Highschooler WHERE name = 'Kyle')
SELECT DISTINCT T1.ID FROM Highschooler AS T1 JOIN Friend AS F1 ON T1.ID = F1.student_id JOIN Likes AS L1 ON F1.friend_id = L1.liked_id
SELECT DISTINCT H1.name FROM Highschooler AS H1 JOIN Friend AS F ON H1.ID = F.student_id JOIN Likes AS L ON H1.ID = L.liked_id GROUP BY H1.name
SELECT min(grade) FROM Highschooler WHERE ID NOT IN (SELECT student_id FROM Friend)
SELECT DISTINCT O1.state FROM Owners AS O1 JOIN Professionals AS P1 ON O1.state = P1.state
SELECT AVG(Dogs.age) FROM Dogs JOIN Treatments ON Dogs.dog_id = Treatments.dog_id GROUP BY Dogs.dog_id
SELECT AVG(Dogs.age) FROM Dogs JOIN Treatments ON Dogs.dog_id = Treatments.dog_id GROUP BY Dogs.dog_id
SELECT Dogs.name FROM Dogs JOIN Treatments ON Dogs.dog_id = Treatments.dog_id JOIN Professionals ON Treatments.professional_id = Professionals.professional_id WHERE Treatments.cost_of_treatment <= 1000
SELECT professional_id, role_code, email_address FROM Professionals WHERE professional_id NOT IN (SELECT DISTINCT professional_id FROM Treatments)
SELECT professionals.professional_id, professionals.cell_number FROM professionals JOIN ( SELECT treatments.professional_id FROM treatments GROUP BY treatments.professional_id HAVING COUNT(DISTINCT treatments.treatment_type_code) >= 2 ) AS subquery ON professionals.professional_id = subquery.professional_id
SELECT first_name, last_name FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id WHERE cost_of_treatment < (SELECT AVG(cost_of_treatment) FROM Treatments)
SELECT Treatments.date_of_treatment, Professionals.first_name FROM Treatments JOIN Professionals ON Treatments.professional_id = Professionals.professional_id
SELECT T1.cost_of_treatment, T2.treatment_type_description FROM Treatments AS T1 JOIN Treatment_Types AS T2 ON T1.treatment_type_code = T2.treatment_type_code
SELECT COUNT(DISTINCT Dogs.dog_id) FROM Dogs INNER JOIN Treatments ON Dogs.dog_id = Treatments.dog_id
SELECT COUNT(DISTINCT T2.professional_id) FROM Treatments AS T2 JOIN Professionals AS T1 ON T2.professional_id = T1.professional_id
SELECT first_name, last_name, email_address FROM Owners WHERE state LIKE '%North%'
SELECT COUNT(*) FROM Dogs WHERE dog_id NOT IN (SELECT dog_id FROM Treatments)
SELECT COUNT(DISTINCT professional_id) FROM professionals WHERE professional_id NOT IN (SELECT professional_id FROM treatments)
SELECT AVG(age) FROM Dogs
SELECT MAX(age) FROM Dogs
SELECT email_address, home_phone, cell_number FROM Professionals
SELECT DISTINCT singer.Name FROM singer ORDER BY singer.Net_Worth_Millions ASC
SELECT DISTINCT singer.Birth_Year, singer.Citizenship FROM singer
SELECT DISTINCT Name FROM singer WHERE Citizenship <> 'France'
SELECT s.Name FROM singer s ORDER BY s.Net_Worth_Millions DESC LIMIT 1
SELECT song.Title, singer.Name FROM song JOIN singer ON song.Singer_ID = singer.Singer_ID
SELECT S1.Name, SUM(S2.Sales) AS TotalSales FROM singer AS S1 JOIN song AS S2 ON S1.Singer_ID = S2.Singer_ID GROUP BY S1.Name
SELECT DISTINCT property_name FROM Properties JOIN Ref_Property_Types ON Properties.property_type_code = Ref_Property_Types.property_type_code WHERE (Ref_Property_Types.property_type_description = 'house' OR Ref_Property_Types.property_type_description = 'apartment') AND Properties.room_count > 1
