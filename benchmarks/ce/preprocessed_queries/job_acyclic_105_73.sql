select count(*) from imdb100, imdb119, imdb80, imdb77 where imdb100.d = imdb119.d and imdb119.d = imdb80.s and imdb80.s = imdb77.s;