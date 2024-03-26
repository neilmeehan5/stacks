WITH A AS (
	SELECT 
		TAG_ID,
		COUNTER AS OG_COUNT,
		WORK_TOTAL_COUNT AS OG_WORK_TOTAL_COUNT,
		WORK_TOTAL_COUNT_NORM AS OG_WORK_TOTAL_COUNT_NORM
	FROM BUILDSHELVES
	WHERE WORK_ID IN (1461747)
	--AND RANKER % 10 = 8
),
B AS (
	SELECT
		WORK_ID,
		--COUNTER,
		--OG_COUNT,
		--COUNTER,
		--OG_WORK_TOTAL_COUNT_NORM,
		--WORK_TOTAL_COUNT_NORM,
		--OG_WORK_TOTAL_COUNT,
		--WORK_TOTAL_COUNT,
		--TAG_TOTAL_COUNT
		--SUM(OG_COUNT * COUNTER) / CAST(CAST(OG_WORK_TOTAL_COUNT_NORM AS FLOAT) * CAST(WORK_TOTAL_COUNT_NORM AS FLOAT) AS FLOAT) AS SIM1,
		--SUM((CAST(OG_COUNT AS FLOAT) / OG_WORK_TOTAL_COUNT) * (CAST(COUNTER AS FLOAT) / WORK_TOTAL_COUNT)) AS SIM2,
		SUM(CAST(OG_COUNT + COUNTER AS FLOAT) / TAG_TOTAL_COUNT) AS SIM3,
		COUNT(DISTINCT TAG_ID) AS NUM_TAG
	FROM BUILDSHELVES
	INNER JOIN A
	USING(TAG_ID)
	WHERE WORK_ID NOT IN (1461747)
	GROUP BY WORK_ID, OG_WORK_TOTAL_COUNT_NORM, WORK_TOTAL_COUNT_NORM
	ORDER BY SIM3 DESC
	LIMIT 100
)
SELECT DISTINCT
	WORK_ID,
	TITLE,
	LANGUAGE_CODE,
	SIM3 * NUM_TAG AS ROUGH_SCORE,
	SIM3,
	NUM_TAG
FROM B
INNER JOIN ENGINE_API_BUILDWORKS 
USING (WORK_ID)
ORDER BY ROUGH_SCORE DESC;

WITH A AS (
	SELECT
		WORK_ID,
		COUNTER,
		ROW_NUMBER() OVER(PARTITION BY WORK_ID ORDER BY COUNTER DESC) AS RANKER
	FROM BUILDSHELVES
)
SELECT
	RANKER,
	AVG(COUNTER) AS AVG_COUNT,
	COUNT(*) AS NUM_OBS
FROM A
GROUP BY RANKER
ORDER BY RANKER;

SELECT *
FROM BUILDSHELVES
WHERE WORK_ID = 1461747
AND RANKER % 10 = 5
ORDER BY RANKER;


SELECT 
	TAG_NAME,
	SUM(COUNT) AS COUNTER
FROM ENGINE_API_SHELVES
GROUP BY TAG_NAME
ORDER BY COUNTER DESC
LIMIT 1000;


--SELECT COUNT(*)
--FROM BUILDSHELVES;