# 构建
```shell
cd /path/to/dockerfile_pack
docker build -t cat:1.0 .
```

# 运行

```shell
export DATA_DIR=/path/to/your/dataset
export CODE_DIR=/path/to/your/code
docker run --gpus all -it -v ${DATA_DIR}:/data -v ${CODE_DIR}:/code mmdet
```

```shell
export DATA_DIR=/root/xfwang/data_hdd/xfwang_data
export CODE_DIR=/root/xfwang/code
export WORK_DIR=/root/xfwang
docker run --name mycat --ipc=host --gpus all -it -v ${DATA_DIR}:/data -v ${CODE_DIR}:/code -v ${WORK_DIR}:/workspace -p 9909:8888 -p 8422:22 cat:1.0

```


