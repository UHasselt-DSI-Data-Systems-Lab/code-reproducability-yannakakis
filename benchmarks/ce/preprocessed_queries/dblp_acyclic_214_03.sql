select count(*) from dblp20, dblp18, dblp21, dblp25, dblp17, dblp8, dblp9, dblp12 where dblp20.s = dblp18.s and dblp18.s = dblp21.s and dblp21.s = dblp25.s and dblp25.s = dblp17.s and dblp17.s = dblp8.s and dblp8.d = dblp9.s and dblp9.d = dblp12.s;