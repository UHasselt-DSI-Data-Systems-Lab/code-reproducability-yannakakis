select count(*) from imdb119, imdb67, imdb76 where imdb119.d = imdb67.s and imdb67.s = imdb76.s;