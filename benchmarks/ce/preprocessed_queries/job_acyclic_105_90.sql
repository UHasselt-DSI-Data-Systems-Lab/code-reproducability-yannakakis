select count(*) from imdb100, imdb3, imdb43, imdb62 where imdb100.d = imdb3.d and imdb3.d = imdb43.s and imdb43.s = imdb62.s;