USE [GraphDB]
GO

INSERT INTO [dbo].[TeamCodeToAccount]
           ($from_id, $to_id,[Permission])
SELECT (SELECT $node_id AS to_id FROM [dbo].[TeamCode] WHERE [TeamCode] = 'AABB1'),
       (SELECT $node_id FROM [dbo].[Account] WHERE [AccountName] = 'John''s Account'),
       'account.accountProperties.view.accountNumber;account.accountProperties.update.accountAddress' AS [Permission]
UNION ALL
SELECT (SELECT $node_id AS to_id FROM [dbo].[TeamCode] WHERE [TeamCode] = 'AABB1'),
       (SELECT $node_id FROM [dbo].[Account] WHERE [AccountName] = 'John''s Account 2'),
       'account.accountProperties.view.accountNumber;account.accountProperties.update.accountAddress' AS [Permission]
UNION All 
SELECT (SELECT $node_id AS to_id FROM [dbo].[TeamCode] WHERE [TeamCode] = 'AABB1'),
       (SELECT $node_id FROM [dbo].[Account] WHERE [AccountName] = 'Don''s Account'),
       'account.accountProperties.view.accountNumber;account.accountProperties.update.accountAddress' AS [Permission]
UNION All 
SELECT (SELECT $node_id AS to_id FROM [dbo].[TeamCode] WHERE [TeamCode] = 'AABB1'),
       (SELECT $node_id FROM [dbo].[Account] WHERE [AccountName] = 'Don''s Account 2'),
       'account.accountProperties.view.accountNumber;account.accountProperties.update.accountAddress' AS [Permission]
UNION All 
SELECT (SELECT $node_id AS to_id FROM [dbo].[TeamCode] WHERE [TeamCode] = 'ABAB3'),
       (SELECT $node_id FROM [dbo].[Account] WHERE [AccountName] = 'John''s Account'),
       'account.accountProperties.view.accountType' AS [Permission]
UNION All 
SELECT (SELECT $node_id AS to_id FROM [dbo].[TeamCode] WHERE [TeamCode] = 'ABAB3'),
       (SELECT $node_id FROM [dbo].[Account] WHERE [AccountName] = 'John''s Account 2'),
       'account.accountProperties.view.accountType' AS [Permission]
UNION All 
SELECT (SELECT $node_id AS to_id FROM [dbo].[TeamCode] WHERE [TeamCode] = 'ABAB3'),
       (SELECT $node_id FROM [dbo].[Account] WHERE [AccountName] = 'Don''s Account'),
       'account.accountProperties.view.accountType' AS [Permission]
UNION All 
SELECT (SELECT $node_id AS to_id FROM [dbo].[TeamCode] WHERE [TeamCode] = 'ABAB3'),
       (SELECT $node_id FROM [dbo].[Account] WHERE [AccountName] = 'Don''s Account 2'),
       'account.accountProperties.view.accountType' AS [Permission] 
GO


