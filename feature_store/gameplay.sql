WITH tb_level AS (
    SELECT idPlayer, 
           vlLevel,
           row_number() OVER (PARTITION BY idPlayer ORDER BY dtCreatedAt DESC) AS rnPlayer
    FROM 
        tb_lobby_stats_player
    WHERE
        dtCreatedAt < '{date}'
        AND dtCreatedAt >= DATE ('{date}', '-1 month')
    ORDER BY
        idPlayer, 
        dtCreatedAt
),

tb_level_final AS (
    SELECT 
        * 
    FROM 
        tb_level
    WHERE
        rnPlayer = 1
),

tb_gameplay_stats AS (

SELECT
    idPlayer,
    COUNT(DISTINCT idLobbyGame) AS qtPartidas,
    COUNT(DISTINCT date (dtCreatedAt)) AS qtDias,
    1.0 * min(JULIANDAY('{date}') - JULIANDAY(dtCreatedAt)) AS qtRecencia,
    1.0 * COUNT(DISTINCT CASE WHEN CAST(STRFTIME('%w', dtCreatedAt) AS INTEGER) = 0 THEN DATE(dtCreatedAt) END) / COUNT(DISTINCT date (dtCreatedAt)) AS qtDia00,
    1.0 * COUNT(DISTINCT CASE WHEN CAST(STRFTIME('%w', dtCreatedAt) AS INTEGER) = 1 THEN DATE(dtCreatedAt) END) / COUNT(DISTINCT date (dtCreatedAt)) AS qtDia01,
    1.0 * COUNT(DISTINCT CASE WHEN CAST(STRFTIME('%w', dtCreatedAt) AS INTEGER) = 2 THEN DATE(dtCreatedAt) END) / COUNT(DISTINCT date (dtCreatedAt)) AS qtDia02,
    1.0 * COUNT(DISTINCT CASE WHEN CAST(STRFTIME('%w', dtCreatedAt) AS INTEGER) = 3 THEN DATE(dtCreatedAt) END) / COUNT(DISTINCT date (dtCreatedAt)) AS qtDia03,
    1.0 * COUNT(DISTINCT CASE WHEN CAST(STRFTIME('%w', dtCreatedAt) AS INTEGER) = 4 THEN DATE(dtCreatedAt) END) / COUNT(DISTINCT date (dtCreatedAt)) AS qtDia04,
    1.0 * COUNT(DISTINCT CASE WHEN CAST(STRFTIME('%w', dtCreatedAt) AS INTEGER) = 5 THEN DATE(dtCreatedAt) END) / COUNT(DISTINCT date (dtCreatedAt)) AS qtDia05,
    1.0 * COUNT(DISTINCT CASE WHEN CAST(STRFTIME('%w', dtCreatedAt) AS INTEGER) = 6 THEN DATE(dtCreatedAt) END) / COUNT(DISTINCT date (dtCreatedAt)) AS qtDia06,
    AVG(1.0 * flWinner) AS winRate,
    AVG(1.0 * qtHs / qtKill) AS avgHsRate,
    SUM(1.0 * qtHs) / SUM(1.0 * qtKill) AS vlHsRate,
    AVG(1.0 * (qtKill + qtAssist) / COALESCE(qtDeath, 1)) AS avgKDA,
    COALESCE(SUM(1.0 * (qtKill + qtAssist)) / COALESCE(qtDeath, 1), 0) AS vlKDA,
    AVG(1.0 * COALESCE(qtKill, 0) / COALESCE(qtDeath, 1)) AS avgKDR,
    SUM(1.0 * COALESCE(qtKill, 0)) / COALESCE(qtDeath, 1) AS vlKDR,
    1.0 * AVG(qtKill) as avgQtKill,
    1.0 * AVG(qtAssist) as avgQtAssist,
    1.0 * AVG(qtDeath) as avgQtDeath,
    1.0 * AVG(qtHs) as avgQtHs,
    1.0 * AVG(qtBombeDefuse) as avgQtBombeDefuse,
    1.0 * AVG(qtBombePlant) as avgQtBombePlant,
    1.0 * AVG(qtTk) as avgQtTk,
    1.0 * AVG(qtTkAssist) as avgQtTkAssist,
    1.0 * AVG(qt1Kill) as avgQt1Kill,
    1.0 * AVG(qt2Kill) as avgQt2Kill,
    1.0 * AVG(qt3Kill) as avgQt3Kill,
    1.0 * AVG(qt4Kill) as avgQt4Kill,
    1.0 * AVG(qt5Kill) as avgQt5Kill,
    1.0 * AVG(qtPlusKill) as avgQtPlusKill,
    1.0 * AVG(qtFirstKill) as avgQtFirstKill,
    1.0 * AVG(qtHits) as avgQtHits,
    1.0 * AVG(qtShots) as avgQtShots,
    1.0 * AVG(qtLastAlive) as avgQtLastAlive,
    1.0 * AVG(qtClutchWon) as avgQtClutchWon,
    1.0 * AVG(qtRoundsPlayed) as avgQtRoundsPlayed,
    1.0 * AVG(qtSurvived) as avgQtSurvived,
    1.0 * AVG(qtTrade) as avgQtTrade,
    1.0 * AVG(qtFlashAssist) as avgQtFlashAssist,
    1.0 * AVG(qtHitHeadshot) as avgQtHitHeadshot,
    1.0 * AVG(qtHitChest) as avgQtHitChest,
    1.0 * AVG(qtHitStomach) as avgQtHitStomach,
    1.0 * AVG(qtHitLeftAtm) as avgQtHitLeftAtm,
    1.0 * AVG(qtHitRightArm) as avgQtHitRightArm,
    1.0 * AVG(qtHitLeftLeg) as avgQtHitLeftLeg,
    1.0 * AVG(qtHitRightLeg) as avgQtHitRightLeg,
    1.0 * COUNT(DISTINCT CASE WHEN descMapName = 'de_mirage' THEN idLobbyGame END) / COUNT(DISTINCT idLobbyGame) AS propMirage,
    1.0 * COUNT(DISTINCT CASE WHEN descMapName = 'de_nuke' THEN idLobbyGame END) / COUNT(DISTINCT idLobbyGame) AS propNuke,
    1.0 * COUNT(DISTINCT CASE WHEN descMapName = 'de_inferno' THEN idLobbyGame END) / COUNT(DISTINCT idLobbyGame) AS propInferno,
    1.0 * COUNT(DISTINCT CASE WHEN descMapName = 'de_vertigo' THEN idLobbyGame END) / COUNT(DISTINCT idLobbyGame) AS propVertigo,
    1.0 * COUNT(DISTINCT CASE WHEN descMapName = 'de_ancient' THEN idLobbyGame END) / COUNT(DISTINCT idLobbyGame) AS propAncient,
    1.0 * COUNT(DISTINCT CASE WHEN descMapName = 'de_dust2' THEN idLobbyGame END) / COUNT(DISTINCT idLobbyGame) AS propDust2,
    1.0 * COUNT(DISTINCT CASE WHEN descMapName = 'de_train' THEN idLobbyGame END) / COUNT(DISTINCT idLobbyGame) AS propTrain,
    1.0 * COUNT(DISTINCT CASE WHEN descMapName = 'de_overpass' THEN idLobbyGame END) / COUNT(DISTINCT idLobbyGame) AS propOverpass    
FROM
    tb_lobby_stats_player
WHERE
    dtCreatedAt < '{date}'
    AND dtCreatedAt >= DATE ('{date}', '-1 month')
GROUP BY
    idPlayer
)
INSERT INTO fs_gameplay
SELECT 
       '{date}' AS dtRef,
       t1.*,
       t2.vlLevel
FROM 
    tb_gameplay_stats AS t1
LEFT JOIN 
    tb_level_final AS t2
ON 
    t1.idPlayer = t2.idPlayer
