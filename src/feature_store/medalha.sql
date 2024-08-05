WITH
    medalhas AS (
        SELECT
            t1.idPlayer,
            COUNT(DISTINCT t1.idMedal) AS qtMedalhasDist,
            COUNT(t1.idMedal) as qtMedalhas
        FROM
            tb_players_medalha AS t1
            LEFT JOIN tb_medalha AS t2 ON t1.idMedal = t2.idMedal
        WHERE
            t1.dtCreatedAt < t1.dtExpiration
            AND t1.dtCreatedAt < COALESCE(t1.dtRemove, date ('now'))
            AND t1.dtCreatedAt < '2021-11-01'
        GROUP BY
            t1.idPlayer
    )
INSERT INTO fs_medalhas
SELECT
    '{date}' AS dtRef,
    t1.*
FROM
    medalhas AS t1