select count(*) from imdb100, imdb118, imdb15, imdb10 where imdb100.d = imdb118.d and imdb118.d = imdb15.s and imdb15.s = imdb10.s;