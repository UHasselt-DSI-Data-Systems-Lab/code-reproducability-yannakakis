select count(*) from yago17_0, yago17_1, yago17_2, yago17_3, yago17_4, yago17_5 where yago17_0.s = yago17_5.d and yago17_0.d = yago17_1.s and yago17_1.d = yago17_2.s and yago17_2.s = yago17_3.d and yago17_3.d = yago17_4.d;