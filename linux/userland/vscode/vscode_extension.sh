#!/bin/bash

set -e

extension_general=" emilast.logfilehighlighter \
                    monokai.theme-monokai-pro-vscode \
                    mads-hartmann.bash-ide-vscode \
                    oderwat.indent-rainbow \
                    rashwell.tcl \
                    redhat.vscode-yaml \
                    Gruntfuggly.todo-tree \
                    vscodevim.vim \
                    ionutvmi.path-autocomplete \
                    dakara.dakara-foldplus \
                    alefragnani.bookmarks \
                    aaron-bond.better-comments \
                    k--kato.intellij-idea-keybindings \
                    esbenp.prettier-vscode \
                    ms-vscode.hexeditor \
                    ms-vscode.powershell \
                    ibm.output-colorizer \
                    ms-vscode-remote.vscode-remote-extensionpack \
                    ms-vscode-remote.remote-ssh \
                    jnoortheen.nix-ide \
                    haskell.haskell \
                    "

extension_misc="    eugenwiens.bitbake \
                    gaborv.flatbuffers \
                    "

# programing languages
extension_cpp=" ms-vscode.cpptools-extension-pack \
                jeff-hykin.better-cpp-syntax \
                ms-vscode.cpptools \
                cschlosser.doxdocgen \
                twxs.cmake \
                cheshirekow.cmake-format \
                ms-vscode.cmake-tools "

extension_python=" ms-python.python njpwerner.autodocstring ms-python.vscode-pylance "
extension_java=" redhat.java "
extension_gcode=" ml.nc-gcode "

# text marking languages
extension_md=" DavidAnson.vscode-markdownlint \
               yzhang.markdown-all-in-one \
               shd101wyy.markdown-preview-enhanced \
               "

# tools
extension_git=" eamodio.gitlens \
                donjayamanne.githistory \
                github.vscode-pull-request-github \
                mhutchie.git-graph "

extension_qt=" zhoufeng.pyqt-integration bbenoist.qml "

extension_web=" formulahendry.auto-close-tag \
                formulahendry.auto-rename-tag \
                vincaslt.highlight-matching-tag \
                kisstkondoros.vscode-gutter-preview "

extension_docker=" ms-azuretools.vscode-docker "
extension_liveshare=" ms-vsliveshare.vsliveshare-pack "
extension_embedded=" platformio.platformio-ide webfreak.debug "

#-------------------------------------------------------------------------------------

extension_all="${extension_general}"

extension_all="${extension_all}${extension_python}"
extension_all="${extension_all}${extension_cpp}"
extension_all="${extension_all}${extension_java}"
extension_all="${extension_all}${extension_md}"
# extension_all="${extension_all}${extension_gcode}"
# extension_all="${extension_all}${extension_embedded}"

extension_all="${extension_all}${extension_git}"
# extension_all="${extension_all}${extension_qt}"
extension_all="${extension_all}${extension_docker}"
# extension_all="${extension_all}${extension_liveshare}"
# extension_all="${extension_all}${extension_web}"
extension_all="${extension_all}${extension_misc}"

extension_minimal="${extension_general}"
extension_minimal="${extension_minimal} ${extension_cpp} ${extension_git} ${extension_python} "

extension_final="${extension_minimal}"
if [ "$#" -gt 0 ]; then
    extension_final="${extension_all}"
fi

for ext in ${extension_final}
do
    if ! command code --install-extension "${ext}" ; then
        echo "Errrors while installing extensions for regular"
        exit 1
    fi
done
