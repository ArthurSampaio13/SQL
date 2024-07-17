WITH tb_assinatura AS (
    SELECT 
        t1.*,
        t2.descMedal
    FROM
        tb_players_medalha AS t1
        LEFT JOIN tb_medalha AS t2 ON t1.idMedal = t2.idMedal
    WHERE
        t1.dtCreatedAt < t1.dtExpiration
        AND t1.dtCreatedAt < COALESCE(t1.dtRemove, t1.dtExpiration, date ('now'))
        AND t1.dtCreatedAt < '{date}'
        AND COALESCE(t1.dtRemove, t1.dtExpiration, DATE('now')) > '{date}'
        AND t2.descMedal in ('Membro Plus', 'Membro Premium')  
    ORDER BY
        t1.idPlayer
),

tb_assinatura_rn AS (
    SELECT
        *,
        row_number() OVER (PARTITION BY idPlayer ORDER BY dtCreatedAt DESC) AS rn_assinatura
    FROM  
        tb_assinatura
    ),

tb_assinatura_sumario AS (
    SELECT 
        *,
        (JULIANDAY('{date}') - JULIANDAY(dtCreatedAt)) AS qtDiasAssinatura,
        (JULIANDAY(dtExpiration) - JULIANDAY('{date}')) AS qtDiasExpiracaoAssinatura
    FROM 
        tb_assinatura_rn
    WHERE 
        rn_assinatura = 1
    ORDER BY 
        idPlayer
),

tb_assinatura_historica AS (
    SELECT
        t1.idPlayer,    
        COUNT(t1.idPlayer) AS qtAssinatura,     
        COUNT(CASE WHEN t2.descMedal = 'Membro Premium' THEN t1.idMedal END) AS qtPremium,
        COUNT(CASE WHEN t2.descMedal = 'Membro Plus' THEN t1.idMedal END) AS qtPlus
    FROM
        tb_players_medalha AS t1
        LEFT JOIN tb_medalha AS t2 ON t1.idMedal = t2.idMedal
    WHERE
        t1.dtCreatedAt < t1.dtExpiration
        AND t1.dtCreatedAt < COALESCE(t1.dtRemove, date ('now'))
        AND t1.dtCreatedAt < '{date}'
        AND t2.descMedal in ('Membro Plus', 'Membro Premium')
    GROUP BY
        t1.idPlayer

)
INSERT INTO fs_assinatura 
SELECT 
    '{date}' as dtRef,      
    t1.idPlayer,
    t1.descMedal,
    1 AS flAssinatura,
    t1.qtDiasAssinatura,
    t1.qtDiasExpiracaoAssinatura,
    t2.qtAssinatura,
    t2.qtPremium,
    t2.qtPlus
    
FROM 
    tb_assinatura_sumario AS t1
LEFT JOIN tb_assinatura_historica AS t2 ON t1.idPlayer = t2.idPlayer

