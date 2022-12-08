ARG PYTORCH="1.9.1"
ARG CUDA="11.1"
ARG CUDNN="8"

FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-devel

# environment install
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN apt-get update
RUN apt-get -y install sudo
RUN apt-get -y install curl
RUN apt-get -y install openssh-client
RUN apt-get -y install openssh-server
RUN apt-get -y install vim
RUN apt-get -y install screen

# set root login
RUN echo "root:passwd123" | chpasswd
RUN sed -ri 's/^#PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config  
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config  
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config 

ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0 7.5 8.0 8.6+PTX" \
    TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
    CMAKE_PREFIX_PATH="$(dirname $(which conda))/../" \
    FORCE_CUDA="1"

# port expose
EXPOSE 22 6006 8888

ADD utils.tar /root/
RUN chmod a+x /root/utils/entrypoint.sh

#python requirement list
RUN pip install numpy
RUN pip install opencv-python

# Install CAT requirement list
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir torch==1.10.2+cu111 torchvision==0.11.3+cu111 torchaudio==0.10.2 -f https://download.pytorch.org/whl/cu111/torch_stable.html
RUN pip install --no-cache-dir openmim && \
    mim install --no-cache-dir "mmcv==1.6.1" "mmdet==2.25.1"
RUN pip install --no-cache-dir -r /tmp/requirements.txt

ENTRYPOINT ["/root/utils/entrypoint.sh"]
