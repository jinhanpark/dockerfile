FROM nvcr.io/nvidia/pytorch:20.07-py3

RUN apt-get update && apt-get install -y \
    zsh \
    git \
    emacs \
    vim \
    htop \
    tmux \
    language-pack-en

# set time zone
RUN set TZ "KST"

# set locale
RUN locale-gen en_US.utf8 \
    && update-locale \
    && export LANG=en_US.UTF-8


# oh my zsh and dot files
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && wget -O ~/.emacs https://raw.githubusercontent.com/jinhanpark/dotfiles/master/emacs \
    && wget -O ~/.zshrc https://raw.githubusercontent.com/jinhanpark/dotfiles/master/zshrc

# jupyter lab settings
RUN conda install -y nodejs nb_conda
RUN pip install ipywidgets
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN jupyter labextension install jupyterlab_vim

# jupyter password settings
RUN echo -e '{\n  "NotebookApp": {\n    "password": "sha1:58c1d0061585:e2127287574c86fd8090ba22e89789a67975ef4a"\n  }\n}' > ~/.jupyter/jupyter_notebook_config.json
