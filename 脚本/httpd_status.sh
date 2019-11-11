#!/bin/bash
#
website[0]=server0.example.com' #网站1
mobile[0]='13554436733'　#对应网站1 手机号码
website[1]=server0.example.com' #同上2
mobile[1]='13141200000'  #同上2
#当网站较多时，可以考虑以文件来存储，或从数据库中读取
length=${#website[@]}   #获取网站总数量
for ((i=0; i<$length; i++)) #循环执行
do
   status=$(curl -I -m 10 -o /dev/null -s -w %{http_code} ${website[$i]})   #CURL 获取http状态码
   if [ "$status"x != "200"x ]; then      #检测是否为 200(正常)
    echo ${website[$i]} '=>' $status  
    #php /htdoc/jk/shell_monitor.php ${mobile[$i]} ${website[$i]}'=>AccessError!'  #执行PHP文件(采用第三方短信类库，或发送报警邮件)
   fi #结束if
done #结束 do
