select count(*) from imdb125, imdb25, imdb17 where imdb125.d = imdb25.s and imdb25.s = imdb17.s;