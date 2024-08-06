USE [GraphDB]
GO

INSERT INTO [dbo].[TeamCode]
           ([TeamCode]
           ,[TeamCodeName]
           ,[IsActive]
           ,[LastUpdated])
     VALUES
           ('AABB1'
           ,'AABB1'
           ,1
           ,GetDate()),
            ('ABAB3'
           ,'ABAB3'
           ,1
           ,GetDate())
GO


