select count(*) from imdb100, imdb124, imdb21, imdb52 where imdb100.d = imdb124.d and imdb124.d = imdb21.s and imdb21.s = imdb52.s;