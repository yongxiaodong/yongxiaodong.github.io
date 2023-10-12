
## For Python

```
# coding:utf-8
import sys
import json
import time,datetime
from elasticsearch import Elasticsearch
from elasticsearch.helpers import bulk
from elasticsearch import helpers
import time

# example
# python es_transfer.py '{"es_source":"192.168.11.75:9200","es_target":"192.168.11.9:9920","source_index":"new_articles","target_index":"new_articles"}'

start_time = time.time()
data = sys.argv[1]
data = json.loads(data)
source_str = data['es_source']
target_str = data['es_target']
source_index = data['source_index']
target_index = data['target_index']
# auth
username = 'elastic'
password = ''
es_source = Elasticsearch(source_str,timeout=500)
es_target = Elasticsearch(target_str,http_auth=f"{username}:{password}", timeout=500)
print('from ' + source_str + '\\' + source_index + ' to ' + target_str + '\\' + target_index)
#build index
mapping = es_source.indices.get_mapping(index=source_index)
mapping = mapping[source_index]['mappings']['_doc']
try:
    # ----导入对应index的mapping（不需要可以注释）----
    es_target.indices.create(index=target_index)
    es_target.indices.put_mapping(index=target_index,doc_type='_doc',body=mapping)
    #es_target.indices.put_mapping(index=target_index,doc_type=source_index,body=mapping)
    print("put mapping finish.")
    #  ----end----
    body = {"query":{"match_all":{}}}
    #body = {"size":10000,"query":{"terms":{"record_uid":["1165829"]}}}
    #body = {"query":{"match_all":{}},"sort":[{"tkPaidTime":{"order":"desc"}}]}
    #body = {"query":{"bool":{"filter":[{"term":{"subsidyType":"饿了么"}},{"term":{"type":1}}]}}}
    print(body)
    data = helpers.reindex(client=es_source,source_index=source_index,target_index=target_index,target_client=es_target,query=body,chunk_size=5000, scroll='15m')
    print('import finish')
    print(time.time() - start_time)
except Exception as e:
    print(e)
    #if str(e) == "RequestError(400, 'index_already_exists_exception', 'already exists')":
    #    print("index already exists")
    #    body={"query":{"match_all":{}}}
    #    helpers.reindex(client=es_source,source_index=source_index,target_index=target_index,target_client=es_target,query=body,chunk_size=5000, scroll='15m')
    #    print('import finish')
```