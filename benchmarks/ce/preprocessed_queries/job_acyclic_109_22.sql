select count(*) from imdb2, imdb126, imdb100, imdb6, imdb9 where imdb2.d = imdb126.d and imdb126.d = imdb100.d and imdb100.d = imdb6.s and imdb6.s = imdb9.s;