-- Who is the senior most employee based on job title

select title, first_name, last_name
from employee
order by levels desc;



--Which countries have the most Invoices

select  COUNT(*) c, billing_country 
from invoice
group by billing_country
order by  c desc;

--What are top 3 values of total invoice

select total 
from invoice
order by total desc;


-- Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
--Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals


select billing_city, SUM(total) InvoiceTotal
from invoice
group by billing_city
order by InvoiceTotal desc
LIMIT 1;


--Who is the best customer? The customer who has spent the most money will be declared the best customer. 
--Write a query that returns the person who has spent the most money


select c.customer_id, first_name, last_name, SUM(total) total_spending
FROM customer c
JOIN invoice i on c.customer_id = i.customer_id
group by c.customer_id,first_name, last_name
order by total_spending desc
LIMIT 1;



--Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
--Return your list ordered alphabetically by email starting with A

select distinct email,first_name, last_name
from customer c
join invoice i on c.customer_id = i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
where track_id IN(
	select track_id from track t
	join genre g on t.genre_id = g.genre_id
	where g.name LIKE 'Rock'
)
order by email;



--Let's invite the artists who have written the most rock music in our dataset. 
--Write a query that returns the Artist name and total track count of the top 10 rock bands

select a.artist_id, a.name, COUNT(a.artist_id) number_of_songs
from track t
join album al on al.album_id = t.album_id
join artist a on a.artist_id = al.artist_id
join genre g on g.genre_id = t.genre_id
where g.name LIKE 'Rock'
group by a.artist_id, a.name
order by number_of_songs desc;


--Return all the track names that have a song length longer than the average song length. 
--Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first


select name, milliseconds
from track
where milliseconds > (
                    select avg(milliseconds) avg_track_lenghth
					from track
					)
order by milliseconds desc;







