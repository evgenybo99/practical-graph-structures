USE [GraphDB]
GO

INSERT INTO [dbo].[TeamToTeamCode]
           ($from_id, $to_id,[Permission])
SELECT (SELECT $node_id AS from_id FROM [dbo].[Team] WHERE [TeamName] = 'Don''s Team'),
       (SELECT $node_id AS to_id FROM [dbo].[TeamCode] WHERE [TeamCode] = 'AABB1') ,
       null AS [Permission]
UNION ALL
SELECT (SELECT $node_id AS from_id FROM [dbo].[Team] WHERE [TeamName] = 'Don''s Team'),
       (SELECT $node_id AS to_id FROM [dbo].[TeamCode] WHERE [TeamCode] = 'ABAB3') ,
       null AS [Permission]       
GO


