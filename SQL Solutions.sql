/*==========
  Write a SQL query to select all columns from the Track_streams table.
==========*/
Select * from Track_streams;


Select Track_id, artist_count, released_year, released_month, released_day, in_spotify_playlists,
in_spotify_charts, streams, in_apple_playlists, in_apple_charts,
in_deezer_playlists,
in_deezer_charts, in_shazam_charts, bpm,  mode, "danceability_%" , "valence_%" , "energy_%",
"acousticness_%" , "instrumentalness_%" , "liveness_%" , "speechiness_%"
from Track_streams
order by 8, 3, 4 
;


/*==========
  Write a SQL query to select the track name and artist from the joined tables.
==========*/

Select Track_name, artist, released_year, released_month, released_day, in_spotify_playlists,
in_spotify_charts, streams, in_apple_playlists, in_apple_charts
from track_streams
left join track_names on track_streams.Track_id = track_names.Track_id
left join track_artist on track_artist.Track_id = track_streams.Track_id;

-- also could go directly to the track_artist and track_names table
SELECT track_artist.artist, track_names.track_name
FROM track_names
left join track_artist on track_names.Track_id = track_artist.Track_id;


/*==========
  Write a SQL query to select all columns from Track_streams where streams are greater than 1,000,000.
==========*/

Select *
from
Track_streams
where streams > 1000000;
--returns 842 of our 843


--What is the one
Select *
from
Track_streams
where streams < 1000000;
--returns the remaining 1 of 843

--I am now curious what Track made it to the list with less than 1 million streams
Select * from 
track_names
where Track_id = 'ID-843';
--single quotes show values

--I am sure I want that row deleted
DELETE FROM  track_names
where Track_id = 'ID-843';
--status showed 1 rows affected

--I am sure I want that row deleted
DELETE FROM  track_streams
where Track_id = 'ID-843';
--status showed 1 rows affected

--I am sure I want that row deleted
DELETE FROM  track_artist
where Track_id = 'ID-843';
--status showed 1 rows affected

Select track_name, artist, track_streams.* FROM track_streams
left join track_names on track_streams.Track_id = track_names.Track_id
left join track_artist on track_artist.Track_id = track_streams.Track_id
where track_streams.track_id in (
    Select track_id from 
    track_artist
    where artist like ('%Taylor%')
    ) 
and 
--or 
artist like ('%Taylor%');


/*==========
  Write a SQL query to select all columns from Track_streams and order by streams in descending order.
==========*/

Select Track_name, artist, released_year, released_month, released_day, in_spotify_playlists,
in_spotify_charts, streams, in_apple_playlists, in_apple_charts
from track_streams
left join track_names on track_streams.Track_id = track_names.Track_id
left join track_artist on track_artist.Track_id = track_streams.Track_id
--where
order by streams desc;


/*==========
  Write a SQL query to group by released_year and get the total streams for each year.
==========*/

SELECT released_year,
       sum(streams) total_streams
  FROM track_streams-- demonstrate how a join can affect my aggregates
 /* join track_artist on track_streams.Track_id = track_artist.track_id WHERE released_year > 2020 */
 GROUP BY 1
 ORDER BY sum(streams) DESC;
 


/*==========
  Write a SQL query to group by release_year and get the highest streaming track for each year.
==========*/

/*==========
  Write a SQL query to classify tracks based on danceability.
  If danceability_% > 70, classify as 'High', between 40 and 70 as 'Medium', and below 40 as 'Low'.
==========*/

/*==========
  Write a SQL query to use a CTE to calculate total streams and then select tracks with total streams above 1,000,000.
==========*/


/*==========
  Write a SQL query to union the Track_streams table with itself.
  Ensure you select distinct tracks in the result.
==========*/


/*==========
  Write a SQL query to drop records where streaming is not in the top 800.
==========*/




/*==========
  Write a SQL query to calculate the average streams for each key and mode combination.
==========*/



/*==========
  Write a SQL query to find tracks that are in Spotify, Apple, and Deezer playlists.
==========*/



/*==========
  Write a SQL query to calculate the percentage of tracks with danceability_% > 50 for each year.
==========*/



