select count(*) from imdb1, imdb119, imdb3, imdb22 where imdb1.s = imdb119.s and imdb119.d = imdb3.d and imdb3.d = imdb22.s;