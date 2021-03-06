print 'Custom Trigger tIUD_OrgCategory'
go

If Exists(Select name
From sysobjects
Where name='tIUD_OrgCategory'
And (type= 'TR')
And uid = User_id('dbo'))
Drop Trigger dbo.tIUD_OrgCategory
go

Create Trigger dbo.tIUD_OrgCategory
   On dbo.OrgCategory
   for Insert, Update, Delete
   Not for Replication
As
Begin
/**********************************************************
*Trigger Name: tIUD_OrgCategory

select * from tIUD_OrgCategory
Category_ID CategoryName Description AddDate EndDate GreekOrg
------------ -------------------------------------------------- --------------------- ----------- --------------- ----------- -------------------------------------------------- -------------- ------------- ------------ ----------- ------------------- -------------- -------------- -------------------- --------- -------------
***********************************************************/
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @errno int,
           @errmsg varchar(255)

SELECT @numrows = @@ROWCOUNT
/* ------------------------- */

INSERT INTO dbo.AuditTrail 
	(UserID, Date, type, OldValue, NewValue,TableName)
SELECT SUSER_SNAME(), getdate(), 'IN', '<NONE>', 
	convert(varchar(6),inserted.Category_ID) + ': ' + inserted.CategoryName + ': ' + inserted.Description + ': '+
	convert(varchar(20),inserted.AddDate) + ': ' + convert(varchar(20),inserted.EndDate) + ': ' + convert(varchar(2),inserted.GreekOrg) ,'OrgCategory' 
FROM inserted 
WHERE NOT EXISTS(select * from deleted where inserted.Category_ID = deleted.Category_ID)

SELECT @errno = @@ERROR
IF @errno <> 0
BEGIN
     SELECT @errmsg = 'Cannot audit adding Member Type.'
     GOTO error
END

INSERT INTO dbo.AuditTrail 
	(UserID, Date, type, OldValue, NewValue,TableName)
SELECT SUSER_SNAME(),getdate(), 'DL',
		convert(varchar(6),deleted.Category_ID) + ': ' + deleted.CategoryName + ': ' + deleted.Description  + ': '+
	convert(varchar(20),deleted.AddDate) + ': ' +convert(varchar(20),deleted.EndDate) + ': ' + convert(varchar(2),deleted.GreekOrg) , 
	'<NONE>','OrgCategory'
FROM deleted 
WHERE NOT EXISTS(select * from inserted where inserted.Category_ID = deleted.Category_ID)

SELECT @errno = @@ERROR
IF @errno <> 0
BEGIN
     SELECT @errmsg = 'Cannot audit deleting Member Type.'
     GOTO error
END

IF UPDATE(CategoryName)
BEGIN
	INSERT INTO dbo.AuditTrail 
		(UserID, Date, type, OldValue, NewValue,TableName)
	SELECT SUSER_SNAME(), getdate(), 'UP:CategoryName',  
		convert(varchar(6),deleted.Category_ID) + ': ' + deleted.CategoryName,
		convert(varchar(6),inserted.Category_ID) + ': ' + inserted.CategoryName,'OrgCategory'
	FROM deleted
	INNER JOIN inserted ON inserted.Category_ID = deleted.Category_ID
	WHERE deleted.CategoryName <> inserted.CategoryName

	SELECT @errno = @@ERROR
	IF @errno <> 0
	BEGIN
		 SELECT @errmsg = 'Cannot audit updating CategoryName.'
		 GOTO error
	END
END

IF UPDATE(GreekOrg)
BEGIN
	INSERT INTO dbo.AuditTrail 
		(UserID, Date, type, OldValue, NewValue,TableName)
	SELECT SUSER_SNAME(), getdate(), 'UP:GreekOrg',  
		convert(varchar(6),deleted.Category_ID) + ': ' + Convert(varchar(2),deleted.GreekOrg),
		convert(varchar(6),inserted.Category_ID) + ': ' + Convert(varchar(2),inserted.GreekOrg),'OrgCategory'
	FROM deleted
	INNER JOIN inserted ON inserted.Category_ID = deleted.Category_ID
	WHERE deleted.GreekOrg <> inserted.GreekOrg

	SELECT @errno = @@ERROR
	IF @errno <> 0
	BEGIN
		 SELECT @errmsg = 'Cannot audit updating GreekOrg.'
		 GOTO error
	END
END

IF UPDATE(Description)
BEGIN
	INSERT INTO dbo.AuditTrail 
		(UserID, Date, type, OldValue, NewValue,TableName)
	SELECT SUSER_SNAME(), getdate(), 'UP:AddDate',  
		convert(varchar(6),deleted.Category_ID) + ': ' + deleted.Description,
		convert(varchar(6),inserted.Category_ID) + ': ' + inserted.Description,'OrgCategory'
	FROM deleted
	INNER JOIN inserted ON inserted.Category_ID = deleted.Category_ID
	WHERE deleted.Description <> inserted.Description

	SELECT @errno = @@ERROR
	IF @errno <> 0
	BEGIN
		 SELECT @errmsg = 'Cannot audit updating Description.'
		 GOTO error
	END
END

IF UPDATE(EndDate)
BEGIN
	INSERT INTO dbo.AuditTrail 
		(UserID, Date, type, OldValue, NewValue,TableName)
	SELECT SUSER_SNAME(), getdate(), 'UP:EndDate',  
		convert(varchar(6),deleted.Category_ID) + ': ' + convert(varchar(20),deleted.EndDate),
		convert(varchar(6),inserted.Category_ID) + ': ' +convert(varchar(20),inserted.EndDate),'OrgCategory'
	FROM deleted
	INNER JOIN inserted ON inserted.Category_ID = deleted.Category_ID
	WHERE deleted.EndDate <> inserted.EndDate

	SELECT @errno = @@ERROR
	IF @errno <> 0
	BEGIN
		 SELECT @errmsg = 'Cannot audit updating AddDate.'
		 GOTO error
	END
END

IF UPDATE(AddDate)
BEGIN
	INSERT INTO dbo.AuditTrail 
		(UserID, Date, type, OldValue, NewValue,TableName)
	SELECT SUSER_SNAME(), getdate(), 'UP:Date',  
		convert(varchar(6),deleted.Category_ID) + ': ' + convert(varchar(20),deleted.AddDate),
		convert(varchar(6),inserted.Category_ID) + ': ' +convert(varchar(20),inserted.AddDate),'OrgCategory'
	FROM deleted
	INNER JOIN inserted ON inserted.Category_ID = deleted.Category_ID
	WHERE deleted.AddDate <> inserted.AddDate

	SELECT @errno = @@ERROR
	IF @errno <> 0
	BEGIN
		 SELECT @errmsg = 'Cannot audit updating EndDate.'
		 GOTO error
	END
END

/* -------------------------- */
  RETURN
error:
  RAISERROR @errno @errmsg
  ROLLBACK TRANSACTION
END

