select count(*) from dblp5, dblp1, dblp2, dblp8, dblp9, dblp6 where dblp5.s = dblp1.s and dblp1.s = dblp2.s and dblp2.d = dblp8.s and dblp8.d = dblp9.s and dblp9.s = dblp6.s;