select count(*) from imdb1, imdb120, imdb2, imdb16 where imdb1.s = imdb120.s and imdb120.d = imdb2.d and imdb2.d = imdb16.s;