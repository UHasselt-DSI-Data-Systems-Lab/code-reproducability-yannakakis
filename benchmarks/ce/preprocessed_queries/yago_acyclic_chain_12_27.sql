select count(*) from yago2_0, yago2_1, yago22_2, yago5_3, yago46, yago12, yago17, yago62_7, yago62_8, yago5_9, yago5_10, yago22_11 where yago2_0.s = yago2_1.s and yago2_1.d = yago12.s and yago22_2.s = yago5_3.s and yago22_2.d = yago46.s and yago5_3.d = yago22_11.d and yago12.d = yago17.s and yago17.d = yago62_7.s and yago62_7.d = yago62_8.d and yago62_8.s = yago5_9.s and yago5_9.d = yago5_10.d and yago5_10.s = yago22_11.s;