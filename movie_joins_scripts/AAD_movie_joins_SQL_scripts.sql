--1. Give the name, release year, and worldwide gross of the lowest grossing movie.

SELECT specs.film_title, specs.release_year, revenue.worldwide_gross
FROM specs
INNER JOIN revenue
ON specs.movie_id = revenue.movie_id
ORDER BY worldwide_gross;

--ANSWER Semi-Tough, 1977, 37187139

--2. What year has the highest average imdb rating?

SELECT specs.release_year, AVG(rating.imdb_rating) AS avg_imdb_rating
FROM specs
INNER JOIN rating
ON specs.movie_id = rating.movie_id
GROUP BY specs.release_year 
ORDER BY avg_imdb_rating DESC;

--ANSWER 1991

--3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT specs.film_title, specs.mpaa_rating, revenue.worldwide_gross, distributors.company_name
FROM specs
INNER JOIN revenue
ON specs.movie_id = revenue.movie_id
INNER JOIN distributors
ON specs.domestic_distributor_id = distributors.distributor_id
WHERE mpaa_rating = 'G'
ORDER BY worldwide_gross DESC;

--ANSWER Toy Story 4, distributed by Walt Disney

--4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

SELECT distributors.company_name, COUNT(specs.film_title)
FROM distributors
LEFT JOIN specs
ON distributors.distributor_id = specs.domestic_distributor_id
GROUP BY distributors.company_name
ORDER BY company_name;

--ANSWER 
--"American International Pictures"	1
-- "Columbia Pictures"	15
-- "DreamWorks"	17
-- "Fox Searchlight Pictures"	1
-- "Icon Productions"	1

--5. Write a query that returns the five distributors with the highest average movie budget.

SELECT distributors.company_name, AVG(revenue.film_budget) AS avg_film_budget
FROM distributors
INNER JOIN specs
ON distributors.distributor_id = specs.domestic_distributor_id
INNER JOIN revenue
ON specs.movie_id = revenue.movie_id
GROUP BY distributors.company_name
ORDER BY avg_film_budget DESC;

--ANSWER Walt Disney, Sony Pictures, Lionsgate, DreamWorks, Warner Bros.

--6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT distributors.company_name, distributors.headquarters, COUNT(specs.film_title), specs.film_title, rating.imdb_rating
FROM distributors
INNER JOIN specs
ON distributors.distributor_id = specs.domestic_distributor_id
INNER JOIN rating
ON specs.movie_id = rating.movie_id
WHERE headquarters NOT iLIKE '%CA'
GROUP BY distributors.company_name, distributors.headquarters, specs.film_title, rating.imdb_rating
ORDER BY rating.imdb_rating DESC;

--ANSWER 2 not headquarterd in CA, Dirty Dancing is highest rated

--7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

SELECT ROUND(AVG(rating.imdb_rating), 2) AS avg_rating,
CASE
	WHEN length_in_min > 120 THEN '>2 Hours'
	ELSE '< 120'
END AS lengthtext
FROM specs
INNER JOIN rating
ON specs.movie_id = rating.movie_id
GROUP BY lengthtext
ORDER BY avg_rating DESC;

--ANSWER movies >2 hours have a higher average rating