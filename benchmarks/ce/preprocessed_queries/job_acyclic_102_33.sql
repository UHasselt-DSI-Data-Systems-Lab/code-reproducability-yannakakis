select count(*) from imdb100, imdb119, imdb71 where imdb100.d = imdb119.d and imdb119.d = imdb71.s;