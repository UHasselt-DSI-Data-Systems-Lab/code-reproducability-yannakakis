select count(*) from imdb100, imdb2, imdb44, imdb5 where imdb100.d = imdb2.d and imdb2.d = imdb44.s and imdb44.s = imdb5.s;