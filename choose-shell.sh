# #!/usr/bin/env bash
# # Entry script: select Bash or Zsh, then start JupyterHub

# if [[ "$DEFAULT_SHELL" == "bash" ]]; then
#   DESIRED_SHELL="/bin/bash"
# else
#   DESIRED_SHELL="/usr/bin/zsh"
# fi

# # Set default shell for new users and jovyan
# sed -i "s|^DSHELL=.*|DSHELL=\"${DESIRED_SHELL}\"|" /etc/adduser.conf
# chsh -s "$DESIRED_SHELL" jovyan

# exec "$@"