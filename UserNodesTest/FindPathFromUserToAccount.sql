USE [GraphDB]
GO

WITH BaseRows AS (
SELECT
  StartNode.Name as FromName,
  LAST_VALUE(TargetObject.Name) within GROUP (graph PATH) AS TargetNode,
   LAST_VALUE(TargetObject.id) within GROUP (graph PATH) AS TargetNodeId,
   LAST_VALUE(TargetObject.RelationNodeType) within GROUP (graph PATH) AS TargetNodeRelationType,
   STRING_AGG(PTH.EdgeType + ' of ' + TargetObject.Name, '->') WITHIN GROUP (graph PATH) AS Path,
  'UserName:' + StartNode.Name + '->' + STRING_AGG(TargetObject.Name, '->') WITHIN GROUP (graph PATH) AS FullPath,
  'UserName:' + StartNode.Name + '->' + STRING_AGG(TargetObject.RelationNodeType + ':' + TargetObject.Name, '->') WITHIN GROUP (GRAPH PATH) AS FullPath2
FROM
  [dbo].[userRelatedNodes] AS StartNode,
  [dbo].[userRelatedEdges] FOR PATH AS PTH,
  [dbo].[userRelatedNodes] FOR PATH AS TargetObject
WHERE 
  StartNode.Id = '6FB7F55B-9E3D-428E-B1F9-20E4ACAB4297' -- '94CC905E-AFCE-432F-B1B1-A17B937F9D1C'   --'account' -- 'B8E6CB74-F88E-4B09-8481-2D75CDC34B5B'
  AND MATCH(
    SHORTEST_PATH(
      StartNode(-(PTH)->TargetObject)+
    )
  )  
)
SELECT FromName, TargetNode, TargetNodeId, FullPath2
from BaseRows 
Where TargetNodeId = 'B8E6CB74-F88E-4B09-8481-2D75CDC34B5B'