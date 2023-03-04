# stick-leds 随身WIFI LED灯控制脚本

我的棒子是芷荷，型号 WY-UF5-6（UFI001C），刷入了Debian系统，内核版本aarch64 Linux 5.15.0-jsbsbxjxh66+

LED的颜色与目录对应如下。其他型号的板子或系统，如果目录名字不同，可以在leds.sh中整体替换掉

| 颜色  | 路径                                     |
|-----|----------------------------------------|
| 蓝色  | /sys/class/leds/blue:wifi/trigger      |
| 绿色  | /sys/class/leds/green:internet/trigger |
| 红色  | /sys/class/leds/mmc0::/trigger         |

## 修改后的LED行为

| 颜色  | 行为                |
|-----|-------------------|
| 蓝色  | 有用户登录时            |
| 绿色  | 正常启动后，无用户登录       |
| 紫色  | 有用户登录时，CPU负载大于50% |
| 黄色  | 无用户登录时，CPU负载大于50% |

## 安装脚本
```
curl -o /path/to/leds.sh https://raw.fastgit.org/yaaprogrammer/stick-leds/main/leds.sh
chmod 755 /path/to/leds.sh
curl -o /usr/lib/systemd/system/leds.service https://raw.fastgit.org/yaaprogrammer/stick-leds/main/leds.service
sudo systemctl enable leds.service --now
```
上述命令以及`leds.service`文件中的`/path/to/leds.sh`自行替换为你想要的目录
## 其他功能
- 判断CPU负载高低的阈值为50%，可以在`leds.sh`中修改变量`threshold`的值
- `leds.service`可配置关闭LED灯，将`Environment=LED_OFF=0`修改为`Environment=LED_OFF=1`即可，之后重启systemd守护进程，`sudo systemctl daemon-reload`
- 每2秒运行一次脚本，可以在`leds.service`中配置运行间隔`RestartSec=2`
