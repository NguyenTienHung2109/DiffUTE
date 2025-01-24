# Sử dụng base image CUDA 11.8 và cuDNN
FROM openmmlab/mmdeploy:ubuntu20.04-cuda11.8-mmdeploy1.3.1 AS dev

# Thiết lập biến môi trường
ENV PATH=/usr/local/bin:$PATH
ENV DEBIAN_FRONTEND=noninteractive

# Cài đặt gói hệ thống cần thiết
RUN apt-get update && apt-get install -y \
    wget \
    git \
    curl \
    ca-certificates \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    cmake \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    supervisor \
    unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Link Python 3 thành python
RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    ln -sf /usr/bin/pip3 /usr/bin/pip

# Kiểm tra phiên bản Python và pip
RUN python --version && pip --version

# Cài đặt PyTorch + CUDA
RUN pip install --upgrade pip && \
    pip install torch torchvision==0.15.0 torchaudio==2.0.0 --index-url https://download.pytorch.org/whl/cu118 &&\
    pip install --upgrade torch torchvision

# Cài đặt gdown
RUN pip install gdown

# Tải file từ Google Drive và giải nén
RUN mkdir -p /workspace/DiffUTE/data && \
    gdown --fuzzy https://drive.google.com/uc?id=1GgNEZYOfCDxyo8FMxco6-5bJ5K3kbdey -O /workspace/DiffUTE/data/archive.zip && \
    unzip /workspace/DiffUTE/data/archive.zip -d /workspace/DiffUTE/data && \
    rm /workspace/DiffUTE/data/archive.zip

# Sao chép thư mục ASCFormer vào workspace
ADD . /workspace/DiffUTE

# Cài đặt các thư viện từ requirements.txt
RUN pip install -r /workspace/DiffUTE/requirements.txt

# Đặt thư mục làm việc mặc định
WORKDIR /workspace
