# gitbackup

将数据定时增量备份到 git 远程仓库。

## 使用

假设在 `/var/www/data` 目录下有 `dir1`、`dir2`、`dir3` 这几个目录，需要分别被分到 `github.com/yourname/dir1`、`gitlab.com/yourname/dir2`、`gitee.com/yourname/dir3` 仓库中，用以下命令配置。

```bash
mkdir -p config/
cat << EOF > config/map.txt
dir1  github.com/yourname/dir1
dir2  gitlab.com/yourname/dir2
dir3  gitee.com/yourname/dir3
EOF
```

配置完成后启动 Docker 容器，默认每天凌晨 2 点备份一次。

```bash
docker run -itd --restart \
-v /var/www/data:/data \
-v $(pwd)/config:/config \
--name gitbackup \
wqyjh/gitbackup
```

如果需要手动指定备份频率与时机，可以通过 CRON 环境变量指定，例如 `CRON=0   4    *   *   *` 指定每天凌晨 4 点备份。

```bash
docker run -itd --restart \
-v /var/www/data:/data \
-v $(pwd)/config:/config \
-e "CRON=0   4    *   *   *" \
--name gitbackup \
wqyjh/gitbackup
```

## 手动构建镜像

有需要的话，可以自行修改并构建镜像。

```bash
docker build --build-arg MIRROR=mirrors.tuna.tsinghua.edu.cn . -t wqyjh/gitbackup
```
