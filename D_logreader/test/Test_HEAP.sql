
--select * into a2 from [dbt2].[dbo].[a1]

SELECT * FROM [dbt2].[dbo].[a2]
checkpoint
select * from fn_dblog('0x0000003b:000000e0:0003',null) where [Transaction ID]<>'0000:000006ae'

insert [a2] values('10','dd','1111111')
delete [a2] where id=10


---   1-1
begin tran 
save tran aaa
insert [a2] values('10','dd','1111111')
rollback tran aaa
commit tran

---   12
begin tran 
insert [a2] values('9','qq','090909')
delete [a2] where id=9
commit tran

---   12-2
begin tran 
insert [a2] values('9','qq','090909')
save tran aaa
delete [a2] where id=9
rollback tran aaa
commit tran
--     2-2
begin tran 
save tran aaa
delete [a2] where id=9
rollback tran aaa
commit tran

--      3
update [a2] set mc='=77727=' where id='7'
update [a2] set mc='=010203=' where id='7'

--      3-3
begin tran 
save tran aaa
update [a2] set mc='=010209=' where id='7'
rollback tran aaa
commit tran

--   --      32
   begin tran 
   update [a2] set mc='=111111=' where id='9'
   delete [a2] where id='9'
   commit tran

--      32-2
---------------------VVVVVVVVVVVVVVVVV---------------------------
begin tran 
update [a2] set mc='=99=' where id='9'
save tran aaa
delete [a2] where id=9
rollback tran aaa
commit tran

--      33
begin tran 
update [a2] set mc='=9f' where id='9'
save tran aaa
update [a2] set dm='777' where id='9'
commit tran

--      33-3
begin tran 
update [a2] set mc='=9x9=' where id='9'
save tran aaa
update [a2] set mc='77777' where id='9'
rollback tran aaa
commit tran

--      33-32
--      begin tran 
--      update [a2] set mc='=99dd=' where id='9'
--      save tran aaa
--      update [a2] set mc='77777' where id='9'
--      rollback tran aaa
--      delete [a2] where id=9
--      commit tran

--      132
--      begin tran 
--      insert [a2] values('9','qq','090909')
--      update [a2] set mc='=99=' where id='9'
--      delete [a2] where id=9
--      commit tran

--      13-32
--    begin tran 
--    insert [a2] values('9','qq','090909')
--    save tran aaa
--    update [a2] set mc='=99=' where id='9'
--    rollback tran aaa
--    delete [a2] where id=9
--    commit tran

--      13-33-3
begin tran 
insert [a2] values('9','qq','090909')
save tran aaa
update [a2] set mc='=99=' where id='9'
rollback tran aaa
save tran bbb
update [a2] set mc='777' where id='9'
rollback tran bbb
commit tran

begin tran 
insert [a2] values('9','qq','090909')
update [a2] set mc='=99=' where id='9'
update [a2] set dm='777' where id='9'
update [a2] set mc='ee' where id='9'
commit tran


--      133-33-3
begin tran 
insert [a2] values('9','qq','090909')
update [a2] set mc='010203' where id='9'
save tran aaa
update [a2] set mc='=99=' where id='9'
rollback tran aaa
save tran bbb
update [a2] set mc='777' where id='9'
rollback tran bbb
commit tran

--     --      13-33-32
--     begin tran 
--     insert [a2] values('9','qq','090909')
--     save tran aaa
--     update [a2] set mc='=99=' where id='9'
--     rollback tran aaa
--     save tran bbb
--     update [a2] set mc='777' where id='9'
--     rollback tran bbb
--     delete [a2] where id=9
--     commit tran

--      133
begin tran 
insert [a2] values('9','qq','090909')
update [a2] set dm='=99=' where id='9'
update [a2] set mc='=11=' where id='9'
commit tran


--      1332
begin tran 
insert [a2] values('9','qq','090909')
update [a2] set mc='=99=' where id='9'
update [a2] set mc='=11=' where id='9'
delete [a2] where id=9
commit tran
--      12-232
begin tran 
insert [a2] values('9','qq','090909')
save tran aaa
delete [a2] where id=9
rollback tran aaa
update [a2] set mc='777' where id='9'
delete [a2] where id=9
commit tran
--      *132-2
begin tran 
insert [a2] values('9','qq','090909')
update [a2] set mc='777' where id='9'
save tran aaa
delete [a2] where id=9
rollback tran aaa
commit tran

--      1332-2
begin tran 
insert [a2] values('9','qq','090909')
update [a2] set mc='777' where id='9'
update [a2] set mc='6666' where id='9'
save tran aaa
delete [a2] where id=9
rollback tran aaa
commit tran

--      12123
begin tran 
insert [a2] values('9','qq','090909')
delete [a2] where id=9

insert [a2] values('9','qq','0x0x0x')
delete [a2] where id=9
update [a2] set mc='6666' where id='9'
commit tran
--  
begin tran 
insert [a2] values('9','qq','090909')
save tran aaa
delete [a2] where id=9
insert [a2] values('9','qq','0x0x0x')
delete [a2] where id=9
rollback tran aaa
update [a2] set mc='6666' where id='9'
commit tran


--      132-23
begin tran 
insert [a2] values('9','qq','090909')
update [a2] set mc='=99=' where id='9'
save tran aaa
delete [a2] where id=9
rollback tran aaa
update [a2] set mc='=11=' where id='9'
commit tran


--    32-23
begin tran 
update [a2] set mc='=99vv=' where id='9'
save tran aaa
delete [a2] where id=9
rollback tran aaa
update [a2] set dm='776' where id='9'
commit tran

--   33
begin tran 
update [a2] set mc='mc123' where id='9'
update [a2] set dm='dm456' where id='9'
commit tran

--   2-23
begin tran 
save tran aaa
delete [a2] where id=9
rollback tran aaa
update [a2] set dm='77' where id='9'
commit tran

--   2-232-2
begin tran 
save tran aaa
delete [a2] where id=9
rollback tran aaa
update [a2] set dm='7x7' where id='9'
save tran bbb
delete [a2] where id=9
rollback tran bbb
commit tran
-----------------------------------------------



--↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ok↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑--
















