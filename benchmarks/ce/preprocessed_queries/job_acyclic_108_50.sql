select count(*) from imdb1, imdb119, imdb2, imdb25 where imdb1.s = imdb119.s and imdb119.d = imdb2.d and imdb2.d = imdb25.s;