select count(*) from dblp17, dblp23, dblp5, dblp2, dblp4, dblp6, dblp18, dblp21 where dblp17.s = dblp23.s and dblp23.s = dblp5.s and dblp5.s = dblp2.s and dblp2.s = dblp4.s and dblp4.s = dblp6.s and dblp6.s = dblp18.s and dblp18.d = dblp21.s;