select count(*) from imdb100, imdb118, imdb60 where imdb100.d = imdb118.d and imdb118.d = imdb60.s;