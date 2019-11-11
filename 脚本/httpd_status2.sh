#!/bin/bash 
#网站url地址
#
URL=$1
#获取http响应代码 
HTTP_CODE=`curl -o /dev/null -s -w "%{http_code}" "${URL}"`
#服务器能正常响应，应该返回200的代码 
if [ $HTTP_CODE != 200 ];then 
    echo $HTTP_CODE
    ((a=$HTTP_CODE/10))
    echo $a
#这里可以报警处理
    exit $a
else
    exit 0
fi
