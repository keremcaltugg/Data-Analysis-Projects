SELECT
 cohort_date,
 session_date,
 DATE_DIFF(DATE(CONCAT(session_date,"-01")),DATE(CONCAT(cohort_date,"-01")),month) AS n_period,
 n_children
FROM ( (
   SELECT
     cohort_date,
     session_date,
     COUNT(DISTINCT ChildId) AS n_children
   FROM (
     SELECT
       c.ChangeMakerId,
       c.cohort_date,
       d.datee AS session_date
     FROM (
       SELECT
         ChangeMakerId,
         MIN(datee) AS cohort_date
       FROM (
         SELECT
           b.ChangeMakerId,
           FORMAT_DATE("%Y-%m", a.Date) AS datee
         FROM (
           SELECT
             Id,
             Date
           FROM
             `edu-338021.dbpublic.Sessions`)a
         LEFT JOIN (
           SELECT
             ChangeMakerId,
             SessionId
           FROM
             `edu-338021.dbpublic.SessionChild`)b
         ON
           a.Id = b.SessionId
         WHERE
           Date >= "2022-01-01"
           AND Date < "2023-01-01"
           AND ChangeMakerId IS NOT NULL
         ORDER BY
           Date)
       GROUP BY
         1)c
     JOIN (
       SELECT
         b.ChangeMakerId,
         FORMAT_DATE("%Y-%m", a.Date) AS datee
       FROM (
         SELECT
           Id,
           Date
         FROM
           `edu-338021.dbpublic.Sessions`)a
       LEFT JOIN (
         SELECT
           ChangeMakerId,
           SessionId
         FROM
           `edu-338021.dbpublic.SessionChild`)b
       ON
         a.Id = b.SessionId
       WHERE
         Date >= "2022-01-01"
         AND Date < "2023-01-01")d
     ON
       c.ChildId = d.ChildId)
   GROUP BY
     1,
     2
   ORDER BY
     1,
     2))