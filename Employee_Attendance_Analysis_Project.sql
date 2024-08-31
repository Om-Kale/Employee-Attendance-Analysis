


-- Calculate the Cumulative Sum of Work Hours by Department

select *,
	sum(work_hours) over(partition by department order by attendance_date) cummulative_sum
from employee_attendance

select * from  employee_attendance

-- Rank Employees Based on Their Total Work Hours

select 
	employee_id,
	employee_name,
	sum(work_hours) total_work_hour,
	rank() over(order by sum(work_hours) desc) RankingByHours
from employee_attendance
group by employee_id, employee_name

select * from  employee_attendance

-- Find the Difference in Work Hours Between Each Day for Each Employee

select employee_id,
employee_name,
work_hours,
coalesce( work_hours - lag(work_hours,1) over(partition by employee_id order by attendance_date desc),0) diff
from employee_attendance

-- Determine the Average Work Hours per Employee per Day with a Rolling Average

select
employee_id,
employee_name,
avg(work_hours) over(partition by employee_id order by attendance_date rows between 1 preceding and current row ) new
from employee_attendance

-- Identify Top 2 Work Hours for Each Department

select * from (
select *,
rank() over(partition by department order by work_hours desc) top_2
from employee_attendance
)t 
where top_2 <=2

-- Calculate the Percentage Contribution of Each Day's Work Hours to the Total Work Hours for Each Employee

select *,
	sum(work_hours) over(partition by employee_id ) total_hr,
	concat((work_hours*100/ sum(work_hours) over(partition by employee_id)), '%') percentage
from employee_attendance;

-- Find the Employee with the Maximum Work Hours Each Day

select *,
	max(work_hours) over(partition by attendance_date ) max_hr
from employee_attendance

-- Count the Number of Working Days for Each Employee

select *,
	count(attendance_date) over( partition by employee_id) as WorkingDays
from employee_attendance

-- Determine the First Date of Attendance for Each Department

select *,
	FIRST_VALUE(attendance_date) over(partition by department order by  attendance_date) as first_date
from employee_attendance

-- Calculate the Difference Between the First and Last Work Day for Each Employee

select *,
	first_value(attendance_date) over(partition by employee_id order by attendance_date) as first_value,
	last_value(attendance_date) over(partition by employee_id order by attendance_date) as last_value,

	datediff(day,first_value(attendance_date)over(partition by employee_id order by attendance_date) ,last_value(attendance_date)  over(partition by employee_id order by attendance_date)) as month

from employee_attendance

--Identify the Median Work Hours for Each Department

select * from employee_attendance

select employee_id,department ,
avg(work_hours) as  Median_work_hour

from(
select *,
		ROW_NUMBER() OVER (PARTITION BY department ORDER BY work_hours) AS rn,
        COUNT(*) OVER (PARTITION BY department) AS total_count
from employee_attendance)t
WHERE rn IN ((total_count + 1) / 2, (total_count + 2) / 2) 
group by employee_id,department

--Find the Total Work Hours Before Each Date for Each Employee

select *,
    SUM(work_hours) OVER (PARTITION BY employee_id ORDER BY attendance_date ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS Total_Whr2

from employee_attendance

-- Calculate the Work Hours of the Next Day for Each Employee

select *,
lead(work_hours) over(partition by employee_id order by attendance_date)  as new
from employee_attendance

--Find Employees with Work Hours Above the Department Average

select * from (
	select employee_id,
	employee_name,
	work_hours,
	department,
	avg(work_hours) over(partition by department ) departworkHR
	from employee_attendance
)t
where work_hours> departworkHR


--Calculate the Monthly Work Hours for Each Employee

select employee_id,employee_name,
	MONTH(attendance_date) AS month,
	sum(work_hours) over(partition by employee_id, month(attendance_date)) as MothlyWorkHR
from employee_attendance

		