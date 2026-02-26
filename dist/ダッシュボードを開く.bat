@echo off
chcp 65001 >nul
title SF導入分析ダッシュボード

echo.
echo  ==========================================
echo   Salesforce 導入分析ダッシュボード
echo  ==========================================
echo.

REM --- Python を探す ---
set PYTHON=
for %%P in (python python3) do (
    if not defined PYTHON (
        where %%P >nul 2>&1 && set PYTHON=%%P
    )
)

REM --- py launcher も試す ---
if not defined PYTHON (
    where py >nul 2>&1 && set PYTHON=py
)

if not defined PYTHON (
    echo  [エラー] Python が見つかりませんでした。
    echo.
    echo  以下の手順でインストールしてください：
    echo    1. https://www.python.org/downloads/ を開く
    echo    2. "Download Python" をクリックしてインストール
    echo    3. インストール時に "Add Python to PATH" にチェックを入れる
    echo    4. 再度このファイルをダブルクリック
    echo.
    pause
    exit /b 1
)

REM --- ポート確認・空きポートを使う ---
set PORT=8765
netstat -an | find ":%PORT% " | find "LISTEN" >nul 2>&1
if %errorlevel%==0 (
    echo  ポート %PORT% は使用中です。8766 を使います。
    set PORT=8766
)

echo  サーバーを起動しています... (ポート %PORT%)
echo.
echo  ブラウザが自動で開きます。
echo  開かない場合は以下のURLをコピーしてブラウザに貼り付けてください：
echo.
echo    http://localhost:%PORT%/dashboard.html
echo.
echo  終了するにはこのウィンドウを閉じてください。
echo  ==========================================
echo.

REM --- ブラウザを開く（少し待ってから）---
start /b cmd /c "timeout /t 2 >nul && start http://localhost:%PORT%/dashboard.html"

REM --- サーバー起動 ---
%PYTHON% -m http.server %PORT%

pause
