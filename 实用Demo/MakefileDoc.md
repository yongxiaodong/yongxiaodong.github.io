###



申明一个build命令,phony申明build是个命令，而不是找当前目录下的文件
.PHONY build  
build:
    go build -o aaa main.go


申明一个test命令，并判断testfile是否存在
test: testfile
    test....

如果灭有申明version，则赋值
ifndef version
    version = 2.0
endif