# ------------------------------ COLORS CODE -------------------------------------------------------------#

r="\e[0;91m"  #> red
b="\e[0;94m"  # > blue
y="\033[1;33m" #>Yellow#
g="\e[0;92m" #> green
w="\e[0;97m" #> white
bo="\e[1m" #> bold
u="\e[4m" #> uline
rt="\e[0m" #> reset
p='\033[0;35m' #> Purple

SL=${p}${bo}[${rt}${b}${bo}-${rt}${p}${bo}]${rt}  #Start of Some Menu
SL1=${p}${bo}[${rt}${y}${bo}1${rt}${p}${bo}]${rt} #Start of Numbers Menus (1)
SL2=${p}${bo}[${rt}${y}${bo}2${rt}${p}${bo}]${rt} #Start of Numbers Menus (2)
StM=${b}${bo}[${p}${bo}---${rt}${b}${bo}]${rt}${w}${bo} #Start Menu show Table  (partition)
EnM=${b}${bo}[${p}${bo}---${rt}${b}${bo}]${rt} # End Menu show Table (partition)

SE=${r}${bo}[${rt}${y}${bo}!${rt}${r}${bo}]${rt}${w}${bo}${u} #Start Exclamation error 
EE=${rt}${r}${bo}[${rt}${y}${bo}!${rt}${r}${bo}]${rt} #End of Exclamation error 
#
SM=${r}${bo}[${rt}${y}${bo}-${rt}${r}${bo}]${rt}${w}${bo}${u} #Start of the Minus sign error
EM=${rt}${r}${bo}[${rt}${y}${bo}-${rt}${r}${bo}]${rt} #End of Minus sign error 
#
SP=${g}${bo}[${rt}${y}${bo}+${rt}${g}${bo}]${rt}${w}${bo} #Start of the success of a Positive sign
EP=${rt}${g}${bo}[${rt}${y}${bo}+${rt}${g}${bo}]${rt} #End of the success of a Positive sign

#------------------------------------------------------------------------------------------------------------#
chmod a+x help.sh
clear
sleep 2
echo -e "\n${p}${bo}
 ░░░░░  ░░░░░░   ░░░░░░ ░░░░░░░░ ░░    ░░ ░░░░░░░ 
▒▒   ▒▒ ▒▒   ▒▒ ▒▒         ▒▒    ▒▒    ▒▒ ▒▒      
▒▒▒▒▒▒▒ ▒▒▒▒▒▒  ▒▒         ▒▒    ▒▒    ▒▒ ▒▒▒▒▒▒▒${rt}
${b}${bo}▓▓   ▓▓ ▓▓   ▓▓ ▓▓         ▓▓    ▓▓    ▓▓      ▓▓ 
██   ██ ██   ██  ██████    ██     ██████  ███████${rt} 
"
##_________________________________________WELCOM TO "ARCTUS" __________________________________________________________________##

os=`cat /etc/*-release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g'`
if [ "${os}" != '"Arch Linux"' ]; then
    echo -e "\n${SE}You must be using Arch Linux to execute this script.${EE}"
    break
elif [ "${os}" == '"Arch Linux"' ]; then
    sleep 3
    #------In order to partition a disk----#
    echo -e "\nInstalling prereqs...\n"
    pacman -S --noconfirm gptfdisk btrfs-progs
    clear
    ### to make clean screen with limit trying 
    count=0
    max=2
    # source the function 
    
    pwd=`pwd`

    source $pwd/func/Hard_disk_selection
    source $pwd/func/EDIT_HARD_DISK
    source $pwd/func/Format_The_Hard_Disk
    source $pwd/func/Direct_Boot_Mode

    #################

    source $pwd/func/Determine_Size
    source $pwd/func/Extender
    source $pwd/func/Check_Of_Extender
    source $pwd/func/MS_PART
    source $pwd/func/GPT
    source $pwd/func/END
    source $pwd/func/ESP
    source $pwd/func/Correctly_DISK
    source $pwd/func/Sections_Format
    source $pwd/func/Mount_Points
 
    function clean_screen() {
        if [ "$count" -eq "$max" ]; then
            clear
            count=`expr $count - 2`
            fi
    }

    Hard_disk_selection

    
    EDIT_HARD_DISK
    
    
    Format_The_Hard_Disk
    

    #-----Select live boot type------#
    
    
    Direct_Boot_Mode

    
        #Determine_Size

        
        #Extender
        
        
        # Check_Of_Extender



    #MS_PART

#------    CREATE GPT PARTITIONS ON BIOS & UEFI MODE -------#

    
    #GPT

    

    #END 
    
    #EFI System Partition 

    if [ "$MODE" == "BIOS" ]  ######### IF IS BIOS MODE #######
        then       
        clear
        Determine_Size
        Extender
        clear
        echo -e ""
        DT=`sudo parted ${DISK} print | grep -i '^Partition Table' | sed 's/Partition Table: //g'`
        if [ "${DT}" == 'msdos' ]; then
            
            MS_PART
            
            Correctly_DISK
            
            Sections_Format

            
            Mount_Points
            clear
            END
        #___________________IF IS GPT ON BIOS _______________#
        elif [ "${DT}" == 'gpt' ]; then
            GPT
            Correctly_DISK

            
            Sections_Format
            Mount_Points
            clear
            END
        fi


####______________________________________________________________________________________________________________________##### 
####______________________________________________________________________________________________________________________#####  

    elif [ "$MODE" == "UEFI" ] # ---------- IF IS UEFI MODE ---------#
        then
        clear
        Determine_Size
        Extender
        clear
        #_____________________ IF MSDOS ON UEFI __________________# 

        DT=`sudo parted ${DISK} print | grep -i '^Partition Table' | sed 's/Partition Table: //g'`
        if [ "${DT}" == 'msdos' ]; then
            MSPART
           Correctly_DISK
            
            Sections_Format
            Mount_Points
            mkdir /mnt/boot
            mkdir /mnt/boot/efi
            mount "${DISK}${EFI}" /mnt/boot/efi
            clear
            END

            #________________________IF IS GPT ON UEFI _______________#
        elif [ "${DT}" == 'gpt' ]; then
            
            ESP
            GPT  
            Correctly_DISK
            
            Sections_Format

    
            Mount_Points
            mkdir /mnt/boot
            mkdir /mnt/boot/efi
            mount "${DISK}${EFI}" /mnt/boot/efi
            clear
            END    
        fi 
    fi
fi

##______________________________________________ENJOY WITH ARCH LINUX NOW ______________________________________##


