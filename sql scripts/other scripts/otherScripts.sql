SELECT 
 t.name as 'ParentObject',
 t1.name as 'ReferencedObject',
 dc.name as 'ConstaraintName'
FROM sys.tables t
INNER JOIN sys.foreign_keys dc ON t.object_id = dc.parent_object_id
INNER JOIN sys.tables t1 ON t1.object_id = dc.referenced_object_id
where dc.name = 'DFuWlPydEkYOBIjQKLzydz6BHkYk'
ORDER BY t.Name--поиск по имени fk констреинта