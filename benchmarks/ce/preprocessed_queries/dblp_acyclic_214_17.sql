select count(*) from dblp8, dblp7, dblp24, dblp17, dblp9, dblp18, dblp5, dblp22 where dblp8.s = dblp7.s and dblp7.s = dblp24.s and dblp24.s = dblp17.s and dblp17.s = dblp9.s and dblp9.s = dblp18.s and dblp18.d = dblp5.s and dblp5.d = dblp22.s;