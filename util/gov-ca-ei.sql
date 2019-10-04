go

DROP TABLE IF EXISTS #dataLabel;
DROP TABLE IF EXISTS #dataSource;

go

CREATE TABLE #dataLabel
(
   RowID   uniqueIdentifier  not null  default newid(),
   Col01   nvarchar(256)	 not null
);

INSERT INTO #dataLabel
		(RowID, Col01)
	VALUES
		('96e215a4-25be-4ecd-ac02-ad71138c244e', 'Canada - EI premium rates and maximums'),
		('a363ae33-2d20-472a-a04f-ff3383c51fae', 'Labour'),
		('15d80e7b-408a-458a-af6a-56f1704c67ab', 'Maximum annual insurable earnings'),
		('a5a8182f-e6ad-4eb3-89e9-7a3250d5a050', 'Rate (%)'),
		('0838eb60-2c26-4eba-8d83-87ab613b47d9', 'Maximum annual employee premium'),
		('671e9770-1c5a-486d-8dfd-dd811840fd70', 'Maximum annual employer premium')
;

CREATE TABLE #dataSource
(
   RowID   uniqueIdentifier  not null  default newid(),    
   Col01   int				 not null, -- Year
   Col02   int				 not null, -- Maximum annual insurable earnings
   Col03   decimal(6,3)      not null, -- Rate (%)
   Col04   decimal(9,2)      not null, -- Maximum annual employee premium
   Col05   decimal(9,2)      not null  -- Maximum annual employer premium
);

go


INSERT INTO #dataSource
		(Col01, Col02, Col03, Col04, Col05)
	VALUES
		(2019,53100,1.62,860.22,1204.31),
		(2018,51700,1.66,858.22,1201.51),
		(2017,51300,1.63,836.19,1170.67),
		(2016,50800,1.88,955.04,1337.06),
		(2015,49500,1.88,930.6,1302.84),
		(2014,48600,1.88,913.68,1279.15),
		(2013,47400,1.88,891.12,1247.57),
		(2012,45900,1.83,839.97,1175.96),
		(2011,44200,1.78,786.76,1101.46),
		(2010,43200,1.73,747.36,1046.3),
		(2009,42300,1.73,731.79,1024.51),
		(2008,41100,1.73,711.03,995.44),
		(2007,40000,1.8,720,1008),
		(2006,39000,1.87,729.3,1021.02),
		(2005,39000,1.95,760.5,1064.7),
		(2004,39000,1.98,772.2,1081.08),
		(2003,39000,2.1,819,1146.6),
		(2002,39000,2.2,858,1201.2),
		(2001,39000,2.25,877.5,1228.5),
		(2000,39000,2.4,936,1310.49),
		(1999,39000,2.55,994.5,1392.3),
		(1998,39000,2.7,1053,1474.2)
;

SELECT
		*
	from
		#dataLabel
	order by
		Col01
;

SELECT
		*
	from
		#dataSource
	order by
		Col01
;

SELECT 
	(SELECT RowID FROM #dataLabel WHERE Col01='Canada - EI premium rates and maximums') AS [Collection],
	'https://github.com/DataSourceryIO/data/blob/master/gov-ca-ei.json' AS [Source],
	(SELECT RowID FROM #dataLabel WHERE Col01='Labour') [Category],
	(SELECT RowID, Col01 AS [en-us] FROM #dataLabel FOR JSON PATH) [Names],
	(
		SELECT 
			m.Col01 AS [Version],
			CAST(m.Col01 AS nvarchar(4)) + '-01-01' AS [ValidFrom],
			CAST(m.Col01 AS nvarchar(4)) + '-12-31' AS [ValidTo],
			(
				SELECT
					*
				FROM
					(
						SELECT
							(SELECT RowID FROM #dataLabel WHERE Col01='Maximum annual insurable earnings') [Name],
							Col02 [Value],
							null [Context.Scope],
							null [Context.Shift],
							null [Context.Meter]
						FROM
							#dataSource d
						WHERE
							d.Col01 = m.Col01

						UNION ALL

						SELECT
							(SELECT RowID FROM #dataLabel WHERE Col01='Rate (%)') [Name],
							Col03 [Value],
							null [Context.Scope],
							null [Context.Shift],
							null [Context.Meter]
						FROM
							#dataSource d
						WHERE
							d.Col01 = m.Col01

						UNION ALL

						SELECT
							(SELECT RowID FROM #dataLabel WHERE Col01='Maximum annual employee premium') [Name],
							Col04 [Value],
							null [Context.Scope],
							null [Context.Shift],
							null [Context.Meter]
						FROM
							#dataSource d
						WHERE
							d.Col01 = m.Col01

						UNION ALL

						SELECT
							(SELECT RowID FROM #dataLabel WHERE Col01='Maximum annual employer premium') [Name],
							Col05 [Value],
							null [Context.Scope],
							null [Context.Shift],
							null [Context.Meter]
						FROM
							#dataSource d
						WHERE
							d.Col01 = m.Col01

					) t
				FOR
					JSON PATH
			) [Values]
			FROM
				#dataSource m	
		FOR 
			JSON PATH
	) Versions
	FOR
		JSON PATH
;

go

DROP TABLE IF EXISTS #dataLabel;
DROP TABLE IF EXISTS #dataSource;

go