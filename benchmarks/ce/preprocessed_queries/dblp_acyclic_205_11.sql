select count(*) from dblp8, dblp5, dblp21, dblp1, dblp26, dblp18 where dblp8.s = dblp5.s and dblp5.d = dblp21.d and dblp21.s = dblp1.s and dblp1.d = dblp26.s and dblp26.d = dblp18.s;