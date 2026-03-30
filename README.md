# Layoffs Exploratory Data Analysis (EDA) 📊

Este projeto foca na **Exploração de Dados (EDA)** de um dataset global de demissões (*layoffs*). Após a etapa inicial de limpeza e padronização, utilizei MySQL para investigar tendências, identificar padrões de mercado e extrair insights estratégicos sobre o impacto econômico no setor de tecnologia.

---

## 🛠️ Tecnicas e Ferramentas Aplicadas

* **Agregações de Negócio:** Uso estratégico de `GROUP BY` e `SUM` para medir o impacto real por país, setor e estágio da empresa.
* **Análise de Picos:** Identificação de picos de demissões ao longo dos meses e anos.
* **Window Functions:** Implementação de `SUM() OVER()` para cálculo de **Total Acumulado (Rolling Total)**, permitindo visualizar a progressão da crise.
* **Consultas Avançadas com CTEs:** Estruturação de múltiplas **Common Table Expressions** e `DENSE_RANK()` para criar rankings dinâmicos (Top 3 empresas com mais demissões por ano).

---

## 📈 Principais Insights Gerados

1.  **Sazonalidade e Picos:** Identificação de que o ano de 2022 foi o mais crítico do dataset em volume de demissões.
2.  **Impacto por Maturidade:** Análise de como empresas em estágio *Post-IPO* tiveram o maior volume absoluto, enquanto startups (*Seed/Series A*) sofreram com fechamentos totais (100% layoff).
3.  **Grandes Falências:** Cruzamento de dados entre empresas que encerraram operações e o volume de investimento (*funds raised*) que elas haviam captado.

---

## 🌍 English Version

This project focuses on the **Exploratory Data Analysis (EDA)** of a global layoffs dataset. Following the initial data cleaning and standardization stage, I used MySQL to investigate trends, identify market patterns, and extract strategic insights into the economic impact on the tech sector.

### 🛠️ Applied Techniques & Tools
* **Business Aggregations:** Strategic use of `GROUP BY` and `SUM` to measure impact by country, industry, and company stage.
* **Time Series Analysis:** Identifying layoff peaks across months and years.
* **Window Functions:** Implementation of `SUM() OVER()` for **Rolling Total** calculations to visualize crisis progression.
* **Advanced Queries with CTEs:** Structuring multiple **Common Table Expressions** and `DENSE_RANK()` to create dynamic rankings (Top 3 companies with the most layoffs per year).

### 📈 Key Insights
1.  **Seasonality & Peaks:** Identification of 2022 as the most critical year in the dataset regarding layoff volume.
2.  **Maturity Impact:** Analysis showing that *Post-IPO* companies had the highest absolute volume, while startups (*Seed/Series A*) suffered more from total shutdowns (100% layoff).
3.  **Large-Scale Failures:** Data correlation between companies that ceased operations and the volume of funding they had raised.

---

## 📂 Como visualizar o projeto / How to view
O script completo com as consultas comentadas está disponível no arquivo: [`data_exploratory_layoffs.sql`](./data_exploratory_layoffs.sql)

*Este projeto é a continuação do meu fluxo de trabalho de dados. Confira a etapa anterior de **[Data Cleaning](https://github.com/victtorluis/sql-data-cleaning-layoffs)**.*

---
**Conecte-se comigo / Let's connect:**
[LinkedIn](https://www.linkedin.com/in/victor-luis-barbosa/)
