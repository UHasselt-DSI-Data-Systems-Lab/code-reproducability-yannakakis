select count(*) from yago2_0, yago2_1, yago22, yago13, yago46, yago53 where yago2_0.s = yago2_1.s and yago2_1.d = yago22.s and yago22.d = yago13.d and yago13.s = yago46.d and yago46.s = yago53.s;