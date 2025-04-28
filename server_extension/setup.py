# server_extension/setup.py
from setuptools import setup, find_packages

setup(
    name="mytermextension",
    version="0.1.0",
    description="A small Jupyter Server extension to spawn Zsh terminals",
    packages=find_packages(),
    install_requires=[
        "jupyter-server>=2.0.0"
    ],
    entry_points={
        "jupyter_server": [
            # this tells Jupyter Server to load your ExtensionApp
            "mytermextension = mytermextension.__init__:MyTermExtension"
        ]
    },
    include_package_data=True,
)
