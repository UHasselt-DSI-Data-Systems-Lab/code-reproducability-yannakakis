SELECT COUNT(*) FROM c, ph WHERE c.UserId = ph.UserId AND c.Score=0 AND ph.PostHistoryTypeId=1;
