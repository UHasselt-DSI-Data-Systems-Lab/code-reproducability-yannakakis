select count(*) from dblp17, dblp7, dblp21, dblp20, dblp6, dblp2, dblp14, dblp5 where dblp17.s = dblp7.s and dblp7.s = dblp21.s and dblp21.s = dblp20.s and dblp20.s = dblp6.s and dblp6.s = dblp2.s and dblp2.d = dblp14.s and dblp14.d = dblp5.s;