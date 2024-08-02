WITH tb_features AS (
SELECT
    t1.*,
    t2.qtPartidas,
    t2.qtDias,
    t2.qtRecencia,
    t2.qtDia00,
    t2.qtDia01,
    t2.qtDia02,
    t2.qtDia03,
    t2.qtDia04,
    t2.qtDia05,
    t2.qtDia06,
    t2.winRate,
    t2.avgHsRate,
    t2.vlHsRate,
    t2.avgKDA,
    t2.vlKDA,
    t2.avgKDR,
    t2.vlKDR,
    t2.avgQtKill,
    t2.avgQtAssist,
    t2.avgQtDeath,
    t2.avgQtHs,
    t2.avgQtBombeDefuse,
    t2.avgQtBombePlant,
    t2.avgQtTk,
    t2.avgQtTkAssist,
    t2.avgQt1Kill,
    t2.avgQt2Kill,
    t2.avgQt3Kill,
    t2.avgQt4Kill,
    t2.avgQt5Kill,
    t2.avgQtPlusKill,
    t2.avgQtFirstKill,
    t2.avgQtHits,
    t2.avgQtShots,
    t2.avgQtLastAlive,
    t2.avgQtClutchWon,
    t2.avgQtRoundsPlayed,
    t2.avgQtSurvived,
    t2.avgQtTrade,
    t2.avgQtFlashAssist,
    t2.avgQtHitHeadshot,
    t2.avgQtHitChest,
    t2.avgQtHitStomach,
    t2.avgQtHitLeftAtm,
    t2.avgQtHitRightArm,
    t2.avgQtHitLeftLeg,
    t2.avgQtHitRightLeg,
    t2.propMirage,
    t2.propNuke,
    t2.propInferno,
    t2.propVertigo,
    t2.propAncient,
    t2.propDust2,
    t2.propTrain,
    t2.propOverpass,
    t2.vlLevel,
    t3.qtMedalhasDist,
    t3.qtMedalhas
FROM
    fs_assinatura AS t1
    LEFT JOIN fs_gameplay AS t2 ON t1.dtRef = t2.dtRef
    AND t1.idPlayer = t2.idPlayer

    LEFT JOIN fs_medalhas AS t3 ON t1.dtRef = t3.dtRef
    AND t1.idPlayer = t3.idPlayer
WHERE
    t1.dtRef <= DATE('2022-02-10', '-30 days')
)
SELECT 
    t1.*,
    COALESCE(t2.flAssinatura, 0) AS flNaoChurn,
    t2.dtRef
FROM 
    tb_features AS t1
LEFT JOIN fs_assinatura AS t2
ON t1.idPlayer = t2.idPlayer
AND t1.dtRef = DATE(t2.dtRef, '-30 days')
ORDER BY t1.dtRef
