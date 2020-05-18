# Steps

```shell
echo 'options vfio-pci ids=10de:1c81,10de:0fb9' | sudo tee -a /etc/modprobe.d/vfio.conf
echo 'force_drivers+="vfio vfio-pci vfio_iommu_type1"' | sudo tee -a /etc/dracut.conf.d/vfio.conf
echo 'options kvm ignore_msrs=1' | sudo tee -a /etc/modprobe.d/kvm.conf

# /etc/default/grub
GRUB_CMDLINE_LINUX="... amd_iommu=on iommu=pt rd.driver.pre=vfio-pci"

kernel_ver=$(uname -r)
sudo dracut -f --kver ${kernel_ver} && sudo grub2-mkconfig | sudo tee /etc/grub2-efi.cfg

sudo usermod -a -G libvirt kd
sudo usermod -a -G kvm kd
sudo usermod -a -G input kd

# these should be run after SeLinux complains
sudo ausearch -c 'qemu-system-x86' --raw | sudo audit2allow -M my-qemusystemx86
sudo semodule -i my-qemusystemx86.p
```

```shell
# /etc/libvirt/qemu.conf
user = "kd"
group = "kvm"
cgroup_device_acl = [
    "/dev/kvm",
    "/dev/input/by-id/usb-1bcf_USB_Optical_Mouse-event-mouse",
    "/dev/input/by-id/usb-HOLTEK_USB-HID_Keyboard-event-kbd",
    "/dev/null", "/dev/full", "/dev/zero",
    "/dev/random", "/dev/urandom",
    "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
    "/dev/rtc","/dev/hpet", "/dev/sev"
]
```

```shell
# while the vm is running, DO NOT TRY TO DEFINE
sudo virsh dumpxml win10 > win10_vm.xml
sudo virsh define win10_vm.xml

sudo virsh start win10
sudo virsh shutdown win10

# need to install virtio driver for good performance
# https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/
# download the .msi file and install on guest

# XML format reference: https://libvirt.org/formatdomain.html
```
