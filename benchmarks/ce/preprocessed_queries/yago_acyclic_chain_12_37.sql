select count(*) from yago9_0, yago13_1, yago54, yago9_3, yago35, yago13_5, yago13_6, yago22, yago57_8, yago57_9, yago21, yago13_11 where yago9_0.d = yago9_3.d and yago13_1.s = yago54.d and yago13_1.d = yago21.d and yago9_3.s = yago35.d and yago35.s = yago13_5.s and yago13_5.d = yago13_6.d and yago13_6.s = yago22.s and yago22.d = yago57_8.s and yago57_8.d = yago57_9.d and yago57_9.s = yago13_11.d and yago21.s = yago13_11.s;