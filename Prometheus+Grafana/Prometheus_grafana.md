
## 安装Prometheus

```
mkdir -p /usr/local/prometheus
cd !$
wget https://github-production-release-asset-2e65be.s3.amazonaws.com/6838921/88308200-b7b7-11ea-826b-4c99718171b7?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20200701%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20200701T013729Z&X-Amz-Expires=300&X-Amz-Signature=184dd8769f1e3c9d170f1dcc35754e48ee4e6936d106e5cabc17ec75eb63f74a&X-Amz-SignedHeaders=host&actor_id=23717585&repo_id=6838921&response-content-disposition=attachment%3B%20filename%3Dprometheus-2.19.2.linux-amd64.tar.gz&response-content-type=application%2Foctet-stream
tar xf prometheus-2.19.2.linux-amd64.tar.gz 
mv prometheus-2.19.2.linux-amd64 prometheus

```

## 安装grafana

```
wget https://dl.grafana.com/oss/release/grafana-7.0.5.linux-amd64.tar.gz
mv grafana-7.0.5 grafana
```
## 