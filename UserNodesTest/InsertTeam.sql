USE [GraphDB]
GO

INSERT INTO [dbo].[Team]
           ([TeamId]
           ,[TeamName]
           ,[IsActive]
           ,[LastUpdated])
     VALUES
           ('133c535d-f311-433d-9b58-912ab79ed552'
           ,'Don''s Team'
           ,1
           ,GetDate())
GO


