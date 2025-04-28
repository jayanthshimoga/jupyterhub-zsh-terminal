from jupyter_server.base.handlers import APIHandler
from jupyter_server.utils import url_path_join
from tornado import web

class ZshTerminalHandler(APIHandler):
    @web.authenticated
    async def post(self):
        # Spawn a new terminal with Zsh
        # TerminalManager.create takes shell_command override
        model = self.terminal_manager.create(
            name=None,
            shell_command=['/usr/bin/zsh', '-i']
        )
        self.finish(model)