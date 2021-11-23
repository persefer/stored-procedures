SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Request_Load] 
	-- Add the parameters for the stored procedure here
	@p_Type tinyint,
	@p_Owner nvarchar(50)
AS
	DECLARE @p_SP_Name NVARCHAR(20) = OBJECT_NAME( @@PROCID );
	DECLARE @p_log_message NVARCHAR(400);
	DECLARE @p_rowcount int;
	DECLARE @p_start_date_time datetime;
	DECLARE @p_start_date char(8);
	DECLARE @p_start_time char(6);
BEGIN
	
	set @p_log_message = N'Prosedür başladı.';
	exec Logging...[sp_Log] @Log_SP=@p_SP_Name, @Log_Message=@p_log_message, @Log_Severity=0;

	set @p_start_date_time=DATEADD(minute,3,getdate());
	set @p_start_date=FORMAT(@p_start_date_time, 'yyyyMMdd');
	set @p_start_time=FORMAT(@p_start_date_time, 'HHmmss');

	if @p_Type=1
	begin
		set @p_log_message = N'Sadece yükleme yapılacak.';
		exec Logging...[sp_Log] @Log_SP=@p_SP_Name, @Log_Message=@p_log_message, @Log_Severity=0;

		begin try
			begin transaction

	select @p_int=START_REQUESTED_FLAG
	from Z_SP_STATUS
	where 
	SP_NAME='sp_Load_logo';
	
	
				update
				Z_SP_STATUS WITH(NOWAIT)
				set
				START_REQUESTED_FLAG=1,
				START_REQUESTED_DATE_TIME=GETDATE(),
				START_REQUESTED_BY=ISNULL(@p_Owner,'[Bilinmiyor]')
				where 
				SP_NAME='sp_Load_logo'
				and 
				(
				START_REQUESTED_FLAG=0
				or START_REQUESTED_FLAG is null
				);




		set @p_log_message = N'VA_SUBE_NO_MASRAF_YERI tablosu dolduruluyor';
		exec dbo.[sp_Log] @Log_SP=@SP_Name, @Log_Message=@p_log_message, @Log_Severity=0;

			MERGE INTO [dbo].[VA_SUBE_NO_MASRAF_YERI] AS target
			USING 
			(
				SELECT 
					[id]
					,[subeno]
					,[masrafkodu]
				FROM [10.0.0.234].[BantasForms].[dbo].[subeno_masrafyeri] with (nolock)
			) AS source 
			ON 	(target.id = source.id)
			when not matched then 
			insert
			(
				[id]
				,[subeno]
				,[masrafkodu]
				,WH_INSERTID
				,WH_INSERTDATE
			) 
			VALUES
			(
				source.[id]
				,source.[subeno]
				,source.[masrafkodu]
				,@p_Etl_Id
				,getdate()
			);
			


				set @p_rowcount=@@ROWCOUNT;

				set @p_log_message = N'Satır sayısı: '+CAST(@p_rowcount as varchar(1));
				exec Logging...[sp_Log] @Log_SP=@p_SP_Name, @Log_Message=@p_log_message, @Log_Severity=0;

				if (@p_rowcount!=1)
				begin
					set @p_log_message = N'Beklenen sonuca ulaşılamadı.';
					exec Logging...[sp_Log] @Log_SP=@p_SP_Name, @Log_Message=@p_log_message, @Log_Severity=0;

					THROW 51000, 'Muhtemelen çalışma veya bekleyen istek var.', 1;  

				end;

				exec msdb.dbo.sp_update_schedule  
					@schedule_id = 28,  
					@enabled = 1,
					@freq_type = 1,
					@active_start_date=@p_start_date,
					@active_start_time=@p_start_time;

			commit transaction
		end try
		begin catch
			
			set @p_log_message = N'istek başarısız.';
			exec Logging...[sp_Log] @Log_SP=@p_SP_Name, @Log_Message=@p_log_message, @Log_Severity=0;

			rollback;
			
		end catch
	end;
END
