select count(*) from yago21_0, yago23_1, yago54, yago5, yago22, yago23_5, yago13_6, yago21_7, yago21_8, yago13_9, yago58, yago23_11 where yago21_0.d = yago5.d and yago23_1.s = yago54.s and yago23_1.d = yago23_11.d and yago5.s = yago22.s and yago22.d = yago23_5.d and yago23_5.s = yago13_6.s and yago13_6.d = yago21_7.d and yago21_7.s = yago21_8.s and yago21_8.d = yago13_9.d and yago13_9.s = yago58.s and yago58.d = yago23_11.s;