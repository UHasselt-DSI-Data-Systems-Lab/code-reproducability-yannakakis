select count(*) from imdb123, imdb9, imdb46 where imdb123.d = imdb9.s and imdb9.s = imdb46.s;