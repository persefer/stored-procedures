SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[F_KUR](
@in_try_value float,
@in_date date,
@in_to_kur_kodu nvarchar(50)
)
returns float as
begin
	declare @donusum_value float;

	select
     @donusum_value=@in_try_value/TLValue
	from
	   Web.dbo.Kur
	where
	   @in_date >= StartDate and @in_date < EndDate
	and
	   Type=@in_to_kur_kodu;

	return @donusum_value;

end;
GO
