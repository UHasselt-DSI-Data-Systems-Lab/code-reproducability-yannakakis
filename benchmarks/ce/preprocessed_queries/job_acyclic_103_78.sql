select count(*) from imdb117, imdb43, imdb54 where imdb117.d = imdb43.s and imdb43.s = imdb54.s;