select count(*) from imdb2, imdb18, imdb17 where imdb2.d = imdb18.s and imdb18.s = imdb17.s;