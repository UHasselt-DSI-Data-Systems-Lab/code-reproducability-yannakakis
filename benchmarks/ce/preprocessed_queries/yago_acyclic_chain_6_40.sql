select count(*) from yago36_0, yago36_1, yago5_2, yago5_3, yago54_4, yago54_5 where yago36_0.d = yago36_1.d and yago36_1.s = yago5_2.s and yago5_2.d = yago5_3.d and yago5_3.s = yago54_4.d and yago54_4.s = yago54_5.d;