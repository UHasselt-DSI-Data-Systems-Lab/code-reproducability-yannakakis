select count(*) from imdb100, imdb120, imdb12 where imdb100.d = imdb120.d and imdb120.d = imdb12.s;