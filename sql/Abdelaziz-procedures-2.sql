CREATE PROC getID
@blocker_id INT OUTPUT,
@blocked_id INT OUTPUT,
@blocker_username VARCHAR(100),
@blocked_username VARCHAR(100)
AS
SELECT @blocker_id = member.memberID
FROM member
WHERE member.username = @blocker_username
SELECT @blocked_id = member.memberID
FROM member
WHERE member.username = @blocked_username
GO

CREATE PROC isFriend
@res BIT OUTPUT,
@memberID1 INT,
@memberID2 INT
AS
IF(EXISTS (SELECT * 
FROM SendFriendRequest T
WHERE ((T.RequestedID = @memberID1 AND T.RequesterID = @memberID2) OR (T.RequestedID = @memberID2 AND T.RequesterID = @memberID1)) AND T.RequestStatus = 1))
SET @res = 1
ELSE
SET @res = 0
GO

CREATE PROC block_Member
@blocker_username VARCHAR(100),
@blocked_username VARCHAR(100)
AS
DECLARE @blockerID INT, @blockedID INT
EXEC getID @blockerID OUTPUT, @blockedID OUTPUT, @blocker_username, @blocked_username
INSERT INTO blocks VALUES(@blockerID, @blockedID)
UPDATE SendFriendRequest SET RequestStatus = 0
WHERE (SendFriendRequest.RequesterID = @blockerID AND SendFriendRequest.RequestedID = @blockeDID)
OR( SendFriendRequest.RequesterID = @blockedID AND SendFriendRequest.RequestedID = @blockerID)
GO

CREATE PROC viewHouse
@username VARCHAR(100)
AS
DECLARE @ID INT
SELECT @ID = member.memberID FROM member WHERE member.username = @username
SELECT H.* FROM member M INNER JOIN house H ON M.house_number = H.house_number AND M.street_name = H.street_name
WHERE M.memberID = @ID
GO

CREATE PROC registerUser
@success BIT OUTPUT,
@username VARCHAR(100),
@name VARCHAR(100),
@neighborhood VARCHAR(100),
@password VARCHAR(100),
@street_name VARCHAR(100),
@house_number SMALLINT,
@postal_code INT
AS
IF(NOT EXISTS(SELECT * FROM member WHERE member.username = @username))
BEGIN
IF(NOT EXISTS(SELECT * FROM house H WHERE H.house_number = @house_number AND H.street_name = @street_name))
BEGIN
INSERT INTO house VALUES(@house_number, @street_name, @postal_code);
END
INSERT INTO member VALUES(@username, @password, @neighborhood, @name, 0, @house_number, @street_name);
SET @success = 1
END
ELSE
SET @success = 0
GO

CREATE PROC user_login
@success BIT OUTPUT,
@username VARCHAR(100),
@password VARCHAR(100)
AS
IF(EXISTS(SELECT * FROM member WHERE member.username = @username AND member.login_password = @password))
SET @success = 1
ELSE
SET @success = 0
GO

/*CREATE PROC accept_event_invitation
@invitedusername VARCHAR(100),
@eventID INT
AS
DECLARE @ID INT
SELECT @ID = member.memberID FROM member WHERE member.username = @invitedusername
UPDATE invites SET invitationStatus = 1 WHERE invites.NSNeventAttendee = @ID AND invites.NSNeventID = @eventID
INSERT INTO goes_to_event VALUES(@ID, @eventID)
GO

CREATE PROC reject_event_invitation
@invitedusername VARCHAR(100),
@eventID INT
AS
DECLARE @ID INT
SELECT @ID = member.memberID FROM member WHERE member.username = @invitedusername
UPDATE invites SET invitationStatus = 0 WHERE invites.NSNeventAttendee = @ID AND invites.NSNeventID = @eventID
GO*/

CREATE PROC view_events
@username VARCHAR(100)
AS
DECLARE @ID INT
SELECT @ID = member.memberID FROM member WHERE member.username = @username

DECLARE @tmp TABLE(ID INT, un VARCHAR(100), pw VARCHAR(100), n VARCHAR(100), X VARCHAR(200), Y BIT, W INT, Z VARCHAR(200))
INSERT INTO @tmp EXEC view_members @username

SELECT *
FROM
(SELECT E.NSNevent_name, E.NSNevent_type, E.NSNevent_date FROM NSNevent E INNER JOIN @tmp TMP
ON E.organizerID = TMP.ID WHERE E.NSNevent_privacy = 0 
UNION
SELECT E2.NSNevent_name, E2.NSNevent_type, E2.NSNevent_date
 FROM invites_to_event I INNER JOIN NSNevent E2 ON I.NSNeventID = E2.NSNeventID
WHERE I.NSNeventAttendee = @ID AND I.invitationStatus =1 OR I.invitationStatus IS NULL ) AS X(N,T,D)
GO

CREATE PROC write_post
@username VARCHAR(100),
@content VARCHAR(5000)
AS
DECLARE @ID INT
SELECT @ID = member.memberID FROM member WHERE member.username = @username
INSERT INTO news VALUES(@content, GETDATE(), @ID)
GO

CREATE PROC edit_post
@username VARCHAR(100),
@content VARCHAR(5000),
@postID INT
AS
DECLARE @ID INT
SELECT @ID = member.memberID FROM member WHERE member.username = @username
UPDATE news  SET news_content = @content WHERE news.memberID = @ID AND news.newsID = @postID
GO

CREATE PROC view_posts
@username VARCHAR(100)
AS
DECLARE @ID INT
SELECT @ID = member.memberID FROM member WHERE member.username = @username
SELECT N.news_content, N.news_date
FROM news N WHERE N.memberID = @ID
order by N.news_date desc
GO

CREATE PROC delete_post
@username VARCHAR(100),
@postID INT
AS
DECLARE @ID INT
SELECT @ID = member.memberID FROM member WHERE member.username = @username
DELETE FROM news WHERE news.memberID = @ID AND news.newsID = @postID
GO

CREATE PROC comment_on_post
@username VARCHAR(100),
@content VARCHAR(4000),
@newsID INT
AS
DECLARE @ID INT
SELECT @ID = member.memberID FROM member WHERE member.username = @username
INSERT INTO member_comments_on_news VALUES(@newsID, @ID, @content, GETDATE())
GO


CREATE PROC delete_comment
@username VARCHAR(100),
@postID INT,
@comment_time datetime
AS
DECLARE @ID INT
SELECT @ID = member.memberID FROM member WHERE member.username = @username
DELETE FROM member_comments_on_news  WHERE member_comments_on_news.newsID = @postID AND member_comments_on_news.commenterID = @ID 
AND member_comments_on_news.commentDate = @comment_time
GO

CREATE PROC get_friends_helper
@ID INT
AS
SELECT 
	S.RequesterID,
	S.RequestedID
FROM
	SendFriendRequest S
WHERE 
	(S.RequesterID = @ID OR S.RequestedID = @ID) AND S.RequestStatus = 1
GO


CREATE PROC get_friends
@ID INT
AS
DECLARE @tmp TABLE(ID1 INT, ID2 INT)
INSERT INTO @tmp 

SELECT 
	S.RequesterID,
	S.RequestedID
FROM
	SendFriendRequest S
WHERE 
	(S.RequesterID = @ID OR S.RequestedID = @ID) AND S.RequestStatus = 1

SELECT tmp.ID1 FROM @tmp tmp WHERE tmp.ID1 != @ID
UNION
SELECT tmp2.ID2 FROM @tmp tmp2 WHERE tmp2.ID2 !=@ID


GO


CREATE PROC recommend_posts_on_likes
@username varchar(100)
AS

DECLARE @ID INT
SELECT @ID = M.memberID FROM member M WHERE M.username = @username

DECLARE @tmp TABLE(ID INT)
INSERT INTO @tmp EXEC get_friends @ID

SELECT 
	L.newsID,
	COUNT(*) num
FROM
	member_likes_news L INNER JOIN @tmp tmp ON L.likerID = tmp.ID INNER JOIN news n ON n.newsID = L.newsID
WHERE
	DATEDIFF(DAY, n.news_date, GETDATE()) <= 30
GROUP BY L.newsID
ORDER BY COUNT(*) DESC


GO



CREATE PROC recommend_public_events
@username VARCHAR(100)

AS 

DECLARE @ID INT
SELECT @ID = M.memberID FROM member M WHERE M.username = @username

DECLARE @tmp TABLE(ID INT)
INSERT INTO @tmp EXEC get_friends @ID

SELECT 
	GE.NSNeventID, COUNT(*)num
FROM
	goes_to_event GE INNER JOIN @tmp tmp ON GE.memberID = tmp.ID INNER JOIN NSNevent E ON E.NSNevent_date >= GETDATE()
GROUP BY GE.NSNeventID
ORDER BY COUNT(*) DESC


GO


CREATE PROC foreign_key_handling
@ID INT
AS
/*DELETE FROM accepts_group_request WHERE memberID = @ID*/
DELETE FROM member_likes_news WHERE likerID = @ID
/*DELETE FROM rejects_group_request WHERE memberID = @ID*/
DELETE FROM member_comments_on_news WHERE commenterID = @ID
DELETE FROM invites_to_event WHERE NSNeventMaker = @ID
DELETE FROM reports WHERE ReporterID = @ID
DELETE FROM blocks WHERE blockerID = @ID
DELETE FROM sendsMessage WHERE senderID = @ID
DELETE FROM goes_to_event WHERE memberID = @ID
DELETE FROM useService WHERE serviceUserID = @ID
DELETE FROM adds_to_group WHERE new_memberID = @ID
DELETE FROM m_admin WHERE memberID = @ID
DELETE FROM SendFriendRequest WHERE RequesterID = @ID
DELETE FROM buy_item WHERE buyerID = @ID
DELETE FROM asks_to_join_group WHERE memberID = @ID

UPDATE adds_to_group SET adminID = NULL WHERE adminID = @ID
UPDATE m_admin SET adminID = NULL WHERE adminID = @ID
/*UPDATE rates SET raterID = NULL WHERE raterID = @ID
UPDATE organizes SET organizerID = NULL WHERE organizerID = @ID
UPDATE accepts_group_request SET adminID = NULL WHERE adminID = @ID
UPDATE rejects_group_request SET adminID = NULL WHERE adminID = @ID*/
GO



 






