select count(*) from yago46_0, yago46_1, yago46_2, yago46_3, yago46_4, yago17 where yago46_0.s = yago46_1.s and yago46_1.s = yago46_2.s and yago46_2.s = yago46_3.s and yago46_3.s = yago46_4.d and yago46_4.d = yago17.d;