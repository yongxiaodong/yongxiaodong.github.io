# 依赖 book
# npm install -g gitbook-summary
# npm install honkit --glolbal
# npm install gitbook-plugin-copy-code-button
# npm i gitbook-plugin-edit-link
# npm i gitbook-plugin-chapter-fold
# npm i gitbook-plugin-tbfed-pagefooter
# npm install inherits

git pull
book sm
honkit build ./ ./docs
git add .
git commit -m 'zuto'
git push 
