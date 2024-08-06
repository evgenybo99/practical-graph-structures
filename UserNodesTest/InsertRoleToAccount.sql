USE [GraphDB]
GO

INSERT INTO [dbo].[RoleToAccount]
           ($from_id, $to_id,[Permission])
SELECT (SELECT $node_id FROM [dbo].[UserRole] WHERE [UserRoleName] = 'owner'),
       (SELECT $node_id FROM [dbo].[Account] WHERE [AccountName] = 'John''s Account'),
       'account.accountProperties.view.accountNumber;account.accountProperties.update.accountAddress' AS [Permission]
UNION All 
SELECT (SELECT $node_id FROM [dbo].[UserRole] WHERE [UserRoleName] = 'owner'),
       (SELECT $node_id FROM [dbo].[Account] WHERE [AccountName] = 'John''s Account 2'),
       'account.accountProperties.view.accountNumber;account.accountProperties.update.accountAddress' AS [Permission]
UNION All 
SELECT (SELECT $node_id FROM [dbo].[UserRole] WHERE [UserRoleName] = 'owner'),
       (SELECT $node_id FROM [dbo].[Account] WHERE [AccountName] = 'Don''s Account'),
       'account.accountProperties.view.accountNumber;account.accountProperties.update.accountAddress' AS [Permission]
UNION All 
SELECT (SELECT $node_id FROM [dbo].[UserRole] WHERE [UserRoleName] = 'owner'),
       (SELECT $node_id FROM [dbo].[Account] WHERE [AccountName] = 'Don''s Account 2'),
       'account.accountProperties.view.accountNumber;account.accountProperties.update.accountAddress' AS [Permission]
UNION All 
SELECT (SELECT $node_id FROM [dbo].[UserRole] WHERE [UserRoleName] = 'accountant'),
       (SELECT $node_id FROM [dbo].[Account] WHERE [AccountName] = 'John''s Account'),
       'account.accountProperties.view.accountNumber;account.accountProperties.update.accountAddress' AS [Permission]
UNION All 
SELECT (SELECT $node_id FROM [dbo].[UserRole] WHERE [UserRoleName] = 'accountant'),
       (SELECT $node_id FROM [dbo].[Account] WHERE [AccountName] = 'John''s Account 2'),
       'account.accountProperties.view.accountNumber;account.accountProperties.update.accountAddress' AS [Permission]
UNION All 
SELECT (SELECT $node_id FROM [dbo].[UserRole] WHERE [UserRoleName] = 'accountant'),
       (SELECT $node_id FROM [dbo].[Account] WHERE [AccountName] = 'Don''s Account'),
       'account.accountProperties.view.accountNumber;account.accountProperties.update.accountAddress' AS [Permission]
UNION All 
SELECT (SELECT $node_id FROM [dbo].[UserRole] WHERE [UserRoleName] = 'accountant'),
       (SELECT $node_id FROM [dbo].[Account] WHERE [AccountName] = 'Don''s Account 2'),
       'account.accountProperties.view.accountNumber;account.accountProperties.update.accountAddress' AS [Permission]

GO


