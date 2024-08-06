USE [GraphDB]
GO

INSERT INTO [dbo].[Account]
           ([AccountNumber]
           ,[AccountType]
           ,[AccountName]
           ,[IsActive]
           ,[LastUpdated])
     VALUES
           ('b8e6cb74-f88e-4b09-8481-2d75cdc34b5b'
           ,'C'
           ,'John''s Account'
           ,1
           ,GetDate()),
           ('a1c5575b-7a77-4614-b5ca-44b7ec9a3c05'
           ,'S'
           ,'John''s Account 2'
           ,1
           ,GetDate()),
           ('c849421d-f063-4d2e-aa5f-d2f7e4197730'
           ,'C'
           ,'Don''s Account'
           ,1
           ,GetDate()),
           ('9ae1cbb1-d725-4277-a184-c3c4fbf6356a'
           ,'S'
           ,'Don''s Account 2'
           ,1
           ,GetDate())
GO


