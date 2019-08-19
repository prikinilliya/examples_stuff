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

--поиск зацикленных зависимостей пакетов

--Oracle
SELECT "spd"."SysPackageId","sp"."Name","spd"."DependOnPackageId","sp1"."Name","spd1"."DependOnPackageId","sp2"."Name" FROM "SysPackageDependency" "spd"
  INNER JOIN "SysPackage" "sp" ON "sp"."Id" = "spd"."SysPackageId"
  INNER JOIN "SysPackage" "sp1" ON "sp1"."Id" = "spd"."DependOnPackageId"
  INNER JOIN "SysPackageDependency" "spd1" ON "spd1"."SysPackageId" = "spd"."DependOnPackageId"
  INNER JOIN "SysPackage" "sp2" ON "sp2"."Id" = "spd1"."DependOnPackageId"
  WHERE "sp"."Name" = 'название менявшегося пакета';
  
--MS SQL
select spd.syspackageid, sp.name, spd.dependonpackageid, sp2.name, spd2.dependonpackageid, sp3.name from SysPackageDependency spd 
inner join syspackage sp on sp.id = spd.syspackageid 
inner join syspackage sp2 on sp2.id = spd.dependonpackageid
inner join SysPackageDependency spd2 on spd2.syspackageid = spd.dependonpackageid
inner join syspackage sp3 on sp3.id = spd2.dependonpackageid where sp.name = 'название менявшегося пакета'