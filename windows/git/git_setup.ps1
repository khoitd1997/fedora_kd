LogHeader "Starting Git Configuration"

git lfs install

git config --global user.name "Khoi Trinh"
git config --global user.email "khoidinhtrinh@gmail.com"

# to make sure executable bits and other permission isn't messed up
git config --global core.filemode false

git config --global core.autocrlf true

LogHeader "Finished Git Configuration"