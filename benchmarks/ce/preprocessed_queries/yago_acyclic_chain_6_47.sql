select count(*) from yago2_0, yago2_1, yago22, yago13_3, yago13_4, yago5 where yago2_0.s = yago2_1.s and yago2_1.d = yago22.s and yago22.d = yago13_3.d and yago13_3.s = yago13_4.s and yago13_4.d = yago5.d;