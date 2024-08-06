/** TOC:
* 1. prepare tables
* 2. prepare data
* 3. prepare heterogenous views
* 4. QUERIES
* 4.a. BUG 1
* 4.b. BUG 2
* 4.c. WORKS
**/

USE [GraphDB]
GO

BEGIN TRANSACTION
GO

/*******************\
| 1. prepare tables |
\*******************/
CREATE TABLE graph.SmallCities   (Name nvarchar(1000), Weight INTEGER, SmallCity_ID INTEGER IDENTITY(666,666) PRIMARY KEY) AS NODE;
CREATE TABLE graph.LargeCities   (Name nvarchar(1000), Weight INTEGER, LargeCity_ID INTEGER IDENTITY(666,666) PRIMARY KEY) AS NODE;
CREATE TABLE graph.Villages      (Name nvarchar(1000), Weight INTEGER, Village_ID   INTEGER IDENTITY(666,666) PRIMARY KEY) AS NODE;
CREATE TABLE graph.Hamlets       (Name nvarchar(1000), Weight INTEGER, Hamlet_ID    INTEGER IDENTITY(666,666) PRIMARY KEY) AS NODE;

CREATE TABLE graph.Hikes     (INDEX UQ UNIQUE nonclustered ($from_id, $to_id)) AS EDGE;
CREATE TABLE graph.Footpaths (INDEX UQ UNIQUE nonclustered ($from_id, $to_id)) AS EDGE;
CREATE TABLE graph.Roads     (INDEX UQ UNIQUE nonclustered ($from_id, $to_id)) AS EDGE;
CREATE TABLE graph.Railways  (INDEX UQ UNIQUE nonclustered ($from_id, $to_id)) AS EDGE;

INSERT INTO graph.SmallCities (Name, Weight) VALUES (N'SmallCityOnRoad', 3);
INSERT INTO graph.LargeCities (Name, Weight) VALUES (N'BigCityOnRailway', 5), (N'BiggishCityOnR&R', 4);
INSERT INTO graph.Villages    (Name, Weight) VALUES (N'VillageInMountains', 2);
INSERT INTO graph.Hamlets     (Name, Weight) VALUES (N'HutInThePass', 1);

/*****************\
| 2. prepare data |
\*****************/
INSERT INTO graph.Railways
  ($from_id, $to_id) 
SELECT
  L1.$node_id, L2.$node_id
FROM
  graph.LargeCities AS L1,
  graph.LargeCities AS L2
WHERE
  L1.Name = N'BigCityOnRailway' 
  AND L2.Name = N'BiggishCityOnR&R';

INSERT INTO graph.Roads
  ($from_id, $to_id) 
SELECT
  L1.$node_id, L2.$node_id
FROM
  graph.LargeCities AS L1,
  graph.SmallCities AS L2
WHERE
  L1.Name = N'BiggishCityOnR&R'
  AND L2.Name = N'SmallCityOnRoad';

INSERT INTO graph.Footpaths
  ($from_id, $to_id) 
SELECT
  L1.$node_id, L2.$node_id
FROM
  graph.SmallCities AS L1,
  graph.Villages AS L2
WHERE
  L1.Name = N'SmallCityOnRoad'
  AND L2.Name = N'VillageInMountains';

INSERT INTO graph.Hikes
  ($from_id, $to_id) 
SELECT
  L1.$node_id, L2.$node_id
FROM
  graph.Villages AS L1,
  graph.Hamlets AS L2
WHERE
  L1.Name = N'VillageInMountains'
  AND L2.Name = N'HutInThePass';

GO

/*******************************\
| 3. prepare heterogenous views |
\*******************************/
CREATE VIEW graph.AllResidentialAreas AS
  SELECT
    LC.$node_id AS node_id,
    LC.Name,
    LC.Weight,
    LC.LargeCity_ID AS Area_ID,
    'Large city' AS AreaType
  FROM
    graph.LargeCities AS LC
  UNION ALL
  SELECT
    SC.$node_id AS node_id,
    SC.Name,
    SC.Weight,
    SC.SmallCity_ID,
    'Small city' AS AreaType
  FROM
    graph.SmallCities AS SC
  UNION ALL
  SELECT
    V.$node_id AS node_id,
    V.Name,
    V.Weight,
    V.Village_ID,
    'Village' AS AreaType
  FROM
    graph.Villages AS V
  UNION ALL
  SELECT
    H.$node_id AS node_id,
    H.Name,
    H.Weight,
    H.Hamlet_ID,
    'Hamlet' AS AreaType
  FROM
    graph.Hamlets AS H;

GO

CREATE VIEW graph.AllPaths AS
  SELECT
    $edge_id AS edge_id,
    $from_id AS from_id,
    $to_id AS to_id,
    'Railway' AS PathType
  FROM
    graph.RailWays
  UNION ALL
  SELECT
    $edge_id,
    $from_id AS from_id,
    $to_id AS to_id,
    'Road' AS PathType
  FROM
    graph.Roads
  UNION ALL
  SELECT
    $edge_id,
    $from_id AS from_id,
    $to_id AS to_id,
    'Footpath' AS PathType
  FROM
    graph.Footpaths
  UNION ALL
  SELECT
    $edge_id,
    $from_id AS from_id,
    $to_id AS to_id,
    'Hike' AS PathType
  FROM
    graph.Hikes;

GO

/************\
| 4. QUERIES |
\************/

/*************
| 4.a. BUG 1 - combining views and underlaying tables doesn't work
*/
SELECT
  STRT.Name AS FromArea,
  LAST_VALUE(NOD.Name) within GROUP (graph PATH) AS ToArea,
  STRT.NAME + '->' + STRING_AGG(NOD.Name, '->') WITHIN GROUP (graph PATH) AS Way
FROM
  graph.LargeCities                  AS STRT, -------this is a problem, view vs edge table
  graph.AllPaths            FOR PATH AS PTH,
  graph.AllResidentialAreas FOR PATH AS NOD
WHERE 1=1
  AND MATCH(
    SHORTEST_PATH(
      STRT(-(PTH)->NOD)+
    )
  )
  AND STRT.NAME = 'BigCityOnRailway';

/**OUTPUT:
--The problem is, that the SHORTEST_PATH doesn't "see" more than one step behind the starting underlaying table
FromArea          ToArea            Way
BigCityOnRailway  BiggishCityOnR&R  BigCityOnRailway->BiggishCityOnR&R
BigCityOnRailway  SmallCityOnRoad   BigCityOnRailway->BiggishCityOnR&R->SmallCityOnRoad
*/

/*****************
| 4.b. BUG 2 - using node rows along the SHORTEST_PATH found
*/
SELECT
  STRT.Name AS FromArea,
  LAST_VALUE(NOD.Name) within GROUP (graph PATH) AS ToArea,
  STRING_AGG(PTH.PathType, '->') WITHIN GROUP (graph PATH) AS Path,
  STRT.NAME + '->' + STRING_AGG(NOD.Name, '->') WITHIN GROUP (graph PATH) AS Way, --this has problem
  SUM(NOD.Weight) WITHIN GROUP (graph PATH) AS Weight, --this has similar problem
  COUNT(PTH.PathType) WITHIN GROUP (graph PATH) AS Path_Length
FROM
  graph.AllResidentialAreas          AS STRT,
  graph.AllPaths            FOR PATH AS PTH,
  graph.AllResidentialAreas FOR PATH AS NOD
WHERE 1=1
  AND MATCH(
    SHORTEST_PATH(
      STRT(-(PTH)->NOD)+
    )
  )
  AND STRT.Name = 'BigCityOnRailway'
  AND STRT.AreaType = 'Large city';

/**OUTPUT
--This correctly finds the "transitive closure" (columns FromArea and ToArea)
--This correctly finds the edges that need to be traversed (column Path)
--BUT the nodes along the way are wrong - see the last two rows:
--  first, second and the last nodes are OK,
--  but all the nodes between are just the first node repeated
--  this is also visible in the Weight column, where the correct weights should be (4, 7, 9, 10)
FromArea          ToArea              Path                           Way                                                                                   Weight  Path_Length
BigCityOnRailway  BiggishCityOnR&R    Railway                        BigCityOnRailway->BiggishCityOnR&R                                                    4       1
BigCityOnRailway  SmallCityOnRoad     Railway->Road                  BigCityOnRailway->BiggishCityOnR&R->SmallCityOnRoad                                   7       2
BigCityOnRailway  VillageInMountains  Railway->Road->Footpath        BigCityOnRailway->BiggishCityOnR&R->BigCityOnRailway->VillageInMountains              11      3
BigCityOnRailway  HutInThePass        Railway->Road->Footpath->Hike  BigCityOnRailway->BiggishCityOnR&R->BigCityOnRailway->BigCityOnRailway->HutInThePass  15      4
*/

/***********************************
| 4.c. WORKS, but isn't heterogenous
*/
CREATE TABLE graph.AllAreas (Name nvarchar(1000), Weight INTEGER, Area_ID INTEGER IDENTITY(666,666) PRIMARY KEY, AreaType VARCHAR(1000)) AS NODE;
CREATE TABLE graph.AllWays (PathType VARCHAR(1000), INDEX UQ UNIQUE nonclustered ($from_id, $to_id)) AS EDGE;

INSERT INTO graph.AllAreas
  (Name, Weight, AreaType)
SELECT
  ARA.Name,
  ARA.Weight,
  ARA.AreaType
FROM
  graph.AllResidentialAreas AS ARA WITH(NOLOCK);

INSERT INTO graph.AllWays
  ($from_id, $to_id, PathType)
SELECT
  AA_FROM.$node_id,
  AA_TO.$node_id,
  AP.PathType
FROM
  graph.AllPaths AS AP
  JOIN graph.AllResidentialAreas AS ARA_FROM ON ARA_FROM.node_id = AP.from_id
  JOIN graph.AllResidentialAreas AS ARA_TO   ON ARA_TO.node_id   = AP.to_id
  JOIN graph.AllAreas AS AA_FROM ON AA_FROM.Name = ARA_FROM.Name
  JOIN graph.AllAreas AS AA_TO   ON AA_TO.Name   = ARA_TO.Name;

SELECT
  STRT.Name AS FromArea,
  LAST_VALUE(NOD.Name) within GROUP (graph PATH) AS ToArea,
  STRING_AGG(PTH.PathType, '->') WITHIN GROUP (graph PATH) AS Path,
  STRT.NAME + '->' + STRING_AGG(NOD.Name, '->') WITHIN GROUP (graph PATH) AS Way, --this has problems too, 
  SUM(NOD.Weight) WITHIN GROUP (graph PATH) AS Weight, --this has similar problem
  COUNT(PTH.PathType) WITHIN GROUP (graph PATH) AS Path_Length
FROM
  graph.AllAreas          AS STRT,
  graph.AllWays  FOR PATH AS PTH,
  graph.AllAreas FOR PATH AS NOD
WHERE 1=1
  AND MATCH(
    SHORTEST_PATH(
      STRT(-(PTH)->NOD)+
    )
  )
  AND STRT.Name = 'BigCityOnRailway'
  AND STRT.AreaType = 'Large city';

/**OUTPUT:
FromArea          ToArea              Path                           Way                                                                                    Weight  Path_Length
BigCityOnRailway  BiggishCityOnR&R    Railway                        BigCityOnRailway->BiggishCityOnR&R                                                     4       1
BigCityOnRailway  SmallCityOnRoad     Railway->Road                  BigCityOnRailway->BiggishCityOnR&R->SmallCityOnRoad                                    7       2
BigCityOnRailway  VillageInMountains  Railway->Road->Footpath        BigCityOnRailway->BiggishCityOnR&R->SmallCityOnRoad->VillageInMountains                9       3
BigCityOnRailway  HutInThePass        Railway->Road->Footpath->Hike  BigCityOnRailway->BiggishCityOnR&R->SmallCityOnRoad->VillageInMountains->HutInThePass  10      4
*/

GO
IF @@TRANCOUNT > 0
  ROLLBACK TRANSACTION
GO