SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[YoneticiRaporları_GelirTablosu]
AS
SELECT DISTINCT 
	YIL, 
	FIRST_VALUE(AY) over (partition by KPIKodu, YIL order by AY desc) AY,
	KPIKodu,
	KPIAciklamasi, 
	FIRST_VALUE(Value) over (partition by KPIKodu, YIL order by AY desc) VALUE
FROM
	Logo.dbo.F_FINANSAL_KPI
  
GO
