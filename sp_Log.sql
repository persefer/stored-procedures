SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		  Ozan Dikerler, persefer@hotmail.com>
-- Description:	Logging function
--
-- USAGE
--
-- 1. Add below line to declaration part of the SP
--     DECLARE @p_log_message NVARCHAR(400);
--     DECLARE @SP_Name NVARCHAR(20) = OBJECT_NAME( @@PROCID );
--     
-- 2. Call the function at the begining & end of each operation for logging
--      set @p_log_message = N'Procedure Starts';
--			exec dbo.[sp_Log] @Log_SP=@SP_Name, @Log_Message=@p_log_message, @Log_Severity=0;
--      
-- Optional. Add below line to the ROLLBACK TRANSACTION
--    SELECT  @p_log_message = 'HATA! Satir: '+CAST(ERROR_LINE() AS varchar) + ' '+ ERROR_MESSAGE();  
--    exec dbo.[sp_Log] @Log_SP=@SP_Name, @Log_Message=@p_log_message, @Log_Severity=0;
--      
-- =============================================


CREATE TABLE [dbo].[Z_LOG](
	[Log_ID] [int] IDENTITY(1,1) NOT NULL,
	[Log_Datetime] [datetime] NULL,
	[Log_SP] [nvarchar](128) NULL,
	[Log_Message] [nvarchar](400) NULL,
	[Log_Severity] [int] NULL
) ON [PRIMARY]
GO


CREATE PROCEDURE [dbo].[sp_Log]
	@Log_SP NVARCHAR(128),
	@Log_Message NVARCHAR(400),
	@Log_Severity INT
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @Sql NVARCHAR(MAX);
    -- Insert statements for procedure here

		INSERT into [dbo].[Z_LOG]
			(
				[Log_Datetime]
				,[Log_SP]
				,[Log_Message]
				,[Log_Severity]
			)
			VALUES (
			 GETDATE()
			 , @Log_SP
			 ,@Log_Message
			 ,@Log_Severity);
END
