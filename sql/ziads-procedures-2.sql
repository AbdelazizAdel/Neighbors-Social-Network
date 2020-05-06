create proc view_my_friends

@memberUN varchar(100)


as

declare @memberID int

select @memberID = m.memberID
from member m
where m.username = @memberUN

select friend.*
from SendFriendRequest req inner join member friend on friend.memberID = req.RequestedID
where req.RequesterID = @memberID and req.RequestStatus = '1'

union

select friend.*
from SendFriendRequest req inner join member friend on friend.memberID = req.RequesterID
where req.RequestedID = @memberID and req.RequestStatus = '1';


go


create proc view_members

@memberUN varchar(100)

as

declare @memberID int

select @memberID = m.memberID
from member m
where m.username = @memberUN

select m1.*
from member m1 inner join member m2 on m1.neighborhood = m2.neighborhood
where m2.memberID = @memberID and m1.memberID <> m2.memberID


go


create proc send_request

@success_bit bit output,
@senderUN varchar(100),
@receiverUN varchar(100)

as 

declare @senderID int
declare @receiverID int

exec getID @senderID output, @receiverID output, @senderUN, @receiverUN

declare @senderNeig varchar(50)
declare @receiverNeig varchar(50)

select @senderNeig = neighborhood
from member m
where m.memberID = @senderID

select @receiverNeig = neighborhood
from member m
where m.memberID = @receiverID

if @receiverNeig = @senderNeig
begin
set @success_bit = 1
insert into SendFriendRequest(RequesterID, RequestedID)
values (@senderID, @receiverID)
end

else
set @success_bit = 0


go


create proc accept_request

@senderUN varchar(100),
@receiverUN varchar(100)

as

declare @senderID int
declare @receiverID int

exec getID @senderID output, @receiverID output, @senderUN, @receiverUN

update SendFriendRequest
set RequestStatus = 1
where RequestedID = @receiverID and RequesterID = @senderID


go


create proc reject_request

@senderUN varchar(100),
@receiverUN varchar(100)

as

declare @senderID int
declare @receiverID int

exec getID @senderID output, @receiverID output, @senderUN, @receiverUN

update SendFriendRequest
set RequestStatus = 0
where RequesterID = @senderID and RequestedID = @receiverID


go


create proc send_message

@senderUN varchar(100),
@receiverUN varchar(100),
@content varchar(2000)

as

declare @senderID int
declare @receiverID int

exec getID @senderID output, @receiverID output, @senderUN, @receiverUN

insert into sendsMessage(senderID, recieverID, message_content, time_sent)
values (@senderID, @receiverID, @content, getdate())


go


create proc view_chat

@senderUN varchar(100),
@receiverUN varchar(100)

as

declare @senderID int
declare @receiverID int

exec getID @senderID output, @receiverID output, @senderUN, @receiverUN

select *
from
(select msg.senderID, msg.message_content, msg.time_sent
from sendsMessage msg
where  msg.senderID = @senderID and msg.recieverID = @receiverID

union

select msg2.senderID, msg2.message_content, msg2.time_sent
from sendsMessage msg2
where msg2.senderID = @receiverID and msg2.recieverID = @senderID) as t(ID, content, time_sent)
order by time_sent desc

go


create proc report_member

@reporterUN varchar(100),
@reportedUN varchar(100),
@content varchar(500)

as

declare @reporterID int
declare @reportedID int

exec getID @reporterID output, @reportedID output, @reporterUN, @reportedUN

insert into reports(ReporterID, ReportedID, reportcontent)
values (@reporterID, @reportedID, @content)


go


create proc rate_member

@raterUN varchar(100),
@ratedUN varchar(100),
@rating int,
@rating_content varchar(1000)

as

declare @raterID int
declare @ratedID int

exec getID @raterID output, @ratedID output, @raterUN, @ratedUN

insert into rates (raterID, ratedID, rating, content)
values (@raterID, @ratedID, @rating, @rating_content)


go


create proc view_my_rating

@memberUN varchar(100)

as

declare @memberID int

select @memberID = m.memberID
from member m
where m.username = @memberUN

select r.raterID, r.rating, r.content
from rates r
where r.ratedID = @memberID


go


create proc change_a_given_rating

@raterUN varchar(100),
@ratedUN varchar(100),
@rating int,
@rating_content varchar(1000)

as

declare @raterID int
declare @ratedID int

exec getID @raterID output, @ratedID output, @raterUN, @ratedUN

update rates
set rating = @rating, content = @rating_content
where raterID = @raterID and ratedID = @ratedID