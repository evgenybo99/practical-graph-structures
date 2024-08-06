-- =========================================
-- Create Graph Edge Table Template
-- =========================================
USE GraphDB
GO

DROP TABLE IF EXISTS dbo.DbUserToTeam
GO

CREATE TABLE dbo.DbUserToTeam
(
    Permission NVARCHAR(MAX) NULL,

    CONSTRAINT EC_DbUserToTeam CONNECTION (dbo.DBUser TO dbo.Team),
    -- Unique index on $edge_id is required.
    -- If no user-defined index is specified, a default index is created.
    --
    INDEX ix_graphid UNIQUE ($edge_id),

    -- indexes on $from_id and $to_id are optional, but support faster lookups.
    --
    INDEX ix_fromid ($from_id, $to_id),
    INDEX ix_toid ($to_id, $from_id)
)
AS EDGE
GO
