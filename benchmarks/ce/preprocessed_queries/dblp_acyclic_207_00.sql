select count(*) from dblp1, dblp25, dblp20, dblp22, dblp6, dblp17, dblp9 where dblp1.s = dblp25.s and dblp25.s = dblp20.s and dblp20.s = dblp22.s and dblp22.s = dblp6.s and dblp6.s = dblp17.s and dblp17.d = dblp9.s;