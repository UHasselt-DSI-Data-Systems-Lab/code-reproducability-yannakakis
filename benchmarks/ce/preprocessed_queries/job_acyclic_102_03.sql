select count(*) from imdb100, imdb120, imdb44 where imdb100.d = imdb120.d and imdb120.d = imdb44.s;