create proc getGroupID  /*sha8ala sa7*/
@groupID INT output,
@groupName varchar(50)
AS
select @groupid=NSNgroup.NSNgroupID from NSNgroup where NSNgroup_name = @groupName;
GO

create proc add_to_group /* sha8ala sa7 */
@memberusername varchar(100),
@adminusername varchar (100),
@groupname varchar (50)
As
declare @memberID int, @adminID int , @groupid int;
exec getGroupID @groupid output ,@groupname;
SELECT @memberID = member.memberID from member where @memberusername = member.username;
SELECT @adminID = member.memberID from member where @adminusername = member.username;
if (exists(select * from m_admin where memberID=@adminID and NSNgroupID=@groupID) and exists(select *from adds_to_group where new_memberID=@adminID and NSNgroupID =@groupID))
insert into adds_to_group values (@adminID,@memberID,@groupid);
GO		

CREATE PROC BuyItem /*sha8ala tmam*/
@itemID INT,
@username varchar (100)
AS
declare @memberID INT;
select @memberID = member.memberID from member where member.username=@username ;
if (EXISTS(select * from item where item.itemID=@itemID and item.isBought = 0))
begin 
update item set item.isBought = 1 where itemID = @itemID;
insert into buy_item values (@itemID,@memberID,GETDATE());	
end
GO

create proc CREATE_GROUP /* sha8ala sa7 */
@username varchar (100),
@groupName varchar (50)
AS
Declare @memberID INT;
select  @memberID=member.memberID from member where member.username = @username;
IF (NOT EXISTS (SELECT  * from NSNGroup where NSNGroup_name =@groupName ))
insert into NSNgroup values (@groupname,@memberID);
declare @groupID int;
exec getGroupID @groupID output, @groupName;
insert into m_admin values (@memberID,@memberID,@groupID);
insert into adds_to_group values (@memberID,@memberID,@groupID);
GO

CREATE PROC DELETE_GROUP /* sha8ala tmam */
@groupID INT,
@username varchar (100)
AS
declare @myid  int;
select  @myid =member.memberID from member where member.username=@username; 

IF (Exists (SELECT * FROM NSNgroup   where NSNgroupID=@groupID and @myid =creatorID ))
begin
delete from NSNgroup where NSNgroupID=@groupID
end
GO

CREATE PROC FindAvailableServices 
@start_time DATETIME,
@end_time DATETIME
AS
SELECT useService.serviceUsedID from useService where @start_time > useService.end_time or @end_time < useService.start_time

GO


create proc MAKE_ADMIN /*sha8ala tmam	*/
@adminusername varchar (100),
@memberusername varchar(100),
@groupname varchar (50)
AS
declare @memberID INT,@adminID INT;
SELECT @memberID = member.memberID from member where @memberusername = member.username;
SELECT @adminID = member.memberID from member where @adminusername = member.username;
declare @groupID INT;
exec getGroupID  @groupID output,@groupname;
if(exists(select * from m_admin where m_admin.memberID=@adminID and m_admin.NSNgroupID=@groupID)and Exists (select * from adds_to_group where @memberID=new_memberID and adds_to_group.NSNgroupID=@groupID))
begin
insert into m_admin values (@adminID,@memberID,@groupID);

end
GO

create proc offeritem /*sha8ala tmam */
@username varchar(100),
@itemName varchar(50),
@price decimal (10,2)
AS
declare @memberID int,@id int;
select @memberID=member.memberID from member where @username= member.username;
insert into item values (@itemName,@price,@memberID,0);
GO


create proc offerService  
@username varchar(100),
@serviceName varchar(100),
@price decimal (10,2)
AS
declare @memberID int;
SELECT @memberID = member.memberID from member where @username = member.username;
insert into NSNService values (@serviceName,@price,@memberID);
GO

create proc Remove_From_Group
@memberusername varchar(100),
@adminusername varchar (100),
@groupname varchar (50)
As
declare @memberID int, @adminID int , @groupid int;
exec getGroupID  @groupid output,@groupname;
SELECT @memberID = member.memberID from member where @memberusername = member.username;
SELECT @adminID = member.memberID from member where @adminusername = member.username;

if (exists(select * from m_admin where memberID=@adminID and NSNgroupID=@groupID and adminID=@adminID))
begin
delete from adds_to_group where new_memberID=@memberID and NSNgroupID = @groupID;
delete from m_admin where memberID=@memberID and NSNgroupID =@groupID
end
else
if (exists(select * from m_admin where memberID=@adminID and NSNgroupID=@groupID) and not exists(select * from m_admin where memberID=@memberID and NSNgroupID=@groupID))
begin
delete from adds_to_group where new_memberID=@memberID and NSNgroupID = @groupID

end
go

create proc Unblock /*sha8ala tmam*/
@blockedusername varchar(100),
@blockerusername varchar(100)
AS
Declare @blockerID int , @blockedID int;
SELECT @blockerID = member.memberID from member where @blockerusername = member.username;
SELECT @blockedID = member.memberID from member where @blockedusername = member.username;
delete from blocks where blockedID=@blockedID and blockerID=@blockerID;
delete SendFriendRequest where (RequestedID=@blockerID and RequesterID = @blockedID) or (RequestedID=@blockedID and RequesterID= @blockerID);

GO

CREATE PROC useThisService
@success bit output,
@serviceID INT,
@username varchar(100),
@start_time datetime,
@end_time datetime
AS
DECLARE @memberID INT;
select @memberID =member.memberID from member where @username=member.username;
DECLARE @tmpI  TABLE (ID int ) ; /*to get all services that are  used before but currently available from table use Service */

INSERT INTO @tmpI(ID )  EXEC FindAvailableServices @start_time,@end_time;  
IF (EXISTS(select * from  @tmpI tmpI where  @serviceID=tmpI.ID )or NOT EXISTS(select * from useService where useService.serviceUsedID = @serviceID))
BEGIN
INSERT INTO useService Values (@serviceID, @memberID,@start_time,@end_time);
SET @success = 1;
END
SET @success =0;
GO

create proc VIEWITEM /*sha8ala tmam*/
@username VARCHAR(100)

AS

DECLARE @tmp TABLE(ID INT, un VARCHAR(100), pw VARCHAR(100), n VARCHAR(100), X VARCHAR(200), Y BIT, W INT, Z VARCHAR(200))
INSERT INTO @tmp EXEC view_members @username

select item.* from item INNER JOIN @tmp TMP ON item.sellerID = TMP.ID where item.isBought = 0

GO


CREATE PROC FindAvailableServicesAtTheMoment /*sha8ala tmam*/
AS
SELECT useService.serviceUsedID FROM useService WHERE GETDATE()<start_time or GETDATE() > end_time;
GO


CREATE PROC ViewService  /*sha8ala tmam*/
@username VARCHAR(100)
AS
DECLARE @serviceIDS TABLE (ID INT);
Insert  into @serviceIDS(ID) EXEC FindAvailableServicesAtTheMoment;

DECLARE @tmp TABLE(ID INT, un VARCHAR(100), pw VARCHAR(100), n VARCHAR(100), X VARCHAR(200), Y BIT, W INT, Z VARCHAR(200))
INSERT INTO @tmp EXEC view_members @username


select NSNService.* from @serviceIDS serviceIDS INNER JOIN NSNService ON  NSNService.serviceID=serviceIDS.ID
INNER JOIN @tmp TMP ON NSNService.providerID = TMP.ID

UNION 

SELECT NSNService.* from NSNService  INNER JOIN @tmp TMP2 ON NSNService.providerID = TMP2.ID where NOT EXISTS (SELECT useService.serviceUsedID from useService where  useService.serviceUsedID = NSNService.serviceID) ;

 GO
 

create proc Leave_Group
@username varchar(100),
@groupname varchar (50)
AS
declare @groupID int;
exec getGroupID @groupID output,@groupname;
declare @memberID int;
 select @memberID = member.memberID FROM member where member.username = @username;
delete from adds_to_group where @memberID= new_memberID and NSNgroupID= @groupID;
delete from m_admin where adminID=@memberID and NSNgroupID= @groupID;
delete from NSNgroup where @memberID= creatorID and NSNgroupID= @groupID;
GO

CREATE PROC view_all_members
AS
select * from member;
GO

CREATE PROC view_comments
@newsID INT
AS
SELECT commenterID,commentDate,content FROM member_comments_on_news WHERE newsID=@newsID
GO