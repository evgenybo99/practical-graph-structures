USE GraphDB
GO

create or ALTER VIEW dbo.userRelatedNodes AS
    SELECT
        usr.$node_id AS node_id,
        cast(usr.UserID AS NVARCHAR(100)) as Id,
        usr.[UserName] as Name,
        'User' AS RelationNodeType
    FROM
        dbo.DbUser AS usr
    UNION ALL
    SELECT
        ur.$node_id AS node_id,
        cast(ur.RoleID AS NVARCHAR(100)) as Id,
        ur.[UserRoleName] as Name,
        'Role' AS RelationNodeType
    FROM
        dbo.UserRole AS ur
    UNION ALL
    SELECT
        tm.$node_id AS node_id,
        cast(tm.TeamID  AS NVARCHAR(100)) as Id,
        tm.[TeamName] as Name,
        'Team' AS RelationNodeType
    FROM
        dbo.Team AS tm
    UNION ALL
    SELECT
        tc.$node_id AS node_id,
        cast(tc.TeamCode  AS NVARCHAR(100)) as Id,
        tc.[TeamCodeName] as Name,
        'TeamCode' AS RelationNodeType
    FROM
        dbo.TeamCode AS tc    
    UNION ALL
    SELECT
        ac.$node_id AS node_id,
        cast(ac.AccountNumber  AS NVARCHAR(100)) as Id,
        ac.[AccountName] as Name,
        'Account' AS RelationNodeType
    FROM
        dbo.Account AS ac     