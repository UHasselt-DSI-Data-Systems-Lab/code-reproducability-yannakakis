select count(*) from v, b, u where u.id = v.userid and v.userid = b.userid and v.bountyamount>=0 and v.bountyamount<=50 and u.downvotes=0;
