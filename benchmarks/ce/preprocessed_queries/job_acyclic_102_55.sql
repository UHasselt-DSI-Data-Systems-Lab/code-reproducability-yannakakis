select count(*) from imdb100, imdb122, imdb83 where imdb100.d = imdb122.d and imdb122.d = imdb83.s;