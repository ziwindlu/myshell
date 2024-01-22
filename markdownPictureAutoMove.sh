#!/bin/bash

# 将markdown中的图片从原来的路径迁移到规范的路径
file_path=$1
store_dir=`realpath ~/markdownImg`
n=$2
n=${n:-0}  # 如果用户没有输入n，则设置默认值为0

if ! [[ -f $file_path ]]; then
		echo "$file_path 不存在"
		exit 1
fi


function getPicturePath(){
# 解析markdown文件，获取图片路径并存入数组
image_remote_paths=()
image_local_paths=()
while IFS= read -r line; do
		if [[ $line =~ ^\!(\[.*\])\((.+)\) ]]; then
				image_path="${BASH_REMATCH[2]}"
				if ! [[ $image_path =~ ^(http:\/\/|https:\/\/).* ]]; then
						image_local_paths+=("$image_path")
				else
						image_remote_paths+=("$image_path")
				fi
		fi
done < "$file_path"

}

function getParentPath(){
text=$1
level=$2
level=${level:-0}
levelReverse=`echo $text | grep -o \/ | wc -l`
realLevel=$((levelReverse-$level))
if test $realLevel -lt 0 ;then
		export n=0
		echo ""
else 
		regex="^\/([^\/]+\/){$realLevel}(.+)"
		if [[ $text =~ $regex ]] ; then
				echo ${BASH_REMATCH[2]}
		fi
fi
}

getPicturePath
if [[  ${#image_local_paths[@]} -eq 0 ]]; then
		echo "nothing do"
		echo "file include remote pictures:"
		for i in ${image_remote_paths[@]};do
				echo $i
		done
		exit 0
fi

# 获取输入文件的path
real_path=`realpath "$file_path"`
path=`dirname $real_path`
# 根据这个paht获取其父目录
store_path=`getParentPath "$path" $n`
# 到达目标目录
# 复制文件时防止文件存放在相对目录
cd $path
# echo $store_path
# 获取文件的名字
if [[  `basename $file_path` =~ (.*)\.md ]] ;then
		file_name=${BASH_REMATCH[1]}
fi

# 指定目录用于存放移动后的图片
if [[ $n -eq 0 ]]; then
		store_dir=$store_dir/$file_name
else
		store_dir=$store_dir/$store_path/$file_name
fi

# 创建目标目录
mkdir -p "$store_dir"

# 遍历图片路径数组，将图片移动到指定目录
for image_path in "${image_local_paths[@]}"; do
		image_name=$(basename "$image_path")
		mv "$image_path" "$store_dir/$image_name"
		if [ $? -eq 0 ]; then
				echo "移动图片 $image_name 到 $store_dir 成功"
				# 更新markdown文件中的图片路径
				sed -i "s|$image_path|$store_dir/$image_name|g" "$file_path"
		else
				echo "移动图片 $image_name 到 $store_dir 失败"
		fi
done

echo "图片移动和路径更新完成"
if ! [[ ${#image_remote_paths[@]} -eq 0 ]]; then
		echo "已经在远程托管的图片有"
		for i in ${image_remote_paths[@]};do
				echo $i
		done
fi
