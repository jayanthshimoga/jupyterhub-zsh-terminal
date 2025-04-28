# Dockerfile for JupyterHub + JupyterLab with Zsh support (no choose-shell.sh)

FROM jupyter/base-notebook:python-3.11

USER root

# 1) Install system tools, Zsh, Git, cURL, Node.js & npm
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      adduser \
      passwd \
      zsh \
      git \
      curl \
      nodejs \
      npm && \
    rm -rf /var/lib/apt/lists/*

# 2) Disable the Zsh new-user installer globally
RUN mkdir -p /etc/zsh && \
    printf 'zsh-newuser-install() { :; }\n' >> /etc/zsh/zshenv

# 3) Make Zsh the default shell for newly created users (via adduser)
RUN sed -i 's|^DSHELL=.*|DSHELL="/usr/bin/zsh"|' /etc/adduser.conf

# 4) Install Oh-My-Zsh skeleton for all new users
RUN git clone --depth=1 \
      https://github.com/ohmyzsh/ohmyzsh.git \
      /etc/skel/.oh-my-zsh && \
    cp /etc/skel/.oh-my-zsh/templates/zshrc.zsh-template \
       /etc/skel/.zshrc

# 5) Install Starship Prompt globally and hook it into skeleton .zshrc
RUN curl -sS https://starship.rs/install.sh | sh -s -- --yes && \
    printf "\n# Initialize Starship\n"     >> /etc/skel/.zshrc && \
    printf 'eval "$(starship init zsh)"\n' >> /etc/skel/.zshrc

# 6) Make Zsh the default shell for the built-in 'jovyan' user
# RUN chsh -s /usr/bin/zsh jovyan

# 7) Ensure all processes see Zsh as the shell
# ENV SHELL=/usr/bin/zsh

# 8) Install Python packages: JupyterHub, JupyterLab, Notebook, DummyAuthenticator
RUN pip install --no-cache-dir \
      jupyterhub \
      jupyterlab \
      notebook \
      jupyterhub-dummyauthenticator

# 9) Install & enable the custom server extension (spawns Zsh terminals)
COPY server_extension /srv/server_extension
RUN pip install --no-cache-dir /srv/server_extension 
RUN jupyter server extension enable --sys-prefix mytermextension

# 10) Build & link the front-end launcher extension (adds “New Zsh Terminal”)
COPY multi-terminal-launcher /extension
WORKDIR /extension
RUN npm install && npm run build && \
    jupyter labextension link . && \
    jupyter lab build

# 11) Copy your JupyterHub config (unchanged)
COPY jupyterhub_config.py /srv/jupyterhub/jupyterhub_config.py

# 12) Expose JupyterHub’s port and start the Hub
EXPOSE 8000
CMD ["jupyterhub", "--config", "/srv/jupyterhub/jupyterhub_config.py"]
