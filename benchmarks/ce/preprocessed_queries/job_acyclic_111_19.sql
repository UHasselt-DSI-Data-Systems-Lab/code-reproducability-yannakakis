select count(*) from imdb31, imdb1, imdb118, imdb3, imdb100, imdb9 where imdb31.s = imdb1.s and imdb1.s = imdb118.s and imdb118.d = imdb3.d and imdb3.d = imdb100.d and imdb100.d = imdb9.s;