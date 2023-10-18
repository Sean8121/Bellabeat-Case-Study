-- Look at Total Steps per Id (where watch was not forgotten)

SELECT Id, SUM(TotalSteps) as TotalStepsPerId
FROM PortfolioProjects..daily_activity_merged
WHERE ForgotWatch NOT LIKE 'TRUE'
GROUP BY Id
ORDER BY 1

-- Look at Total Calories per Id (where watch was not forgotten)

SELECT Id, SUM(Calories) as TotalCaloriesPerId
FROM PortfolioProjects..daily_activity_merged
WHERE ForgotWatch NOT LIKE 'TRUE'
GROUP BY Id
ORDER BY 1

-- Look at Total Distance per Id (where watch was not forgotten)

SELECT Id, SUM(TotalDistance) as TotalDistancePerId
FROM PortfolioProjects..daily_activity_merged
WHERE ForgotWatch NOT LIKE 'TRUE'
GROUP BY Id
ORDER BY 1

-- Total Days with Watch per Id

SELECT Id, COUNT(DISTINCT ActivityDate) as DaysWithWatch
FROM PortfolioProjects..daily_activity_merged
WHERE ForgotWatch NOT LIKE 'TRUE'
GROUP BY Id
ORDER BY 1

-- Averages of Calories, Steps, Distance per Day, Days with Watch


WITH TempTable as
(SELECT Id, 
SUM(TotalSteps) as TotalStepsPerId,
SUM(Calories) as TotalCaloriesPerId,
SUM(TotalDistance) as TotalDistancePerId,
COUNT(DISTINCT ActivityDate) as DaysWithWatch
FROM PortfolioProjects..daily_activity_merged
WHERE ForgotWatch NOT LIKE 'TRUE'
GROUP BY Id
)
SELECT Id, TotalStepsPerId/DaysWithWatch as StepsPerDay,
TotalCaloriesPerId/DaysWithWatch as CaloriesPerDay,
TotalDistancePerId/DaysWithWatch as DistancePerDay,
DaysWithWatch
FROM TempTable
ORDER BY 1

-- Looking at days of the week

SELECT DayOfWeek, AVG(TotalDistance) as DistancePerDay,
AVG(TotalSteps) as StepsPerDay,
AVG(Calories) as CaloriesPerDay
FROM PortfolioProjects..daily_activity_merged
GROUP BY DayOfWeek
ORDER BY DistancePerDay DESC

-- Calories burned per hour of day SUM

SELECT Cast(ActivityTime as time) as HourOfDay, SUM(Calories) as SumCalories
FROM PortfolioProjects..hourly_calories_merged
GROUP BY ActivityTime
ORDER BY 1


-- Calories burned per hour of day AVG

SELECT Cast(ActivityTime as time) as HourOfDay, AVG(Calories) as AvgCalories
FROM PortfolioProjects..hourly_calories_merged
GROUP BY ActivityTime
ORDER BY 1


-- Total Intensity Per Hour of Day

SELECT Cast(ActivityHour as Time) as HourOfDay, SUM(TotalIntensity) as SumIntensity
FROM PortfolioProjects..hourly_intensities_merged
GROUP BY ActivityHour
ORDER BY 1

-- Avg Intensity per hour of day

SELECT Cast(ActivityHour as Time) as HourOfDay, AVG(TotalIntensity) as AvgIntensity
FROM PortfolioProjects..hourly_intensities_merged
GROUP BY ActivityHour
ORDER BY 1

-- Intensity Types Per Id

SELECT Id, SUM(VeryActiveMinutes) as TotalVeryActiveMinutes, 
SUM(FairlyActiveMinutes) as TotalFairlyActiveMinutes, 
SUM(LightlyActiveMinutes) as TotalLightlyActiveMinutes, 
SUM(SedentaryMinutes) as TotalSedentaryMinutes
FROM PortfolioProjects..daily_activity_merged
GROUP BY Id

--BONUS DATA: WEIGHT DATA

Select Id, Date, WeightPounds
FROM PortfolioProjects..weight_log_info_merged

-- BONUS DATA : SLEEP DATA

--Amount of Days Recorded with Sleep Data per Id

SELECT Id, COUNT(Distinct(SleepDay)) as NumberOfSleepDays 
FROM PortfolioProjects..sleep_day_merged
GROUP BY Id
ORDER BY 2 DESC

-- Total Minutes Asleep per Id

SELECT Id, SUM(TotalMinutesAsleep) as MinutesAsleepPerId
FROM PortfolioProjects..sleep_day_merged
GROUP BY Id
Order BY 2 DESC


-- Average Minutes Asleep Per Id (over days recorded with sleep data) where Number of Sleep Days > 8 (min 15)

WITH TempTable2 as
(SELECT Id, 
COUNT(Distinct(SleepDay)) as NumberOfSleepDays,
SUM(TotalMinutesAsleep) as MinutesAsleepPerId
FROM PortfolioProjects..sleep_day_merged
GROUP BY Id
)
SELECT Id, MinutesAsleepPerId/NumberOfSleepDays as MinutesAsleepAverage
FROM TempTable2
WHERE NumberOfSleepDays >8
ORDER BY 2



---- CREATING VIEWS
---- Average ActivitiesPerDay

--Create View AverageActivitiesPerDay as
--WITH TempTable as
--(SELECT Id, 
--SUM(TotalSteps) as TotalStepsPerId,
--SUM(Calories) as TotalCaloriesPerId,
--SUM(TotalDistance) as TotalDistancePerId,
--COUNT(DISTINCT ActivityDate) as DaysWithWatch
--FROM PortfolioProjects..daily_activity_merged
--WHERE ForgotWatch NOT LIKE 'TRUE'
--GROUP BY Id
--)
--SELECT Id, TotalStepsPerId/DaysWithWatch as StepsPerDay,
--TotalCaloriesPerId/DaysWithWatch as CaloriesPerDay,
--TotalDistancePerId/DaysWithWatch as DistancePerDay,
--DaysWithWatch
--FROM TempTable
--ORDER BY 1


----ActivityPerDayOfWeek

--Create View ActivityPerDayOfWeek as 
--SELECT DayOfWeek, AVG(TotalDistance) as DistancePerDay,
--AVG(TotalSteps) as StepsPerDay,
--AVG(Calories) as CaloriesPerDay
--FROM PortfolioProjects..daily_activity_merged
--GROUP BY DayOfWeek
----ORDER BY DistancePerDay DESC

----Hours of Day
---- Calories Per Hour

--Create View CaloriesPerHour as
--SELECT Cast(ActivityTime as time) as HourOfDay, SUM(Calories) as SumCalories
--FROM PortfolioProjects..hourly_calories_merged
--GROUP BY ActivityTime
----ORDER BY 1


---- Total Intensity Per Hour of Day
---- Intensity Per Hour


--Create View ActivityPerHour as
--SELECT Cast(ActivityHour as Time) as HourOfDay, SUM(TotalIntensity) as SumIntensity
--FROM PortfolioProjects..hourly_intensities_merged
--GROUP BY ActivityHour
----ORDER BY 1



----SLEEP VIEW BONUS

--Create View AverageOfSleep as
--WITH SleepTable as
--(SELECT Id, 
--COUNT(Distinct(SleepDay)) as NumberOfSleepDays,
--SUM(TotalMinutesAsleep) as MinutesAsleepPerId
--FROM PortfolioProjects..sleep_day_merged
--GROUP BY Id
--)
--SELECT Id, MinutesAsleepPerId/NumberOfSleepDays as MinutesAsleepAverage
--FROM SleepTable
--WHERE NumberOfSleepDays >8
----ORDER BY 2