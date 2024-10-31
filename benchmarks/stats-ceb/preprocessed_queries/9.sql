SELECT COUNT(*) FROM c, p, ph WHERE p.Id = c.PostId AND p.Id = ph.PostId AND p.CommentCount>=0 AND p.CommentCount<=25;
