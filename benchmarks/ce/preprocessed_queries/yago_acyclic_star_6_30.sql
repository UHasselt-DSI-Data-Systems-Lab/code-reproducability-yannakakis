select count(*) from yago8_0, yago43_1, yago43_2, yago3, yago8_4, yago2 where yago8_0.s = yago43_1.s and yago43_1.s = yago43_2.s and yago43_2.s = yago3.s and yago3.s = yago8_4.s and yago8_4.s = yago2.d;