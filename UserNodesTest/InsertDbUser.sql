USE [GraphDB]
GO

INSERT INTO [dbo].[DbUser]
           ([UserId]
           ,[UserName]
           ,[UserEmail]
           ,[IsActive]
           ,[LastUpdated])
     VALUES
           ('94cc905e-afce-432f-b1b1-a17b937f9d1c',
           'John Doe',
           'jd@home.com',
           1,
           GetDate()),
           ('6fb7f55b-9e3d-428e-b1f9-20e4acab4297',
           'Don Doe',
           'dd@home.com',
           1,
           GetDate())
GO


