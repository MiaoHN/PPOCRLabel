@echo off
SET VENV_DIR=venv

:: 检查Python是否存在
python --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Python is not installed. Please install Python first.
    pause
    exit /b
)

:: 检查Python版本是否为3.12
FOR /F "tokens=2 delims=." %%i IN ('python --version 2^>^&1') DO SET PYTHON_VERSION=%%i
IF NOT "%PYTHON_VERSION%"=="12" (
    echo Python 3.12 is required. Please install Python 3.12: https://www.python.org/ftp/python/3.12.7/python-3.12.7-amd64.exe
    pause
    exit /b
)

:: 检查虚拟环境是否存在
IF EXIST "%VENV_DIR%\Scripts\activate.bat" (
    echo Activating virtual environment...
    call "%VENV_DIR%\Scripts\activate.bat"
) ELSE (
    echo Virtual environment not found. Creating new one...
    python -m venv %VENV_DIR%

    :: 激活虚拟环境
    call "%VENV_DIR%\Scripts\activate.bat"

    :: 安装依赖项
    echo Installing dependencies...
    pip install paddlepaddle -i https://pypi.tuna.tsinghua.edu.cn/simple
    pip install paddleocr -i https://pypi.tuna.tsinghua.edu.cn/simple
    pip install openpyxl -i https://pypi.tuna.tsinghua.edu.cn/simple
    pip install PyQt5 -i https://pypi.tuna.tsinghua.edu.cn/simple
    pip install setuptools -i https://pypi.tuna.tsinghua.edu.cn/simple
)

:: 运行PPOCRLabel.py
echo Running PPOCRLabel.py...

python .\PPOCRLabel.py --det_model_dir .\inference\PP-OCRv4_det_student_raw\ --rec_model_dir .\inference\PP-OCRv3_rec\ --cls_model_dir .\inference\PP-OCRv3_cls\

:: 退出虚拟环境
deactivate

pause