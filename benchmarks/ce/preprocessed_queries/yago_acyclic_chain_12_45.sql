select count(*) from yago23, yago36_1, yago5_2, yago46, yago50, yago36_5, yago39_6, yago5_7, yago5_8, yago39_9, yago54, yago55 where yago23.s = yago36_1.s and yago36_1.d = yago50.d and yago5_2.s = yago54.d and yago5_2.d = yago46.d and yago50.s = yago36_5.s and yago36_5.d = yago39_6.d and yago39_6.s = yago5_7.s and yago5_7.d = yago5_8.d and yago5_8.s = yago39_9.s and yago39_9.d = yago55.d and yago54.s = yago55.s;