select count(*) from imdb121, imdb6, imdb25 where imdb121.d = imdb6.s and imdb6.s = imdb25.s;