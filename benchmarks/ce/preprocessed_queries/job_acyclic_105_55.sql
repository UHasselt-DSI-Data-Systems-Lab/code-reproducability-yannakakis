select count(*) from imdb100, imdb126, imdb44, imdb54 where imdb100.d = imdb126.d and imdb126.d = imdb44.s and imdb44.s = imdb54.s;