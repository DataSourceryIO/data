
DROP TABLE IF EXISTS #dataLabel;
DROP TABLE IF EXISTS #dataVersion;
DROP TABLE IF EXISTS #dataSource;

CREATE TABLE #dataLabel
(
   RowID   uniqueIdentifier  not null  default newid(),
   Col01   nvarchar(256)	 not null
)

INSERT INTO #dataLabel
		(RowID, Col01)
	VALUES
		('A363AE33-2D20-472A-A04F-FF3383C51FAE', 'Labour'),

		('648BA67E-8682-420F-B02E-D88E042E1664', 'Base Rate'),
		('6AE63D1C-AB30-43D3-9FAA-A77419769F34', 'Holiday and Vacation'),
		('D18B89A0-FF18-47C4-831E-F1CF2333EEEE', 'Health and Welfare'),
		('5E827528-442E-4022-A6B2-0179D83975C6', 'Pension'),
		('C97FA357-7367-4332-BF07-E77E24A0724A', 'Training'),
		('5A29070C-0E81-433D-8132-E333C29D4DCC', 'Gross Rate'),

		('3E2C9035-B949-4990-87FF-59233ABFD233', 'Shift Premium'),

		('D9466448-6510-4F41-A0AE-43C77F8224F5', 'Straight-time'),

		('9A3F4597-8DC5-4122-ABCF-D2FC1F756731', 'Second shift'),
		('437D44D8-B37A-4F60-AA88-A4236F3E5BEC', 'Third shift'),

		('A687F373-502B-4A1C-8AB3-E7DF4A40ECA0', '% of Certified Construction Craft Labourer Rate'),

		('B02A59B6-ED51-4501-AE0B-0BE1BA409EAD', 'Part A (Industrial)'),
		('63838AC5-4E2F-4E16-828B-C01611DCF5BB', 'Certified Construction Craft Labourer'),
		('485D151C-2EC8-4AA1-B374-FA3974348A5C', 'Uncertified Labourer'),
		('34C68478-2133-449C-8EB6-148E075FD9C7', 'Trainee 3'),
		('19D6930B-2BA3-40B8-AAB8-E5BAE611B504', 'Trainee 2'),
		('F74E071A-FE30-4912-8A39-992A570828A8', 'Trainee 1')

--SELECT * FROM #dataLabel FOR JSON AUTO

CREATE TABLE #dataVersion
(
   [Version] int             not null,
   ValidFrom nvarchar(10)	 not null,
   ValidTo nvarchar(10),
)

INSERT INTO #dataVersion
		([Version], ValidFrom, ValidTo)
	VALUES
		(1,'2015-05-03','2015-10-31'),
		(2,'2015-11-01','2016-04-30'),
		(3,'2016-05-01','2016-10-31'),
		(4,'2016-11-01','2017-05-06'),
		(5,'2017-05-07','2017-11-04'),
		(6,'2017-11-05','2018-05-05'),
		(7,'2018-05-06','2018-11-03'),
		(8,'2018-11-04',null)

--SELECT * FROM #dataVersion FOR JSON AUTO

CREATE TABLE #dataSource
(
   RowID   uniqueIdentifier  not null  default newid(),  
   Scope   nvarchar(36)      not null, -- Scope  
   Col01   int				 not null, -- Version
   Col02   decimal(6,3)      not null, -- % of Certified Construction Craft Labourer Rate
   Col03   decimal(9,2)		 not null, -- Base Rate
   Col04   decimal(9,2)      not null, -- Holiday & Vacation
   Col05   decimal(9,2)      not null, -- Health & Welfare
   Col06   decimal(9,2)      not null, -- Pension
   Col07   decimal(9,2)      not null, -- Training
   Col08   decimal(9,2)      not null  -- Gross Rate
)

INSERT INTO #dataSource
		(Scope, Col01, Col02, Col03, Col04, Col05, Col06, Col07, Col08)
	VALUES
		('63838AC5-4E2F-4E16-828B-C01611DCF5BB',1,1,35.74,3.57,2.06,5.06,0.45,46.88),
		('485D151C-2EC8-4AA1-B374-FA3974348A5C',1,0.93,33.24,3.32,2.06,5.06,0.45,44.13),
		('34C68478-2133-449C-8EB6-148E075FD9C7',1,0.85,30.38,3.04,2.06,4.30,0.45,40.23),
		('19D6930B-2BA3-40B8-AAB8-E5BAE611B504',1,0.75,26.81,2.68,2.06,3.80,0.45,35.80),
		('F74E071A-FE30-4912-8A39-992A570828A8',1,0.65,23.23,2.32,2.06,3.29,0.45,31.35),

		('63838AC5-4E2F-4E16-828B-C01611DCF5BB',8,1,36.05,3.61,2.06,5.06,0.45,47.23),
		('485D151C-2EC8-4AA1-B374-FA3974348A5C',8,0.93,33.53,3.35,2.06,5.06,0.45,44.45),
		('34C68478-2133-449C-8EB6-148E075FD9C7',8,0.85,30.64,3.06,2.06,4.30,0.45,40.51),
		('19D6930B-2BA3-40B8-AAB8-E5BAE611B504',8,0.75,27.03,2.70,2.06,3.80,0.45,36.04),
		('F74E071A-FE30-4912-8A39-992A570828A8',8,0.65,23.43,2.34,2.06,3.29,0.45,31.57)


--SELECT * FROM #dataSource

SELECT
	(SELECT RowID FROM #dataLabel WHERE Col01='Part A (Industrial)') AS [Collection],
	'https://github.com/DataSourceryIO/data/blob/master/crla-ca-ab-labourers.json' AS [Source],
	(SELECT RowID FROM #dataLabel WHERE Col01='Labour') [Category],
	(SELECT RowID, Col01 AS [en-us] FROM #dataLabel FOR JSON PATH) [Names],
	(
		SELECT
			v.[Version],
			v.[ValidFrom],
			v.[ValidTo],
			(
				SELECT
					*
				FROM
					(
						SELECT
							(SELECT RowID FROM #dataLabel WHERE Col01='% of Certified Construction Craft Labourer Rate') [Name],
							CAST(Col02 AS nvarchar(36)) [Value],
							d.Scope [Context.Scope],
							null [Context.Meter],
							null [Context.Shift]
						FROM
							#dataSource d
						WHERE
							(v.[Version] < 8 and d.Col01 = 1) or
							(v.[Version] = d.Col01)
						
						UNION ALL

						SELECT
							(SELECT RowID FROM #dataLabel WHERE Col01='Base Rate') [Name],
							CAST(Col03 AS nvarchar(36)) [Value],
							d.Scope [Context.Scope],
							(SELECT RowID FROM #dataLabel WHERE Col01='Straight-time') [Context.Meter],
							null [Context.Shift]
						FROM
							#dataSource d
						WHERE
							(v.[Version] < 8 and d.Col01 = 1) or
							(v.[Version] = d.Col01)
						
						UNION ALL

						SELECT
							(SELECT RowID FROM #dataLabel WHERE Col01='Holiday and Vacation') [Name],
							CAST(Col04 AS nvarchar(36)) [Value],
							d.Scope [Context.Scope],
							(SELECT RowID FROM #dataLabel WHERE Col01='Straight-time') [Context.Meter],
							null [Context.Shift]
						FROM
							#dataSource d
						WHERE
							(v.[Version] < 8 and d.Col01 = 1) or
							(v.[Version] = d.Col01)
						
						UNION ALL

						SELECT
							(SELECT RowID FROM #dataLabel WHERE Col01='Health and Welfare') [Name],
							CAST(Col05 AS nvarchar(36)) [Value],
							d.Scope [Context.Scope],
							(SELECT RowID FROM #dataLabel WHERE Col01='Straight-time') [Context.Meter],
							null [Context.Shift]
						FROM
							#dataSource d
						WHERE
							(v.[Version] < 8 and d.Col01 = 1) or
							(v.[Version] = d.Col01)
						
						UNION ALL

						SELECT
							(SELECT RowID FROM #dataLabel WHERE Col01='Pension') [Name],
							CAST(Col06 AS nvarchar(36)) [Value],
							d.Scope [Context.Scope],
							(SELECT RowID FROM #dataLabel WHERE Col01='Straight-time') [Context.Meter],
							null [Context.Shift]
						FROM
							#dataSource d
						WHERE
							(v.[Version] < 8 and d.Col01 = 1) or
							(v.[Version] = d.Col01)
						
						UNION ALL

						SELECT
							(SELECT RowID FROM #dataLabel WHERE Col01='Training') [Name],
							CAST(Col07 AS nvarchar(36)) [Value],
							d.Scope [Context.Scope],
							(SELECT RowID FROM #dataLabel WHERE Col01='Straight-time') [Context.Meter],
							null [Context.Shift]
						FROM
							#dataSource d
						WHERE
							(v.[Version] < 8 and d.Col01 = 1) or
							(v.[Version] = d.Col01)
						
						UNION ALL

						SELECT
							(SELECT RowID FROM #dataLabel WHERE Col01='Gross Rate') [Name],
							CAST(Col08 AS nvarchar(36)) [Value],
							d.Scope [Context.Scope],
							(SELECT RowID FROM #dataLabel WHERE Col01='Straight-time') [Context.Meter],
							null [Context.Shift]
						FROM
							#dataSource d
						WHERE
							(v.[Version] < 8 and d.Col01 = 1) or
							(v.[Version] = d.Col01)

						UNION ALL

						SELECT
							(SELECT RowID FROM #dataLabel WHERE Col01='Shift Premium') [Name],
							'3.00' [Value],
							d.Scope [Context.Scope],
							null [Context.Meter],
							(SELECT RowID FROM #dataLabel WHERE Col01='Second shift') [Context.Shift]
						FROM
							#dataSource d
						WHERE
							(v.[Version] < 8 and d.Col01 = 1) or
							(v.[Version] = d.Col01)

						UNION ALL

						SELECT
							(SELECT RowID FROM #dataLabel WHERE Col01='Shift Premium') [Name],
							'3.00' [Value],
							d.Scope [Context.Scope],
							null [Context.Meter],
							(SELECT RowID FROM #dataLabel WHERE Col01='Third shift') [Context.Shift]
						FROM
							#dataSource d
						WHERE
							(v.[Version] < 8 and d.Col01 = 1) or
							(v.[Version] = d.Col01)

					) t
				FOR
					JSON PATH
			) [Values]
			FROM
				#dataVersion v	
		FOR 
			JSON PATH
	) Versions
	FOR
		JSON PATH

--DROP TABLE IF EXISTS #dataLabel;
--DROP TABLE IF EXISTS #dataVersion;
--DROP TABLE IF EXISTS #dataSource;
