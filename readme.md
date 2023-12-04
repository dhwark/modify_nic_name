使用方法：

source modify_nic.sh [原始网卡名] [新网卡名]



或取消注释，脚本自动获取当前网卡名

PCINAME=$(nmcli con show | awk 'NR==2 {print $4}')