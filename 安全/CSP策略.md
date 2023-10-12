## CSP 内容安全策略  
- 该策略用于限制HTML只能从被允许的的地址中加载css/jss/data等资源，降低被XSS攻击、注入恶意内容的风险。  
- 实施方式： 在response Header头中添加Content-Security-Policy字段，支持该字段的浏览器识别到后会进行处理


## 最佳实践
浏览器支持Content-Security-Policy和Content-Security-Policy-Report-Only字段。  
- Content-Security-Policy字段： 会强制浏览器按照指定的规则执行，阻止规则不允许的资源加载 
- Content-Security-Policy-Report-Only字段： 不会阻止资源加载。但会输出错误信息到console面板也可以将错误上传到指定的url进行分析，可以用于上线csp策略前的埋点调试  


### 埋点调试错误信息
nginx返回用于调试的header头
    `more_set_headers "Content-Security-Policy-Report-Only: default-src 'self' *.itgod.org;  style-src 'self' *.baidu.com; script-src 'self'; report-uri  https://9d4e-43-154-200-149.ngrok-free.app/csp";`

- default-src： 默认策略，最低优先级，只允许加载自身域下的资源和来自*.itgod.org下的资源
- style-src： 限制了只允许从自身域下和*.baidu.com加载样式表资源  
- script-src: 限制了只允许从自身域下获取js资源  
- report-uri: 将错误信息发送到指定的url，错误信息包含引发了什么类型的错误以及哪个资源被阻止加载等信息，错误信息样本如下:  
```
{
  'csp-report': {
    'document-uri': 'https://dy.aaa.com/daren/zhaoshang/jiepinshenhe',
    'referrer': 'https://dy.aaa.com/login',
    'violated-directive': 'script-src-elem',
    'effective-directive': 'script-src-elem',
    'original-policy': "default-src 'self' 'unsafe-inline'; report-uri  https://9d4e-43-154-200-149.ngrok-free.app/csp",
    'disposition': 'report',
    'blocked-uri': 'https://cdn.staticfile.org/vue/2.6.11/vue.min.js',
    'status-code': 200,
    'script-sample': ''
  }
}
```
> 表示触发了script-src-elem脚本加载限制，从https://cdn.staticfile.org/vue/2.6.11/vue.min.js的加载被阻止了，disposition（处置方式）是report（上报），这里不会被浏览器阻止加载，因为我们使用的是Content-Security-Policy-Report-Only策略，浏览器只会上报错误而不会直接阻止  


### 上线CSP策略  
通过上述的调试策略分析所有的错误信息，并进行修复后，可以直接将Content-Security-Policy-Report-Only头修改为Content-Security-Policy头，这样浏览器就会强制阻止规则以外的资源加载了。  


nginx 添加返回头:
    `more_set_headers "Content-Security-Policy: default-src 'self' *.baidu.com;  style-src 'self' *.baidu.com; script-src 'self'; report-uri  https://9d4e-43-154-200-149.ngrok-free.app/csp";`


> 1、Content-Security-Policy-Report-Only和Content-Security-Policy头可以同时存在，浏览器同样会严格阻止Content-Security-Policy规则以外的资源，触发的Content-Security-Policy-Report-Only规则限制则只会上报  
> 2、尽量不要使用HTML内联样式，样式都通过外部文件加载，内联样式的注入风险比较大（比如标签被关闭后植入script代码）  
> 3、Content-Security-Policy也支持指定report-uri，注意时刻收集线上的csp错误并及时处理  

参考: https://developer.mozilla.org/zh-CN/docs/Web/HTTP/CSP  

