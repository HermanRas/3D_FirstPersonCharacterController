$comment = Read-Host -Prompt 'Input commit comment'
git add "."
git pull
git commit -m "$comment"
git push --progress