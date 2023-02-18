#!/bin/bash

# =================================================
#	Description: OlivOS-OneKey-slim
#	Version: 1.2.3-dev
#	Author: RHWong
# =================================================

author="OlivOS-Team RHWong"
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Warrning="${Red_font_prefix}[警告]${Font_color_suffix}"
Tip="${Green_font_prefix}[提示]${Font_color_suffix}"

ret_code=`curl -o /dev/null --connect-timeout 3 -s -w %{http_code} https://google.com`
project_path=$HOME/OlivOS
project_name=OlivOS
main_file=main.py
py_ver=3.9
min_py_ver=8
max_py_ver=10
Ver=v1.2.3-dev


    # 检测本地python版本
    check_python()
    {
        local py_v_1=`python -V 2>&1|awk '{print $2}'|awk -F '.' '{print $1}'`
        local py_v_2=`python -V 2>&1|awk '{print $2}'|awk -F '.' '{print $2}'`
        local python_version=`python -V 2>&1 | awk '{print $2}'`
        # 如果版本大于等于3.8，小于等于3.10
        if [[ ${py_v_1} -eq 3 && ${py_v_2} -ge ${min_py_ver} && ${py_v_2} -le ${max_py_ver} ]]; then
            echo -e "${Info} 检测到本地python版本为${Green_font_prefix}[${python_version}]${Font_color_suffix}，符合要求！"
            sleep 2
        # 如果版本小于3.8
        elif [[ ${py_v_1} -eq 3 && ${py_v_2} -lt ${min_py_ver} ]]; then
            echo -e "${Error} 检测到本地python版本为${Red_font_prefix}[${python_version}]${Font_color_suffix}，小于3.${min_py_ver}，不符合要求！"
            exit 1  
        # 如果版本大于3.10
        elif [[ ${py_v_1} -eq 3 && ${py_v_2} -gt ${max_py_ver} ]]; then
            echo -e "${Error} 检测到本地python版本为${Red_font_prefix}[${python_version}]${Font_color_suffix}"
            echo -e "${Tip} ${project_name}目前仅支持python3.${min_py_ver}-3.${max_py_ver}，如果你的python版本大于3.${max_py_ver}，可能会出现未知错误！"
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
                echo -e "${Tip} 请先手动安装python3.${min_py_ver}~3.${max_py_ver}，或重新运行脚本使用conda安装"
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
    # 安装项目
    install_project()
    {
        cd $HOME
        # 判断项目目录下主要程序是否存在  
    if [ ! -f "${project_name}/${main_file}" ]; then
        echo -e "${Info} ${project_name}主文件不存在，开始安装..."
        sleep 2
        # 如果ret_code变量值是200
        if [ $ret_code -eq 200]; then
            echo -e "${Info} 网络连接正常，开始下载${project_name}..."
            git clone https://github.com/OlivOS-Team/OlivOS.git
        else 
        # 如果ret_code变量值不是200，使用镜像下载
            echo -e "${Info} 网络连接异常，开始使用镜像下载${project_name}..."
            git clone https://ghproxy.com/https://github.com/OlivOS-Team/OlivOS.git
        fi
        echo -e "${Tip} ${project_name}下载完成！"
        sleep 2
    else
        echo -e "${Info} ${project_name}文件已存在，无需安装！"
        sleep 2
        # 更新项目文件
        echo -e "${Tip} 正在更新${project_name}..."
        sleep 2
        cd ${project_path}
        git pull
        echo -e "${Tip} ${project_name}更新完成！"
        sleep 2
    fi
    }


    # 安装或修复依赖
    install_dependence()
    {
        echo -e "${Info} 开始安装或修复依赖..."
        sleep 2
        local py_v_2=`python -V 2>&1|awk '{print $2}'|awk -F '.' '{print $2}'`
        cd ${project_path}
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
                # 如果python版本大于3.10
                # if [ $py_v_2 -gt 10 ]; then
                #     pip3 install --upgrade pip -r requirements310.txt
                # else
                    pip3 install --upgrade pip -r ${file}
                # fi
                echo -e "${Tip} ${file}中的依赖安装完成！"
                sleep 1
            else
                echo -e "${Info} 正在安装${file}中的依赖..."
                sleep 1
                # 如果python版本大于3.10
                # if [ $py_v_2 -gt 10 ]; then
                #     pip3 install --upgrade pip -r requirements310.txt -i https://mirrors.cloud.tencent.com/pypi/simple/
                # else
                    pip3 install --upgrade pip -r ${file} -i https://mirrors.cloud.tencent.com/pypi/simple/
                # fi
                echo -e "${Tip} ${file}中的依赖安装完成！"
                sleep 1
            fi
        done
        echo -e "${Tip} 所有依赖安装或修复完成！"
        sleep 2
        }


    # 下载默认插件
    download_default_plugin()
    {
        echo -e "${Info} 开始下载默认插件..."
        sleep 2
        cd ${project_path}/plugin/app
            echo -e "${Info} 下载OlivaDiceCore..."
            sleep 1
            wget -P ${project_path}/plugin/app/ https://ghproxy.com/https://github.com/OlivOS-Team/OlivaDiceCore/releases/latest/download/OlivaDiceCore.opk -N
            echo -e "${Info} 下载OlivaDiceJoe..."
            sleep 1
            wget ${project_path}/plugin/app/ https://ghproxy.com/https://github.com/OlivOS-Team/OlivaDiceJoy/releases/latest/download/OlivaDiceJoy.opk -N
            echo -e "${Info} 下载OlivaDiceLogger..."
            sleep 1
            wget ${project_path}/plugin/app/ https://ghproxy.com/https://github.com/OlivOS-Team/OlivaDiceLogger/releases/latest/download/OlivaDiceLogger.opk -N
            echo -e "${Info} 下载OlivaDiceMaster..."
            sleep 1
            wget ${project_path}/plugin/app/ https://ghproxy.com/https://github.com/OlivOS-Team/OlivaDiceMaster/releases/latest/download/OlivaDiceMaster.opk -N
            echo -e "${Info} 下载ChanceCustom..."
            sleep 1
            wget ${project_path}/plugin/app/ https://ghproxy.com/https://github.com/OlivOS-Team/ChanceCustom/releases/latest/download/ChanceCustom.opk -N
            echo -e "${Info} 下载OlivaDiceOdyssey..."
            sleep 1
            wget ${project_path}/plugin/app/ https://ghproxy.com/https://github.com/OlivOS-Team/OlivaDiceOdyssey/releases/latest/download/OlivaDiceOdyssey.opk -N

        echo -e "${Tip} 默认插件下载完成！"
    }


    # 本地安装  
    install_local(){
        check_python
        check_pip
        install_project
        chmod -R 766 ${project_path}
        cd ${project_path}
        install_dependence
        download_default_plugin
        echo -e "${Tip} ${project_name}安装完成！"
        sleep 2
        # 打印安装位置
        echo -e "${Tip} ${project_name}安装位置：${project_path}"
        sleep 5
        echo -e "${Tip} 开始尝试运行，如有问题请提交issue"
        sleep 2
        cd ${project_path} && python3 ${main_file}
    }


    StartProject()
    {
    # 启动脚本
        echo -e "·····························"
        echo -e "···____···____···____··_··__·"
        echo -e "··/·__·\·/·__·\·/·__·\|·|/·/·"
        echo -e "·|·|··|·|·|··|·|·|··|·|·'·/··"
        echo -e "·|·|··|·|·|··|·|·|··|·|· <···"
        echo -e "·|·|__|·|·|__|·|·|__|·|·.·\··"
        echo -e "··\____/·\____/·\____/|_|\_\·"
        echo -e "·····························"
        echo -e "${Red_font_prefix}---${project_name}-OneKey ${Ver} by ${author}---${Font_color_suffix}"
        echo -e "${Tip} 开始安装${project_name}..."
        sleep 2 
        install_local
    }

    StartProject