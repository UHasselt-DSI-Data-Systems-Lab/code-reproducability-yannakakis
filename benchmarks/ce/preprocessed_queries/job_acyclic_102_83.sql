select count(*) from imdb100, imdb2, imdb10 where imdb100.d = imdb2.d and imdb2.d = imdb10.s;