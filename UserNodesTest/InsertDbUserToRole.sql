USE [GraphDB]
GO

INSERT INTO [dbo].[DbUserToRole] 
        ($from_id, $to_id,[Permission])
SELECT (SELECT $node_id AS from_id FROM dbo.DbUser WHERE [UserName] = 'John Doe'),
       (SELECT $node_id AS to_id FROM [dbo].[UserRole] WHERE [UserRoleName] = 'owner') ,
       null AS [Permission]
       UNION ALL
SELECT (SELECT $node_id AS from_id FROM dbo.DbUser WHERE [UserName] = 'Don Doe'),
       (SELECT $node_id AS to_id FROM [dbo].[UserRole] WHERE [UserRoleName] = 'Accountant'),
       null AS [Permission]
GO


