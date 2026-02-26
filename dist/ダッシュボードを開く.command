#!/bin/bash
# Mac用起動スクリプト
# このファイルをダブルクリックするだけでダッシュボードが開きます

# スクリプトと同じフォルダに移動
cd "$(dirname "$0")"

echo ""
echo "=========================================="
echo " Salesforce 導入分析ダッシュボード"
echo "=========================================="
echo ""

# --- Python を探す ---
PYTHON=""
for cmd in python3 python; do
    if command -v "$cmd" &>/dev/null; then
        PYTHON="$cmd"
        break
    fi
done

if [ -z "$PYTHON" ]; then
    echo " [エラー] Python が見つかりませんでした。"
    echo ""
    echo " 以下の手順でインストールしてください："
    echo "   1. ターミナルで次のコマンドを実行："
    echo "      brew install python"
    echo "   または"
    echo "   1. https://www.python.org/downloads/ を開く"
    echo "   2. 「Download Python」をクリックしてインストール"
    echo ""
    echo " Homebrew がない場合："
    echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    echo ""
    read -p "Enterキーで閉じる..."
    exit 1
fi

# --- ポート確認 ---
PORT=8765
if lsof -i :$PORT &>/dev/null; then
    echo " ポート $PORT は使用中です。8766 を使います。"
    PORT=8766
fi

echo " Python: $($PYTHON --version)"
echo " サーバーを起動しています... (ポート $PORT)"
echo ""
echo " ブラウザが自動で開きます。"
echo " 開かない場合は以下のURLをコピーしてください："
echo ""
echo "   http://localhost:$PORT/dashboard.html"
echo ""
echo " 終了するにはこのウィンドウを閉じてください。"
echo "=========================================="
echo ""

# ブラウザを少し待ってから開く
(sleep 2 && open "http://localhost:$PORT/dashboard.html") &

# サーバー起動
$PYTHON -m http.server $PORT
