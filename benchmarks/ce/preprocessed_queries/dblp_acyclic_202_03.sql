select count(*) from dblp8, dblp5, dblp22, dblp21, dblp9, dblp13 where dblp8.s = dblp5.s and dblp5.s = dblp22.s and dblp22.s = dblp21.s and dblp21.s = dblp9.s and dblp9.d = dblp13.s;