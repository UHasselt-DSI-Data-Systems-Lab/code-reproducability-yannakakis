select count(*) from imdb100, imdb124, imdb93, imdb9 where imdb100.d = imdb124.d and imdb124.d = imdb93.s and imdb93.s = imdb9.s;