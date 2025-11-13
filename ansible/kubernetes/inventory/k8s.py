#!/usr/bin/env python3
import json
import subprocess
import itertools


tf_out = subprocess.run(
    ["terraform", "output", "-json"],
    capture_output=True,
    text=True,
    check=True,
    cwd="../../terraform"
)

outputs = json.loads(tf_out.stdout)


hosts = outputs["k8-ips"]["value"]
hosts = itertools.chain.from_iterable(hosts)
hosts = itertools.chain.from_iterable(hosts)
hosts = filter(lambda x: x != '127.0.0.1', hosts)

out = {"all":{"hosts":list(hosts)}}
print(json.dumps(out))

# z = filter(lambda x: x[0] != '127.0.0.1', hosts)
# # print(list(z)[0][0])

# out = {"all":{"hosts":[list(z)[0][0]]}}
# print(json.dumps(out))

# inventory = {
#     "all": {"hosts": hosts},
#     "_meta": {"hostvars": {ip: {"ansible_user": "ubuntu"} for ip in hosts}}
# }

# print(json.dumps(inventory))