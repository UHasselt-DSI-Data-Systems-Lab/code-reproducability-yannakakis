select count(*) from dblp8, dblp25, dblp22, dblp2, dblp4, dblp17, dblp24, dblp20 where dblp8.s = dblp25.s and dblp25.s = dblp22.s and dblp22.s = dblp2.s and dblp2.d = dblp4.s and dblp4.d = dblp17.s and dblp17.d = dblp24.s and dblp24.s = dblp20.s;