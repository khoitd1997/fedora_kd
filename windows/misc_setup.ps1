[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";G:\Xilinx\Vitis\2020.1\bin",
    [EnvironmentVariableTarget]::Machine)