select count(*) from imdb2, imdb13, imdb11 where imdb2.d = imdb13.s and imdb13.s = imdb11.s;