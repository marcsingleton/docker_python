FROM ubuntu:latest
LABEL maintainer="Marc Singleton <marcsingleton@berkeley.edu>"

ARG PYTHON_VERSION=3.11

# Most of the following are common utilities useful for data science and CLI work
# gcc and python3-dev were added as jupyterlab dependencies
# python3-dev specifically is needed for some C headers
# (DEBIAN_FRONTEND=noninteractive is needed to turn off interactive prompts for image build only)
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --yes --no-install-recommends \
    gcc \
    git \
    less \
    make \
    nano \
    pip \
    python3-dev \
    python${PYTHON_VERSION} \
    sudo \
    wget \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python${PYTHON_VERSION} python \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*


RUN pip install --no-cache \
  numpy \
  scipy \
  matplotlib \
  pandas \
  scikit-learn \
  jupyterlab

# In Ubuntu the users group is given GID 100
ARG USER="docker"
ARG GID="100"
RUN useradd --no-log-init --create-home --gid $GID $USER && \
    sudo -u $USER mkdir /home/$USER/.jupyter/
COPY jupyter_lab_config.py /home/$USER/.jupyter/
RUN chown $USER: /home/$USER/.jupyter/jupyter_lab_config.py && \
    chmod 750 /home/$USER/.jupyter/jupyter_lab_config.py

USER $USER
WORKDIR /home/$USER

EXPOSE 8888

ENTRYPOINT ["bash"]
