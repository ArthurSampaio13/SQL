# Projeto de Predição de churn

## Sobre o Projeto

Este projeto tem como objetivo criar modelos de Machine Learning para previsão de churn. Utilizando as metodologias CRISP-DM e SEMMA, bem como a ferramenta MLflow para gestão do ciclo de vida dos modelos.

## Metodologia

### CRISP-DM

CRISP-DM (Cross Industry Standard Process for Data Mining) é uma metodologia padrão para mineração de dados. As etapas incluem:

1. **Entendimento do Negócio:** Compreensão dos objetivos e requisitos do negócio.
2. **Entendimento dos Dados:** Coleta inicial de dados para familiarização.
3. **Preparação dos Dados:** Limpeza e transformação dos dados para análise.
4. **Modelagem:** Aplicação de técnicas de modelagem para criar modelos preditivos.
5. **Avaliação:** Avaliação dos modelos para garantir que atendem aos objetivos do negócio.
6. **Desdobramento:** Implementação dos modelos em um ambiente de produção.

![CRISP-DM](https://miro.medium.com/v2/resize:fit:988/0*tA5OjppLK627FfFo)

### SEMMA

SEMMA (Sample, Explore, Modify, Model, Assess) é uma metodologia desenvolvida pelo SAS para modelagem de dados. As etapas incluem:

1. **Sample:** Amostragem dos dados.
2. **Explore:** Exploração dos dados para encontrar padrões.
3. **Modify:** Modificação e transformação dos dados.
4. **Model:** Construção dos modelos preditivos.
5. **Assess:** Avaliação dos modelos.

![SEMMA](https://documentation.sas.com/api/docsets/emref/14.3/content/images/semma.png?locale=en)

### MLflow

MLflow é uma plataforma para gerenciar o ciclo de vida do aprendizado de máquina, incluindo experimentação, replicação e deploy de modelos de ML.

## Processo de ETL

O processo de ETL (Extract, Transform, Load) completo foi realizado para garantir a preparação adequada dos dados. As etapas incluem:

1. **Extração:** Extração dos dados do banco de dados da Olist.
2. **Transformação:** Criação de aproximadamente 60 features (variáveis) para alimentar o modelo preditivo. Estas features são calculadas a partir dos dados brutos extraídos.
3. **Carregamento:** Transformação dos dados com o modelo treinado e armazenamento dos scores de chance de ativação, churn, atraso no pedido e clusters no banco de dados.

## Estrutura do Projeto

O projeto está organizado nas seguintes pastas principais:

- **data:** Contém o banco de dados utilizado no projeto.
- **src:** Diretório principal contendo as pastas feature_store e model.
  - **feature_store:** Contéma as features_stores e script de ingestão.
    - `assinatura.sql`
    - `gameplay.sql`
    - `medalha.sql`
    - `executor.py`
  - **model:** Scripts de predição e treinamento de modelos, juntamento com a ABT.
    - `ABT.py`
    - `modeling.py`

## Execução do Projeto

### Passo 1 - Introdução à ML + Definição do Problema

Conheci o ciclo básico de desenvolvimento de um modelo de Machine Learning e defini colaborativamente o problema de negócio a ser resolvido utilizando técnicas preditivas.

### Passo 2 - Brainstorm de Variáveis + Criação da Feature Store 

Discuti as variáveis que ajudarão a prever o evento de interesse e criei as primeiras variáveis em suas tabelas de Feature Stores.

### Passo 3 - Criação da ABT

Processei a tabela definitiva para treinamento do algoritmo de Machine Learning, conhecida como ABT (Analytical Base Table), que contém todas as informações necessárias para a solução do problema de negócios.

### Passo 4 - Treinando Algoritmos com MLflow

Treinei os primeiros algoritmos de Machine Learning utilizando a biblioteca MLflow para gerenciar o ciclo de vida dos modelos, facilitando a identificação da performance, métricas, parâmetros e variáveis de cada modelo.

### Passo 5 - Escolhendo o Melhor Algoritmo + Deploy

Defini o modelo campeão, realizei novas predições e criei scripts para automatizar o processo de predição, utilizando o modelo para ajudar o negócio com novas possibilidades.
