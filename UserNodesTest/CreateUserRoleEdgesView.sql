USE GraphDB
GO

create or ALTER VIEW dbo.userRelatedEdges AS
  SELECT
    UR.$edge_id AS edge_id,
    UR.$from_id AS from_id,
    UR.$to_id AS to_id,
    UR.Permission,
    'UserToRole' AS EdgeType
  FROM
    dbo.DbUserToRole AS UR 
  UNION ALL
    SELECT
    RA.$edge_id AS edge_id,
    RA.$from_id AS from_id,
    RA.$to_id AS to_id,
    RA.Permission,
    'RoleToAccount' AS EdgeType
  FROM
    dbo.RoleToAccount as RA
  UNION ALL
    SELECT
    UT.$edge_id AS edge_id,
    UT.$from_id AS from_id,
    UT.$to_id AS to_id,
    Permission,
    'UserToTeam' AS EdgeType
  FROM
    dbo.DbUserToTeam AS UT
  UNION ALL
    SELECT
    TTC.$edge_id AS edge_id,
    TTC.$from_id AS from_id,
    TTC.$to_id AS to_id,
    TTC.Permission,
    'TeamToTeamCode' AS EdgeType
  FROM
    dbo.TeamToTeamCode as TTC
  UNION ALL
    SELECT
    TCA.$edge_id AS edge_id,
    TCA.$from_id AS from_id,
    TCA.$to_id AS to_id,
    TCA.Permission,
    'TeamCodeToAccount' AS EdgeType
  FROM
    dbo.TeamCodeToAccount AS TCA
