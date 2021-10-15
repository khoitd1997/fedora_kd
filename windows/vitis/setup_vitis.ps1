Set-Location "G:\Downloads\Xilinx_Unified_2021.1_0610_2318"

# tar -xvzf ".\Xilinx_Unified_2020.1_0602_1208.tar.gz"
# tar -xvzf ".\Xilinx_Vivado_Vitis_Update_2020.1.1_0805_2247.tar.gz"

./xsetup.exe -c "$PSScriptRoot/install_config.txt" --agree "XilinxEULA,3rdPartyEULA,WebTalkTerms" --batch Add

Set-Location "$PSScriptRoot"