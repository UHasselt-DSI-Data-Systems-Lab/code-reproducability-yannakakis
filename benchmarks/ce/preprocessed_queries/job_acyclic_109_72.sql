select count(*) from imdb2, imdb126, imdb100, imdb18, imdb16 where imdb2.d = imdb126.d and imdb126.d = imdb100.d and imdb100.d = imdb18.s and imdb18.s = imdb16.s;