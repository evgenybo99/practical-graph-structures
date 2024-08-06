USE [GraphDB]
GO

INSERT INTO [dbo].[UserRole]
           ([RoleId]
           ,[UserRoleName]
           ,[IsActive]
           ,[LastUpdated])
     VALUES
           ('992a4d07-7868-435d-a7af-7cef3a4389b9'
           ,'owner'
           ,1
           ,GetDate()),
           ('f08bb1fb-7316-424d-b55d-c69e95c145ce'
           ,'accountant'
           ,1
           ,GetDate())
GO


