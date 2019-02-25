  --Роли пользователя
 select sau.Name,sau1.Name,sau1.TSBranchCode from SYsAdminUnitInRole sa
 join SysAdminUnit sau on sau.Id = sa.SysAdminUnitId
 join SysAdminUnit sau1 on sau1.Id = sa.SysAdminUnitRoleId
 where sau.Name = 'HeadPM_branch'

 select sau.Name,sau1.Name,sau1.TSBranchCode from SysUserInRole sa
 join SysAdminUnit sau on sau.Id = sa.SysUserId
 join SysAdminUnit sau1 on sau1.Id = sa.SysRoleId
 where sau.Name = 'HeadPM_branch'
 
 --Проставить галочки в данных
UPDATE dc
  SET dc.IsForceUpdate = 'True'
FROM dbo.SysPackageSchemaDataColumn dc
JOIN dbo.SysPackageSchemaData d
  ON d.Id = dc.SysPackageSchemaDataId
JOIN dbo.SysPackage sp
  ON d.SysPackageId = sp.Id
JOIN dbo.SysWorkspace w
  ON w.Id = sp.SysWorkspaceId
WHERE w.[Name] = 'Default'
  AND d.[Name] IN
  (
	'Имя привязки'
  )
  
  --Активности по заявке (ОТП)
select a.* from Activity a with(nolock)
join TSApplication as tsa on tsa.Id = a.TSApplicationId
where tsa.TSNumber = 1955
order by a.CReatedOn desc 

--Права на объект по имени схемы
SELECT
  sau.Name,
  ss.Name,
  ses.CanRead,
  ses.CanAppend,
  ses.CanEdit,
  ses.CanDelete,
  ses.Position
FROM SysEntitySchemaOperationRight ses
JOIN SYsSchema ss
  ON ss.UId = ses.SubjectSchemaUId
JOIN SYsAdminUnit sau
  ON sau.Id = ses.SysAdminUnitId
WHERE ss.Name = 'Product'
ORDER BY ses.Position

	SELECT
	   ContactId 
	FROM
	   SysAdminUnit sau with(nolock)
	WHERE
	   EXISTS
	   (
	      SELECT
	         suir.SysUserId 
	      FROM
	         SysUserInRole suir  with(nolock)
	         INNER JOIN
	            SysAdminUnit s with(nolock)
	            ON s.id = suir.SysRoleId 
	            AND s.SysAdminUnitTypeValue = 2 
	      WHERE
	         suir.SysUserId = sau.Id 
	         AND EXISTS 
	         (
	            SELECT
	               su.SysRoleId 
	            FROM
	               SysUserInRole su with(nolock)
				join 
					sysadminunit sau1 on sau1.Id = su.SysRoleId
	            WHERE
	               su.SysUserId = 'A6F3F5C8-8530-4F58-A41D-053DA540C1AE' 
	               AND s.ParentRoleId = su.SysRoleId and sau1.SysAdminUnitTypeValue = 1
	         )
	   )
	   
--каст XML то бы весь влазил
 CAST('<A><![CDATA[' + CAST(TsRequest as nvarchar(max)) + ']]></A>' AS xml)
 
 --Все процессы по заявке 
 SELECT
  spl.Id AS [Id],
  spl.CreatedOn AS [CreatedOn],
  spl.StartDate AS [Process Start Date],
  spl.CompleteDate AS [Process End Date],
  spl.Name AS [Process Name],
  sps.Name AS [Status],
  tsa.TsNumber AS [Application Number]
FROM SysProcessLog spl
JOIN SysProcessEntity spe
  ON spe.SysProcessId = spl.Id
JOIN SysProcessStatus sps
  ON sps.Id = spl.StatusId
JOIN TSApplication tsa
  ON tsa.Id = spe.EntityId
WHERE tsa.TSNumber = '1538'
order by spl.CreatedOn desc