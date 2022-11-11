<div align="center">

# OlivOS-OneKey

用于部署 [OlivOS](https://github.com/OlivOS-Team/OlivOS) 异步机器人框架的Linux快速部署脚本<br>

<img src="https://img.shields.io/github/issues/rhwong/OlivOS-OneKey"> <img src="https://img.shields.io/github/forks/rhwong/OlivOS-OneKey"> 
<img src="https://img.shields.io/github/stars/rhwong/OlivOS-OneKey"> <img src="https://img.shields.io/github/license/rhwong/OlivOS-OneKey">

注意：本项目仅用于快速部署 [OlivOS](https://github.com/OlivOS-Team/OlivOS) 本体，后续对接何种前端(如[Go-cqhtp](https://github.com/Mrs4s/go-cqhttp/))取决您自己的选择，这些部分并不包含在部署范围内，请参考[官方论坛](https://forum.olivos.run/)。

注意：本脚本仅在以下发行版经过测试

<img src="https://img.shields.io/badge/Ubuntu-x86__64-red?style=flat-square&logo=ubuntu"> 
<img src="https://img.shields.io/badge/Ubuntu-aarch64-red?style=flat-square&logo=ubuntu"> 
<img src="https://img.shields.io/badge/CentOS-x86__64-green?style=flat-square&logo=centos">
<!--img src="https://img.shields.io/badge/CentOS-aarch64-green?style=flat-square&logo=centos"-->
<img src="https://img.shields.io/badge/Debian-x86__64-purple?style=flat-square&logo=debian">
<!--img src="https://img.shields.io/badge/Debian-aarch64-purple?style=flat-square&logo=debian"-->

其他发行版及类型系统如果出现问题请提交issue！

</div>
<!-- projectInfo end -->

## 快速启动

### 安装

```shell
wget -N https://ghproxy.com/https://github.com/rhwong/OlivOS-OneKey/raw/main/install_OlivOS.sh
chmod -R 755 install_OlivOS.sh
./install_OlivOS.sh
```

也可以这样启动安装脚本 `./install_OlivOS.sh -s` 

使用 `-s` 参数可以跳过所有确认步骤使用conda安装方式安装。

#### 【注意事项】

由于conda在加入环境变量后，脚本会退出运行。此时必须重新连接到终端以生效，此时请务必断开ssh，重新连接终端。

重新连接后提示符前面出现 `(base)` ，例如 `(base) root@ecs:~# ` 这样的显示就是conda成功安装了。

在成功安装conda之后，我们需要重新运行一次脚本：

```shell
conda activate OlivOS
./install_OlivOS.sh
```

键入 `conda activate OlivOS` 用于激活Conda中刚刚创建的OlivOS环境，键入 `./install_OlivOS.sh` 用于重新运行脚本以继续安装。

### 启动

依次输入如下指令来启动OlivOS，此后也如此。

```shell
conda activate OlivOS
cd $HOME/OlivOS
python3 main.py
```
确认调试无误后可以用screen后台运行，没有screen请自行安装，Ubuntu使用 `sudo apt-get -y install screen` CentOS使用`yum -y install screen`。

```shell
screen -dmS OlivOS conda activate OlivOS && cd $HOME/OlivOS && python3 main.py
```
使用以下命令可以恢复screen窗口

```shell
screen -r OlivOS
```
### 更新和修复

重复安装步骤，按照原本的安装方式选择即可。检测到已存在OlivOS目录时，脚本会自动拉取代码并更新依赖。