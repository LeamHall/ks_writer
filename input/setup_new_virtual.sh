virt-install -n HOSTNAME -r 2048 --vcpus=1 -v --network=bridge:br0   --disk path=/opt/virtuals/guests/HOSTNAME.img,size=15 --location /opt/iso/CentOS-VERSION.iso --nographics --extra-args="ks=http://192.168.1.200/ks/HOSTNAME_ks.cfg ip=IP netmask=255.255.255.0 console=tty0 console=ttyS0,115200n8" 