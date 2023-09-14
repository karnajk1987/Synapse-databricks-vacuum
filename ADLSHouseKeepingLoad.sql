/****** Object:  StoredProcedure [DATACATALOGUE].[ADLSHouseKeepingLoad]    Script Date: 8/30/2023 12:15:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [monitoring].[ADLSHouseKeepingLoad]
(
    -- Add the parameters for the stored procedure here
	@TargetFolderPath		  NVARCHAR(max),
	@IsVaccumDone			  BIT,
	@IsZOrderDone			  BIT,
	@Comments				  NVARCHAR(max) = Null
    
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @VaccumDatetime		DATETIME;
	DECLARE @ZorderDatetime		DATETIME;
	DECLARE @RecordCheck		BIT;
    SET NOCOUNT ON

	-- SET vaccumdatetime if vaccum is performed
	IF @IsVaccumDone = 1
		SET @VaccumDatetime = GETUTCDATE()
	Else
		SET @VaccumDatetime = (SELECT DISTINCT LastVaccumDateTime FROM [monitoring].[Housekeeping_Vacuum]
				WHERE TargetFolderPath = @TargetFolderPath)
	
	-- SET zorderdatetime if zordering is performed
	IF @IsZOrderDone = 1
		SET @ZorderDatetime = GETUTCDATE()
	Else
		SET @ZorderDatetime = (SELECT DISTINCT LastZOrderDateTime FROM [monitoring].[Housekeeping_Vacuum]
				WHERE TargetFolderPath = @TargetFolderPath)

	-- SET @RecordCheck = 1 if record already exists else 0
	IF EXISTS
			(
				SELECT DISTINCT 
					TargetFolderPath
				FROM [monitoring].[Housekeeping_Vacuum]
				WHERE TargetFolderPath = @TargetFolderPath
			)
			SET @RecordCheck = 1
		ELSE
			SET @RecordCheck = 0

	IF @RecordCheck = 0
		BEGIN
		  INSERT INTO [monitoring].[Housekeeping_Vacuum]
			([TargetFolderPath]
			,[LastVaccumDateTime]
			,[LastZOrderDateTime]
			,[Comments])
		  VALUES
			(@TargetFolderPath
			,@VaccumDatetime
			,@ZorderDatetime
			,@Comments)
		END
	ELSE IF @RecordCheck = 1
		BEGIN
		  UPDATE [monitoring].[Housekeeping_Vacuum]
			SET [LastVaccumDateTime] = @VaccumDatetime,
				[LastZOrderDateTime] = @ZorderDatetime,
				[Comments] = @Comments
			WHERE 
				TargetFolderPath = @TargetFolderPath
		END
   
END
GO


