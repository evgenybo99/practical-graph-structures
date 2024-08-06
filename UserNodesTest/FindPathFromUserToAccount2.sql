USE [GraphDB]
GO

WITH BaseRows AS (
SELECT STRT.Id as NodeId,
       STRT.Name as NodeName,
       STRT.ID as RealtedNodeID,
       STRT.Name as RelatedNodeName,
       CAST(STRT.RelationNodeType + ':' + STRT.Name AS NVARCHAR(4000)) AS Path, 
       CAST(CONCAT('\', STRT.ID, '\') AS VARCHAR(8000)) AS IdPath,
       CAST('' AS VARCHAR(4000)) AS Permission, 
       0 AS level --the level
    FROM [dbo].[userRelatedNodes] as STRT
    WHERE STRT.Id = '94CC905E-AFCE-432F-B1B1-A17B937F9D1C' --'6FB7F55B-9E3D-428E-B1F9-20E4ACAB4297'
    UNION ALL
	--pretty typical 1 level graph query:
    SELECT RelNode.Id AS NodeId,
           RelNode.Name AS NodeName,
           TargetObject.Id AS RealtedNodeID,
           TargetObject.Name as RelatedNodeName,
           BaseRows.Path + '>' + TargetObject.RelationNodeType + ':' + TargetObject.Name,
           BaseRows.IdPath + CAST(TargetObject.Id AS VARCHAR(10)) + '\',
           CASE WHEN LEN(BaseRows.Permission) > 0 THEN CAST(BaseRows.Permission + ';' + ISNULL(PTH.Permission,'') AS VARCHAR(4000))
                    Else CAST(ISNULL(PTH.Permission,'') AS VARCHAR(4000)) END,
           BaseRows.level + 1
    FROM [dbo].[userRelatedNodes] as RelNode,
         [dbo].[userRelatedEdges] FOR PATH AS PTH,
         [dbo].[userRelatedNodes] FOR PATH AS TargetObject,
         BaseRows
    WHERE MATCH(RelNode-(PTH)->TargetObject)  
				--this joins the anchor to the recursive part of the query
                AND BaseRows.RealtedNodeID = RelNode.Id
				--this is the part that stops recursion
                AND NOT BaseRows.IdPath LIKE CONCAT('%\', TargetObject.Id, '\%')
                AND BaseRows.level <= 20)               
SELECT BaseRows.Path,
       BaseRows.IdPath,
       Baserows.PERMISSION
FROM BaseRows
WHERE BaseRows.RealtedNodeID = 'B8E6CB74-F88E-4B09-8481-2D75CDC34B5B';
GO


