# %%
import pandas as pd
import numpy as np
import sqlalchemy
    
import sqlite3

from sklearn import model_selection, pipeline, tree, ensemble, metrics

from feature_engine import imputation, encoding

import matplotlib.pyplot as plt
import scikitplot as skplt
# %%
engine = sqlalchemy.create_engine("sqlite:///../../../data/gc (1).db")
conn = sqlite3.connect("../../../data/gc (1).db")
query = "SELECT * FROM ABT"
# %%
# SAMPLE
df = pd.read_sql_query(query, conn)
# %%
dt_oot = df[df['dtRef'] == '2022-01-11']
# %%
df_train = df[df['dtRef'] != '2022-01-11']
# %%
target = 'flNaoChurn'
identificadores = ['dtRef', 'idPlayer', 'dtRef:1']
to_remove = 'flAssinatura'

columns = df.columns

features = list(set(columns) - set(identificadores + [target] + [to_remove]))
# %%
X_train, X_test, y_train, y_test = model_selection.train_test_split(df_train[features],
                                                                                        df_train[target],
                                                                                        test_size = 0.2,
                                                                                        random_state=42)

# %%
# EXPLORE
## Missings
missing_columns = X_train.count()[X_train.count() < X_train.shape[0]].index
# %%
missings_flag = [
    'avgHsRate',
    'avgKDA',
    'avgKDR',
    'avgQt1Kill',
    'avgQt2Kill',
    'avgQt3Kill',
    'avgQt4Kill',
    'avgQt5Kill',
    'avgQtAssist',
    'avgQtBombeDefuse',
    'avgQtBombePlant',
    'avgQtClutchWon',
    'avgQtDeath',
    'avgQtFirstKill',
    'avgQtFlashAssist',
    'avgQtHitChest',
    'avgQtHitHeadshot',
    'avgQtHitLeftAtm',
    'avgQtHitLeftLeg',
    'avgQtHitRightArm',
    'avgQtHitRightLeg',
    'avgQtHitStomach',
    'avgQtHits',
    'avgQtHs',
    'avgQtKill',
    'avgQtLastAlive',
    'avgQtPlusKill',
    'avgQtRoundsPlayed',
    'avgQtShots',
    'avgQtSurvived',
    'avgQtTk',
    'avgQtTkAssist',
    'avgQtTrade',
    'qtRecencia',
    'vlHsRate',
    'vlKDA',
    'vlKDR',
    'vlLevel',
    'winRate']

missing_zero = [
    'propAncient',
    'propDust2',
    'propInferno',
    'propMirage',
    'propNuke',
    'propOverpass',
    'propTrain',
    'propVertigo',
    'qtDia00',
    'qtDia01',
    'qtDia02',
    'qtDia03',
    'qtDia04',
    'qtDia05',
    'qtDia06',
    'qtDias',
    'qtMedalhas',
    'qtMedalhasDist',
    'qtPartidas'
]

cat_features = X_train.dtypes[X_train.dtypes == 'object'].index.tolist()
cat_features
# %%

# MODIFY
fe_onehot = encoding.OneHotEncoder(variables=cat_features)

fe_missing_flag = imputation.ArbitraryNumberImputer(variables= missings_flag, 
                                                    arbitrary_number= -100)

fe_missing_zero = imputation.ArbitraryNumberImputer(variables= missing_zero,
                                                    arbitrary_number = 0)
# %%
# MODELING
model = ensemble.RandomForestClassifier(random_state=42)

params = {
    "min_samples_leaf" : [10,25,50],
    "n_estimators" : [50,100,250,500]
    }

grid_model = model_selection.GridSearchCV(model, 
                                          params, 
                                          n_jobs=-1,
                                          scoring='roc_auc',
                                          cv=3,
                                          verbose=3)
# %%
model_pipeline = pipeline.Pipeline([("Missing Flag", fe_missing_flag), 
                                    ("Missing Zero", fe_missing_zero),
                                    ("OneHot", fe_onehot),
                                    ("Classificador-T", grid_model)])

grid_model.fit(X_train, y_train)

# %%
pd.DataFrame(grid_model.cv_results_)
# %%
y_train_predict = grid_model.predict(X_train)
acc_train = metrics.accuracy_score(y_train, y_train_predict)
acc_train

# %%
y_test_predict = grid_model.predict(X_test)

y_probas = model_pipeline.predict_proba(X_test)

acc_test = metrics.accuracy_score(y_test, y_test_predict)
acc_test

# %%
features_fit = model_pipeline[:-1].transform(X_train).columns.tolist()

features_importance = pd.Series(model.feature_importances_, index=features_fit)
features_importance.sort_values(ascending=False).head(15)

# %%
skplt.metrics.plot_roc(y_test, y_probas)
# %%
skplt.metrics.plot_ks_statistic(y_test, y_probas)
# %%

y_oot_predict = grid_model.predict(dt_oot[features])

y_probas_oot = model_pipeline.predict_proba(dt_oot[features])

acc_oot = metrics.accuracy_score(dt_oot[target], y_oot_predict)
acc_oot
# %%
skplt.metrics.plot_roc(dt_oot[target], y_probas_oot)
# %%
skplt.metrics.plot_ks_statistic(dt_oot[target], y_probas_oot)
# %%
