os=`cat /etc/*-release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g'`
if [ "${os}" != '"Arch Linux"' ]; then
    echo "You must be using Arch Linux to execute this script."
    elif [ "${os}" == '"Arch Linux"' ]; then
    root=`whoami`
    case $root in
        "root")
 
            sudo rm -rf /var/lib/pacman/db.lck
            count=0
            max=3
            function clean_screen() {
                if [ "$count" -eq "$max" ]; then
                    clear
                    count=`expr $count - 3`
                    fi
            }
            clear
            function KERNEL_Preparation() {

                while true
                    do 

                    echo -e "\n===================================="
                    echo "[---]    Kernel Preparation    [---]"
                    echo -e "====================================\n"
                    #N1=1
                    #N2=2
                    echo -e "\nThe Default Kernel Is 'Stable Linux Kernel'...\n"
                    read -p  "Do You Want To Change It [Y/N] ? : " ask
                    ############################

                    case $ask in 
                        
                        y|Y|yes|Yes|YES)
                            clear
                            while true
                                do 
                                echo -e "\n================================="
                                echo "[---]     Linux Kernel      [---]"
                                echo -e "=================================\n"
                                echo -e "\n+[1] LTS Kernel" # 
                                echo  "+[2] Hardened Kernel" # 
                                echo -e "+[3] Zen Kernel\n" # 
                                read -p "Choose a Kernel Or Enter ['A'] To Install Them All : " KERNEL
                                case $KERNEL in 
                                "a"|"A")
                                    break ;;

                                "1"|"2"|"3")
                                    while true
                                        do 
                                        echo -e
                                        read -p "Do You Want To Remove The Default Kernel ? : " ask2
                                        case $ask2 in 
                                            y|Y|yes|Yes|YES)
                                                break ;;
                                            n|N|no|No|NO)
                                                break
                                                ;;
                                            *)
                                                echo -e "\n[-] Enter yes or no (y/n) [-]"
                                                echo "----------------------------------"
                                                count=`expr $count + 1`
                                                clean_screen;;
                                        esac
                                        
                                    done ;;
                                esac

                            done
                            break;;

                        n|N|no|No|NO)
                            break ;;

                        *)
                            echo ""
                            sleep 1
                            echo -e "\n[-] Choose an option from the options[-]"
                            echo "---------------------------------------------"
                            count=`expr $count + 1`
                            clean_screen ;;
                    esac
                done
            }
            KERNEL_Preparation
            clear
            function Boot_Setup() {
                

                case $ask2 in 
                    y|Y|YES|Yes|yes)
                        echo ""
                        while true 
                            do
                            echo -e "\n==============================="
                            echo "[---]     Boot Setup      [---]"
                            echo -e "===============================\n"
                            echo -e 
                            read -p "Do You Want To Have a Quick Boot Up ? : " ab # ask boot
                            case $ab in 
                                y|Y|yes|Yes|YES)
                                    break ;;
                                n|N|no|No|NO)
                                    break ;;
                                *)  
                                    echo -e "\n[-] Enter yes or no (y/n) [-]"
                                    echo "---------------------------------------" 
                                    count=`expr $count + 1`
                                    clean_screen ;;
                            esac
                        done
                        ;;
                esac  
            }
            Boot_Setup
            clear
            function Desktop_Setup() { 
                while true
                    do  
                    echo -e "\n======================================="
                    echo "[---]  Desktop Environment Setup  [---]"
                    echo -e "=======================================\n"
                    echo -e "\n+[1] GNOME  " # BIOS
                    echo -e  "+[2] XFCE4" # UFI
                    echo -e  "+[3] KDE_PLASMA\n" # UFI    
                    read -p "Choose A Desktop Environment : "  ENV
                    case $ENV in 
                        "1"|"2"|"3")
                            break ;;
                        *)
                            echo -e "\n[-] Choose an option from the options [-]"
                            echo "------------------------------------" 
                            count=`expr $count + 1`
                            clean_screen ;;
                    esac

                done
            }
            Desktop_Setup
            clear
            function Packages() {
                
                while true
                    do
                    echo -e "\n================================="
                    echo "[---]  Base Packages Setup   ---]"
                    echo -e "=================================\n"
                    echo -e "\n+[1] Main Packages  " 
                    echo -e  "+[2] Full base packages (take a time...)\n"
                    read -p "Choose Your Packages Install Mode : " PM #Package mode
                    if [ "$PM" == "1" ] ||  [ "$PM" == "2" ] ;then
                        break
                        else
                        sleep 0.8
                        echo -e "\n[+]Choose an option from the options[+]"
                        count=`expr $count + 1`
                        clean_screen
                    fi
                done
            }
            Packages
            clear 
            ########## START INSTALLATION ##################
            #__________ KERNEL LINUX CHOOSE
            echo -e "\n___Installation started  .......\n"
            sudo rm -rf /var/lib/pacman/db.lck
            sleep 1
            case $KERNEL in 
                "1")
                    # "lts"
                    sudo pacman -S linux-lts --noconfirm
                    sudo pacman -S linux-lts-headers --noconfirm
                    sudo grub-mkconfig -o /boot/grub/grub.cfg
                    ;;
                "2")  
                    # "herdand"
                    sudo pacman -S linux-hardened --noconfirm
                    sudo grub-mkconfig -o /boot/grub/grub.cfg
                    ;;
                "3")
                    # "zen" 
                    sudo pacman -S linux-zen --noconfirm
                    sudo grub-mkconfig -o /boot/grub/grub.cfg
                    ;;  
                "a"|"A")
                    echo "all kernel" 
                    sudo pacman -S linux-lts --noconfirm
                    sudo pacman -S linux-lts-headers --noconfirm
                    sudo pacman -S linux-hardened --noconfirm
                    sudo pacman -S linux-zen --noconfirm
                    echo "GRUB_DISABLE_SUBMENU=y" >> /etc/default/grub
                    echo "GRUB_DEFAULT=saved" >> /etc/default/grub
                    echo "GRUB_SAVEDEFAULT=true" >> /etc/default/grub
                    sudo grub-mkconfig -o /boot/grub/grub.cfg
                    ;;
            esac
            case $ask2 in 
                y|Y|YES|Yes|yes)
                    sudo pacman -Rs linux --noconfirm
                    sudo grub-mkconfig -o /boot/grub/grub.cfg
                    ;;
                n|N|NO|No|no)
                    echo "GRUB_DISABLE_SUBMENU=y" >> /etc/default/grub
                    echo "GRUB_DEFAULT=saved" >> /etc/default/grub
                    echo "GRUB_SAVEDEFAULT=true" >> /etc/default/grub
                    sudo grub-mkconfig -o /boot/grub/grub.cfg
                    ;;

            esac

            #__________ GRUB CONFIG


            case $ab in
                    y|Y|yes|Yes|YES)
                        echo 'GRUB_FORCE_HIDDEN_MENU="true"' >> /etc/deafult/grub
                        sudo rm -rf /etc/grub.d/31_hold_shift
                        cp 31_hold_shift /etc/grub.d/
                        sudo chmod a+x /etc/grub.d/31_hold
                        sudo grub-mkconfig -o /boot/grub/grub.cfg
                        ;;
            esac

            #____base packages install 

            case $PM in 
                "1")
                    PKGS=(
                    'intel-ucode'
                    'linux-firmware'
                    'firefox' #  Browser
                    'pulseaudio' #
                    'pulseaudio-alsa' # 
                    'xorg'
                    'xorg-xinit'
                    'xorg-server'
                    'xorg-apps'
                    'xorg-xkill'
                    'xorg-drivers' # 
                    'bash-completion'
                    'ufw' # 
                    'libreoffice'
                    'aria2' # 
                    'gedit' # video conferences
                    'conky'
                    'celluloid' # video player
                    'autojump'
                    'unzip'
                    'linux-firmware'
                    'code'
                    'cups'

                    )
                    for PKG in "${PKGS[@]}"; do
                        sudo pacman -S --noconfirm $PKG
                    done
                    ;;
                "2")
                    echo "full package"
                    PKGS=(
                    'ufw'
                    'xorg'
                    'xorg-xinit'
                    'xorg-server'
                    'xorg-apps'
                    'xorg-drivers'
                    'xorg-xkill'
                    'intel-ucode'
                    'linux-firmware'
                    'bash-completion'       # Tab completion for Bash
                    'curl'                  # Remote content retrieval
                    'file-roller'           # Archive utility
                    'gtop'                  # System monitoring via terminal
                    'gufw'                  # Firewall manager
                    'hardinfo'              # Hardware info app
                    'htop'                  # Process viewer
                    'neofetch'              # Shows system info when you launch terminal
                    'ntp'                   # Network Time Protocol to set time via network.
                    'numlockx'              # Turns on numlock in X11
                    'p7zip'                 # 7z compression program
                    'rsync'                 # Remote file sync utility
                    'speedtest-cli'         # Internet speed via terminal
                    'terminus-font'         # Font package with some bigger fonts for login terminal
                    'tlp'                   # Advanced laptop power management
                    'unrar'                 # RAR compression program
                    'unzip'                 # Zip compression program
                    'wget'                  # Remote content retrieval
                    'terminator'            # Terminal emulator
                    'vim'                   # Terminal Editor
                    'zenity'                # Display graphical dialog boxes via shell scripts
                    'zip'                   # Zip compression program
                    'zsh'                   # ZSH shell
                    'zsh-completions'       # Tab completion for ZSH

                    # DISK UTILITIES ------------------------------------------------------

                    'android-tools'         # ADB for Android
                    'android-file-transfer' # Android File Transfer
                    'btrfs-progs'           # BTRFS Support
                    'dosfstools'            # DOS Support
                    'exfat-utils'           # Mount exFat drives
                    'gparted'               # Disk utility
                    'gvfs-mtp'              # Read MTP Connected Systems
                    'gvfs-smb'              # More File System Stuff
                    'nautilus-share'        # File Sharing in Nautilus
                    'ntfs-3g'               # Open source implementation of NTFS file system
                    'parted'                # Disk utility
                    'samba'                 # Samba File Sharing
                    'smartmontools'         # Disk Monitoring
                    'smbclient'             # SMB Connection 
                    'xfsprogs'              # XFS Support

                    # GENERAL UTILITIES ---------------------------------------------------

                    'flameshot'             # Screenshots
                    'freerdp'               # RDP Connections
                    'libvncserver'          # VNC Connections
                    'nautilus'              # Filesystem browser
                    'remmina'               # Remote Connection
                    'veracrypt'             # Disc encryption utility
                    'variety'               # Wallpaper changer

                    # DEVELOPMENT ---------------------------------------------------------

                    'gedit'                 # Text editor
                    'clang'                 # C Lang compiler
                    'cmake'                 # Cross-platform open-source make system
                    'code'                  # Visual Studio Code
                    'electron'              # Cross-platform development using Javascript
                    'git'                   # Version control system
                    'gcc'                   # C/C++ compiler
                    'glibc'                 # C libraries
                    'meld'                  # File/directory comparison
                    'nodejs'                # Javascript runtime environment
                    'npm'                   # Node package manager
                    'python'                # Scripting language
                    'yarn'                  # Dependency management (Hyper needs this)

                    # MEDIA ---------------------------------------------------------------

                    'kdenlive'              # Movie Render
                    'obs-studio'            # Record your screen
                    'celluloid'             # Video player
                    
                    # GRAPHICS AND DESIGN -------------------------------------------------

                    'gcolor2'               # Colorpicker
                    'gimp'                  # GNU Image Manipulation Program
                    'ristretto'             # Multi image viewer

                    # PRODUCTIVITY --------------------------------------------------------

                    'hunspell'              # Spellcheck libraries
                    'xpdf'                  # PDF viewer
                
                    # MEDIA ---------------------------------------------------------------

                    'screenkey'                 # Screencast your keypresses

                    # THEMES --------------------------------------------------------------
                    'materia-gtk-theme'             # Desktop Theme
                    'papirus-icon-theme'            # Desktop Icons
                    #ANOTHER PACKAGES
                    'ark' # compression
                    'audiocd-kio'
                    'autoconf' # build
                    'automake' # build
                    'bind'
                    'bind'
                    'binutils'
                    'bison'
                    'bluedevil'
                    'bluez'
                    'bluez-libs'
                    'bluez-utils'
                    'breeze'
                    'breeze-gtk'
                    'bridge-utils'
                    'btrfs-progs'
                    'brave-bin' # Brave Browser

                    'xterm'

                    'dialog'
                    'discover'
                    'dosfstools'
                    'dtc'
                    'egl-wayland'
                    'exfat-utils'
                    'extra-cmake-modules'
                    'filelight'
                    'flex'
                    'fuse2'
                    'fuse3'
                    'fuseiso'
                    'gamemode'
                    'usbutils'
                    'vim'
                    'virt-manager'
                    'virt-viewer'
                    'wget'
                    'which'
                    'wine-gecko'
                    'wine-mono'
                    'winetricks'
                    'xdg-desktop-portal-kde'
                    'xdg-user-dirs'
                    'zeroconf-ioslave'
                    'zip'
                    'zsh'
                    'zsh-syntax-highlighting'
                    'zsh-autosuggestions'
                    'python-notify2'
                    'python-psutil'
                    'python-pyqt5'
                    'python-pip'
                    'qemu'
                    'rsync'
                    'sddm'
                    'sddm-kcm'
                    'snapper'
                    'spectacle'
                    'steam'
                    'sudo'
                    'swtpm'
                    'synergy'
                    'systemsettings'
                    'terminus-font'
                    'traceroute'


                    'pulseaudio'
                    'pulseaudio-alsa'
                    'pulseaudio-bluetooth'

                    'p7zip'
                    'pacman-contrib'
                    'patch'
                    'picom'
                    'pkgconf'
                    'libtool'
                    'linux'
                    'linux-firmware'
                    'linux-headers'
                    'lsof'
                    'lutris'
                    'lzop'
                    'm4'
                    'make'
                    'milou'
                    'nano'
                    'neofetch'
                    'networkmanager'
                    'ntfs-3g'
                    'ntp'
                    'okular'
                    'openbsd-netcat'
                    'openssh'
                    'os-prober'
                    'gst-plugins-good'
                    'gst-plugins-ugly'
                    'gwenview'
                    'haveged'
                    'htop'
                    'iptables-nft'
                    'jdk-openjdk' # Java 17
                    'kate'
                    'kcodecs'
                    'kcoreaddons'
                    'kdeplasma-addons'
                    'kde-gtk-config'
                    'kinfocenter'
                    'kscreen'
                    'kvantum-qt5'
                    'kitty'
                    'konsole'
                    'kscreen'
                    'layer-shell-qt'
                    'libdvdcss'
                    'libnewt'
                    'gparted' # partition management
                    'gptfdisk'
                    'grub'
                    'grub-customizer'
                    'gst-libav'
                    'extra-cmake-modules'
                    'filelight'
                    'flex'
                    'fuse2'
                    'fuse3'
                    'fuseiso'
                    'exfat-utils'
                    
                    'dxvk-bin' # DXVK DirectX to Vulcan
                    'github-desktop-bin' # Github Desktop sync
                    'lightly-git'
                    'lightlyshaders-git'
                    'mangohud' # Gaming FPS Counter
                    'mangohud-common'
                    'nerd-fonts-fira-code'
                    'nordic-darker-standard-buttons-theme'
                    'nordic-darker-theme'
                    'nordic-kde-git'
                    'nordic-theme'
                    'noto-fonts-emoji'
                    'papirus-icon-theme'
                    'plasma-pa'
                    'ocs-url' # install packages from websites
                    'sddm-nordic-theme-git'
                    'snapper-gui-git'
                    'ttf-droid'
                    'ttf-hack'
                    'ttf-meslo' # Nerdfont package
                    'ttf-roboto'
                    'zoom' # video conferences
                    'snap-pac'

                    )
                    for PKG in "${PKGS[@]}"; do
                        sudo pacman -S --noconfirm $PKG
                    done
                    ;;
            esac
            # determine processor type and install microcode
            proc_type=$(lscpu | awk '/Vendor ID:/ {print $3}')
            case "$proc_type" in
                GenuineIntel)
                    print "Installing Intel microcode"
                    pacman -S --noconfirm intel-ucode
                    proc_ucode=intel-ucode.img
                    ;;
                AuthenticAMD)
                    print "Installing AMD microcode"
                    pacman -S --noconfirm amd-ucode
                    proc_ucode=amd-ucode.img
                    ;;
            esac	

            # Graphics Drivers find and install
            if lspci | grep -E "NVIDIA|GeForce"; then
                pacman -S nvidia --noconfirm --needed
                nvidia-xconfig
            elif lspci | grep -E "Radeon"; then
                pacman -S xf86-video-amdgpu --noconfirm --needed
            elif lspci | grep -E "Integrated Graphics Controller"; then
                pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils --needed --noconfirm
            fi

            #___Desktop Environment 
            case $ENV in 
                "1")
                    #gnome
                    sudo pacman -S gnome --noconfirm
                    systemctl stop --now lightdm.service
                    systemctl disable --now lightdm.service
                    systemctl stop --now sddm.service
                    systemctl disable  --now sddm.service
                    sudo ufw enable --now
                    sudo systemctl enable --now ufw.service
                    systemctl enable --now gdm.service
                    systemctl start --now gdm.service

                    ;;
                "2")
                    # "xfce4"
                    sudo pacman -S  xfce4 xfce4-goodies --noconfirm
                    systemctl stop --now gdm.service
                    systemctl disable --now gdm.service
                    systemctl stop --now sddm.service
                    systemctl disable --now sddm.service
                    sudo ufw enable --now
                    sudo systemctl enable --now ufw.service
                    echo "exec startxfce-4" > ~/.xinitrc
                    systemctl enable --now lightdm.service
                    systemctl start --now lightdm.service
                    ;;
                "3")
                    # "KDE"
                    sudo pacman -S xorg plasma plasma-wayland-session kde-applications --noconfirm
                    systemctl stop --now lightdm.service
                    systemctl disable --now lightdm.service
                    systemctl stop --now gdm.service
                    systemctl disable --now gdm.service
                    systemctl enable --now sddm.service
                    sudo ufw enable --now
                    sudo systemctl enable --now ufw.service
                    systemctl start --now sddm.service
                    ;;
            esac
            ;;
        *)
            echo "You Must Be a Root User To Successfully Complete a Process !! "
            ;;
    esac
fi
