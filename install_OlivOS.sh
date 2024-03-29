#!/bin/bash

# =================================================
#	Description: OlivOS-OneKey
#	Version: 1.2.3
#	Author: RHWong
# =================================================

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Warrning="${Red_font_prefix}[警告]${Font_color_suffix}"
Tip="${Green_font_prefix}[提示]${Font_color_suffix}"
ret_code=`curl -o /dev/null --connect-timeout 3 -s -w %{http_code} https://google.com`
conda_path=$HOME/miniconda3
OlivOS_path=$HOME/OlivOS
Ver=v1.2.3

    if [ $ret_code -eq 200 ] || [ $ret_code -eq 301 ]; then
        miniconda_url=https://repo.anaconda.com/miniconda
    else
        miniconda_url=https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda
    fi
            


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

    # 检测本机内核发行版
    check_sys(){
        if [[ -f /etc/redhat-release ]]; then
            release="Centos"
        elif cat /etc/issue | grep -q -E -i "Debian"; then
            release="Debian"
        elif cat /etc/issue | grep -q -E -i "Ubuntu"; then
            release="Ubuntu"
        elif cat /etc/issue | grep -q -E -i "Centos|red hat|redhat"; then
            release="Centos"
        elif cat /proc/version | grep -q -E -i "Debian"; then
            release="Debian"
        elif cat /proc/version | grep -q -E -i "Ubuntu"; then
            release="Ubuntu"
        elif cat /proc/version | grep -q -E -i "Centos|red hat|redhat"; then
            release="Centos"
        # 如果是未知系统版本则输出unknown
        else
            release="unknown"
        fi
        bit=`uname -m`
    }

    # 如果不是x86_64则返回警告
    anti_bit(){
        if [[ ${bit} == "x86_64" ]]; then
            print_release_bit
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
        if [[ ${release} == "Centos" ]]; then
            yum install -y wget git
        elif [[ ${release} == "Ubuntu" ]]; then
            sudo apt update
            sudo apt install -y wget git
        elif [[ ${release} == "Debian" ]]; then
            apt update
            apt install -y wget git
        elif [[ ${release} == "unknown" ]]; then
            echo -e "${Error} 未知系统版本，若无法继续运行请自行安装wget和git"
            sleep 3
        fi
    }

    # 打印release和bit
        # 如果是Centos则返回警告
    print_release_bit(){
            echo -e "${Info} 当前系统为 ${Green_font_prefix}[${release}]${Font_color_suffix} ${Green_font_prefix}[${bit}]${Font_color_suffix}"
    }

    # 安装conda
    check_conda(){
        if [ -d "$conda_path" ]; then
            echo -e "${Info} 检测到已存在conda目录，跳过安装，如果需要重新安装，请先删除conda目录！"
            sleep 2
        else
            echo -e "${Info} 检测到未安装conda，开始安装"
        # conda安装
            # 下载安装包
                if [[ ${bit} == "x86_64" ]]; then
                    wget ${miniconda_url}/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
                elif [[ ${bit} == "aarch64" ]]; then
                    wget ${miniconda_url}/Miniconda3-latest-Linux-aarch64.sh -O miniconda.sh
                elif [[ ${bit} == "armv7l" ]]; then
                    wget ${miniconda_url}/Miniconda3-latest-Linux-armv7l.sh -O miniconda.sh
                elif [[ ${bit} == "i686" ]]; then
                    wget ${miniconda_url}/Miniconda3-latest-Linux-x86.sh -O miniconda.sh
                elif [[ ${bit} == "ppc64le" ]]; then
                    wget ${miniconda_url}/Miniconda3-latest-Linux-ppc64le.sh -O miniconda.sh
                elif [[ ${bit} == "s390x" ]]; then
                    wget ${miniconda_url}/Miniconda3-latest-Linux-s390x.sh -O miniconda.sh
                elif [[ ${bit} == "i386" ]]; then
                    wget ${miniconda_url}/Miniconda3-latest-Linux-x86.sh -O miniconda.sh
                else
                    echo -e "${Error} miniconda不支持${Red_font_prefix}[${bit}]${Font_color_suffix}系统！"
                    exit 1
                fi
            bash miniconda.sh -b
            echo -e "${Info} conda安装结束！"
            sleep 2
        check_conda_install
        fi
    }

    # 检测conda安装是否成功
    check_conda_install(){
        if [ -n "$($conda_path/bin/conda -V)" ]; then
            echo -e "${Info} conda安装成功！"
            sleep 2
        else
            echo -e "${Error} conda安装失败，请检查日志输出！"
            exit 1
        fi
    }

    create_conda_env(){
        # 判断OlivOS环境是否已经存在
        if [ -d "$conda_path/envs/OlivOS" ]; then
            echo -e "${Info} OlivOS环境已存在，跳过部署！"
            sleep 2
        else
            echo -e "${Info} OlivOS环境不存在，开始部署..."
            sleep 2
            echo y | $conda_path/bin/conda create -n OlivOS python=3.10
            $conda_path/bin/conda activate OlivOS
            echo -e "${Info} OlivOS环境部署完成！"
        fi
    }

    # 检测本地python版本
    check_python()
    {
        local py_v_1=`python -V 2>&1|awk '{print $2}'|awk -F '.' '{print $1}'`
        local py_v_2=`python -V 2>&1|awk '{print $2}'|awk -F '.' '{print $2}'`
        local python_version=`python -V 2>&1 | awk '{print $2}'`
        # 如果版本大于3.8，小于3.10
        if [[ ${py_v_1} -eq 3 && ${py_v_2} -ge 8 && ${py_v_2} -lt 10 ]]; then
            echo -e "${Info} 检测到本地python版本为${Green_font_prefix}[${python_version}]${Font_color_suffix}，符合要求！"
            sleep 2
        # 如果版本小于3.8
        elif [[ ${py_v_1} -eq 3 && ${py_v_2} -lt 8 ]]; then
            echo -e "${Error} 检测到本地python版本为${Red_font_prefix}[${python_version}]${Font_color_suffix}，小于3.8，不符合要求！"
            exit 1  
        # 如果版本大于3.10
        elif [[ ${py_v_1} -eq 3 && ${py_v_2} -gt 10 ]]; then
            echo -e "${Error} 检测到本地python版本为${Red_font_prefix}[${python_version}]${Font_color_suffix}"
            echo -e "${Tip} OlivOS目前仅支持python3.8-3.10，如果你的python版本大于3.10，可能会出现未知错误！"
                # 询问是否继续，输入y继续，输入n退出
                read -p "是否继续？[y/n]:" yn
                if [[ $yn == [Yy] ]]; then
                echo -e "${Info} 继续运行..."
                else
                echo -e "${Info} 退出运行！"
                exit 1
                fi
        # 如果安装的是python2
        elif [[ ${py_v_1} -eq 2 ]]; then
            echo -e "${Error} 检测到本地python版本为${Red_font_prefix}[${python_version}]${Font_color_suffix}，你的战术是现代的,构思却相当古老。你究竟是什么人？！"
            exit 1
        else
            # 没有python
                echo -e "${Error} 本地没有安装python！"
                echo -e "${Tip} 请先手动安装python3.8~3.10，或重新运行脚本使用conda安装"
                exit 1
            
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
                # 尝试安装python
                echo -e "${Tip} 正在尝试使用yum安装pip3..."
                if [[ ${release} == "Centos" ]]; then
                    yum install -y python3-pip
                elif [[ ${release} == "Ubuntu" ]]; then
                    sudo apt install -y python3-pip
                elif [[ ${release} == "Debian" ]]; then
                    apt install -y python3-pip
                elif [[ ${release} == "unknown" ]]; then
                    echo -e "${Error} 未知系统版本，请自行安装pip3！"
                    sleep 3
                    exit 1
                fi
                echo -e "${Info} pip3安装结束！"
                sleep 2

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
            git clone https://mirror.ghproxy.com/https://github.com/OlivOS-Team/OlivOS.git & waiting
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
        cd $OlivOS_path
        if [ $ret_code -eq 200 ]; then
            echo -e "${Info} 网络连通性良好，使用默认镜像下载"
            pip3 install --upgrade pip
        else
            echo -e "${Info} 网络连通性不佳，使用腾讯镜像下载"
            pip3 install --upgrade pip -i https://mirrors.cloud.tencent.com/pypi/simple/
        fi
        # 搜索目录下的所有requirements.txt文件并逐个安装
        for file in $(find . -name "requirements.txt")
        do
            if [ $ret_code -eq 200 ]; then
                echo -e "${Info} 正在安装${file}中的依赖..."
                sleep 1
                pip3 install --upgrade pip -r $file
                echo -e "${Tip} ${file}中的依赖安装完成！"
                sleep 1
            else
                echo -e "${Info} 正在安装${file}中的依赖..."
                sleep 1
                pip3 install --upgrade pip -r $file -i https://mirrors.cloud.tencent.com/pypi/simple
                echo -e "${Tip} ${file}中的依赖安装完成！"
                sleep 1
            fi
        done
        echo -e "${Tip} 所有依赖安装或修复完成！"
        sleep 2
        }

    # 为conda环境安装或修复依赖
    install_conda_dependence()
    {
        echo -e "${Info} 开始安装或修复依赖..."
        sleep 2
        cd $OlivOS_path
        if [ $ret_code -eq 200 ]; then
            echo -e "${Info} 网络连通性良好，使用默认镜像下载"
            $conda_path/envs/OlivOS/bin/pip3 install --upgrade pip
        else
            echo -e "${Info} 网络连通性不佳，使用腾讯镜像下载"
            $conda_path/envs/OlivOS/bin/pip3 install --upgrade pip -i https://mirrors.cloud.tencent.com/pypi/simple/
        fi
         # 搜索目录下的所有requirements.txt文件并逐个安装
        for file in $(find . -name "requirements.txt")
        do
            if [ $ret_code -eq 200 ]; then
                echo -e "${Info} 正在安装${file}中的依赖..."
                sleep 1
                $conda_path/envs/OlivOS/bin/pip3 install --upgrade pip -r $file
                echo -e "${Tip} ${file}中的依赖安装完成！"
                sleep 1
            else
                echo -e "${Info} 正在安装${file}中的依赖..."
                sleep 1
                $conda_path/envs/OlivOS/bin/pip3 install --upgrade pip -r $file -i https://mirrors.cloud.tencent.com/pypi/simple
                echo -e "${Tip} ${file}中的依赖安装完成！"
                sleep 1
            fi
        done
        echo -e "${Tip} 依赖安装或修复完成！"
        sleep 2
    }


    # 下载默认插件
    download_default_plugin()
    {
        echo -e "${Info} 开始下载默认插件..."
        sleep 2
        cd $OlivOS_path/plugin/app
            echo -e "${Info} 下载OlivaDiceCore..."
            sleep 1
            wget -P $OlivOS_path/plugin/app/ https://mirror.ghproxy.com/https://github.com/OlivOS-Team/OlivaDiceCore/releases/latest/download/OlivaDiceCore.opk -N
            echo -e "${Info} 下载OlivaDiceJoe..."
            sleep 1
            wget $OlivOS_path/plugin/app/ https://mirror.ghproxy.com/https://github.com/OlivOS-Team/OlivaDiceJoy/releases/latest/download/OlivaDiceJoy.opk -N
            echo -e "${Info} 下载OlivaDiceLogger..."
            sleep 1
            wget $OlivOS_path/plugin/app/ https://mirror.ghproxy.com/https://github.com/OlivOS-Team/OlivaDiceLogger/releases/latest/download/OlivaDiceLogger.opk -N
            echo -e "${Info} 下载OlivaDiceMaster..."
            sleep 1
            wget $OlivOS_path/plugin/app/ https://mirror.ghproxy.com/https://github.com/OlivOS-Team/OlivaDiceMaster/releases/latest/download/OlivaDiceMaster.opk -N
            echo -e "${Info} 下载ChanceCustom..."
            sleep 1
            wget $OlivOS_path/plugin/app/ https://mirror.ghproxy.com/https://github.com/OlivOS-Team/ChanceCustom/releases/latest/download/ChanceCustom.opk -N
            echo -e "${Info} 下载OlivaDiceOdyssey..."
            sleep 1
            wget $OlivOS_path/plugin/app/ https://mirror.ghproxy.com/https://github.com/OlivOS-Team/OlivaDiceOdyssey/releases/latest/download/OlivaDiceOdyssey.opk -N

        echo -e "${Tip} 默认插件下载完成！"
    }

    # 删除miniconda
    remove_miniconda(){
        if [ -d "$conda_path" ]; then
            # 提示是否删除conda
            echo -e "${Tip} 是否删除miniconda？"
            # 继续运行请按Y
            read -p "是否继续运行？[Y/n]" confirm
            if [ $confirm == "Y" ] || [ $confirm == "y" ]; then
                echo -e "${Info} 开始删除miniconda..."
                sleep 2
                rm -rf $conda_path
                echo -e "${Tip} miniconda删除成功！"
                sleep 2
                # 检测是否删除成功
                if [ -d "$conda_path" ]; then
                    echo -e "${Error} 删除失败！"
                    exit 1
                else
                    echo -e "${Tip} 删除成功！"
                fi
            else
                echo -e "${Tip} 取消删除miniconda！"
                sleep 2
            fi
        # 未找到目录
        else
            echo -e "${Info} 未检测到conda目录"
        fi
    }

    # 删除OlivOS
    remove_OlivOS(){
        # 警告
        echo -e "${Warrning} 卸载OlivOS会${Red_font_prefix}完全删除${Font_color_suffix}所有数据，且${Red_font_prefix}无法恢复${Font_color_suffix}！"
        echo -e "${Warrning} 请确保你已经备份好需要保留的数据！"
        # 继续运行请按Y
            read -p "是否继续运行？[Y/n]:" yn
            if [[ $yn == [Yy] ]]; then
            echo -e "${Info} 继续运行..."
            else
            exit 1
            fi
        if [ -d "$OlivOS_path" ]; then
            echo -e "${Info} 检测到已存在OlivOS目录，正在删除..."
            rm -rf $OlivOS_path
        # 未找到目录
        else
            echo -e "${Info} 未检测到OlivOS目录"
        fi
        # 检测是否删除成功
        if [ -d "$OlivOS_path" ]; then
            echo -e "${Error} 删除失败！"
            exit 1
        else
            echo -e "${Tip} 删除成功！"
        fi
    }

    # 卸载
    uninstall(){
        echo -e "${Info} 开始卸载..."
        sleep 2
        remove_miniconda
        remove_OlivOS
        echo -e "${Tip} 卸载完成！"
        sleep 2
    }

    StartOlivOS()
    {
    # 启动OlivOS
        echo -e "·····························"
        echo -e "···____···____···____··_··__·"
        echo -e "··/·__·\·/·__·\·/·__·\|·|/·/·"
        echo -e "·|·|··|·|·|··|·|·|··|·|·'·/··"
        echo -e "·|·|··|·|·|··|·|·|··|·|· <···"
        echo -e "·|·|__|·|·|__|·|·|__|·|·.·\··"
        echo -e "··\____/·\____/·\____/|_|\_\·"
        echo -e "·····························"
        echo -e "${Red_font_prefix}---OlivOS-OneKey ${Ver} by OlivOS-Team---${Font_color_suffix}"
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
        chmod -R 766 $OlivOS_path
        cd $OlivOS_path
        install_dependence
        download_default_plugin
        echo -e "${Tip} OlivOS安装完成！"
        sleep 2
        echo -e "${Tip} 开始尝试运行，如有问题请提交issue"
        cd $OlivOS_path && python3 main.py
        # 打印安装位置
        echo -e "${Tip} OlivOS安装位置：$OlivOS_path"
        # 打印OlivOS启动指令
        echo -e "启动指令如下："
        echo -e "${Green_font_prefix}cd $OlivOS_path && python3 main.py${Font_color_suffix}"
        echo -e "如果需要后台运行，请使用:"
        echo -e "${Green_font_prefix}cd $OlivOS_path && screen -dmS OlivOS python3 main.py${Font_color_suffix}"
    }

    # conda安装
    install_conda(){
        install_wget_git
        check_conda
        create_conda_env
        echo -e "${Tip} 正在安装OlivOS..."
        sleep 2
        install_OlivOS
        chmod -R 766 $OlivOS_path
        install_conda_dependence
        download_default_plugin
        echo -e "${Tip} OlivOS安装完成！"
        sleep 2
        echo -e "${Tip} 开始尝试运行，如有问题请提交issue"
        cd $OlivOS_path && $conda_path/envs/OlivOS/bin/python3 main.py
        # 打印安装位置
        echo -e "${Tip} OlivOS安装位置：$OlivOS_path"
    #    打印OlivOS启动指令
        echo -e "启动指令如下："
        echo -e "${Green_font_prefix}cd $OlivOS_path && $conda_path/envs/OlivOS/bin/python3 main.py${Font_color_suffix}"
        echo -e "如果需要后台运行，请使用:"
        echo -e "${Green_font_prefix}cd $OlivOS_path && screen -dmS OlivOS $conda_path/envs/OlivOS/bin/python3 main.py${Font_color_suffix}"
    }


    # 静默conda安装
    silent_start(){
        check_sys
        print_release_bit
        install_wget_git
        check_conda
        create_conda_env
        echo -e "${Tip} 正在安装OlivOS..."
        sleep 2
        install_OlivOS
        chmod -R 766 $OlivOS_path
        install_conda_dependence
        download_default_plugin
        echo -e "${Tip} OlivOS安装完成！"
        sleep 2
        echo -e "${Tip} 开始尝试运行，如有问题请提交issue"
        cd $OlivOS_path && $conda_path/envs/OlivOS/bin/python3 main.py
        # 打印安装位置
        echo -e "${Tip} OlivOS安装位置：$OlivOS_path"
    #    打印OlivOS启动指令
        echo -e "启动指令如下："
        echo -e "${Green_font_prefix}cd $OlivOS_path && $conda_path/envs/OlivOS/bin/python3 main.py${Font_color_suffix}"
        echo -e "如果需要后台运行，请使用:"
        echo -e "${Green_font_prefix}cd $OlivOS_path && screen -dmS OlivOS $conda_path/envs/OlivOS/bin/python3 main.py${Font_color_suffix}"
    }

    # 提示选择在本地安装还是在conda安装
    select_install(){
        echo -e "${Info} 请选择安装方式"
        echo -e "1. conda虚拟环境安装(推荐)"
        echo -e "2. 本地安装"
        echo -e "3. conda安装(清洁模式)"
        echo -e "4. 卸载"
        read -p "请输入数字:" num
        case "$num" in
            1)
            install_conda
            ;;
            2)
            install_local
            ;;
            3)
            uninstall
            install_conda
            ;;
            4)
            uninstall
            ;;
            *)
            echo -e "${Error} 请输入正确的数字"
            exit 1
            ;;
        esac
    }
    # 判断脚本运行时是否包含-s参数，如果有则跳过确认步骤
    if [[ $1 == "-s" ]]; then
        silent_start
    else
        StartOlivOS
    fi
