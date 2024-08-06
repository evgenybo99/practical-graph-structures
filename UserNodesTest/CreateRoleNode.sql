-- =========================================
-- Create Graph Node Template
-- =========================================
USE GraphDB
GO

IF OBJECT_ID('dbo.UserRole', 'U') IS NOT NULL
  DROP TABLE dbo.UserRole
GO

CREATE TABLE dbo.UserRole
(
    RoleId Uniqueidentifier PRIMARY KEY NOT NULL,
    UserRoleName nvarchar(100) NOT NULL,
	  IsActive bit NOT NULL,
	  LastUpdated datetime NOT NULL

    -- Unique index on $node_id is required.
    -- If no user-defined index is specified, a default index is created.
    INDEX ix_graphid UNIQUE ($node_id)
)
AS NODE
GO
