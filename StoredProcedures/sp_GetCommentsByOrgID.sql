USE [StudentOrgs]
GO

/****** Object:  StoredProcedure [dbo].[sp_GetCommentsByOrgID]    Script Date: 02/08/2013 09:41:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Sree>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_GetCommentsByOrgID]
	-- Add the parameters for the stored procedure here
	@OrganizationID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Date, Text,UserID 
	FROM OrgComments
	WHERE Organization_ID=@OrganizationID ORDER BY DATE DESC
	
if @@ERROR<>0
		BEGIN 
		raiserror('100',16,1)
		return -100;
		END
		
	else return 0;
END 
GO

