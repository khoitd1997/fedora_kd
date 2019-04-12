#!/bin/bash

extension_general=" kevinkyang.auto-comment-blocks CoenraadS.bracket-pair-colorizer formulahendry.code-runner webfreak.debug wayou.vscode-todo-highlight emilast.logfilehighlighter Tyriar.sort-lines oderwat.indent-rainbow rashwell.tcl eugenwiens.bitbake redhat.vscode-yaml Gruntfuggly.todo-tree ibm.output-colorizer compulim.vscode-clock ryuta46.multi-command vscodevim.vim laurenttreguier.rpm-spec bungcip.better-toml ionutvmi.path-autocomplete tickleforce.scrolloff esbenp.prettier-vscode wk-j.save-and-run shakram02.bash-beautify "

extension_theme=" monokai.theme-monokai-pro-vscode  vscode-icons-team.vscode-icons emmanuelbeziat.vscode-great-icons "

extension_dropped=" vsciot-vscode.vscode-arduino"

# programing languages
extension_cpp=" ms-vscode.cpptools hars.cppsnippets vector-of-bool.cmake-tools twxs.cmake mitaki28.vscode-clang "
extension_python=" ms-python.python njpwerner.autodocstring "
extension_java=" redhat.java vscjava.vscode-java-debug naco-siren.gradle-language "
extension_vhdl=" puorc.awesome-vhdl "
extension_verilog=" mshr-h.veriloghdl "
extension_matlab=" Gimly81.matlab "
extension_golang=" ms-vscode.go "

# text marking languages
extension_md=" mushan.vscode-paste-image DavidAnson.vscode-markdownlint yzhang.markdown-all-in-one shd101wyy.markdown-preview-enhanced yzane.markdown-pdf "
extension_latex=" james-yu.latex-workshop "

# tools
extension_git=" eamodio.gitlens donjayamanne.githistory huizhou.githd github.vscode-pull-request-github "
extension_doxygen=" bbenoist.doxygen cschlosser.doxdocgen "
extension_arm=" dan-c-underwood.arm marus25.cortex-debug "
extension_qt=" zhoufeng.pyqt-integration bbenoist.qml "
extension_web=" formulahendry.auto-close-tag "
extension_docker=" PeterJausovec.vscode-docker "

#-------------------------------------------------------------------------------------

extension_all="${extension_general}${extension_theme}"

extension_all="${extension_all}${extension_python}"
extension_all="${extension_all}${extension_cpp}"
extension_all="${extension_all}${extension_matlab}"
# extension_all="${extension_all}${extension_vhdl}"
extension_all="${extension_all}${extension_golang}"
# extension_all="${extension_all}${extension_verilog}"
extension_all="${extension_all}${extension_latex}"
extension_all="${extension_all}${extension_java}"
extension_all="${extension_all}${extension_md}"

extension_all="${extension_all}${extension_git}"
extension_all="${extension_all}${extension_doxygen}"
extension_all="${extension_all}${extension_arm}"
extension_all="${extension_all}${extension_qt}"
extension_all="${extension_all}${extension_docker}"
extension_all="${extension_all}${extension_web}"

for ext in ${extension_all}
do
    if ! code --install-extension "${ext}" ; then
        print_error "Errrors while installing extensions\n"
        exit 1
    fi
done