select count(*) from yago2_0, yago2_1, yago5_2, yago37, yago36_4, yago17_5, yago17_6, yago36_7, yago36_8, yago5_9, yago5_10, yago21 where yago2_0.s = yago2_1.s and yago2_1.d = yago36_4.d and yago5_2.s = yago37.d and yago5_2.d = yago5_10.d and yago36_4.s = yago17_5.d and yago17_5.s = yago17_6.s and yago17_6.d = yago36_7.s and yago36_7.d = yago36_8.d and yago36_8.s = yago5_9.s and yago5_9.d = yago21.d and yago5_10.s = yago21.s;