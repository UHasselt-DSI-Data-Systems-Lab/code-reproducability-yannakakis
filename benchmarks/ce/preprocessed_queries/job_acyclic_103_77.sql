select count(*) from imdb119, imdb76, imdb13 where imdb119.d = imdb76.s and imdb76.s = imdb13.s;