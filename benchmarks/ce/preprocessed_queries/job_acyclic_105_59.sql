select count(*) from imdb100, imdb124, imdb22, imdb82 where imdb100.d = imdb124.d and imdb124.d = imdb22.s and imdb22.s = imdb82.s;