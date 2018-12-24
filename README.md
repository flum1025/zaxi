Zaxi
===

Monitor ESXi S.M.A.R.T Statuses with Zabbix.
Fetch S.M.A.R.T Statuses via a VMware vSphere API.

Usage
---

```
$ vi docker-compose.yml # Set your environment
$ docker-compose up
```

Environment
---

### `ESXI_HOST`

This variable is IP or DNS name of ESXi server.

### `ESXI_USER`, `ESXI_PASSWORD`

This variable are used to connect ESXi server.

### `ZABBIX_API_URL`

This variable is URL of Zabbix jsonrpc.

### `ZABBIX_API_USER`, `ZABBIX_API_PASSWORD`

This variable are used to connect Zabbix server.

### `ZABBIX_SENDER_HOST`

This variable is IP or DNS name of Zabbix server. It can use with Zabbix Proxy.

### `ZABBIX_SENDER_PORT`

This variable is port of Zabbix server or proxy.

### `ZABBIX_ESXI_HOST`

This variable is ESXi host of Zabbix monitoring item.

Behavior
---

1. Get root ESXi host from vSphere API.
2. Get host_id of Zabbix monitoring item.
3. Get or Create Zabbix application. `storage.smart`
4. Get storage devices of ESXi host
5. Get S.M.A.R.T Statuses
6. Get or Create Zabbix item.   
  `storage.smart[{{ device }},{{ smart_item_name }},{{ /Threashold|Value|Worst/ }}]`  
  ex. `storage.smart[t10.ATA_____DEVICE____________________________DEVICE,driver_rated_max_temperature,threshold]	`
7. Send measurement data to Zabbix
