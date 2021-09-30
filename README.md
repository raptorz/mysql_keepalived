# 在Docker上使用MySQL5.7+Keepalived

## 使用方法

注意：只能在两台单独的服务器（物理或虚拟）上使用，不可在一台服务器上运行两个本Docker实例。

先构建镜像：

```bash
docker build -t mysql_keepalive .
```

然后在两台服务器上分别运行：

```
./bin/start_mysql.sh <server_id>
```

其中`<server_id>`取值为1或2，在服务器1上使用1，在服务器2上使用2。

如：

```
./bin/start_mysql.sh 1  # 在服务器1上运行
./bin/start_mysql.sh 2  # 在服务器2上运行
```

等待Docker实例启动后，在服务器1上运行：

```
./bin/init_master.sh <network_interface> <virtual_ip> <master_ip> <slave_ip>
```

其中`<network_interface>`为服务器网卡名称，可使用以下命令查看：

```
ip link
```

通常叫`eth0`或`ens123`等。

`<virtual_ip>`为需要keepalived创建的虚拟IP，必须是客户端可以访问到的未被使用的IP。

`<master_ip>`为本机（服务器1）网卡的实际IP，不是Docker容器里使用的虚拟IP。

`<slave_ip>`为另一台服务器（服务器2）的实际IP。

如：

```
./bin/init_master.sh eth0 192.168.0.100 192.168.0.101, 192.168.0.102
```

等待运行完成后，再到服务器2上运行：

```
./bin/init_slave.sh <network_interface> <virtual_ip> <slave_ip>
```

参数意义同上。

如：

```
./bin/init_slave.sh eth0 192.168.0.100 192.168.0.102
```

安装完成。

客户端连接方式如：

```
mysql -h192.168.0.100 -uroot -p
```

注意：要使用keepalived创建的虚拟IP才能实现自动切换的高可用服务。
