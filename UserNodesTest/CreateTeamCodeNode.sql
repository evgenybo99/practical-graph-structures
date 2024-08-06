-- =========================================
-- Create Graph Node Template
-- =========================================
USE GraphDB
GO

IF OBJECT_ID('dbo.TeamCode', 'U') IS NOT NULL
  DROP TABLE dbo.TeamCode
GO

CREATE TABLE dbo.TeamCode
(
    TeamCode VARCHAR(5) PRIMARY KEY NOT NULL,
    TeamCodeName nvarchar(100) NOT NULL,
	IsActive bit NOT NULL,
	LastUpdated datetime NOT NULL

    -- Unique index on $node_id is required.
    -- If no user-defined index is specified, a default index is created.
    INDEX ix_graphid UNIQUE ($node_id)
)
AS NODE
GO
