select count(*) from imdb20, imdb1, imdb118, imdb2, imdb100, imdb7 where imdb20.s = imdb1.s and imdb1.s = imdb118.s and imdb118.d = imdb2.d and imdb2.d = imdb100.d and imdb100.d = imdb7.s;