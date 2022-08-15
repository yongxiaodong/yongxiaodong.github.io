

```

import hashlib

m1 = hashlib.md5('yongxiaodong'.encode('utf-8'))
res = m1.hexdigest()

print(res)

```