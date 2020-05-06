declare @success BIT

exec registerUser @success output, 'ZIAX', 'Ziad Tamer', 'Spandau', 'Ziax1234', 'Stakeneer', 21, 12345;

exec registerUser @success output, 'ZIZO99', 'Abdelaziz Adel', 'Spandau', 'Mazen', 'Rathaus', 19, 79865;

exec registerUser @success output, 'Mazen_Ibrahim', 'Mazen Ibrahim', 'Spandau', 'Abdelaziz', 'Stakeneer', 20, 12345

exec registerUser @success output, 'Joe', 'Youssef Essam', 'Tegel', 'elGamedGdn', 'hollander', 20, 69169

exec registerUser @success output, 'nossa', 'Nossier Fawzy', 'Tegel', 'elAmlas', 'londoner', 16, 71265

exec registerUser @success output, 'BeBo', 'Mohammed Elkholy', 'Mitte', 'elGamed', 'Potsdamer', 11, 81652

exec registerUser @success output, 'AAY', 'Ahmed Ali', 'Spandau', 'AAY22', 'Stakeneer', 21, 12345

exec registerUser @success output, 'ZOMA', 'Hazem Abdelalim', 'Spandau', '123456', 'Stakeneer', 25, 12346;

exec registerUser @success output, 'Eiad99', 'Eiad Essam', 'Tegel', 'zvxzv', 'elsymbelawyen', 25, 12342;

exec registerUser @success output, 'Omda', 'Ahmed Emad', 'Tegel', 'zvxzv', 'elsymbelawyen', 25, 12342;

exec send_request @success output, 'ZIAX', 'ZIZO99'

exec accept_request 'ZIAX', 'ZIZO99'

exec send_request @success output, 'ZIAX', 'AAY'

exec accept_request 'ZIAX', 'AAY'

exec send_request @success output, 'ZIAX', 'Mazen_Ibrahim'

exec accept_request 'ZIAX', 'Mazen_Ibrahim'

exec send_request @success output, 'ZIAX', 'ZOMA'

exec reject_request 'ZIAX', 'ZOMA'

exec send_request @success output, 'ZIZO99', 'ZOMA'

exec accept_request'ZIZO99', 'ZOMA'

exec send_request @success output, 'Joe', 'nossa'

exec accept_request 'Joe', 'nossa'

exec block_Member 'nossa', 'Joe'

exec send_message 'ZIAX', 'ZIZO99', 'First Message!'

exec send_message 'ZIZO99', 'ZIAX', 'Second Message!'

exec send_message 'ZIAX', 'ZIZO99', 'Third Message!'

exec send_message 'ZIAX', 'ZIZO99', 'Fourth Message!'

exec report_member 'ZIAX', 'ZIZO99', 'he is bullying me all the time!!!'

exec rate_member 'ZIAX', 'ZIZO99', 1, 'HE is still bullying me!'

exec write_post 'ZIZO99', 'ZIAX is such a weirdo.'

exec write_post 'ZIAX', 'WE should all block ZIZO99. He bullies me!'

exec comment_on_post 'ZIAX', 'TOZ FEEK', 1

Declare @str varchar(40)
Declare @dt datetime
set @str='01/12/2019'
set dateformat dmy
set @dt=@str
exec organize_event 'ZIZO', '4ela so5na fl so5na',@str, 0, 'dancing'

Declare @str2 varchar(40)
Declare @dt2 datetime
set @str2='01/12/2019'
set dateformat dmy
set @dt2=@str2
exec organize_event 'nossa', 'mecha neka',@str2, 1, 'education'

exec invite_member_to_event 'nossa', 'Joe', 2
exec accept_event_invitation 'Joe', 2

exec CREATE_GROUP 'ZIZO99', 'Herr Geziry'

exec add_to_group 'ZIAX', 'ZIZO99', 'Herr Geziry'

exec MAKE_ADMIN 'ZIZO99', 'ZIAX', 'Herr Geziry'

exec offeritem 'ZIAX', 'fota', 10

exec BuyItem '1', 'ZIZO99'

exec offerService 'ZIZO99', 'Mdlkaty', 0

Declare @str3 varchar(40)
Declare @dt3 datetime
set @str3='01/12/2019'
set dateformat dmy
set @dt3=@str3

Declare @str4 varchar(40)
Declare @dt4 datetime
set @str4='02/12/2019'
set dateformat dmy
set @dt4=@str4

exec useThisService @success output, 1, 'Mazen_Ibrahim', @str3, @str4

