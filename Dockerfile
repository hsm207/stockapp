FROM continuumio/anaconda3:latest

# from https://code.visualstudio.com/docs/remote/containers-advanced#_adding-a-nonroot-user-to-your-dev-container
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN conda install -c conda-forge jupyterlab
RUN pip install black \
    nb_black

USER vscode
WORKDIR /home/vscode
RUN git clone https://github.com/ranaroussi/yfinance.git && \
    cd yfinance && \
    pip install -e .
