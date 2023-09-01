# goctl根据数据库生成model

## 描述单位的数据表

```sql
-- 创建 units 数据表
CREATE TABLE units (
    id SERIAL PRIMARY KEY,
    symbol VARCHAR(50) UNIQUE NOT NULL,  -- 单位的符号
    abbreviation VARCHAR(50),  -- 单位的简写
    name VARCHAR(100),  -- 单位的全名
    equivalent VARCHAR(100),  -- 单位的等效表达式或转换因子
    uses_scientific_notation BOOLEAN,  -- 是否采用科学计数法
    doc TEXT,  -- 英文文档或描述
    doc_zh TEXT  -- 简体中文文档或描述
);
```
## 描述变量类型的数据表

```sql
-- 创建变量类型表
CREATE TABLE variable_types (
    id SERIAL PRIMARY KEY,
    symbol VARCHAR(50) UNIQUE NOT NULL,  -- 变量类型的符号
    abbreviation VARCHAR(50),  -- 变量类型的简写
    unit_id INTEGER REFERENCES units(id),  -- 关联的单位ID
    min_value DOUBLE PRECISION,  -- 最小值
    max_value DOUBLE PRECISION,  -- 最大值
    default_value DOUBLE PRECISION,  -- 默认值
    doc TEXT,  -- 英文文档或描述
    doc_zh TEXT  -- 简体中文文档或描述
);

```

## 根据数据表生成对应的model

`goctl model pg datasource --url="postgres://user:123@localhost:5432/testDB?sslmode=disable" --table="*"`这个代码用来从postgresql数据生成model。