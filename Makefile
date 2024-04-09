DOCKER_NETWORK = docker-hadoop_default
ENV_FILE = hadoop.env
current_branch := latest
build:
	docker build -t registry.cn-guangzhou.aliyuncs.com/123acc/hadoop-base:3.4.0 ./base
	docker build -t registry.cn-guangzhou.aliyuncs.com/123acc/hadoop-namenode:$(current_branch) ./namenode
	docker build -t registry.cn-guangzhou.aliyuncs.com/123acc/hadoop-datanode:$(current_branch) ./datanode
	docker build -t registry.cn-guangzhou.aliyuncs.com/123acc/hadoop-resourcemanager:$(current_branch) ./resourcemanager
	docker build -t registry.cn-guangzhou.aliyuncs.com/123acc/hadoop-nodemanager:$(current_branch) ./nodemanager
	docker build -t registry.cn-guangzhou.aliyuncs.com/123acc/hadoop-historyserver:$(current_branch) ./historyserver
	docker build -t registry.cn-guangzhou.aliyuncs.com/123acc/hadoop-submit:$(current_branch) ./submit

wordcount:
	docker build -t hadoop-wordcount ./submit
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} registry.cn-guangzhou.aliyuncs.com/123acc/hadoop-base:3.4.0 hdfs dfs -mkdir -p /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} registry.cn-guangzhou.aliyuncs.com/123acc/hadoop-base:3.4.0 hdfs dfs -copyFromLocal -f /opt/hadoop-3.4.0/README.txt /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} registry.cn-guangzhou.aliyuncs.com/123acc/hadoop-base:3.4.0 hdfs dfs -cat /output/*
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} registry.cn-guangzhou.aliyuncs.com/123acc/hadoop-base:3.4.0 hdfs dfs -rm -r /output
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} registry.cn-guangzhou.aliyuncs.com/123acc/hadoop-base:3.4.0 hdfs dfs -rm -r /input
