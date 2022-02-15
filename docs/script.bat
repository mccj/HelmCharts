@echo off
@REM 声明采用UTF-8编码
chcp 65001

@REM echo 删除已经生成的文件(*.tgz)
@REM for /r %%x in (*.tgz) do del /q %%x

@REM @REM if exist "tmp" rd /s /q "tmp"
@REM if not exist "tmp" md "tmp"
@REM if not exist "tmp\helm.exe" copy /-Y "helm.exe" "tmp\"
@REM cd "tmp"

@REM if exist "releases" rd /s /q "releases"
if not exist "releases" md "releases"

echo 开始批量编译helm项目
for /d %%i in (../charts/*)  do helm package ../charts/%%i --dependency-update 
@REM :: --sign --key "mccj" --keyring pubring.gpg

echo 检查生成的 tgz 文件
for %%i in (*.tgz) do helm lint %%i

@REM echo 验证生成的 tgz 文件
@REM for %%i in (*.tgz) do helm verify %%i


echo 移动 tgz 文件
for %%i in (*.tgz) do if not exist releases\%%i (move /Y %%i releases\) else (del /q %%i)

echo 生成目录文件
if not exist "releases\helm.exe" copy /-Y "helm.exe" "releases\"
cd releases
helm repo index ../ --merge ../index.yaml --url ./
cd ..
if exist "releases\helm.exe" del /q "releases\helm.exe"
@REM move /Y "releases\index.yaml" "index.yaml"

echo 创建完成
pause>nul
