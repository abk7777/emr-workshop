CREATE EXTERNAL TABLE Customer (
c_custkey int,
c_name string,
c_address string,
c_nationkey int,
c_phone string,
c_acctbal double,
c_mktsegment string,
c_comment string
)
ROW FORMAT SERDE
'org.apache.hadoop.hive.serde2.OpenCSVSerde'
STORED AS INPUTFORMAT
'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
's3://emr-workshops-us-west-2/athena_federation_workshop/data/s10/customer';

CREATE EXTERNAL TABLE Orders (
o_orderkey int,
o_custkey int,
o_orderstatus string,
o_totalprice double,
o_orderdate string,
o_orderpriority string,
o_clerk string,
o_shippriority int,
o_comment string
)
ROW FORMAT SERDE
'org.apache.hadoop.hive.serde2.OpenCSVSerde'
STORED AS INPUTFORMAT
'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
's3://emr-workshops-us-west-2/athena_federation_workshop/data/s10/orders';

create external table lineitem
(
id int,
l_orderkey int,
l_partkey int,
l_suppkey int,
l_linenumber int,
l_quantity int,
l_extendedprice double,
l_discount double,
l_tax double,
l_returnflag string,
l_linestats string,
l_shipdate string,
l_commitdate string,
l_receiptdate string,
l_shipinstruct string,
l_shipmode string,
l_comment string
)
ROW FORMAT SERDE
'org.apache.hadoop.hive.serde2.OpenCSVSerde'
STORED AS INPUTFORMAT
'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
's3://emr-workshops-us-west-2/athena_federation_workshop/data/s10/lineitem';

set hive.execution.engine=tez;
set hive.auto.convert.join=true;
set hive.auto.convert.join.noconditionaltask=true;
set hive.auto.convert.join.noconditionaltask.size=405306368;
set hive.vectorized.execution.enabled=true;
set hive.vectorized.execution.reduce.enabled =true;
set hive.cbo.enable=true;
set hive.compute.query.using.stats=true;
set hive.stats.fetch.column.stats=true;
set hive.stats.fetch.partition.stats=true;
set hive.merge.mapfiles =true;
set hive.merge.mapredfiles=true;
set hive.merge.size.per.task=134217728;
set hive.merge.smallfiles.avgsize=44739242;
set mapreduce.job.reduce.slowstart.completedmaps=0.8;

