select count(*) from dblp21, dblp26, dblp25, dblp6, dblp17, dblp5, dblp18, dblp8 where dblp21.d = dblp26.d and dblp26.d = dblp25.s and dblp25.s = dblp6.s and dblp6.s = dblp17.s and dblp17.s = dblp5.s and dblp5.s = dblp18.s and dblp18.s = dblp8.s;