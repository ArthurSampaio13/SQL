SELECT
    t1.idPlayer,
    COUNT(DISTINCT t1.idMedal) AS qtMedalhasDist,
    COUNT(t1.idMedal) as qtMedalhas,
    t2.descMedal,
    COUNT(CASE WHEN t2.descMedal in ('Membro Plus', 'Membro Premium') THEN t1.idMedal END) AS qtAssinatura,
    COUNT(CASE WHEN t2.descMedal = 'Membro Plus' THEN t1.idMedal END) AS qtPlus,
    COUNT(CASE WHEN t2.descMedal = 'Membro Premium' THEN t1.idMedal END) AS qtPremium,
    max(CASE WHEN t2.descMedal in ('Membro Plus', 'Membro Premium' AND COALESCE(t1.dtRemove, date ('now') > '2022-01-01')) THEN 1 ELSE 0 END) AS flAssinante
FROM
    tb_players_medalha AS t1
    LEFT JOIN tb_medalha AS t2 ON t1.idMedal = t2.idMedal
WHERE
    t1.dtCreatedAt < t1.dtExpiration
    AND t1.dtCreatedAt < COALESCE(t1.dtRemove, date ('now'))
    AND t1.dtCreatedAt < '2022-01-01'
GROUP BY
    t1.idPlayer