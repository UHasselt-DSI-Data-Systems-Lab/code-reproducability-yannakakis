select count(*) from imdb2, imdb124, imdb100, imdb16, imdb12 where imdb2.d = imdb124.d and imdb124.d = imdb100.d and imdb100.d = imdb16.s and imdb16.s = imdb12.s;