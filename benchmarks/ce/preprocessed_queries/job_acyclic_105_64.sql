select count(*) from imdb100, imdb118, imdb64, imdb73 where imdb100.d = imdb118.d and imdb118.d = imdb64.s and imdb64.s = imdb73.s;