select count(*) from dblp21, dblp26, dblp17, dblp25, dblp2, dblp8, dblp9, dblp1 where dblp21.d = dblp26.d and dblp26.d = dblp17.s and dblp17.s = dblp25.s and dblp25.s = dblp2.s and dblp2.s = dblp8.s and dblp8.s = dblp9.s and dblp9.s = dblp1.s;