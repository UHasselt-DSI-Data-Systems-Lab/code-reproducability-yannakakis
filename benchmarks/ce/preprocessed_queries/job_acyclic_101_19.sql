select count(*) from imdb3, imdb126, imdb1 where imdb3.d = imdb126.d and imdb126.s = imdb1.s;