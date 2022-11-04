#!/bin/bash

# =================================================
#	Description: OlivOS-OneKey
#	Version: 1.0.3
#	Author: RHWong
# =================================================

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Warrning="${Red_font_prefix}[警告]${Font_color_suffix}"
Tip="${Green_font_prefix}[提示]${Font_color_suffix}"
ret_code=`curl -o /dev/null --connect-timeout 3 -s -w %{http_code} https://google.com`
conda_path=$HOME/miniconda3

function waiting()
{
    i=0
    while [ $i -le 100 ]
    do
    for j in '\\' '|' '/' '-'
    do
    printf "\t%c%c%c%c%c ${Info} 少女祈祷中... %c%c%c%c%c\r" \
    "$j" "$j" "$j" "$j" "$j" "$j" "$j" "$j" "$j" "$j"
    sleep 0.1
    done
    let i=i+4
    done
}

# 检测本机内核版
check_sys(){
    if [[ -f /etc/redhat-release ]]; then
        release="centos"
    elif cat /etc/issue | grep -q -E -i "Debian"; then
        release="debian"
    elif cat /etc/issue | grep -q -E -i "Ubuntu"; then
        release="Ubuntu"
    elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
        release="centos"
    elif cat /proc/version | grep -q -E -i "Debian"; then
        release="Debian"
    elif cat /proc/version | grep -q -E -i "Ubuntu"; then
        release="Ubuntu"
    elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
        release="centos"
    # 如果是未知系统版本则输出unknown
    else
        release="unknown"
    fi
    bit=`uname -m`
}

# 如果不是x86_64则返回警告
anti_bit(){
    if [[ ${bit} == "x86_64" ]]; then
        echo -e "${Info} 系统类型为 ${Green_font_prefix}[${bit}]${Font_color_suffix}，开始安装..."
    else
        echo -e "${Warrning} OlivOS官方不推荐使用${Red_font_prefix}[${bit}]${Font_color_suffix}进行部署!"
        echo -e "${Warrning} 本脚本可以运行在${Red_font_prefix}[${bit}]${Font_color_suffix}上，但未经验证，可能会出现未知错误。"
        # 继续运行请按Y
            read -p "是否继续运行？[Y/n]:" yn
            if [[ $yn == [Yy] ]]; then
            echo -e "${Info} 继续运行..."
            else
            exit 1
            fi
    fi

}

# 判断${release}使用不同方式安装wget和git
install_wget_git(){
    if [[ ${release} == "centos" ]]; then
        yum install -y wget git
    elif [[ ${release} == "debian" || ${release} == "Ubuntu" ]]; then
        apt-get update
        apt-get install -y wget git
    elif [[ ${release} == "unknown" ]]; then
        echo -e "${Error} 未知系统版本，若无法继续运行请自行安装wget和git"
        sleep 3
    fi
}

# 检测是否存在conda
check_conda(){
    # conda命令可用，跳过安装
    if [ -x "$(command -v conda)" ]; then
        echo -e "${Info} 检测到已存在conda，跳过安装"
        sleep 2
    else
        echo -e "${Info} 检测到未安装conda，开始安装"
        # 删除conda目录
        if [ -d "$conda_path" ]; then
            echo -e "${Info} 检测到已存在conda目录，正在删除..."
            rm -rf $conda_path
        fi
        echo -e "${Warrning} 注意，在安装中可能会有提示需要你点击enter键或输入yes，请按照屏幕上的提示输入！"
        sleep 2
        # 按下enter继续
        read -p "按下enter键继续..."
    # conda安装
    # 判断系统是否为Ubuntu
         if [ -x "$(command -v apt)" ]; then
        echo -e "${Tip} 正在尝试安装conda..."
        sleep 2
        apt install -y wget
        # 下载安装包
            if [[ ${bit} == "x86_64" ]]; then
                wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
            elif [[ ${bit} == "aarch64" ]]; then
                wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-aarch64.sh -O miniconda.sh
            elif [[ ${bit} == "armv7l" ]]; then
                wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-armv7l.sh -O miniconda.sh
            elif [[ ${bit} == "i686" ]]; then
                wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86.sh -O miniconda.sh
            elif [[ ${bit} == "ppc64le" ]]; then
                wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-ppc64le.sh -O miniconda.sh
            elif [[ ${bit} == "s390x" ]]; then
                wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-s390x.sh -O miniconda.sh
            elif [[ ${bit} == "i386" ]]; then
                wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86.sh -O miniconda.sh
            else
                echo -e "${Error} 本脚本不支持${Red_font_prefix}[${bit}]${Font_color_suffix}系统！"
                exit 1
            fi
        bash miniconda.sh
        echo -e "${Info} conda安装结束！"
        else
    # 使用yum安装conda
        echo -e "${Tip} 正在尝试安装conda..."
        yum install -y wget
    # 下载安装包
            if [[ ${bit} == "x86_64" ]]; then
                wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
            elif [[ ${bit} == "aarch64" ]]; then
                wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-aarch64.sh -O miniconda.sh
            elif [[ ${bit} == "armv7l" ]]; then
                wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-armv7l.sh -O miniconda.sh
            elif [[ ${bit} == "i686" ]]; then
                wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86.sh -O miniconda.sh
            elif [[ ${bit} == "ppc64le" ]]; then
                wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-ppc64le.sh -O miniconda.sh
            elif [[ ${bit} == "s390x" ]]; then
                wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-s390x.sh -O miniconda.sh
            elif [[ ${bit} == "i386" ]]; then
                wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86.sh -O miniconda.sh
            else
                echo -e "${Error} 本脚本不支持${Red_font_prefix}[${bit}]${Font_color_suffix}系统！"
                exit 1
            fi
        bash miniconda.sh
        echo -e "${Info} conda安装结束！"
        sleep 2
        fi
    add_conda_path
    source /etc/profile
    check_conda_install
    fi
}

# 检测conda安装是否成功
check_conda_install(){
    if [ -x "$(command -v conda)" ]; then
        echo -e "${Info} conda安装成功！"
        sleep 2
    else
        echo -e "${Error} conda安装失败，请手动安装conda"
        exit 1
    fi
}

# 将conda加入环境变量
add_conda_path(){
    echo -e "${Tip} 正在将conda加入环境变量..."
    echo "export PATH=$conda_path/bin:$PATH" >> /etc/profile
    source /etc/profile
    echo -e "${Info} conda加入环境变量完成！"
}

# 检测本地python版本
check_python()
{
    local python_version=`python3 -V 2>&1 | awk '{print $2}'`
    # 如果版本大于3.7，小于3.8
    if [ "$python_version" \> "3.7.0" ] && [ "$python_version" \< "3.10.99" ]; then
        echo -e "${Info} 本地python版本为$python_version，符合要求！"
        sleep 2
    else
    # 如果版本小于3.7，大于3.9
        if [ "$python_version" \< "3.6.99" ] || [ "$python_version" \> "3.11.0" ]; then
            echo -e "${Error} 本地python版本为$python_version，不符合要求！"
            echo -e "${Tip} 请安装python3.7~3.10！"
            exit 1
        else
            # 尝试安装python

            # 判断系统是否为Ubuntu
             if [ -x "$(command -v apt)" ]; then
                echo -e "${Tip} 正在尝试安装python3.8..."
                apt install -y python3.8
            else
            # 使用yum安装python3.8
                echo -e "${Tip} 正在尝试使用yum安装python3.8..."
                yum install -y python3.8
            fi
            echo -e "${Info} python3.8安装完成！"
            sleep 2 
            
        fi

    fi
}

# 检测是否安装pip
check_pip()
{
    if [ -x "$(command -v pip3)" ]; then
        # 升级pip
         python3 -m pip install --upgrade pip
         echo -e "${Info} pip已更新！"
         sleep 2
    else
        echo -e "${Error} pip未安装！"
        # 尝试安装pip 
        echo -e "${Tip} 正在尝试安装pip..."
        sleep 2
            # 判断系统是否为Ubuntu
             if [ -x "$(command -v apt)" ]; then
                apt install -y python3-pip
                echo -e "${Info} pip安装完成！"
            else
            # 使用yum安装pip
                yum install -y python3-pip
                echo -e "${Info} pip安装完成！"
            fi

        if [ -x "$(command -v pip3)" ]; then
            echo -e "${Info} pip安装成功！"
            sleep 2
        else
            echo -e "${Error} pip安装失败，请自行安装！"
            exit 1
        fi
    fi
}

# 安装OlivOS
install_OlivOS()
{
    cd $HOME
    # 判断OlivOS目录下main.py是否存在  
if [ ! -f "OlivOS/main.py" ]; then
    echo -e "${Info} OlivOS主文件不存在，开始安装..."
    sleep 2
    # 如果ret_code变量值是200
    if [ $ret_code -eq 200]; then
        echo -e "${Info} 网络连接正常，开始下载OlivOS..."
        git clone https://github.com/OlivOS-Team/OlivOS.git & waiting
    else 
    # 如果ret_code变量值不是200，使用镜像下载
        echo -e "${Info} 网络连接异常，开始使用镜像下载OlivOS..."
        git clone https://ghproxy.com/https://github.com/OlivOS-Team/OlivOS.git & waiting
    fi
    echo -e "${Tip} OlivOS下载完成！"
    sleep 2
else
    echo -e "${Info} OlivOS文件已存在，无需安装！"
    sleep 2
    # 更新OlivOS
    echo -e "${Tip} 正在更新OlivOS..."
    sleep 2
    git pull & waiting
    echo -e "${Tip} OlivOS更新完成！"
    sleep 2
fi
}

# 安装或修复依赖
install_dependence()
{
    echo -e "${Info} 开始安装或修复依赖..."
    sleep 2
    cd $HOME/OlivOS
    if [ $ret_code -eq 200 ]; then
        echo -e "${Info} 网络连通性良好，使用默认镜像下载"
        pip3 install --upgrade pip
        pip3 install --upgrade pip -r requirements.txt
    else
        echo -e "${Info} 网络连通性不佳，使用腾讯镜像下载"
        pip3 install --upgrade pip -i https://mirrors.cloud.tencent.com/pypi/simple/
        pip3 install --upgrade pip -r requirements.txt -i https://mirrors.cloud.tencent.com/pypi/simple
    fi
    echo -e "${Tip} 依赖安装或修复完成！"
    sleep 2
}

StartOlivOS()
{
# 启动OlivOS
    echo -e "${Tip} 开始安装OlivOS..." 
    check_sys
    anti_bit
    select_install
}

# 本地安装  
install_local(){
    install_wget_git
    check_python
    check_pip
    install_OlivOS
    chmod -R 766 $HOME/OlivOS
    cd $HOME/OlivOS
    install_dependence
    echo -e "${Tip} OlivOS安装完成！"
    sleep 2
    echo -e "${Tip} 开始尝试运行，如有问题请提交issue"
    python3 main.py
    # 打印安装位置
    echo -e "${Tip} OlivOS安装位置：$HOME/OlivOS"
    # 打印OlivOS启动指令
    echo -e "启动指令如下："
    echo -e "${Green_font_prefix}cd $HOME/OlivOS && python3 main.py${Font_color_suffix}"
}

# conda安装
install_conda(){
    install_wget_git
    check_conda
    # 判断OlivOS环境是否已经存在
    if [ -d "$conda_path/envs/OlivOS" ]; then
        echo -e "${Info} OlivOS环境已存在，跳过部署！"
    else
        echo -e "${Info} OlivOS环境不存在，开始部署..."
        conda init bash
        conda create -n OlivOS python=3.8
        conda activate OlivOS
        echo -e "${Info} OlivOS环境部署完成！请重新连接到终端，使用${Green_font_prefix}conda activate OlivOS${Font_color_suffix}指令来激活OlivOS环境"
        exit 1
    fi
    echo -e "${Tip} 正在安装OlivOS..."
    sleep 2
    install_OlivOS
    chmod -R 766 $HOME/OlivOS
    cd $HOME/OlivOS
    install_dependence
    echo -e "${Tip} OlivOS安装完成！"
    sleep 2
    echo -e "${Tip} 开始尝试运行，如有问题请提交issue"
    python3 main.py
    # 打印安装位置
    echo -e "${Tip} OlivOS安装位置：$HOME/OlivOS"
#    打印OlivOS启动指令
    echo -e "启动指令如下："
    echo -e "${Green_font_prefix}cd $HOME/OlivOS && conda activate OlivOS && python3 main.py${Font_color_suffix}"
}


# 提示选择在本地安装还是在conda安装
select_install(){
    echo -e "${Info} 请选择安装方式"
    echo -e "1. 本地安装"
    echo -e "2. conda虚拟环境安装(推荐)"
    read -p "请输入数字:" num
    case "$num" in
        1)
        install_local
        ;;
        2)
        install_conda
        ;;
        *)
        echo -e "${Error} 请输入正确的数字"
        exit 1
        ;;
    esac
}


StartOlivOS



