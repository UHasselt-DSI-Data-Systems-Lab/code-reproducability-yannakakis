select count(*) from imdb3, imdb100, imdb123 where imdb3.d = imdb100.d and imdb100.d = imdb123.d;