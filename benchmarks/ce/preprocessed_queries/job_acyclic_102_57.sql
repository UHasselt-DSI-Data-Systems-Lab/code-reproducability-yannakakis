select count(*) from imdb100, imdb117, imdb89 where imdb100.d = imdb117.d and imdb117.d = imdb89.s;