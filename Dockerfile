FROM nvcr.io/nvidia/pytorch:20.03-py3
# https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/

RUN apt-get update && apt-get install -y \
    zsh \
    git \
    emacs \
    vim \
    htop \
    tmux \
    language-pack-en

# set locale
RUN locale-gen en_US.utf8 \
    && update-locale \
    && export LANG=en_US.UTF-8


# oh my zsh and dot files
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && wget -O ~/.emacs https://raw.githubusercontent.com/jinhanpark/dotfiles/master/emacs \
    && wget -O ~/.zshrc https://raw.githubusercontent.com/jinhanpark/dotfiles/master/zshrc \
    && conda init zsh && conda init bash

# tmux 256color settings and prefix key change
RUN echo -e 'set -g default-terminal "screen-256color"\nunbind C-b\nset-option -g prefix C-q\nbind-key C-q send-prefix' > ~/.tmux.conf

# jupyter lab settings + epc and virtualenv for emacs
RUN pip install jupyterlab==2.2.9
RUN pip install --upgrade jupyter-tensorboard
RUN conda install -y nodejs nb_conda
RUN pip install ipywidgets epc virtualenv
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager

# jupyter password settings
RUN echo -e '{\n  "NotebookApp": {\n    "password": "sha1:58c1d0061585:e2127287574c86fd8090ba22e89789a67975ef4a"\n  }\n}' > ~/.jupyter/jupyter_notebook_config.json

# when you want to use vim in lab
#RUN jupyter labextension install jupyterlab_vim

# when you want to use emacs in lab
RUN jupyter labextension install jupyterlab-emacskeys
RUN mkdir -p ~/.jupyter/lab/user-settings/@jupyterlab/shortcuts-extension
RUN echo -e '{\n    "shortcuts": [\n        {\n            "command": "application:toggle-left-area",\n            "keys": [\n                "Accel B"\n            ],\n            "selector": "body",\n            "disabled": true\n        },\n        {\n            "command": "application:close",\n            "keys": [\n                "Alt W"\n            ],\n            "selector": ".jp-Activity",\n            "disabled": true\n        },\n        {\n            "command": "notebook:split-cell-at-cursor",\n            "keys": [\n                "Ctrl Shift -"\n            ],\n            "selector": ".jp-Notebook.jp-mod-editMode",\n            "disabled": true\n        },\n        {\n            "command": "apputils:print",\n            "keys":["Accel P"],\n            "selector": "body",\n            "disabled": true\n        },\n        {\n            "command": "documentsearch:start",\n            "keys": [\n                "Accel F"\n            ],\n            "selector": ".jp-mod-searchable",\n            "disabled": true\n        },\n        {\n            "command": "documentsearch:start",\n            "keys": [\n                "Accel S"\n            ],\n            "selector": ".jp-mod-searchable",\n        },\n        {\n            "command": "docmanager:save",\n            "keys": [\n                "Accel X"\n            ],\n            "selector": "body"\n        },\n    ]\n}' > ~/.jupyter/lab/user-settings/@jupyterlab/shortcuts-extension/shortcuts.jupyterlab-settings

# install vs code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --version=3.5.0
