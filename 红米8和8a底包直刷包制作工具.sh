#本工具依赖于Termux。
#工具制作By rm-rf/*
  cd ~
  if [ ! -d /sdcard/工作目录 ];then
  mkdir /sdcard/工作目录
  mkdir /sdcard/工作目录/未完成
  mkdir /sdcard/工作目录/未完成/底包
  mkdir /sdcard/工作目录/未完成/直刷包
  mkdir /sdcard/工作目录/已完成
  mkdir /sdcard/工作目录/已完成/底包
  mkdir /sdcard/工作目录/已完成/直刷包
  fi
  
  echo "\033[32m
****************************************************
***欢迎使用红米8/8a底包&直刷包制作工具v1.5****
***作者:rm-rf/****
***作者QQ:3586563103****
***注意！本工具依赖于Termux****
*****************************************************\033[0m"
  echo "制作选项:
         1.制作底包&直刷包
         2.修改system（要root）
         3.修改vendor（要root）
         "
  read -p "请选择: " xz
#制作底包&直刷包
if [ $xz = '1' ];then
  echo "正在初始化……"
  
  read -p "初始化需要挂t，是否继续？(y/n): " Initialization
  
  if [ $Initialization = 'y' ];then
  pkg install git python brotli e2fsprogs zip -y
  git clone https://github.com/yi985432/python
  else
  if [ $Initialization = "n" ];then
  echo "\033[31m已取消\033[0m" 
  exit
  fi
  pkg install git python brotli e2fsprogs zip -y
  git clone https://github.com/yi985432/python
  fi
  
  if [ ! -d /sdcard/工作目录/未完成/底包/META-INF ];then
  cp -r ~/python/底包/* /sdcard/工作目录/未完成/底包
  fi
  
  if [ ! -d /sdcard/工作目录/未完成/直刷包/META-INF ];then
  cp -r ~/python/直刷包/* /sdcard/工作目录/未完成/直刷包
  fi
   
   
  echo "\033[32m
初始化已完成！
   \033[0m"
   read -p "请将raw格式的boot.img、vendor.img放到/sdcard/工作目录/未完成/底包，system.img放到/sdcard/工作目录/未完成/直刷包里，是否继续？(y/n): " make
   
   if [ $make = 'y' ];then
   echo "正在制作底包"   
   if [ ! -f /sdcard/工作目录/未完成/底包/vendor.img ];then
   echo "\033[31m底包制作失败！请确认是否已把boot.img、vendor.img移动到/sdcard/工作目录/未完成/底包文件夹里。\033[0m"
   exit
   fi
   read -p "请输入底包vendor的大小（8:1536M，8A:1024M 不用带单位，或者按回车使用默认大小:1024M）: " vsize
   if [ $vsize ];then
   e2fsck -fy /sdcard/工作目录/未完成/底包/vendor.img
   resize2fs -f /sdcard/工作目录/未完成/底包/vendor.img ${vsize}m
   else
   e2fsck -fy /sdcard/工作目录/未完成/底包/vendor.img
   resize2fs -f /sdcard/工作目录/未完成/底包/vendor.img 1024m
   fi
   read -p "如需定制刷入文字请修改未完成/底包里的updater-script文件，按任意键继续: " db
   read -p "请输入底包包名（不带后缀）: " vcompression
   if [ $vcompression ];then
   echo "正在压缩底包"
   cd /sdcard/工作目录/未完成/底包
   zip -r /sdcard/工作目录/已完成/底包/$vcompression.zip ./*
   else
   echo "正在压缩底包"
   cd /sdcard/工作目录/未完成/底包
   zip -r /sdcard/工作目录/已完成/底包/我的底包.zip ./*
   fi
   echo "\033[32m底包制作完成！\033[0m"
   cd ~
   echo "正在制作直刷包"   
   if [ ! -f /sdcard/工作目录/未完成/直刷包/system.img ];then
   echo "\033[31m直刷包制作失败！请确认是否已把system.img移动到/sdcard/工作目录/未完成/直刷包文件夹里。\033[0m"
   exit
   fi
   read -p "请输入直刷包system的大小（8:4608M，8A:4096M 不用带单位，或者按回车使用默认大小:4096M）: " ssize
   if [ $ssize ];then
   e2fsck -fy /sdcard/工作目录/未完成/直刷包/system.img
   resize2fs -f /sdcard/工作目录/未完成/直刷包/system.img ${ssize}m
   else
   e2fsck -fy /sdcard/工作目录/未完成/直刷包/system.img
   resize2fs -f /sdcard/工作目录/未完成/直刷包/system.img 4096m
   fi
   read -p "如需定制刷入文字请修改未完成/直刷包里的updater-script文件，按任意键继续: " zsb
   echo "正在转换为dat"
   python ~/python/rimg2sdat.py /sdcard/工作目录/未完成/直刷包/system.img -o /sdcard/工作目录/未完成/直刷包 -v 4
   if [ ! -f /sdcard/工作目录/未完成/直刷包/system.new.dat ];then
   echo "\033[31m转换dat失败！\033[0m"
   exit
   fi
   echo "\033[32m转换完成！\033[0m"
   echo "正在转换为br"
   read -p "请选择br的压缩级别（ 0-11 数字越大br体积越小，压缩时间更长，或者按回车使用默认等级压缩:0）: " ysdj
   if [ $ysdj ];then
   brotli -q $ysdj /sdcard/工作目录/未完成/直刷包/system.new.dat -o /sdcard/工作目录/未完成/直刷包/system.new.dat.br
   else
   brotli -q 0 /sdcard/工作目录/未完成/直刷包/system.new.dat -o /sdcard/工作目录/未完成/直刷包/system.new.dat.br
   fi
   if [ ! -f /sdcard/工作目录/未完成/直刷包/system.new.dat.br ];then
   echo "\033[31m转换br失败！\033[0m"
   exit
   fi
   echo "\033[32mbr转换完成！\033[0m"
   rm -rf /sdcard/工作目录/未完成/直刷包/system.new.dat
   rm -rf /sdcard/工作目录/未完成/直刷包/system.img
   touch /sdcard/工作目录/未完成/直刷包/system.patch.dat
   read -p "请输入直刷包包名（不带后缀）: " scompression
   if [ $scompression ];then
   echo "正在压缩直刷包"
   cd /sdcard/工作目录/未完成/直刷包
   zip -r /sdcard/工作目录/已完成/直刷包/$scompression.zip ./*
   else
   echo "正在压缩直刷包"
   cd /sdcard/工作目录/未完成/直刷包
   zip -r /sdcard/工作目录/已完成/直刷包/我的直刷包.zip ./*
   fi
   echo "\033[32m直刷包已制作完成！\033[0m"
   cd ~
   else
   if [ $make = "n" ];then
   echo "\033[31m已取消\033[0m"  
   exit
   fi
   echo "正在制作底包"   
   if [ ! -f /sdcard/工作目录/未完成/底包/vendor.img ];then
   echo "\033[31m底包制作失败！请确认是否已把boot.img、vendor.img移动到/sdcard/工作目录/未完成/底包文件夹里。\033[0m"
   exit
   fi
   read -p "请输入底包vendor的大小（8:1536M，8A:1024M 不用带单位，或者按回车使用默认大小:1024M）: " vsize
   if [ $vsize ];then
   e2fsck -fy /sdcard/工作目录/未完成/底包/vendor.img
   resize2fs -f /sdcard/工作目录/未完成/底包/vendor.img ${vsize}m
   else
   e2fsck -fy /sdcard/工作目录/未完成/底包/vendor.img
   resize2fs -f /sdcard/工作目录/未完成/底包/vendor.img 1024m
   fi
   read -p "如需定制刷入文字请修改未完成/底包里的updater-script文件，按任意键继续: " db
   read -p "请输入底包包名（不带后缀）: " vcompression
   if [ $vcompression ];then
   echo "正在压缩底包"
   cd /sdcard/工作目录/未完成/底包
   zip -r /sdcard/工作目录/已完成/底包/$vcompression.zip ./*
   else
   echo "正在压缩底包"
   cd /sdcard/工作目录/未完成/底包
   zip -r /sdcard/工作目录/已完成/底包/我的底包.zip ./*
   fi
   echo "\033[32m底包制作完成！\033[0m"
   cd ~
   echo "正在制作直刷包"
   if [ ! -f /sdcard/工作目录/未完成/直刷包/system.img ];then
   echo "\033[31m直刷包制作失败！请确认是否已把system.img移动到/sdcard/工作目录/未完成/直刷包文件夹里。\033[0m"
   exit
   fi
   echo "正在制作直刷包"
   read -p "请输入直刷包system的大小（8:4608M，8A:4096M 不用带单位，或者按回车使用默认大小:4096M）: " ssize
   if [ $ssize ];then
   e2fsck -fy /sdcard/工作目录/未完成/直刷包/system.img
   resize2fs -f /sdcard/工作目录/未完成/直刷包/system.img ${ssize}m
   else
   e2fsck -fy /sdcard/工作目录/未完成/直刷包/system.img
   resize2fs -f /sdcard/工作目录/未完成/直刷包/system.img 4096m
   fi
   read -p "如需定制刷入文字请修改未完成/直刷包里的updater-script文件，按任意键继续: " zsb
   echo "正在转换为dat"
   python ~/python/rimg2sdat.py /sdcard/工作目录/未完成/直刷包/system.img -o /sdcard/工作目录/未完成/直刷包 -v 4
   if [ ! -f /sdcard/工作目录/未完成/直刷包/system.new.dat ];then
   echo "\033[31m转换dat失败！\033[0m"
   exit
   fi
   echo "\033[32m转换完成！\033[0m"
   echo "正在转换为br"
   read -p "请选择br的压缩级别（ 0-11 数字越大br体积越小，压缩时间更长，或者按回车使用默认等级压缩:0）: " ysdj
   if [ $ysdj ];then
   brotli -q $ysdj /sdcard/工作目录/未完成/直刷包/system.new.dat -o /sdcard/工作目录/未完成/直刷包/system.new.dat.br
   else
   brotli -q 0 /sdcard/工作目录/未完成/直刷包/system.new.dat -o /sdcard/工作目录/未完成/直刷包/system.new.dat.br
   fi
   if [ ! -f /sdcard/工作目录/未完成/直刷包/system.new.dat.br ];then
   echo "\033[31m转换br失败！\033[0m"
   exit
   fi
   echo "\033[32mbr转换完成！\033[0m"
   rm -rf /sdcard/工作目录/未完成/直刷包/system.new.dat
   rm -rf /sdcard/工作目录/未完成/直刷包/system.img
   touch /sdcard/工作目录/未完成/直刷包/system.patch.dat
   read -p "请输入直刷包包名（不带后缀）: " scompression
   if [ $scompression ];then
   echo "正在压缩直刷包"
   cd /sdcard/工作目录/未完成/直刷包
   zip -r /sdcard/工作目录/已完成/直刷包/$scompression.zip ./*
   else
   echo "正在压缩直刷包"
   cd /sdcard/工作目录/未完成/直刷包
   zip -r /sdcard/工作目录/已完成/直刷包/我的直刷包.zip ./*
   fi
   echo "\033[32m直刷包已制作完成！\033[0m"
   cd ~
   fi
   read -p "底包和直刷包已制作完成，是否把包移到/sdcard并删除工作目录？(y/n): " rm
   if [ $rm = "y" ];then
   mv /sdcard/工作目录/已完成/底包/*.zip /sdcard
   mv /sdcard/工作目录/已完成/直刷包/*.zip /sdcard
   rm -rf /sdcard/工作目录
   else
   if [ $rm = "n" ];then
   echo "\033[32m不删除\033[0m"  
   exit
   fi
   mv /sdcard/工作目录/已完成/底包/*.zip /sdcard
   mv /sdcard/工作目录/已完成/直刷包/*.zip /sdcard
   rm -rf /sdcard/工作目录
   fi
fi

#修改system
if [ $xz = '2' ];then
   read -p "是否修改system.img?(y/n): " system
   if [ $system = 'y' ];then
   read -p "请将raw格式的boot.img、vendor.img放到/sdcard/工作目录/未完成/底包，system.img放到/sdcard/工作目录/未完成/直刷包里，按任意键继续: " me
   echo "\033[33m请在面具》设置》挂载命名空间模式选择全局命名空间，否则挂载了看不见里面的文件(如果是第一次设置请关闭一次Termux再打开重新执行一下脚本)。\033[0m"
   read -p "按任意键继续" xg
   su - oracle -c mount -o remount -rw /
   su - oracle -c mkdir /工作目录 /工作目录/system
   su - oracle -c losetup /dev/block/loop5 /sdcard/工作目录/未完成/直刷包/system.img
   su - oracle -c mount /dev/block/loop5 /工作目录/system
   echo "\033[32msystem.img已挂载到根目录/工作目录/system里，请自行修改\033[0m"
   read -p "如果修改完成了请按任意键继续（2-1）" xg
   read -p "如果真的修改完成了请再按一下继续（2-2）" xg
   su - oracle -c umount /工作目录/system
   su - oracle -c rm -rf /工作目录
   echo "\033[32m修改已完成！\033[0m"   
   else
   if [ $system = 'n' ];then
   echo "\033[31m不修改\033[0m"
   exit
   fi
   read -p "请将raw格式的boot.img、vendor.img放到/sdcard/工作目录/未完成/底包，system.img放到/sdcard/工作目录/未完成/直刷包里，按任意键继续: " me
   echo "\033[33m请在面具》设置》挂载命名空间模式选择全局命名空间，否则挂载了看不见里面的文件(如果是第一次设置请关闭一次Termux再打开重新执行一下脚本)。\033[0m"
   read -p "按任意键继续" xg
   su - oracle -c mount -o remount -rw /
   su - oracle -c mkdir /工作目录 /工作目录/system
   su - oracle -c losetup /dev/block/loop5 /sdcard/工作目录/未完成/直刷包/system.img
   su - oracle -c mount /dev/block/loop5 /工作目录/system
   echo "\033[32msystem.img已挂载到根目录/工作目录/system里，请自行修改\033[0m"
   read -p "如果修改完成了请按任意键继续（2-1）" xg
   read -p "如果真的修改完成了请再按一下继续（2-2）" xg
   su - oracle -c umount /工作目录/system
   su - oracle -c rm -rf /工作目录
   echo "\033[32m修改已完成！\033[0m"   
   fi
fi

#修改vendor
if [ $xz = '3' ];then
   read -p "是否修改vendor.img？(y/n): " vendor
   if [ $vendor = 'y' ];then
   read -p "请将raw格式的boot.img、vendor.img放到/sdcard/工作目录/未完成/底包，system.img放到/sdcard/工作目录/未完成/直刷包里，按任意键继续: " me   
   echo "\033[33m请在面具》设置》挂载命名空间模式选择全局命名空间，否则挂载了看不见里面的文件(如果是第一次设置请关闭一次Termux再打开重新执行一下脚本)。\033[0m"
   read -p "按任意键继续" xg
   su - oracle -c mount -o remount -rw /
   su - oracle -c mkdir /工作目录 /工作目录/vendor
   su - oracle -c losetup /dev/block/loop4 /sdcard/工作目录/未完成/底包/vendor.img
   su - oracle -c mount /dev/block/loop4 /工作目录/vendor
   echo "\033[32mvendor.img已挂载到根目录/工作目录/vendor里，请自行修改\033[0m"
   read -p "如果修改完成了请按任意键继续（2-1）" xg
   read -p "如果真的修改完成了请再按一下继续（2-2）" xg
   su - oracle -c umount /工作目录/vendor
   su - oracle -c rm -rf /工作目录
   echo "\033[32m修改已完成！\033[0m"
   else
   if [ $vendor = 'n' ];then
   echo "\033[31m不修改\033[0m"
   exit
   fi
   read -p "请将raw格式的boot.img、vendor.img放到/sdcard/工作目录/未完成/底包，system.img放到/sdcard/工作目录/未完成/直刷包里，按任意键继续: " me   
   echo "\033[33m请在面具》设置》挂载命名空间模式选择全局命名空间，否则挂载了看不见里面的文件(如果是第一次设置请关闭一次Termux再打开重新执行一下脚本)。\033[0m"
   read -p "按任意键继续" xg
   su - oracle -c mount -o remount -rw /
   su - oracle -c mkdir /工作目录 /工作目录/vendor
   su - oracle -c losetup /dev/block/loop4 /sdcard/工作目录/未完成/底包/vendor.img
   su - oracle -c mount /dev/block/loop4 /工作目录/vendor
   echo "\033[32mvendor.img已挂载到根目录/工作目录/vendor里，请自行修改\033[0m"
   read -p "如果修改完成了请按任意键继续（2-1）" xg
   read -p "如果真的修改完成了请再按一下继续（2-2）" xg
   su - oracle -c umount /工作目录/vendor
   su - oracle -c rm -rf /工作目录
   echo "\033[32m修改已完成！\033[0m"
   fi
fi