select count(*) from yago2_0, yago2_1, yago23, yago5_3, yago5_4, yago13 where yago2_0.s = yago2_1.s and yago2_1.d = yago23.s and yago23.d = yago5_3.d and yago5_3.s = yago5_4.s and yago5_4.d = yago13.d;