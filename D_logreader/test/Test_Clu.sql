
SELECT * FROM [dbt2].[dbo].[a1]
checkpoint
select * from fn_dblog('0x00000039:000000b0:0001',null) where [Transaction ID]<>'0000:00000000'

insert [a1] values('10','dd','1111111')
delete [a1] where id=10


---   1-1
begin tran 
save tran aaa
insert [a1] values('10','dd','1111111')
rollback tran aaa
commit tran

---   12
begin tran 
insert [a1] values('9','qq','090909')
delete [a1] where id=9
commit tran

---   12-2
begin tran 
insert [a1] values('9','qq','090909')
save tran aaa
delete [a1] where id=9
rollback tran aaa
commit tran
--     2-2
begin tran 
save tran aaa
delete [a1] where id=9
rollback tran aaa
commit tran

--      3
update [a1] set mc='=77727=' where id='7'
update [a1] set mc='=010203=' where id='7'

--      3-3
begin tran 
save tran aaa
update [a1] set mc='=010203=' where id='7'
rollback tran aaa
commit tran

--      32
begin tran 
update [a1] set mc='=111111=' where id='9'
delete [a1] where id='9'
commit tran

--      32-2
---------------------VVVVVVVVVVVVVVVVV---------------------------
begin tran 
update [a1] set mc='=99=' where id='9'
save tran aaa
delete [a1] where id=9
rollback tran aaa
commit tran

--      33-3
begin tran 
update [a1] set mc='=99=' where id='9'
save tran aaa
update [a1] set mc='77777' where id='9'
rollback tran aaa
commit tran

--      33-32
begin tran 
update [a1] set mc='=99dd=' where id='9'
save tran aaa
update [a1] set mc='77777' where id='9'
rollback tran aaa
delete [a1] where id=9
commit tran

--      132
begin tran 
insert [a1] values('9','qq','090909')
update [a1] set mc='=99=' where id='9'
delete [a1] where id=9
commit tran

--      13-32
begin tran 
insert [a1] values('9','qq','090909')
save tran aaa
update [a1] set mc='=99=' where id='9'
rollback tran aaa
delete [a1] where id=9
commit tran
--      13-33-3
begin tran 
insert [a1] values('9','qq','090909')
save tran aaa
update [a1] set mc='=99=' where id='9'
rollback tran aaa
save tran bbb
update [a1] set mc='777' where id='9'
rollback tran bbb
commit tran

begin tran 
insert [a1] values('9','qq','090909')
update [a1] set mc='=99=' where id='9'
update [a1] set mc='777' where id='9'
update [a1] set mc='ee' where id='9'
commit tran


--      133-33-3
begin tran 
insert [a1] values('9','qq','090909')
update [a1] set mc='010203' where id='9'
save tran aaa
update [a1] set mc='=99=' where id='9'
rollback tran aaa
save tran bbb
update [a1] set mc='777' where id='9'
rollback tran bbb
commit tran

--      13-33-32
begin tran 
insert [a1] values('9','qq','090909')
save tran aaa
update [a1] set mc='=99=' where id='9'
rollback tran aaa
save tran bbb
update [a1] set mc='777' where id='9'
rollback tran bbb
delete [a1] where id=9
commit tran

--      133
begin tran 
insert [a1] values('9','qq','090909')
update [a1] set dm='=99=' where id='9'
update [a1] set mc='=11=' where id='9'
commit tran


--      1332
begin tran 
insert [a1] values('9','qq','090909')
update [a1] set mc='=99=' where id='9'
update [a1] set mc='=11=' where id='9'
delete [a1] where id=9
commit tran
--      12-232
begin tran 
insert [a1] values('9','qq','090909')
save tran aaa
delete [a1] where id=9
rollback tran aaa
update [a1] set mc='777' where id='9'
delete [a1] where id=9
commit tran
--      *132-2
begin tran 
insert [a1] values('9','qq','090909')
update [a1] set mc='777' where id='9'
save tran aaa
delete [a1] where id=9
rollback tran aaa
commit tran

--      1332-2
begin tran 
insert [a1] values('9','qq','090909')
update [a1] set mc='777' where id='9'
update [a1] set mc='6666' where id='9'
save tran aaa
delete [a1] where id=9
rollback tran aaa
commit tran

--      12123
begin tran 
insert [a1] values('9','qq','090909')
delete [a1] where id=9

insert [a1] values('9','qq','0x0x0x')
delete [a1] where id=9
update [a1] set mc='6666' where id='9'
commit tran

--      132-23
begin tran 
insert [a1] values('9','qq','090909')
update [a1] set mc='=99=' where id='9'
save tran aaa
delete [a1] where id=9
rollback tran aaa
update [a1] set mc='=11=' where id='9'
commit tran


--    32-23
begin tran 
update [a1] set mc='=99vv=' where id='9'
save tran aaa
delete [a1] where id=9
rollback tran aaa
update [a1] set dm='776' where id='9'
commit tran

--   33
begin tran 
update [a1] set mc='mc123' where id='9'
update [a1] set dm='dm456' where id='9'
commit tran

--   2-23
begin tran 
save tran aaa
delete [a1] where id=9
rollback tran aaa
update [a1] set dm='77' where id='9'
commit tran

--   2-232-2
begin tran 
save tran aaa
delete [a1] where id=9
rollback tran aaa
update [a1] set dm='77' where id='9'
save tran bbb
delete [a1] where id=9
rollback tran bbb
commit tran
-----------------------------------------------



--↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ok↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑--
















