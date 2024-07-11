将MySQL表映射到本地，通过查询Clickhouse中的库表，直接获取到远程MySQL的中的数据，看起来就像是查询Clickhouse本地一样

### 利用Mysql表引擎建立与MySQL表的映射关系（实际上是一种远程查询引擎）
```
CREATE TABLE mysqldb.mysql_table
(
`id` Int32,
`uid` Int32,
`day_str` String,
`create_time` DateTime,
`status` Int32,
`commission` Nullable(Float32),
)
ENGINE = MySQL('192.168.120.1', 'from_mysql_dbname', 'from_mysql_table_name', 'mysql_user', 'mysql_password')
```