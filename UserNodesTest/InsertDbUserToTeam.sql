USE [GraphDB]
GO

INSERT INTO [dbo].[DbUserToTeam]
           ($from_id, $to_id,[Permission])
SELECT (SELECT $node_id AS from_id FROM dbo.DbUser WHERE [UserName] = 'John Doe'),
       (SELECT $node_id AS to_id FROM [dbo].[Team] WHERE [TeamName] = 'Don''s Team') ,
       null AS [Permission]
GO


