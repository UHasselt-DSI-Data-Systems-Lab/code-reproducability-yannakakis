select count(*) from yago2_0, yago2_1, yago43_2, yago43_3, yago8_4, yago8_5, yago17_6, yago4, yago17_8 where yago2_0.s = yago2_1.s and yago2_1.d = yago43_2.s and yago43_2.d = yago43_3.d and yago43_3.s = yago8_4.s and yago8_4.d = yago8_5.d and yago8_5.s = yago17_6.s and yago17_6.d = yago4.d and yago4.s = yago17_8.d;