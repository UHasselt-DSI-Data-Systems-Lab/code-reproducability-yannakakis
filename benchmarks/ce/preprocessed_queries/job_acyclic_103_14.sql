select count(*) from imdb122, imdb85, imdb80 where imdb122.d = imdb85.s and imdb85.s = imdb80.s;