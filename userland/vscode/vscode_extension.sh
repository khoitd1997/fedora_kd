#!/bin/bash

extension_general=" coenraads.bracket-pair-colorizer-2 webfreak.debug emilast.logfilehighlighter oderwat.indent-rainbow rashwell.tcl eugenwiens.bitbake redhat.vscode-yaml Gruntfuggly.todo-tree ibm.output-colorizer compulim.vscode-clock ryuta46.multi-command vscodevim.vim laurenttreguier.rpm-spec bungcip.better-toml ionutvmi.path-autocomplete wk-j.save-and-run dakara.dakara-foldplus alefragnani.bookmarks ms-vsliveshare.vsliveshare-pack ms-vscode-remote.vscode-remote-extensionpack visualstudioexptteam.vscodeintellicode jack89ita.copy-filename ryu1kn.partial-diff grapecity.gc-excelviewer aaron-bond.better-comments gaborv.flatbuffers bierner.color-info kisstkondoros.vscode-gutter-preview sleistner.vscode-fileutils marcostazi.vs-code-vagrantfile "

extension_theme=" monokai.theme-monokai-pro-vscode vscode-icons-team.vscode-icons emmanuelbeziat.vscode-great-icons zhuangtongfa.material-theme "

extension_dropped=" vsciot-vscode.vscode-arduino"

# programing languages
extension_cpp=" ms-vscode.cpptools hars.cppsnippets twxs.cmake asabil.meson "
extension_csharp=" ms-dotnettools.csharp "
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
extension_git=" eamodio.gitlens donjayamanne.githistory github.vscode-pull-request-github mhutchie.git-graph "
extension_doxygen=" cschlosser.doxdocgen "
extension_arm=" dan-c-underwood.arm marus25.cortex-debug "
extension_qt=" zhoufeng.pyqt-integration bbenoist.qml "
extension_web=" formulahendry.auto-close-tag formulahendry.auto-rename-tag vincaslt.highlight-matching-tag "
extension_docker=" ms-azuretools.vscode-docker "

#-------------------------------------------------------------------------------------

extension_all="${extension_general}${extension_theme}"

extension_all="${extension_all}${extension_python}"
extension_all="${extension_all}${extension_cpp}"
extension_all="${extension_all}${extension_csharp}"
extension_all="${extension_all}${extension_matlab}"
# extension_all="${extension_all}${extension_vhdl}"
# extension_all="${extension_all}${extension_golang}"
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
    if ! command code --install-extension "${ext}" ; then
        print_error "Errrors while installing extensions for regular\n"
        exit 1
    fi

    if [ -x "$(command -v code-insiders)" ]; then
        if ! code-insiders --install-extension "${ext}" ; then
            print_error "Errrors while installing extensions for insider\n"
            exit 1
        fi
    fi
done
