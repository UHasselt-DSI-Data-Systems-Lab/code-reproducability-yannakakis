select count(*) from dblp2, dblp20, dblp18, dblp5, dblp21, dblp8, dblp24, dblp1 where dblp2.s = dblp20.s and dblp20.s = dblp18.s and dblp18.s = dblp5.s and dblp5.d = dblp21.s and dblp21.d = dblp8.s and dblp8.d = dblp24.s and dblp24.s = dblp1.s;