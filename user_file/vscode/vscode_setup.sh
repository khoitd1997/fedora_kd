#!/bin/bash
# scripts written to quickly install visual studio code extensions

# essential extensions that will always be installed
extension_general="ms-vscode.cpptools  kevinkyang.auto-comment-blocks CoenraadS.bracket-pair-colorizer formulahendry.code-runner \
eamodio.gitlens donjayamanne.githistory huizhou.githd robertohuertasm.vscode-icons webfreak.debug  \
wayou.vscode-todo-highlight emilast.logfilehighlighter Tyriar.sort-lines Gimly81.matlab \
PeterJausovec.vscode-docker tomoki1207.pdf oderwat.indent-rainbow rashwell.tcl \
vector-of-bool.cmake-tools twxs.cmake eugenwiens.bitbake redhat.vscode-yaml \
zhoufeng.pyqt-integration pnp.polacode wmaurer.vscode-jumpy Gruntfuggly.todo-tree \
ibm.output-colorizer compulim.vscode-clock github.vscode-pull-request-github mitaki28.vscode-clang ryuta46.multi-command vscodevim.vim \
laurenttreguier.rpm-spec "

extension_theme=" zhuangtongfa.material-theme monokai.theme-monokai-pro-vscode "

extension_dropped=" vsciot-vscode.vscode-arduino"

# specialized dev tools
extension_python=" ms-python.python njpwerner.autodocstring "
extension_java=" redhat.java vscjava.vscode-java-debug naco-siren.gradle-language "
extension_doxygen=" bbenoist.doxygen cschlosser.doxdocgen "
extension_arm=" dan-c-underwood.arm marus25.cortex-debug "
extension_vhdl=" puorc.awesome-vhdl "
extension_verilog=" mshr-h.veriloghdl "
extension_md=" mushan.vscode-paste-image DavidAnson.vscode-markdownlint yzhang.markdown-all-in-one \
shd101wyy.markdown-preview-enhanced yzane.markdown-pdf "
extension_web=" formulahendry.auto-close-tag "
extension_docker=" PeterJausovec.vscode-docker "
extension_latex=" james-yu.latex-workshop "
extension_golang=" ms-vscode.go "

currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${currDir}
source ../utils.sh

set -e 
set -o pipefail
set -o nounset
#----------------------------------------------------------------------------------------------------

print_message "Installing vscode\n"

extension_all="${extension_general}${extension_theme}"
# extension_all="${extension_all}${extension_python}"
# extension_all="${extension_all}${extension_doxygen}"
# extension_all="${extension_all}${extension_arm}"
# extension_all="${extension_all}${extension_vhdl}"
# extension_all="${extension_all}${extension_java}"
# extension_all="${extension_all}${extension_md}"
# extension_all="${extension_all}${extension_web}"
# extension_all="${extension_all}${extension_latex}"
# extension_all="${extension_all}${extension_golang}"
extension_all="${extension_all}${extension_verilog}"

print_message "Starting Package Installation\n"
for ext in ${extension_all}
do
if ! code --install-extension "${ext}" ; then
print_error "Errrors while installing extensions\n"
exit 1
fi
done
print_message "Installation Done, configuring\n"

# open editor so that it creates a setting file, then we can overwite it
code&
sleep 2
pkill code

# copy Visual Studdio Code setting file and keybinding file
vscode_config_dir="~/.config/Code/User"
cp -vf ${currDir}/settings.json ${vscode_config_dir}/settings.json
cp -vf ${currDir}/keybindings.json ${vscode_config_dir}/keybindings.json

print_message "Installing Source Code Pro font"
git clone https://github.com/adobe-fonts/source-code-pro.git --branch release ~/source-code-pro

mkdir -p ~/.fonts
cp ~/source-code-pro/OTF/*.otf ~/.fonts
fc-cache -f -v ~/.fonts/
rm -rf ~/source-code-pro

print_message "Visual Studio Code Configurations done\n"