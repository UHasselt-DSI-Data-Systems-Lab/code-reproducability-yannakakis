select count(*) from yago5_0, yago36_1, yago5_2, yago58, yago36_4, yago5_5 where yago5_0.s = yago36_1.s and yago36_1.s = yago58.d and yago5_0.d = yago5_2.d and yago36_1.d = yago36_4.d and yago36_4.s = yago5_5.s;