# server_extension/mytermextension/__init__.py

import tornado.web
from jupyter_server.base.handlers import APIHandler
from jupyter_server.serverapp import ServerApp
from jupyter_server.utils import url_path_join

class ZshTerminalHandler(APIHandler):

    def check_xsrf_cookie(self):
        # Skip XSRF check for this endpoint only
        return

    @tornado.web.authenticated
    async def post(self):
        # Spawn a new Zsh terminal
        model = self.terminal_manager.create(
            name=None,
            shell_command=["/usr/bin/zsh", "-i"]
        )
        self.finish(model)

def _load_jupyter_server_extension(server_app: ServerApp):
    web_app = server_app.web_app
    base    = web_app.settings["base_url"]
    route   = url_path_join(base, "api", "zsh_terminal")
    web_app.add_handlers(".*$", [(route, ZshTerminalHandler)])
