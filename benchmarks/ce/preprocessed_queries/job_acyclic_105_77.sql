select count(*) from imdb100, imdb3, imdb10, imdb26 where imdb100.d = imdb3.d and imdb3.d = imdb10.s and imdb10.s = imdb26.s;