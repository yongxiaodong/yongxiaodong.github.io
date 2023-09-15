## 转发到回环口  
> firewalld 不支持将xx端口转发到回环口  
 
- 需求： 监听了一个127.0.0.1:40000端口，在不方便修改监听的情况下想让外部访问到这个端口，则通过自定义代码监听一个40000端口，然后使用iptables转发到回环口  

`iptables -t nat -A PREROUTING -p tcp --dport 40001 -j DNAT --to-destination 127.0.0.1:40000`

** 这时候如果要限制来源，则要限制来源IP->40000端口的访问，而不能限制来源IP->40001的访问，如：  

```
iptables -I INPUT -p tcp --dport 40000  -s 192.168.1.1 -j ACCEPT
iptables -A INPUT -p tcp --dport 40000  -j REJECT
```