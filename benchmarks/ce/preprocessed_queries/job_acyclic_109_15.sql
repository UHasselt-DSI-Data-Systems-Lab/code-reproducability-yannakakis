select count(*) from imdb2, imdb123, imdb100, imdb7, imdb9 where imdb2.d = imdb123.d and imdb123.d = imdb100.d and imdb100.d = imdb7.s and imdb7.s = imdb9.s;