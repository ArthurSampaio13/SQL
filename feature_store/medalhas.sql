SELECT
    t1.idPlayer,
    COUNT(DISTINCT t1.idMedal) AS qtMedalhasDist,
    COUNT(t1.idMedal) as qtMedalhas,
    t2.descMedal
FROM
    tb_players_medalha AS t1
    LEFT JOIN tb_medalha AS t2 ON t1.idMedal = t2.idMedal
WHERE
    t1.dtCreatedAt < t1.dtExpiration
    AND t1.dtCreatedAt < COALESCE(t1.dtRemove, date ('now'))
    AND t1.dtCreatedAt < '2022-01-01'
    AND COALESCE(t1.dtRemove, DATE('now')) > '2022-01-01'
    AND t2.descMedal in ('Membro Plus', 'Membro Premium')
GROUP BY
    t1.idPlayer