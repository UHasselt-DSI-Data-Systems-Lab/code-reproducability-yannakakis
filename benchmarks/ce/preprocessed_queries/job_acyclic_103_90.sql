select count(*) from imdb125, imdb10, imdb97 where imdb125.d = imdb10.s and imdb10.s = imdb97.s;