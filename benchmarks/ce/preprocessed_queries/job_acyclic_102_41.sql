select count(*) from imdb100, imdb123, imdb72 where imdb100.d = imdb123.d and imdb123.d = imdb72.s;