select count(*) from imdb100, imdb2, imdb22, imdb10 where imdb100.d = imdb2.d and imdb2.d = imdb22.s and imdb22.s = imdb10.s;