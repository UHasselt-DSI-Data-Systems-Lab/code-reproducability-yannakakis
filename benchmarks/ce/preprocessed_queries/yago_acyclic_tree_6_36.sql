select count(*) from yago17_0, yago5_1, yago5_2, yago17_3, yago21, yago17_5 where yago17_0.s = yago5_1.d and yago17_0.d = yago17_5.d and yago5_1.s = yago5_2.s and yago5_2.d = yago17_3.s and yago17_3.s = yago21.d;