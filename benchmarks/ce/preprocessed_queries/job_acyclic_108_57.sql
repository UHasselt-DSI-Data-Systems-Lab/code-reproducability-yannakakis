select count(*) from imdb1, imdb124, imdb2, imdb24 where imdb1.s = imdb124.s and imdb124.d = imdb2.d and imdb2.d = imdb24.s;