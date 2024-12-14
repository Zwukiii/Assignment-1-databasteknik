/*
1.1 retrieves all artists with the same first letter as me.
*/
SELECT * 
FROM Artist
WHERE Name LIKE 'A%';

/* 
1.2 retrieves all tracks by BackBeat artists 
*/

SELECT Track.*
FROM Track
JOIN Album USING (AlbumId)
JOIN Artist USING (ArtistId)
WHERE Artist.Name = 'BackBeat';


/* 
1.3  all album titles along with their respective artist name.
*/

SELECT Album.Title, Artist.Name
FROM Album
JOIN Artist USING (ArtistId);


/* 
1.4  the total number of tracks in each album, sorted by total in descending order.
*/

SELECT Album.Title as Album_Title, COUNT(Track.TrackId) as Total_Tracks
from Album
join Track using (albumId)
GROUP by Album.Title
ORDER BY Total_Tracks DESC;


/* 
1.5  tracks with “Protected AAC audio file” media type
*/
SELECT Track.*
FROM Track
JOIN MediaType ON Track.MediaTypeId = MediaType.MediaTypeId
WHERE MediaType.Name = 'Protected AAC audio file';

/* 
 1.6  all tracks from “Big Ones” album   
*/
SELECT Track.*
from Track
join Album on Track.AlbumId = Album.AlbumId
where Album.Title = 'Big Ones';

/* 
1.7 finds the total duration of tracks in each playlist. You'll need to use the Playlist,
PlaylistTrack, and Track tables for this.
*/
SELECT Playlist.Name AS PlaylistName, SUM(Track.Milliseconds) AS TotalDuration
FROM Playlist
JOIN PlaylistTrack ON Playlist.PlaylistId = PlaylistTrack.PlaylistId
JOIN Track ON PlaylistTrack.TrackId = Track.TrackId
GROUP BY Playlist.PlaylistId, Playlist.Name;


/* 
1.8 10 most expensive tracks
*/
SELECT Track.Name, Track.UnitPrice
from Track
order by Track.UnitPrice DESC
LIMIT 10;


/* 
1.9  artists who do not have any albums
*/
SELECT Artist.Name
from Artist
left join Album on Artist.ArtistId = Album.ArtistId
where Album.ArtistId is NULL;


/* 
1.10 all playlists and the number of tracks in each.
*/
SELECT Playlist.Name, count(trackid) as NumOfTracks
from Playlist
join PlaylistTrack using (playlistid)
GROUP by playlistid;

/* 
2.1 finds albums with multiple genres.
Clarification: Find all albums with tracks from multiple genres. It will be necessary to
group tracks by album and genre and filter for albums that appear in multiple genres.
*/
SELECT Album.Title AS AlbumTitle, COUNT(DISTINCT Genre.GenreId) AS NumberOfGenres
FROM Album
JOIN Track ON Album.AlbumId = Track.AlbumId
JOIN Genre ON Track.GenreId = Genre.GenreId
GROUP BY Album.AlbumId, Album.Title
HAVING COUNT(DISTINCT Genre.GenreId) > 1;

/* 
  2.2 customers with the highest average invoice value.
*/

SELECT Customer.CustomerId, Customer.FirstName, Customer.LastName, AVG(Invoice.Total) AS Average_Invoice_Value
FROM Customer
JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
GROUP BY Customer.CustomerId, Customer.FirstName, Customer.LastName
ORDER BY Average_Invoice_Value DESC;

/* 
  2.3 Finds the Longest Playlist by Duration
*/
SELECT Playlist.PlaylistId, Playlist.Name as Play_list, SUM(Track.Milliseconds) as Total_Duration
FROM Playlist
JOIN PlaylistTrack ON Playlist.PlaylistId = PlaylistTrack.PlaylistId
JOIN Track ON PlaylistTrack.TrackId = Track.TrackId
GROUP BY Playlist.PlaylistId, Playlist.Name
ORDER BY Total_Duration DESC
LIMIT 1;

/* 
  2.4 finds customers with Maximum Purchase in Each Country.
*/
SELECT Customer.FirstName AS First_Name, 
       Customer.LastName AS Last_Name, 
       Customer.Country, 
       SUM(Invoice.Total) AS Total_Purchases
FROM Customer
JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
GROUP BY Customer.CustomerId, Customer.Country
HAVING SUM(Invoice.Total) = (
SELECT MAX(Total_Purchases)
FROM (
        SELECT Customer.Country, 
               SUM(Invoice.Total) AS Total_Purchases
        FROM Customer
        JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
        GROUP BY Customer.Country, Customer.CustomerId
) AS CountryPurchases
WHERE CountryPurchases.Country = Customer.Country
)
ORDER BY Total_Purchases DESC;


/* 
2.5 finds the most popular album purchased by each country. 
*/
SELECT Album.Title AS Album_name, Invoice.BillingCountry AS Country, COUNT(*) AS Most_Popular
FROM Album
JOIN Track ON Track.AlbumId = Album.AlbumId
JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
JOIN Invoice ON Invoice.InvoiceId = InvoiceLine.InvoiceId
GROUP BY Invoice.BillingCountry, Album.AlbumId
ORDER BY Most_Popular DESC;





