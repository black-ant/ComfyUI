@echo off
chcp 65001 >nul
title ComfyUI 启动器

echo ========================================
echo     ComfyUI 一键启动脚本
echo ========================================
echo.

REM 切换到脚本所在目录
cd /d "%~dp0"

REM 检查 Python 是否安装
echo [1/3] 检查 Python 环境...
python --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未检测到 Python，请先安装 Python 3.10 或更高版本
    echo.
    echo 下载地址: https://www.python.org/downloads/
    pause
    exit /b 1
)

python --version
echo [✓] Python 环境正常
echo.

REM 检查依赖是否安装
echo [2/3] 检查依赖包...
python -c "import torch; import aiohttp; import sqlalchemy; import alembic" >nul 2>&1
if errorlevel 1 (
    echo [警告] 检测到缺少依赖包，正在安装所有依赖...
    echo 这可能需要几分钟时间，请耐心等待...
    echo.
    pip install -r requirements.txt
    if errorlevel 1 (
        echo [错误] 依赖安装失败，请手动运行: pip install -r requirements.txt
        pause
        exit /b 1
    )
    echo [✓] 依赖安装完成
    echo.
    REM 再次验证关键依赖
    echo 验证关键依赖...
    python -c "import torch; import aiohttp; import sqlalchemy; import alembic" >nul 2>&1
    if errorlevel 1 (
        echo [警告] 部分依赖可能未正确安装，但将继续尝试启动...
    ) else (
        echo [✓] 关键依赖验证通过
    )
) else (
    echo [✓] 依赖包检查通过
)
echo.

REM 启动 ComfyUI
echo [3/3] 启动 ComfyUI 服务器...
echo.
echo ========================================
echo     正在启动，请稍候...
echo ========================================
echo.
echo [提示] 使用 CPU 模式运行（适合功能验证，速度较慢）
echo 启动后，请在浏览器中访问: http://127.0.0.1:8188
echo.
echo 按 Ctrl+C 可以停止服务器
echo ========================================
echo.

python main.py --cpu

REM 如果程序异常退出，暂停以便查看错误信息
if errorlevel 1 (
    echo.
    echo [错误] 程序异常退出，错误代码: %errorlevel%
    pause
)
