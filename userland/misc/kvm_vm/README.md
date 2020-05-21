# Setting Up and Working with Win10 VM with GPU Passthrough

## Setting Up Host

First is to setup various things like isolating the GPU to pass, asking grub to load the correct driver, etc.

```shell
# might need to change ID if graphic card changes
echo 'options vfio-pci ids=10de:1c81,10de:0fb9' | sudo tee -a /etc/modprobe.d/vfio.conf
echo 'force_drivers+="vfio vfio-pci vfio_iommu_type1"' | sudo tee -a /etc/dracut.conf.d/vfio.conf
echo 'options kvm ignore_msrs=1' | sudo tee -a /etc/modprobe.d/kvm.conf # for host-passthrough to work

# /etc/default/grub
GRUB_CMDLINE_LINUX="... amd_iommu=on iommu=pt rd.driver.pre=vfio-pci"

kernel_ver=$(uname -r)
sudo dracut -f --kver ${kernel_ver} && sudo grub2-mkconfig | sudo tee /etc/grub2-efi.cfg

sudo usermod -a -G libvirt ${USER}
sudo usermod -a -G kvm ${USER}
sudo usermod -a -G input ${USER}
```

Add mouse, keyboard to evdev:

```shell
# /etc/libvirt/qemu.conf
user = "kd"
group = "kvm"

# need to change the path in the xml and here if mouse and keyboard changes
cgroup_device_acl = [
    "/dev/input/by-id/usb-1bcf_USB_Optical_Mouse-event-mouse",
    "/dev/input/by-id/usb-HOLTEK_USB-HID_Keyboard-event-kbd",
    ...
]
```

Once all that is done, next is to bring up the VM. This folder contains the `win10_vm.xml` file which should serve as a template for future VM. May need to adjust things like the path to the Win10 Iso. Check [here](2) for the xml file format.

```shell
# NOTE: Download the win10 iso to /home/kd/Downloads/win10.iso first

# create qcow2 filesystem
sudo qemu-img create -f qcow2 '/var/lib/libvirt/images/win10.qcow2' 100G

virsh define win10_vm.xml # while the vm is running, DO NOT TRY TO DEFINE

virsh dumpxml win10 > win10_vm.xml # should do this occasionally and check if config becomes invalid

virsh start win10
# these should be run after SeLinux complains
# may need to run multiple times
sudo ausearch -c 'qemu-system-x86' --raw | sudo audit2allow -M my-qemusystemx86
sudo semodule -i my-qemusystemx86.p

virsh shutdown win10
```

## Prepping Windows 10 Guest

Need to install [virtio msi installers](1) and [spice guest tools](3) for good performance(and stuffs like clipboard sharing). They should already be in the shared folder of the vm. For convenience, these are the links:

## Using the VM

Workflow is to switch between monitors using the monitor's input selection or to use an HDMI switch to quickly switch between host and VM. `Looking Glass` has been tried but the ergonomic of use is a little awkward since it can't start to stream until user has logged in, it also requires more setup on both host and guest side.

Left+Right Ctrl to switch to VM mouse and keyboard.

[1]: https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win-gt-x64.msi
[2]: https://libvirt.org/formatdomain.html
[3]: https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe
