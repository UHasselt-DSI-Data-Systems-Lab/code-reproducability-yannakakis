select count(*) from imdb127, imdb6, imdb73 where imdb127.d = imdb6.s and imdb6.s = imdb73.s;