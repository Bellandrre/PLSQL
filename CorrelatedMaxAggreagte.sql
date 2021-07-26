-- In this PLSQL Statement, I am trying to correlate an aggregated column with another column.
-- Lets say you aggregate by max(x) column and you need corresponding y for that max(x). Thats whats going on!!
select FLOOR(TO_NUMBER(MinDispLineNumber)) || DECODE(((MinDispLineNumber -  FLOOR(TO_NUMBER(MinDispLineNumber)) ) * 100000), 0, '' , '.' || ((MinDispLineNumber -  FLOOR(TO_NUMBER(MinDispLineNumber)) ) * 100000) ) as MinDispLineNumber,
       FLOOR(TO_NUMBER(MaxDispLineNumber)) || DECODE(((MaxDispLineNumber -  FLOOR(TO_NUMBER(MaxDispLineNumber)) ) * 100000), 0, '' , '.' || ((MaxDispLineNumber -  FLOOR(TO_NUMBER(MaxDispLineNumber)) ) * 100000) ) as MaxDispLineNumber,
       TotalDispLineNumber from
(select auction_header_id,max(to_number(DISP_LINE_NUMBER)) MaxDispLineNumber, min(to_number(DISP_LINE_NUMBER)) MinDispLineNumber, count(to_number(DISP_LINE_NUMBER)) TotalDispLineNumber from x
where hid = :hid group by hid)