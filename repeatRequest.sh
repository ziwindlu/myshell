#!/bin/bash

# repeate exec curl with some times

# 定义要执行的 curl 命令、次数和命令名称的 JSON 配置数组
curl_config=(
  '{"times": 3,
	"cmd": "some crul cmd",
	"cmdName": "Command 1"}'

  # '{"times": 3,
	# "cmd": "some crul cmd",
	# "cmdName": "Command 1"}'

  # '{"times": 3,
	# "cmd": "some crul cmd",
	# "cmdName": "Command 1"}'

)

# 创建一个函数，用于执行 curl 命令并输出返回值和执行次数
execute_curl() {
  cmd=$1
  cmd_name=$2
  result=$(eval "$cmd")
  echo "Command Name: $cmd_name"
  echo "Result: $result"
  echo "Executed Times: $executed_times"
  echo "------------------------"
}

# 使用循环遍历 curl 配置数组
for config in "${curl_config[@]}"
do
  # 解析 JSON 配置中的 times、cmd 和 cmdName 字段
  times=$(echo "$config" | jq -r '.times')
  cmd=$(echo "$config" | jq -r '.cmd')
  cmd_name=$(echo "$config" | jq -r '.cmdName')

  # 执行指定次数的 curl 命令
  for ((executed_times=1; executed_times<=$times; executed_times++))
  do
    execute_curl "$cmd" "$cmd_name" &
  done
done

# 等待所有后台任务完成
wait
