-- In this PLSQL Statement, I am trying to correlate an aggregated column with another column.
-- Lets say you aggregate by max(x) column and you need corresponding y for that max(x).
-- The inner subquery has both min and max, so finding a correlated field just for the max(x) is challenging(or maybe not :P)
-- Math invloved is just a requirement.
select FLOOR(TO_NUMBER(MinDispLineNumber)) || DECODE(((MinDispLineNumber -  FLOOR(TO_NUMBER(MinDispLineNumber)) ) * 100000), 0, '' , '.' || ((MinDispLineNumber -  FLOOR(TO_NUMBER(MinDispLineNumber)) ) * 100000) ) as MinDispLineNumber,
       FLOOR(TO_NUMBER(MaxDispLineNumber)) || DECODE(((MaxDispLineNumber -  FLOOR(TO_NUMBER(MaxDispLineNumber)) ) * 100000), 0, '' , '.' || ((MaxDispLineNumber -  FLOOR(TO_NUMBER(MaxDispLineNumber)) ) * 100000) ) as MaxDispLineNumber,
       TotalDispLineNumber from
(select id, max(to_number(disp_x_number)) MaxDispLineNumber, min(to_number(disp_x_number)) MinDispLineNumber, count(to_number(disp_x_number)) TotalDispLineNumber from x
where hid = :hid group by hid)
