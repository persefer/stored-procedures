SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[YoneticiRaporları_GelirTablosu]
AS
    SELECT 
        SUM(ISNULL([Banknot],0))                                             AS   Banknot
       ,YIL                                                                  AS   YEAR 
       ,FIRST_VALUE(AY) over (partition by KPIKodu, YIL order by AY desc)    AS   MONTH
       ,KPIKodu                                                              AS   KPI_CODE
       ,FIRST_VALUE(Value) over (partition by KPIKodu, YIL order by AY desc) AS   VALUE
       ,ISNULL(NULLIF([BUDGET_VALUE],''), '0')                               AS   BUDGET	
    FROM
	Logo.dbo.F_FINANCIAL_KPI
    WHERE 1=1
  
GO
