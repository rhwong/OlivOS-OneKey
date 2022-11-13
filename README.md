<div align="center">
    <img alt="OOOK" src="https://olivos.onekey.ren/img/logo.png"/>

# OlivOS-OneKey

用于部署 [OlivOS](https://github.com/OlivOS-Team/OlivOS) 异步机器人框架的Linux快速部署脚本<br>

<img src="https://img.shields.io/github/issues/rhwong/OlivOS-OneKey"> <img src="https://img.shields.io/github/forks/rhwong/OlivOS-OneKey"> 
<img src="https://img.shields.io/github/stars/rhwong/OlivOS-OneKey"> <img src="https://img.shields.io/github/license/rhwong/OlivOS-OneKey">

注意：本项目仅用于快速部署 [OlivOS](https://github.com/OlivOS-Team/OlivOS) 框架和官方基础插件，后续对接何种前端(如[Go-cqhtp](https://github.com/Mrs4s/go-cqhttp/))取决您自己的选择，这些部分并不包含在部署范围内，请参考[官方论坛](https://forum.olivos.run/)。

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
wget -N https://gitee.com/Rhwong/OlivOS-OneKey/raw/main/install_OlivOS.sh
chmod -R 755 install_OlivOS.sh
./install_OlivOS.sh
```

也可以这样启动安装脚本 `./install_OlivOS.sh -s` 

使用 `-s` 参数可以跳过所有确认步骤使用conda安装方式安装。

### 启动

#### Conda 安装时

```
# 前台运行
cd $HOME/OlivOS && $HOME/miniconda3/envs/OlivOS/bin/python3 main.py
# Screen 后台运行
screen -dmS OlivOS cd $HOME/OlivOS && $HOME/miniconda3/envs/OlivOS/bin/python3 main.py
```
#### 本地安装时
```
# 前台运行
cd $HOME/OlivOS && python3 main.py
# Screen 后台运行
screen -dmS OlivOS cd $HOME/OlivOS && python3 main.py
```

没有screen请自行安装，Ubuntu使用 `sudo apt-get -y install screen` CentOS使用`yum -y install screen`。

使用以下命令可以恢复screen窗口

```shell
screen -r OlivOS
```
### 更新和修复

重复安装步骤，按照原本的安装方式选择即可。检测到已存在OlivOS目录时，脚本会自动拉取代码并更新依赖。