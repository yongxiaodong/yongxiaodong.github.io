## 镜像存储git私钥  
`git config --global credential.helper store`  

>> 登录后自动生成 /root/.git-credentials和/root/.gitconfig




## 本地修改冲突时利用暂存区合并

```
git stash

git pull 

git stash pop
```


## git中新添加的.gitignore不生效问题
原因是 .gitignore 只能忽略那些原来没有被track的文件，如果某些文件已经被纳入了版本管理中，则修改.gitignore是无效的。
那么解决方法就是先把本地缓存删除（改变成未track状态），然后再提交
```
git rm -r --cached .

git add .

git commit -m 'update .gitignore'
```