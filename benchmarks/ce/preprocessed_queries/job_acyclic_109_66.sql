select count(*) from imdb2, imdb125, imdb100, imdb21, imdb10 where imdb2.d = imdb125.d and imdb125.d = imdb100.d and imdb100.d = imdb21.s and imdb21.s = imdb10.s;