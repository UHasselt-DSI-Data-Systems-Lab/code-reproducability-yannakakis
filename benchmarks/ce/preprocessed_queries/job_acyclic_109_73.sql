select count(*) from imdb3, imdb121, imdb100, imdb16, imdb22 where imdb3.d = imdb121.d and imdb121.d = imdb100.d and imdb100.d = imdb16.s and imdb16.s = imdb22.s;