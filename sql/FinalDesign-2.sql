CREATE TABLE house(
	house_number SMALLINT,
	street_name VARCHAR(50),
	postal_code INT,
	
	PRIMARY KEY(house_number, street_name)
);
CREATE TABLE member(
	memberID INT PRIMARY KEY IDENTITY,
	username VARCHAR(100) UNIQUE NOT NULL,
	login_password VARCHAR(50) NOT NULL,
	neighborhood VARCHAR(50) NOT NULL,
	member_name VARCHAR(50) NOT NULL,
	isBad BIT,
	house_number SMALLINT NOT NULL,
	street_name VARCHAR(50) NOT NULL,
	FOREIGN KEY(house_number, street_name) REFERENCES house(house_number, street_name) ON UPDATE CASCADE
);

CREATE TABLE NSNgroup(
	NSNgroupID INT PRIMARY KEY IDENTITY,
	NSNgroup_name VARCHAR(50) UNIQUE,
	creatorID INT REFERENCES member(memberID) on delete cascade,
);

CREATE TABLE NSNevent(
	NSNeventID INT PRIMARY KEY IDENTITY,
	NSNevent_name VARCHAR(50) NOT NULL,
	NSNevent_type VARCHAR(50) NOT NULL,
	NSNevent_privacy BIT DEFAULT 0,
	NSNevent_date DATETIME NOT NULL,
	organizerID int references member(memberID) on delete cascade
);

CREATE TABLE news(
	newsID INT PRIMARY KEY IDENTITY,
	news_content VARCHAR(1000) NOT NULL,
	news_date DATETIME,
	memberID INT REFERENCES member(memberID) on delete cascade,
);
CREATE TABLE item(
	itemID INT PRIMARY KEY IDENTITY,
	item_name VARCHAR(100) NOT NULL,
	item_price DECIMAL(10,2) NOT NULL DEFAULT 0,
	sellerID INT REFERENCES member(memberID) on delete set null,
	isBought BIT,
);
CREATE TABLE buy_item(
	itemID INT PRIMARY KEY,
	buyerID INT references member(memberID),  
	buy_time DATETIME,
	FOREIGN KEY(itemID) REFERENCES item(itemID),
	
);
CREATE TABLE m_admin(
	adminID INT references member(memberID),
	memberID INT references member(memberID),
	NSNgroupID INT REFERENCES NSNgroup(NSNgroupID) ON DELETE CASCADE ,
	PRIMARY KEY(memberID, NSNgroupID)
);
CREATE TABLE adds_to_group(
	adminID INT references member(memberID) ,
	new_memberID INT references member(memberID),
	NSNgroupID INT REFERENCES NSNgroup(NSNgroupID) on delete cascade,
	PRIMARY KEY (new_memberID, NSNgroupID)
);
CREATE TABLE SendFriendRequest (
		RequesterID INT references member(memberID),
		RequestedID INT,
		RequestStatus BIT ,
		CONSTRAINT TheRequest PRIMARY KEY (RequesterID,RequestedID),
		CONSTRAINT ForeignRequested FOREIGN KEY (RequestedID)
		REFERENCES member(memberID) on delete cascade,

);

CREATE TABLE NSNService(

		serviceID INT PRIMARY KEY IDENTITY,
		serviceName VARCHAR (100),
		price DECIMAL (10,2),
		providerID int foreign key references member(memberID) on delete cascade,

);

CREATE TABLE useService (
	serviceUsedID INT ,
	serviceUserID INT references member(memberID) ,
	start_time DATETIME,
	end_time DATETIME,
	CONSTRAINT MyPrimaryKeyuseService PRIMARY KEY (serviceUsedID,start_time),
	CONSTRAINT ForeignService FOREIGN KEY (serviceUsedID)
	REFERENCES NSNService (serviceID) ON DELETE CASCADE,
);

CREATE TABLE sendsMessage (
	senderID INT references member(memberID),
	recieverID INT ,
	message_content VARCHAR (2000),
	time_sent datetime ,
	CONSTRAINT sendsMessage_1 PRIMARY KEY (senderID,recieverID,time_sent),
	CONSTRAINT sendsMesssage_3 FOREIGN KEY(recieverID)
	REFERENCES member (memberID) on delete cascade,
);

CREATE TABLE blocks(
	blockerID INT references member(memberID),
	blockedID INT,
	CONSTRAINT blocks_1 PRIMARY KEY (blockerID,blockedID),
	Constraint blocks_2 FOREIGN KEY (blockedID) REFERENCES member(memberID) on delete cascade,
);

CREATE TABLE reports(
	ReporterID INT references member(memberID),
	ReportedID INT,
	reportcontent VARCHAR (500),
	CONSTRAINT reports_1 PRIMARY KEY (ReporterID,ReportedID),
	CONSTRAINT reports_2 FOREIGN  KEY (ReportedID) references member(memberID) on delete cascade, 
);

CREATE TABLE invites_to_event(
	NSNeventID INT,
	NSNeventMaker INT references member(memberID),
	NSNeventAttendee INT references member(memberID),
	invitationStatus bit,
	CONSTRAINT invites_1 PRIMARY KEY (NSNeventID, NSNeventAttendee),
	CONSTRAINT invites_2 FOREIGN KEY (NSNeventID) REFERENCES NSNevent ON DELETE CASCADE,
);

create table rates(
	
	raterID int references member(memberID),
	ratedID int references member(memberID) on delete cascade,
	rating int not null check (rating between 0 and 10),
	content varchar(1000) default '',
	primary key (raterID, ratedID),
	
);
/*
create table organizes_Event(
	
	organizerID int references member(memberID),
	NSNeventID int not null foreign key references NSNevent(NSNeventID) on delete cascade,
	primary key (organizerID, NSNeventID),

);*/

create table goes_to_event(
	
	memberID int references member(memberID),
	NSNeventID int not null foreign key references NSNevent(NSNeventID) on delete cascade,
	primary key (memberID, NSNeventID),

);

create table asks_to_join_group(
	
	memberID int references member(memberID),
	NSNgroupID int foreign key references NSNgroup(NSNgroupID) on delete cascade,
	isAccepted BIT
	primary key (memberID, NSNgroupID)

);

/*create table accepts_group_request(

	adminID int references member(memberID),
	memberID int references member(memberID),
	NSNgroupID int not null foreign key references NSNgroup(NSNgroupID) on delete cascade,
	primary key(memberID, NSNgroupID),

);

create table rejects_group_request(
	
	adminID int references member(memberID),
	memberID int references member(memberID),
	NSNgroupID int not null foreign key references NSNgroup(NSNgroupID) on delete cascade,
	primary key (memberID, NSNgroupID),

);*/

create table member_comments_on_news(
	
	newsID int not null foreign key references news(newsID) on delete cascade,
	commenterID int references member(memberID),
	content varchar(1000) not null,
	commentDate datetime,
	primary key (newsID, commenterID, commentDate),
	
);

create table member_likes_news(
	
	newsID int not null foreign key references news(newsID) on delete cascade,
	likerID int references member(memberID),
	liked bit not null,
	primary key (newsID, likerID),

);