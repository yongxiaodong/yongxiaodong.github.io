## 镜像存储git私钥  
`git config --global credential.helper store`  

>> 登录后自动生成 /root/.git-credentials和/root/.gitconfig




## 本地修改冲突时利用暂存区合并

```
git stash

git pull 

git stash pop
```