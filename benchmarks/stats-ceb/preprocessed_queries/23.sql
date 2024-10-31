SELECT COUNT(*) FROM v, b, u WHERE u.Id = v.UserId AND v.UserId = b.UserId AND u.DownVotes>=0 AND u.DownVotes<=0;
