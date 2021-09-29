echo -e "\nInstalling git (for next steups)...\n"
pacman -S --noconfirm git

echo "en_US.UTF-8 UTF-8" >> /etc/local.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "--------------------------------------"
echo "--          Host Setup           --"
echo "--------------------------------------"

echo -e "\nEnter your Host name (Ex:archPc) :"
read HostN
echo "$HostN" > /etc/hostname
echo "127.0.1.1	  localhost.localdomin	  $HostN" > /etc/hosts

echo "--------------------------------------"
echo "--          Network Setup           --"
echo "--------------------------------------"

pacman -S networkmanager dhclient --noconfirm --needed
systemctl enable --now NetworkManager

echo "--------------------------------------"
echo "-- Bootloader Systemd Installation  --"
echo "--------------------------------------"
pacman -S --noconfirm efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --removable
grub-makconfig -o /boot/grub/grub.cfg

echo "--------------------------------------"
echo "--      Set Password for Root       --"
echo "--------------------------------------"
echo "Enter password for root user: "
passwd root
exit
