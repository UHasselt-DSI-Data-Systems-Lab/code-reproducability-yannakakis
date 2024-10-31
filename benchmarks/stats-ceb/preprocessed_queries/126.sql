SELECT COUNT(*) FROM ph, v, u, b WHERE u.Id = b.UserId AND u.Id = ph.UserId AND u.Id = v.UserId AND u.Views>=0;
