select count(*) from dblp20, dblp9, dblp21, dblp17, dblp5, dblp23 where dblp20.s = dblp9.s and dblp9.s = dblp21.s and dblp21.s = dblp17.s and dblp17.s = dblp5.s and dblp5.d = dblp23.s;