select count(*) from dblp24, dblp21, dblp17, dblp8, dblp7, dblp22 where dblp24.s = dblp21.s and dblp21.s = dblp17.s and dblp17.d = dblp8.s and dblp8.d = dblp7.s and dblp7.s = dblp22.s;