#!/bin/bash
install_pyenv(){
    apk add git
    git clone --depth 1 https://github.com/pyenv/pyenv.git /tmp/.pyenv
    echo 'export PYENV_ROOT="/tmp/.pyenv"' >> /tmp/.bash_profile
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /tmp/.bash_profile
    echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> /tmp/.bash_profile
    source /tmp/.bash_profile
}
install_pyenv
pyenv install $DEF_PYTHON_VERSION
source ~/.bashrc
curl -sL $SRC_LINK --stderr - | tar zx
cd $(ls -d */)
echo $(pwd)
pip wheel .
cp $(ls |grep .whl) /dist
