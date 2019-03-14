%include fedora-kickstarts/fedora-live-cinnamon.ks
%include fedora-kd-base.ks

%post
cat >> /usr/share/glib-2.0/schemas/99_my_custom_settings.gschema.override << FOE
[x.dm.slick-greeter]
background='/usr/share/user_file/resource/TCP118v1_by_Tiziano_Consonni.jpg'
background-color='#2ceb26'
logo='/usr/share/user_file/resource/login_logo.png'
draw-user-backgrounds=false
draw-grid=false
enable-hidpi='auto'
font-name='Noto Sans 11'
icon-theme-name='Mint-Y-Aqua'
show-hostname=true
theme-name='Mint-Y-Dark-Aqua'
show-clock=true
FOE

glib-compile-schemas /usr/share/glib-2.0/schemas/

%end