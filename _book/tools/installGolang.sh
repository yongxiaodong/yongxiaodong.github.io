# source installGoang.sh

packageName='go1.19.2.linux-amd64.tar.gz'
function downLoad() {
  wget https://golang.google.cn/dl/${packageName}
}


function deCompress() {
  tar xf ${packageName} -C /usr/local/
}


function setEnv() {
  export PATH=$PATH:/usr/local/go/bin
  echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile
}

function clearTemp() {
  rm -rf ./${packageName}
}


downLoad
deCompress
setEnv
clearTemp

