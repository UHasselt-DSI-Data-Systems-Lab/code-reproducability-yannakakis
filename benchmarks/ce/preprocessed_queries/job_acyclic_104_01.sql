select count(*) from imdb2, imdb100, imdb118 where imdb2.d = imdb100.d and imdb100.d = imdb118.d;