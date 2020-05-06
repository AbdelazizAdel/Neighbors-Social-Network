CREATE PROCEDURE delete_service 
@serviceId INT,
@username VARCHAR(100)
AS
DECLARE @ID INT
SELECT @ID = M.memberID FROM member M WHERE M.username = @username
DELETE FROM NSNService WHERE serviceID = @serviceId;


GO


CREATE PROCEDURE delete_item

@itemid int,
@username varchar(100)

AS

declare @id int
SELECT @id = M.memberID FROM member M WHERE M.username = @username

DELETE FROM item WHERE itemID = @itemid;


GO


create proc organize_event

@creatorUN varchar(100),
@eventName varchar(100),
@eventDate datetime,
@privacy bit,
@type varchar(100)

as

DECLARE @creatorID INT
SELECT @creatorID = M.memberID FROM member M WHERE M.username = @creatorUN

insert into NSNevent values(@eventName, @type, @privacy, @eventDate, @creatorID)


GO


create proc invite_member_to_event

@organizerUN varchar(100),
@attendeeUN varchar(100),
@eventID int

as

declare @organizerID int
declare @attendeeID int

exec getID @organizerID output, @attendeeID output, @organizerUN, @attendeeUN

insert into invites_to_event values(@eventID, @organizerID, @attendeeID, null)


go


create proc view_event_invitations

@username varchar(100)

as

DECLARE @ID INT
SELECT @ID = M.memberID FROM member M WHERE M.username = @username

select e.*
from invites_to_event i inner join NSNevent e on i.NSNeventID = e.NSNeventID
where i.NSNeventAttendee = @ID


go


create proc accept_event_invitation

@username varchar(100),
@eventID int

as

DECLARE @ID INT
SELECT @ID = M.memberID FROM member M WHERE M.username = @username

update invites_to_event
set invitationStatus = 1
where invites_to_event.NSNeventAttendee = @ID and invites_to_event.NSNeventID = @eventID


go


create proc reject_event_invitation

@username varchar(100),
@eventID int

as

DECLARE @ID INT
SELECT @ID = M.memberID FROM member M WHERE M.username = @username

update invites_to_event
set invitationStatus = 0
where invites_to_event.NSNeventAttendee = @ID and invites_to_event.NSNeventID = @eventID


go


create proc view_blocked

@username varchar(100)

as

DECLARE @ID INT
SELECT @ID = M.memberID FROM member M WHERE M.username = @username

select m.*
from blocks b inner join member m on b.blockedID = m.memberID
where b.blockerID = @ID


go


create proc change_password

@success bit output,
@username varchar(100),
@old_password varchar(100),
@new_password varchar(100)

as

DECLARE @ID INT
SELECT @ID = M.memberID FROM member M WHERE M.username = @username

declare @password varchar(100)
select @password = m.login_password
from member m 
where m.memberID = @ID

if (@password = @old_password)
begin
set @success = 1
update member
set login_password = @new_password
where memberID = @ID
end
else
set @success = 0


go


create proc view_items_within_price_range
@price DECIMAL(10,2),
@item_name VARCHAR(100)
AS
SELECT
	*
FROM
	item
WHERE
	item.item_price <= @price AND item.item_name = @item_name


GO


create proc view_services_within_price_range
@price DECIMAL(10,2),
@service_name VARCHAR(100)
AS
SELECT
	*
FROM
	NSNService
WHERE
	NSNService.price <= @price AND NSNService.serviceName = @service_name


GO


create proc view_events_by_date
@start_time DATETIME,
@end_time DATETIME
AS
SELECT 
	*
FROM
	NSNevent E
WHERE
	E.NSNevent_privacy = 0 AND E.NSNevent_date >= @start_time AND E.NSNevent_date <= @end_time
UNION
SELECT
	E2.*
FROM
	NSNevent E2 INNER JOIN invites_to_event I ON E2.NSNeventID = I.NSNeventID 
WHERE
	E2.NSNevent_date >= @start_time AND E2.NSNevent_date <= @end_time AND I.invitationStatus = 1


GO


CREATE PROC view_news_with_keywords
@username VARCHAR(100),
@keywords VARCHAR(200)
AS
DECLARE @tmp TABLE(ID INT, un VARCHAR(100), pw VARCHAR(100), n VARCHAR(100), X VARCHAR(200), Y BIT, W INT, Z VARCHAR(200))
INSERT INTO @tmp EXEC view_members @username

SELECT
	N.*	
FROM
	@tmp tmp INNER JOIN news N ON N.memberID = tmp.ID
WHERE
	N.news_content LIKE '%' + @keywords +'%'


GO




CREATE PROC group_join_request
@groupName VARCHAR(100),
@memberUN VARCHAR(100)
AS 
DECLARE @groupID INT
SELECT @groupID = G.NSNgroupID FROM NSNgroup G WHERE G.NSNgroup_name = @groupName
DECLARE @memberID INT
SELECT @memberID = memberID FROM member WHERE username = @memberUN;
INSERT INTO asks_to_join_group VALUES(@memberID, @groupID, NULL)


GO


CREATE proc accepts_group_request

@groupID int,
@username varchar(100)

as

DECLARE @ID INT
SELECT @ID = M.memberID FROM member M WHERE M.username = @username

update asks_to_join_group
set isAccepted = 1
where memberID = @ID  and NSNgroupID = @groupID


go


CREATE proc rejects_group_request

@groupID int,
@username varchar(100)

as

DECLARE @ID INT
SELECT @ID = M.memberID FROM member M WHERE M.username = @username

update asks_to_join_group
set isAccepted = 0
where memberID = @ID  and NSNgroupID = @groupID


go


create proc delete_group_admin

@id int

as

delete from NSNgroup where NSNgroupID = @id


go


create proc delete_event_admin

@id int

as

delete from NSNevent where NSNeventID = @id


go


create proc delete_news_admin

@id int

as

delete from news where newsID = @id


go


create proc delete_item_admin

@id int

as

delete from item where itemID = @id


go


create proc delete_service_admin

@id int

as

delete from NSNService where serviceID = @id


go

create proc delete_comment_admin

@newsID int,
@username varchar(100),
@comment_date datetime
as
DECLARE @memberID INT
SELECT @memberID = M.memberID FROM member M WHERE M.username = @username
delete from member_comments_on_news where commentDate = @comment_date and commenterID = @memberID and newsID = @newsID
go

CREATE PROC delete_member_admin
@username VARCHAR(100)
AS
DECLARE @memberID INT
SELECT @memberID = M.memberID FROM member M WHERE M.username = @username
EXEC foreign_key_handling @memberID
DELETE FROM member WHERE memberID = @memberID
go

CREATE PROC delete_house_admin
@house_num INT,
@st_name VARCHAR(200)
AS
DELETE FROM house WHERE house_number = @house_num AND street_name = @st_name


GO


create proc recommend_friends_helper

@ID int

as

declare @tmp2 table (id1 int, id2 int)
insert into @tmp2 

SELECT 
	S.RequesterID,
	S.RequestedID
FROM
	SendFriendRequest S
WHERE 
	(S.RequesterID = @ID OR S.RequestedID = @ID) AND S.RequestStatus = 1

declare @tmp table (id int)
insert into @tmp

SELECT tmp.ID1 FROM @tmp2 tmp WHERE tmp.ID1 != @ID
UNION
SELECT tmp2.ID2 FROM @tmp2 tmp2 WHERE tmp2.ID2 !=@ID



select f1.RequestedID
from @tmp tmp1 inner join SendFriendRequest f1 on tmp1.id = f1.RequesterID and f1.RequestStatus = 1
where f1.RequestedID <> @ID

union

select f2.RequesterID
from @tmp tmp2 inner join SendFriendRequest f2 on tmp2.id = f2.RequestedID and f2.RequestStatus = 1
where f2.RequesterID <> @ID

except select * from @tmp tmp


go


create proc recommend_friends

@username varchar(100)

as

DECLARE @ID INT
SELECT @ID = M.memberID FROM member M WHERE M.username = @username

declare @tmp table (id int)
insert into @tmp execute recommend_friends_helper @ID


select *, count(*) num
from @tmp tmp 
group by tmp.id
order by count(tmp.id) desc


go


create proc react_to_news

@newsID int,
@likerUN varchar(500),
@react bit

as

DECLARE @ID INT
SELECT @ID = M.memberID FROM member M WHERE M.username = @likerUN

insert into member_likes_news values(@newsID, @ID, @react)


go


CREATE PROC view_messages

@username varchar(100)

as

SELECT message_content
FROM sendsMessage
WHERE @username = recieverID
GO