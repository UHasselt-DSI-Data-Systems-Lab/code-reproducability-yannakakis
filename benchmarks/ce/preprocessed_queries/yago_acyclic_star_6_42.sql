select count(*) from yago26, yago29, yago53_2, yago53_3, yago53_4, yago53_5 where yago26.s = yago29.s and yago29.s = yago53_2.d and yago53_2.d = yago53_3.d and yago53_3.d = yago53_4.d and yago53_4.d = yago53_5.d;