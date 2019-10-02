go

DROP TABLE IF EXISTS #dataLabel;
DROP TABLE IF EXISTS #dataSource;

go

CREATE TABLE #dataLabel
(
   RowID   uniqueIdentifier  not null  default newid(),
   Col01   nvarchar(256)	 not null
);

CREATE TABLE #dataSource
(
   RowID   uniqueIdentifier  not null  default newid(),
   Col01   int				 not null, -- Year
   Col02   int				 not null, -- Maximum annual pensionable earnings
   Col03   int				 not null, -- Basic exemption amount
   Col04   int				 not null, -- Maximum contributory earnings
   Col05   decimal(6,3)      not null, -- Employee and employer contribution rate (%)
   Col06   decimal(9,2)      not null, -- Maximum annual employee and employer contribution
   Col07   decimal(9,2)      not null -- Maximum annualself-employedcontribution
);

go

INSERT INTO #dataLabel
		(RowID, Col01)
	VALUES
		('5fcfa609-472b-4b2f-8b26-756a95870475', 'Any'),
		('f7359d72-750e-4f1f-abe9-a69f72a3b521', 'Canada - CPP contribution rates, maximums and exemptions'),
		('a363ae33-2d20-472a-a04f-ff3383c51fae', 'Labour'),
		('8af87405-e685-4e3c-a898-c43f1a095581', 'Year'),
		('768fbd91-155d-4a30-bdd0-71696a2353c2', 'Maximum annual pensionable earnings'),
		('c27ecfa8-d15b-4de3-884d-370d390eca0e', 'Basic exemption amount'),
		('afe888a8-7b2c-42d7-aedc-0905e3f581c5', 'Maximum contributory earnings'),
		('8c2579db-6a50-4528-b122-9b68c9015ab1', 'Employee and employer contribution rate (%)'),
		('6edfd166-cd4a-4bd2-b7c2-172668088d0c', 'Maximum annual employee and employer contribution'),
		('75722813-ab86-41d7-8b95-248a7cae5ed2', 'Maximum annualself-employedcontribution')
;

INSERT INTO #dataSource
		(Col01, Col02, Col03, Col04, Col05, Col06, Col07)
	VALUES
		(2019,57400,3500,53900,5.1,2748.9,5497.8),
		(2018,55900,3500,52400,4.95,2593.8,5187.6),
		(2017,55300,3500,51800,4.95,2564.1,5128.2),
		(2016,54900,3500,51400,4.95,2544.3,5088.6),
		(2015,53600,3500,50100,4.95,2479.95,4959.9),
		(2014,52500,3500,49000,4.95,2425.5,4851),
		(2013,51100,3500,47600,4.95,2356.2,4712.4),
		(2012,50100,3500,46600,4.95,2306.7,4613.4),
		(2011,48300,3500,44800,4.95,2217.6,4435.2),
		(2010,47200,3500,43700,4.95,2163.15,4326.3),
		(2009,46300,3500,42800,4.95,2118.6,4237.2),
		(2008,44900,3500,41400,4.95,2049.3,4098.6),
		(2007,43700,3500,40200,4.95,1989.9,3979.8),
		(2006,42100,3500,38600,4.95,1910.7,3821.4),
		(2005,41100,3500,37600,4.95,1861.2,3722.4),
		(2004,40500,3500,37000,4.95,1831.5,3663),
		(2003,39900,3500,36400,4.95,1801.8,3603.6),
		(2002,39100,3500,35600,4.7,1673.2,3346.4),
		(2001,38300,3500,34800,4.3,1496.4,2992.8),
		(2000,37600,3500,34100,3.9,1329.9,2659.8),
		(1999,37400,3500,33900,3.5,1186.5,2373),
		(1998,36900,3500,33400,3.2,1068.8,2137.6),
		(1997,35800,3500,32300,2.925,944.78,1889.55),
		(1996,35400,3500,31900,2.8,893.2,1786.4),
		(1995,34900,3400,31500,2.7,850.5,1701),
		(1994,34400,3400,31000,2.6,806,1612),
		(1993,33400,3300,30100,2.5,752.5,1505),
		(1992,32200,3200,29000,2.4,696,1392),
		(1991,30500,3000,27500,2.3,632.5,1265),
		(1990,28900,2800,26100,2.2,574.2,1148.4),
		(1989,27700,2700,25000,2.1,525,1050),
		(1988,26500,2600,23900,2,478,956),
		(1987,25900,2500,23400,1.9,444.6,889.2),
		(1986,25800,2500,23300,1.8,419.4,838.8),
		(1985,23400,2300,21100,1.8,379.8,759.6),
		(1984,20800,2000,18800,1.8,338.4,676.8),
		(1983,18500,1800,16700,1.8,300.6,601.2),
		(1982,16500,1600,14900,1.8,268.2,536.4),
		(1981,14700,1400,13300,1.8,239.4,478.8),
		(1980,13100,1300,11800,1.8,212.1,424.8),
		(1979,11700,1100,10600,1.8,190.8,381.6),
		(1978,10400,1000,9400,1.8,169.2,338.4),
		(1977,9300,900,8400,1.8,151.2,302.4),
		(1976,8300,800,7500,1.8,135,270),
		(1975,7400,700,6700,1.8,120.6,241.2),
		(1974,6600,700,5900,1.8,106.2,212.4),
		(1973,5600,600,5000,1.8,90,180),
		(1972,5500,600,4900,1.8,88.2,176.4),
		(1971,5400,600,4800,1.8,86.4,172.8),
		(1970,5300,600,4700,1.8,84.6,169.2),
		(1969,5200,600,4600,1.8,82.8,165.6),
		(1968,5100,600,4500,1.8,81,162),
		(1967,5000,600,4400,1.8,79.2,158.4),
		(1966,5000,600,4400,1.8,79.2,158.4)
;

SELECT
		*
	from
		#dataSource
	order by
		Col01
	FOR
		JSON AUTO
;

SELECT
		RowID,
		null [Division],
		'f7359d72-750e-4f1f-abe9-a69f72a3b521' [Collection],
		Col01 [Revision],
		'a363ae33-2d20-472a-a04f-ff3383c51fae' [Type],
		null [Scope],
		null [Subscope],
		null [Meter],
		null [Measure],
		'afe888a8-7b2c-42d7-aedc-0905e3f581c5' [Data.Name],
		Col04 [Data.Value],
		'8c2579db-6a50-4528-b122-9b68c9015ab1' [Data.Name],
		Col05 [Data.Value]


	from
		#dataSource
	order by
		Col01
	FOR
		JSON PATH
;

go

DROP TABLE IF EXISTS #dataLabel;
DROP TABLE IF EXISTS #dataSource;

go