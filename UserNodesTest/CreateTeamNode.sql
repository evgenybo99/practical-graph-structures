-- =========================================
-- Create Graph Node Template
-- =========================================
USE GraphDB
GO

IF OBJECT_ID('dbo.Team', 'U') IS NOT NULL
  DROP TABLE dbo.Team
GO

CREATE TABLE dbo.Team
(
    TeamId Uniqueidentifier PRIMARY KEY NOT NULL,
    TeamName nvarchar(100) NOT NULL,
	IsActive bit NOT NULL,
	LastUpdated datetime NOT NULL

    -- Unique index on $node_id is required.
    -- If no user-defined index is specified, a default index is created.
    INDEX ix_graphid UNIQUE ($node_id)
)
AS NODE
GO
