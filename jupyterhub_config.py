# jupyterhub_config.py

from jupyterhub.auth import LocalAuthenticator
from dummyauthenticator import DummyAuthenticator

class LocalDummyAuthenticator(DummyAuthenticator, LocalAuthenticator):
    """Allows any username/password + auto-creates a UNIX user."""
    pass

c = get_config()

# 1) Authenticate anyone with DummyAuthenticator
c.JupyterHub.authenticator_class = LocalDummyAuthenticator
c.LocalDummyAuthenticator.password = "password"
c.LocalDummyAuthenticator.create_system_users = True

c.ServerApp.jpserver_extensions = {
    'mytermextension': True
}
c.ServerApp.terminado_settings = {
    'shell_command': ['/bin/bash', '-i']
}
c.ServerApp.disable_check_xsrf = True
# 2) Launch each user in JupyterLab
c.Spawner.default_url = '/lab'

# 3) Bind the Hub to 0.0.0.0:8000 so Docker -p works
c.JupyterHub.bind_url = 'http://0.0.0.0:8000'
c.JupyterHub.hub_ip   = '0.0.0.0'

# (No `c.Spawner.environment` or other shell overrides here!)
