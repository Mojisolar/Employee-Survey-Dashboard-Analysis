--- How to use my database
use Project;
-- Show the top 1000 
SELECT TOP (1000) [Response_ID]
      ,[Status]
      ,[Department]
      ,[Director]
      ,[Manager]
      ,[Supervisor]
      ,[Staff]
      ,[Question]
      ,[Response]
      ,[Response_Text]
  FROM [Project].[dbo].[Employee_survey]

---- How i reduce space and replace NULL with space
  UPDATE employee_survey
SET Department = NULLIF(TRIM(Department), ''),
    Question   = NULLIF(TRIM(Question), ''),
    Response_Text = NULLIF(TRIM(Response_Text), '');

    ------ Total number of department
    select count( distinct Department) as  Total_dep 
    from Employee_survey;
  ---- Total director
  select count (*)  as Total_director
  from Employee_survey
  where Director =1;
 
 --- Total supervisor
   select count (*)  as Total_supervisor
  from Employee_survey
  where Supervisor =1;
   --- Total Manager
     select count (*)  as Total_manager
  from Employee_survey
  where Manager =1;


  ---- Total Employees
  select count(Response_id) as Total_Employee
  from Employee_survey;

  --- Department with number of manager
  select Department ,
  count(distinct Manager) as Totalmanager
  from Employee_survey
  group by Department
  order by Department;
  --- Department with supervisor and Dirctor
   select Department ,
  count(distinct Supervisor) as TotalSupervisor
  from Employee_survey
  group by Department
  order by Department;
  ---- Department with Directors
   select Department ,
  count(distinct Director) as Totaldirector
  from Employee_survey
  group by Department
  order by Department;
    --- Total number of unique directors
    select count(distinct Manager) as uniqueDirector
    from Employee_survey;

    --- Directors that appears morethan once
    select director,
    count(distinct Department) as Depcount
    from Employee_survey
    group by director 
    having count (distinct Department)>1
    order by Depcount DESC;

    ----- Total Response
    select distinct Response_Text
    from Employee_survey;

    --- Total agree and disagree response from employee
    select Question,Response_Text,
    count(*) as TotalResponse
    from Employee_survey
    where Response_Text in ('Agree','Disagree','Strongly Agree','Strongly Disagree','NULL','Not Applicable')
    group by Question, Response_Text
    order by Question,Response_Text DESC;
--- Total survey question that employee agree and disagree with
    select Question,Response_Text,
    count(*) as TotalResponse
    from Employee_survey
    where Response_Text in ('Agree','Disagree')
    group by Question, Response_Text
    order by Question,Response_Text DESC;

    ---Total percentage of agree and disagree

    select Question,
    ROUND(
    100.0 * sum(case when Response_Text in ('Agree') then 1 else 0 end)/count(*),0) as Agreepercent,
    ROUND(
    100.0 * sum(case when Response_Text in ('Disagree') then 1 else 0 end)/count(*),0) as Disagreepercent
    from Employee_survey
    group by Question
    order by Question;

    ---- Total  agree and disagree by department 
    select Department,Question,
    sum(case when Response_Text in ('Agree') then 1 else 0 end)as Agreecount,
    sum(case when Response_Text in ('Disagree') then 1 else 0 end) as Disagreecount,
    count(*) as Totalresponse
    from Employee_survey
    group by Department,Question
    order by Department,Question;
    ---- Joining the manager, supervisor and director columns to one
    Select
    Response_Text,
    Department, 
    'Director' as Role,
    Director as Person
    from Employee_survey
    where Director is not null
    union
     Select
    Response_Text,
    Department, 
    'Manager' as Role,
    Manager as Person
    from Employee_survey
    where Director is not null
    union
     Select
    Response_Text,
    Department, 
    'Supervisor' as Role,
    Supervisor as Person
    from Employee_survey
    where Director is not null;

