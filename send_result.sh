#! /bin/bash

# Usage
# sh ./send_result.sh 2023-1.txt

result="楽天カードの利用履歴から算出した家計簿をお知らせします。\\n $(ruby ./main.rb $1)"

echo $result > "result/$1"

# cd "$(ghq root)/github.com/yagijin/actions-sandbox" || return
# gh workflow run line-notify.yml -f text="$result"
# cd - || return
