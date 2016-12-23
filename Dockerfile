# Copyright (C) 2016 PerfectlySoft Inc.
# Author: boyer <7249987481@qq.com>
# 在安装Docker主机上终端执行镜像部署命令：
#    docker build ../PerfectTemplate/

FROM perfectlysoft/ubuntu1510
RUN /usr/src/Perfect-Ubuntu/install_swift.sh --sure
RUN git clone https://github.com/huos3203/PerfectTemplate.git /usr/src/PerfectTemplate
WORKDIR /usr/src/PerfectTemplate
RUN swift build
CMD .build/debug/PerfectTemplate --port 80
