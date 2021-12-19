clear
echo "
 █████╗ ██████╗  ██████╗████████╗██╗   ██╗███████╗
██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██║   ██║██╔════╝
███████║██████╔╝██║        ██║   ██║   ██║███████╗
██╔══██║██╔══██╗██║        ██║   ██║   ██║╚════██║
██║  ██║██║  ██║╚██████╗   ██║   ╚██████╔╝███████║
╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝   ╚═╝    ╚═════╝ ╚══════╝
" 
##_________________________________________WELCOM TO "ARCTUS" __________________________________________________________________##

os=`cat /etc/*-release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g'`
if [ "${os}" != '"Arch Linux"' ]; then
    echo -e "\nYou must be using Arch Linux to execute this script."
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
    function clean_screen() {
        if [ "$count" -eq "$max" ]; then
            clear
            count=`expr $count - 2`
            fi
    }
    while true
    do
    echo -e "\n======================================================"
    echo "[---]     Select Your Disk To Installation       [---]"
    echo -e "======================================================\n"
    lsblk
    echo -e "\nPlease Enter Disk: (example /dev/sda)\n"
    read DISK
    if [ "$DISK" == "" ] 
        then
        echo -e "\n[-] Choose The Disk To Install To !!![-]\n"
        sleep 1
        count=`expr $count + 1`
        sleep 1
        clean_screen
       
        else
            echo -e ""
            read -p "Please confirm [y/n] : " HDC #HARD DISK CONFIRM 
            case $HDC in 
                y|Y|yes|Yes|YES)
                    break ;;
                n|N|no|No|NO)
                    sleep 3
                    clear ;;
                *)
                    echo -e "\n[+] ENTER 'Yes' or 'No' !!! [+]\n"
                    count=`expr $count + 1` 
                    sleep 1 
                    clean_screen  ;;
            esac
       
    fi
    done
    count=0
    clear
    function EDIT_HARD_DISK() {
        while true
            do
            echo -e "\n[+]Note: This is a script that cannot detect if there is space available for installation[+]"
            echo "..or if an extender already exists"
            echo "[+]So you have to make sure that you have enough space and that there is no pre-expanded in the next stage. [+]"
            echo -e "\nPress Enter To Continue"
            read CN #Confirm Note
            case $CN in 
                "")
                    
                    while true
                        do
                        echo -e "\n====================================="
                        echo "[---]     Hard Disk Editor      [---]"
                        echo -e "=====================================\n"
                        echo -e ""
                        read -p "Do You Want To Modify a Hard Disk [Y/N] ? : " HDEC # HARD DISK EDIT CONFIRM 
                        case $HDEC in 
                            y|Y|yes|Yes|YES)
                                    clear
                                    while true
                                        do
                                        echo -e "\nChoose Tool for Managing Hard Disk Partitions.\n"
                                        echo "**********"
                                        echo "[-]fdisk"
                                        echo "[-]cfdisk"
                                        echo "[-]parted"
                                        echo "[-]cgdisk"
                                        echo -e "\n***********\n"
                                        read -p "Enter Your Favorite Tool : " TOOL ## TOOL TO EDIT DISK
                                        case $TOOL in 
                                            fdisk|cfdisk|parted|cgdisk)
                                                $TOOL ${DISK}
                                                break
                                                ;;
                                            "")
                                                echo -e "\n[-] Sorry, Choose One From Them !!! [-]\n"
                                                sleep 1
                                                count=`expr $count + 1`
                                                clean_screen
                                                ;;
                                            *)
                                                echo -e "\n[-] Enter The Tool Name Correctly!!! [-]\n"
                                                sleep 1
                                                count=`expr $count + 1`
                                                clean_screen
                                        esac
                                    done
                                    break              
                                    ;;

                            n|N|no|No|NO)
                                break
                                ;;
                            *)
                                echo -e "\n[+] ENTER 'Yes' or 'No' !!! [+]\n"
                                count=`expr $count + 1` 
                                sleep 1 
                                clean_screen 
                                ;;                      
                        esac
                        clean_screen
                    done
                *)  
                    clear ;;

            esac
        done
    }
    EDIT_HARD_DISK
    clear
    count=0
    function Format_The_Hard_Disk (){
            while true
                do 
                echo -e "\n====================================="
                echo "[---]     Hard Disk Usage       [---]"
                echo -e "=====================================\n"
                echo -e ""
                echo "[1] Use it all and format the hard drive."
                echo "[2] Use only free disk space."
                echo -e ""
                read -p "Do you want to use all disk for installation or just free space : " HDU  #Hard Disk Usage
                #clear
                if [ "$HDU" == "1" ]; then 
            
                    clear
                    sgdisk -Z ${DISK} # zap all on disk
                    clear
                    while true 
                        do
                        echo -e "\n============================================"
                        echo "[---]  Hard disk partition table type  [---]"
                        echo -e "============================================\n"
                        echo "[1] GPT"
                        echo "[2] MSDOS"
                        echo -e ""
                        read -p "Do you want a 'GPT' or 'MSDOS' table for your hard disk : " HDT  #Hard Disk Table
                        case $HDT in 
                        "1")
                            clear
                            sgdisk -a 2048 -o ${DISK} 
                            break
                            ;;

                        "2")
                            clear
                            echo "o
                            w
                            " | fdisk ${DISK}
                            break
                            ;;

                        *)
                            echo -e "\n[-] ENTER One '1' Or Two '2' !!![-]\n"
                            count=`expr $count + 1`
                            sleep 1
                            clean_screen
                            ;;
                        esac
                        clean_screen
                    done    
                    break
                
                elif [ "$HDU" == "2" ]; then
                    count=0
                    function Available_Table() {
                        AODT=`sudo parted ${DISK} print | grep -i '^Partition Table' | sed 's/Partition Table: //g'` #Availability Of Disk Table 
                        clear
                        case $AODT in
                            "unknown")
                                    while true
                                        do
                                        echo -e "\n============================================"
                                        echo "[---]  Hard disk partition table type  [---]"
                                        echo -e "============================================\n"
                                        echo "You don't have any hard disk table, Choose one"
                                        echo -e ""
                                        echo "[1] MSDOS"
                                        echo "[2] GPT"
                                        read -p "Your Choice : " NHDT #New Hard Disk Table
                                        case $NHDT in 
                                            "1")
                                                clear
                                                echo "o
                                                w
                                                "| fdisk ${DISK}
                                                break
                                                ;;
                                            "2")
                                                clear
                                                sgdisk -a 2048 -o ${DISK} 
                                                break
                                                ;;
                                            *)
                                                echo -e "\n[-] Choose Number 'One' or 'Two' [-]\n"
                                                count=`expr $count + 1`
                                                sleep 1
                                                clean_screen
                                                ;;
                                        esac
                                        clean_screen
                                        
                                    done
                                    ;; 
                                *)
                                    break
                                    ;;
                        esac

                    }
                    Available_Table
                    break 
                else
                echo -e "\n[-] Choose Number 'One' or 'Two' [-]\n"
                count=`expr $count + 1`
                sleep 1
                clean_screen
                fi
                
            done
                
    }
    Format_The_Hard_Disk
    clear

    #-----Select live boot type------#
    count=0
    function Direct_Boot_Mode () {   

        Mode=`ls /sys/firmware/efi`
        clear
        echo -e "\n================================"
        echo "[---]    Live Boot Type    [---]"
        echo -e "================================\n"
        if $Mode >/dev/null 2>&1; then
                MODE="BIOS"
        else
                MODE="UEFI"
        fi
    }
    Direct_Boot_Mode
    function CHECK_MODE() {
        while true
            do 
            echo -e "\n[+]THE CURRENT BOOT MODE IS {'${MODE}'} ?[+]\n"
            read -p "Please confirm [y/n] : " CM #Confirm MODE
            case $CM in 
                y|Y|yes|Yes|YES)
                    break
                    ;;

                n|N|no|No|NO)
                    clear
                    while true
                        do 
                                
                        echo -e "\n========================================"
                        echo "[---]   Select Your Boot Type      [---]"
                        echo -e "========================================\n"
                        echo -e "\n+[1] BIOS Mode" # BIOS
                        echo -e  "+[2] UEFI Mode\n" # UEFI
                        read -p  "Enter Number : " MODE
                        case $MODE in 
                            "1")
                                 Mode="BIOS"
                                echo ""
                                echo -e "\n[+]The Boot Mode In Which The Installation Will Be Performed Is ${MODE}.[+] ."
                                echo "[+]If it is not correct, try restarting the script and try again[+]."
                                ;;
                            "2")
                                Mode="UEFI"
                                echo ""
                                echo -e "\n[+]The Boot Mode In Which The Installation Will Be Performed Is ${MODE}.[+] ."
                                echo "[+]If it is not correct, try restarting the script and try again[+]."
                                sleep 4 ;;

                            *)
                                echo -e "\n[-] Choose Number One '1' or Two '2' [-]\n"
                                count=`expr $count + 1`
                                clean_screen ;;
                        esac
                        break             
                    done
                    break
                    ;;
                "")
                    echo -e "\n[+] Default Choose {'${MODE}'} [+]"
                    sleep 5
                    break ;;

                *)
                    echo -e "\n[-] ENTER 'Yes' or 'No' !!![-]\n"
                    count=`expr $count + 1`
                    clean_screen
                    ;;
            esac
            clean_screen 
        done
    }
    CHECK_MODE
        
    function Determine_Size() {

        #_____Determine the size of the root partition____#
        count=0
        while true
            do
            echo -e "\n======================================================"
            echo "[---]  Determine the size of the Home partition  [---]"
            echo -e "======================================================\n"
            echo -e "\nNote:Enter Just The Number And Without GB or MB on Next steps"
            read -p "Please Enter Size For Root Partition : " RooP #Root Partition
            if [ -z "${RooP//[0-9]/}" -a ! -z "$RooP" ]; then 
                    echo "${RooP}"
                    break
            elif [ -z "${RooP##*[!0-9]*}" ]; then
                    echo -e "\n[-] Enter Just The Number And Without GB or MB. [-]"
                    count=`expr $count + 1`
            else
                    echo -e "\n[-] You Must Enter Root Partition Size !!![-]\n"
                    count=`expr $count + 1`
            fi
            clean_screen
                
        done
        clear
        count=0       
        #____Determine the size of the home partition___#
        while true
            do
            echo -e "\n=========================================="
            echo "[---]  Select Create Home Partition  [---]"
            echo -e "==========================================\n"
            read  -p "Please do you want create home part or not [y/n] : " CH #Create  Home 
            case $CH in 
                y|Y|YES|Yes|yes)

                    clear
                    echo -e 
                    #echo -e "Note: Enter Values in 'MB' or 'GB' on Next step\n "
                    while true
                        do
                        count=0
                        echo -e "\n======================================================"
                        echo "[---]  Determine The Size of The Home Partition  [---]"
                        echo -e "======================================================\n"
  
                        read -p "Enter Your Home Partition Size Please : " Homep #Home Partition
                        if [ -z "${Homep//[0-9]/}" -a ! -z "$Homep" ]; then
                                break
                        elif [ -z "${Homep##*[!0-9]*}" ]; then
                                echo -e "\n[-] Enter Just The Number And Without GB or MB. [-]"
                                count=`expr $count + 1`
                        else 
                                echo "\n[-] Enter Valid Value !![-]\n"
                                count=`expr $count + 1`
                        fi
                        clean_screen
                           
                    done
                    echo -e 
                    break
                    ;;
                n|no)
                        break
                        ;;
                        *) 
                            echo -e "\n[-] ENTER 'Yes' or 'No' !!![-]\n"
                            count=`expr $count + 1`
                            clean_screen
                            ;;
            esac
        done
        clear
        count=0
        #_____Determine the size of the swap partition__#

        while true
            do
            echo -e "\n=========================================="
            echo "[---]  Select Create swap Partition  [---]"
            echo -e "==========================================\n"
            read  -p "Please Do You Want Create Swap Part Or Not [y/n] : " CS #Create swap 
            case $CS in 
                y|Y|YES|Yes|yes)
                    clear
                    echo -e 

                    while true
                        do
                        count=0
                        echo -e "\n======================================================"
                        echo "[---]  Determine The Size of the Swap Partition  [---]"
                        echo -e "======================================================\n"
                        read -p "Enter Your Swap Partition Size Please : " Swp # Swap Partition
                        if [ -z "${Swp//[0-9]/}" -a ! -z "$Swap" ]; then
                                break
                        elif [ -z "${Swp##*[!0-9]*}" ]; then
                                echo -e "\n[-] Enter Just The Number And Without GB or MB. [-]"
                                count=`expr $count + 1`
                        else 
                                echo "\n[-] Enter Valid Value !![-]\n"
                                count=`expr $count + 1`
                        fi
                        clean_screen              
                    done
                    echo -e 
                    break
                    ;;
                n|N|NO|No|no)
                    break
                    ;;
                *) 
                    echo -e "\n[-] Enter yes or no (y/n) [-]"
                    count=`expr $count + 1`
                    clean_screen
                    ;;
            esac
        done
        }
        #Determine_Size

        function Extender() {

            case $CH in 
                y|Y|yes|Yes|YES)

                    case $CS in 
                        y|Y|yes|Yes|YES)
                                ES=`expr ${RooP} + ${Homep} + ${Swp}` ;; ###Extender Size
                    esac 
                    case $CS in 
                        n|N|no|No|NO)
                                ES=`expr ${RooP} + ${Homep}`;;
                    esac
                    ;;
                n|N|no|No|NO)

                    case $CS in 
                        y|Y|yes|Yes|YES)
                                ES=`expr ${RooP} + ${Swp}` ;;
                    esac
                    case $CS in 
                        n|N|no|No|NO)
                                ;;
                    esac
                    ;;
            esac
        } 
        #logic
        
        function Check_Of_Extender() {
        while true
            do 
            count=0
            echo -e "\n========================================"
            echo "[---]  Total Size For Installation  [---]"
            echo -e "========================================\n"
            echo -e "\nIs This The Total Volume For The Operation ${ES}GB ?\n"
            read -p "Enter 'Yes' To Continue or 'No' To Edit Size : " CES #Confirme Extender Size
            case $CES in 
                y|Y|yes|Yes|YES)
                        break
                        ;;

                n|N|no|No|NO)
                        clear
                        while true
                            do 
                            count=0
                            echo -e "\n================================"
                            echo "[---]     Overall Size     [---]"
                            echo -e "================================\n"
                            echo -e "On Next Step GB Is Default\n"
                            read -p "Enter The Size With (number only): " ES
                            if [ -z "${ES//[0-9]/}" -a ! -z "$ES" ]; then
                                    clear
                                    echo -e "\n[+]The size for the process is ${ES}GB.[+] ."
                                    echo "[+]If it is not correct, try restarting the script and try again[+]."
                                    break
                            else 
                                    echo -e "\n[-] Enter Just The Number Without GB or Valid Value !![-]\n"
                                    count=`expr $count + 1`
                            fi
                            clean_screen
                        done
                        break
                        ;;
                *)
                        echo -e "\n[-] ENTER 'yes' or 'no' !!![-]\n"
                        count=`expr $count + 1`
                        ;;
            esac
            clean_screen 
        done

        }
        # Check_Of_Extender


    #####################################################################################################################

    #  NOTE: Every line Here Is Important Even If It Is Empty. If You Delete Any Line Here, It Will Be A Problem
    #               You Must Understand How the "FDISK" Partition Works To Understand It

    ################################################################################################################## 

        
 #------    CREATE MSDOS PARTITIONS ON BIOS & UEFI MODE -------#

    function MS_PART () {
    
        function MSDOS(){
                        
            Check_Of_Extender
            echo "n
            e
            
            
            +${ES}GB
            w
            "| fdisk ${DISK}
            if [ "$MODE" == "UEFI" ]; then
                    #___ efi part
                echo "n
                l
                
                +512M
                w
                " | fdisk ${DISK}
                EFI=`sudo partx -rgo NR -n -1:-1 ${DISK}`
            fi
            echo "n  
            l
            
            +${RooP}GB
            w
            " | fdisk ${DISK}
            ROOT=`sudo partx -rgo NR -n -1:-1 ${DISK}`

            case $CH in 
                y|Y|yes|Yes|YES)

                    case $CS in 
                        y|Y|yes|Yes|YES)
                            echo "
                            n
                            l
                            
                            +${Homep}GB
                            w
                            "| fdisk ${DISK}  
                            HOME=`sudo partx -rgo NR -n -1:-1 ${DISK}`
                                                                                                    
                            echo "
                            n
                            l
                            
                            
                            +${Swp}GB
                            w
                            "| fdisk ${DISK}
                            SWAP=`sudo partx -rgo NR -n -1:-1 ${DISK}`;;

                    esac 
                    case $CS in 
                        n|N|no|No|NO)
                            echo "
                            n
                            l
                            
                            
                            +${Homep}GB
                            w
                            "| fdisk ${DISK}
                            HOME=`sudo partx -rgo NR -n -1:-1 ${DISK}`;;
                    esac
                    ;;

                n|N|no|No|NO)

                    case $CS in 

                        y|Y|yes|Yes|YES)
                            echo "
                            n
                            l
                            
                            
                            +${Swp}GB
                            w
                            "| fdisk ${DISK}
                            SWAP=`sudo partx -rgo NR -n -1:-1 ${DISK}` ;;
                    esac

                    case $CS in 
                        n|N|no|No|NO) 
                            ;;
                                ### If Home And Swap Not Created
                    esac
                    ;;

            esac
            }

            case $CH in
                n|N|no|No|NO)
                    case $CS in
                        n|N|no|No|NO)

                            echo "
                            n
                            p


                            +${RooP}GB
                            w
                            "| fdisk ${DISK} 
                            ROOT=`sudo partx -rgo NR -n -1:-1 ${DISK}`
                            ;;
                        *)
                            MSDOS
                            ;;

                    esac
                    ;;
                *)
                    MSDOS
                    ;;
                esac
    }
    #MS_PART

#------    CREATE GPT PARTITIONS ON BIOS & UEFI MODE -------#

    function GPT(){
        echo "
        n  


        +${RooP}GB
        w
        " | fdisk ${DISK}
        ROOT=`sudo partx -rgo NR -n -1:-1 ${DISK}`

        case $CH in 
            y|Y|yes|Yes|YES)

                case $CS in 
                    y|Y|yes|Yes|YES)

                        echo "n


                        +${Homep}GB
                        w
                        " | fdisk ${DISK}  
                        HOME=`sudo partx -rgo NR -n -1:-1 ${DISK}`
                                                        #____home
                        echo "
                        n


                        +${Swp}GB
                        w
                        " | fdisk ${DISK}
                        SWAP=`sudo partx -rgo NR -n -1:-1 ${DISK}` ;;

                esac 
                case $CS in 
                    n|N|no|No|NO)
                        echo "
                            n
                            
                            
                            +${Homep}GB
                            w
                            " | fdisk ${DISK}
                            HOME=`sudo partx -rgo NR -n -1:-1 ${DISK}` ;;
                esac
                ;;

            n|N|no|No|NO)

                case $CS in 
                    y|Y|yes|Yes|YES)

                        echo "
                        n


                        +${Swp}GB
                        w
                        " | fdisk ${DISK}
                        SWAP=`sudo partx -rgo NR -n -1:-1 ${DISK}` ;;

                esac

                case $CS in 
                    n|N|no|No|NO) 
                        ;;

                esac
                ;;
        esac   
                        
    }
    #GPT

    function Sections_Format() {

        echo "y" | mkfs.ext4 "${DISK}${ROOT}"
        case $CH in 
            y|Y|yes|Yes|YES)

                case $CS in 
                    y|Y|yes|Yes|YES)
                                    
                        echo "y" | mkfs.ext4 "${DISK}${HOME}" #partition (Home)
                        mkswap "${DISK}${SWAP}" #partition (Swap)
                        swapon "${DISK}${SWAP}" ;;

                esac 
                case $CS in 
                    n|N|no|No|NO)
                        echo "y" | mkfs.ext4 "${DISK}${HOME}" ;;
                esac
                ;;

            n|N|no|No|NO)

                case $CS in 
                    y|Y|yes|Yes|YES)
                                    
                        mkswap "${DISK}${SWAP}" 
                        swapon "${DISK}${SWAP}";;
                esac

                case $CS in 
                    n|N|no|No|NO)
                        ;;
                            
                esac
                ;;
        esac 
    }
    #Sections_Format

    function Mount_Points () {
                
        mount "${DISK}${ROOT}" /mnt
        case $CH in 
            y|Y|yes|Yes|YES)
                mkdir /mnt/home
                mount "${DISK}${HOME}" /mnt/home ;;

            n|N|no|No|NO)
                        
                ;;
        esac
    }
    #Mount Points

    function END() { 
                
        lsblk
        echo -e "\n"
        echo "----------------------------------------------------------------"
        echo "--   If you did not do the division correctly      -------------"
        echo "--           Stop Script with (CTRL + Z)           -------------"
        echo "           And run the script 'help.sh'             ------------"
        echo "----------------------------------------------------------------"
        echo "or read the steps mentioned in it and execute them manually  ---"
        echo "--                and try again                           ------"
        echo "----------------------------------------------------------------"
        sleep 20
        clear
        echo "==========================================="
        echo "[---]   Arch Install on Main Drive    [---]"
        echo "==========================================="
        pacstrap /mnt --noconfirm base base-devel linux linux-firmware vim nano sudo micro
        genfstab -U /mnt >> /mnt/etc/fstab

        #### To prepare step 2 ####
        cp ~/Arctus/step2.sh /mnt/
        chmod a+x /mnt/step2.sh
        echo "$DISK" > /mnt/ID
        echo "$MODE" > /mnt/GrubID
        pwd=`pwd`
        sed -i 's/ROOT=.*/ROOT='${ROOT}'/' ${pwd}/help.sh
        sed -i 's/SWAP=.*/SWAP='${SWAP}'/' ${pwd}/help.sh
        chmod a+x help.sh
        clear
        echo "-------------------------------------------------------------"
        echo "--    You Should Run Step 2 After It Be Ready (./step2)  --"
        echo "-------------------------------------------------------------"
        sleep 4
        echo -e "\n----------------------------"
        echo    "------   It Ready !!    ----"
        echo    "----------------------------"
        arch-chroot /mnt 

        #---After arch-chroot---#
        umount -R /mnt
        clear
        echo "--------------------------------------"
        echo "--   SYSTEM READY FOR FIRST BOOT    --"
        echo "--------------------------------------"
        echo "--          Reboot Now              --"
        break
    }

    #END 
    function ESP() {
        #___ efi part
        echo "n


        +512M
        w
        " | fdisk ${DISK}
        EFI=`sudo partx -rgo NR -n -1:-1 ${DISK}`

    }
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
        #___________________IF IS GPT ON BIOS _______________#
        elif [ "${DT}" == 'gpt' ]; then
            ESP
            GPT

        fi

        ##__________________SELECT CONVERT TO __________________#
        sleep 1
        Sections_Format
        #_____________ MOUNT THE POINTS PARTITIONS  _______________#

        Mount_Points
        clear
#______________________________END WORK_________________________________#
        END

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
            clear

            #________________________IF IS GPT ON UEFI _______________#
        elif [ "${DT}" == 'gpt' ]; then
            
            ESP
            GPT      
        fi

        #_____________ mount the point ___________#

        echo "y" | mkfs.fat -F32 "${DISK}${EFI}"

        Sections_Format  ## Sections_Format
            #---------  mount the points partitions  --------------#

        Mount_Points 
        mkdir /mnt/boot
        mkdir /mnt/boot/efi
        mount "${DISK}${EFI}" /mnt/boot/efi
        clear
        END
        else
        echo -e "\n[+]Choose Number One Or Two [+]\n"
        count=`expr $count + 1`
        if [ "$count" -eq "$max" ]; then
            clear
            count=`expr $count - 3`
            fi  
    fi
fi

##______________________________________________ENJOY WITH ARCH LINUX NOW ______________________________________##


