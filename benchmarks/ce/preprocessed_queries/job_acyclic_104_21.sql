select count(*) from imdb3, imdb100, imdb127 where imdb3.d = imdb100.d and imdb100.d = imdb127.d;