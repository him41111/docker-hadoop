DOCKER_NETWORK = docker-hadoop_default
ENV_FILE = hadoop.env
current_branch := latest
build:
	docker build -t him411/hadoop-base:$(current_branch) ./base
	docker build -t him411/hadoop-namenode:$(current_branch) ./namenode
	docker build -t him411/hadoop-datanode:$(current_branch) ./datanode
	docker build -t him411/hadoop-resourcemanager:$(current_branch) ./resourcemanager
	docker build -t him411/hadoop-nodemanager:$(current_branch) ./nodemanager
	docker build -t him411/hadoop-historyserver:$(current_branch) ./historyserver
	docker build -t him411/hadoop-submit:$(current_branch) ./submit

wordcount:
	docker build -t hadoop-wordcount ./submit
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} him411/hadoop-base:$(current_branch) hdfs dfs -mkdir -p /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} him411/hadoop-base:$(current_branch) hdfs dfs -copyFromLocal -f /opt/hadoop-3.4.0/README.txt /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} him411/hadoop-base:$(current_branch) hdfs dfs -cat /output/*
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} him411/hadoop-base:$(current_branch) hdfs dfs -rm -r /output
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} him411/hadoop-base:$(current_branch) hdfs dfs -rm -r /input
