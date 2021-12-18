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
    echo -e "-------------------------------------------------\n"
    echo -e "______Select Your Disk To Installation___________\n"
    echo -e "-------------------------------------------------\n"
    lsblk
    echo -e "\nPlease Enter Disk: (example /dev/sda)\n"
    read DISK
    if [ "$DISK" == "" ] 
        then
        echo -e "\n[+]Choose The Disk To Install To !!![+]\n"
        sleep 1
        count=`expr $count + 1`
        clean_screen
       
        else 
        break    
    fi
    done
    ##### to choos Disk option free space or all or gpt or msdos


    clear
    function EDIT_HARD() {
        while true
            do
            echo -e "-------------------------------------------------\n"
            echo -e "____________    Hard Disk Editor   ______________\n"
            echo -e "-------------------------------------------------\n"
            echo -e ""
            read -p "Do You Want To Modify a Hard Disk (Y/N) ? : " ED #EDIT DISK
            case $ED in 
                y|Y|yes|Yes|YES)
                        while true
                            do
                            clear
                            echo -e "\nChoose Tool for Managing Hard Disk Partitions.\n"
                            echo "**********"
                            echo "[-]fdisk"
                            echo "[-]cfdisk"
                            echo "[-]parted"
                            echo "[-]cgdisk"
                            echo -e "\n***********\n"
                            read -p "Enter Your Favorite Tool : " tool
                            case $tool in 
                                fdisk|cfdisk|parted|cgdisk)
                                    $tool ${DISK}
                                    break
                                    ;;
                                *)
                                    echo -e "\n[+]Sorry, Choose One From Them !!! [+]\n"
                                    count=`expr $count + 1`
                                    ;;
                            esac
                        done
                        break              
                        ;;

                n|N|no|No|NO)
                    break
                    ;;
                *)
                    echo -e "\n[+]ENTER 'yes' OR 'no' !!! [+]\n"
                    count=`expr $count + 1`   
                    ;;                      
            esac
            clean_screen
        done
    }
    EDIT_HARD
    clear
    echo "-------------------------------------------------"
    echo "---           Disk Usage                     ----"
    echo "-------------------------------------------------"
    #echo -e "\n"
    function disk_format(){
            while true
                do 
                echo -e ""
                echo "[1] Use it all and format the hard drive."
                echo "[2] Use only free disk space."
                echo -e ""
                read -p "Do you want to use all disk for installation or just free space : " UD #USE DISK
                clear
                if [ "$UD" == "1" ] 
                then
                clear
                sgdisk -Z ${DISK} # zap all on disk
                while true 
                    do
                    
                    echo -e "" ################ disk table new write here on box
                    echo "[1] GPT"
                    echo "[2] MSDOS"
                    echo -e ""
                    read -p "Do you want a 'GPT' or 'MSDOS' table for your hard disk : " table 
                    case $table in 
                    1)
                        clear
                        sgdisk -a 2048 -o ${DISK} 
                        break
                        ;;

                    2)
                        clear
                        echo "o
                        w
                        " | fdisk ${DISK}
                        break
                        ;;

                    *)
                        echo "enter 1 or 2 "
                        count=`expr $count + 1`
                        ;;
                    esac
                    clean_screen
                done    
                break
                
                elif [ "$UD" == "2" ]; then
                function available_table() {
                    DT0=`sudo parted ${DISK} print | grep -i '^Partition Table' | sed 's/Partition Table: //g'`
                    clear
                    case $DT0 in
                        "unknown")
                                while true
                                    do
                                    echo -e ""
                                    echo "You don't have any hard disk table, Choose one"
                                    echo -e ""
                                    echo "[1] MSDOS"
                                    echo "[2] GPT"
                                    read -p "Your Choice : " NT #New Table
                                    case $NT in 
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
                                            echo -e "\n[+]Choose Number 'One' or 'Two' [+]\n"
                                            count=`expr $count + 1`
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
                available_table
                break 
                else
                echo -e "\n[+]Choose Number 'One' or 'Two' [+]\n"
                count=`expr $count + 1`
                clean_screen
                fi
                
            done
                
    }
    disk_format
    clear

    #-----Select live boot type------#

    function MODE() {

        Mode=`ls /sys/firmware/efi`
        if $Mode >/dev/null 2>&1; then
                Mode="BIOS"
                    
        else
                Mode="UEFI"
        fi
    }
    MODE

    function CHECK_MODE() {
        while true
            do 
            echo -e "\nTHE CURRENT BOOT MODE IS ${Mode} ?\n"
            read -p "Please confirm [y/n] : " AM #ask MODE
            case $AM in 
                y|Y|yes|Yes|YES)
                    break
                    ;;

                n|N|no|No|NO)
                    clear
                    while true
                        do 
                                
                        echo "-------------------------------------------------"
                        echo "----------Select Your Boot Type -----------------"
                        echo "-------------------------------------------------"
                        echo -e "\n+[1] Bios Mode" # BIOS
                        echo -e  "+[2] UFI Mode\n" # UFI
                        read -p  "Enter Number : " Mode
                        case $Mode in 
                            "1")
                                    Mode="BIOS"
                                    echo ""
                                    echo -e "\n[+]The Boot Mode In Which The Installation Will Be Performed Is ${Mode}.[+] ."
                                    echo "[+]If it is not correct, try restarting the script and try again[+]."
                                    break ;;
                            "2")
                                    Mode="UEFI"
                                    echo ""
                                    echo -e "\n[+]The Boot Mode In Which The Installation Will Be Performed Is ${Mode}.[+] ."
                                    echo "[+]If it is not correct, try restarting the script and try again[+]."
                                    break ;;

                            *)
                                    echo "enter just one or two "
                                    count=`expr $count + 1`
                                    clean_screen ;;
                        esac
                            
                                
                    done
                    break
                    ;;
                "")
                    break ;;

                *)
                    echo -e "\n[+]ENTER 'yes' or 'no' !!![+]\n"
                    count=`expr $count + 1`
                    ;;
            esac
            clean_screen 
        done
    }
    CHECK_MODE
        
    function Determine_size() {


        #_____Determine the size of the root partition____#
        echo -e "\nNote: Enter Values in 'MB' or 'GB' on Next step\n "
        while true
            do
            echo -e ""
            read -p "Please Enter Size For Root Partition : " RooP #Root Part
            if [ -z "${RooP//[0-9]/}" -a ! -z "$RooP" ]; then 
                    echo "${RooP}"
                    break
            elif [ -z "${RooP##*[!0-9]*}" ]; then
                    echo -e "\n[+]enter just the number and  with out GB or MB[+]"
                    count=`expr $count + 1`
            else
                    echo -e "\n[+]You Must Enter Root Partition Size !!![+]\n"
                    count=`expr $count + 1`
            fi
            clean_screen
            echo -e "\nNote: Enter Values in 'MB' or 'GB' on Next step"
                
        done
        clear
                    
        #____Determine the size of the home partition___#
        while true
            do
            echo -e 
            read  -p "Please do you want create home part or not (y/n) : " AN #ANSWER
            case $AN in 
                y|Y|YES|Yes|yes)

                    clear
                    echo -e 
                    echo -e "Note: Enter Values in 'MB' or 'GB' on Next step\n "
                    while true
                        do
                        read -p "Enter your /home partition size please : " Homep #Home Part
                        if [ -z "${Homep//[0-9]/}" -a ! -z "$Homep" ]; then
                                break
                        elif [ -z "${Homep##*[!0-9]*}" ]; then
                                echo -e "\n[+]enter just the number without GB or MB[+]\n"
                                count=`expr $count + 1`
                        else 
                                echo "enter vailde value !!"
                                count=`expr $count + 1`
                        fi
                        clean_screen
                        echo -e "Note: Enter Values in 'MB' or 'GB' on Next step\n"
                                
                    done
                    echo -e 
                    break
                    ;;
                n|no)

                        break
                        ;;
                        *) 
                            echo -e "\n[+]Enter yes or no (y/n)[+]"
                            count=`expr $count + 1`
                            clean_screen
                            ;;
            esac
        done
        clear
        #_____Determine the size of the swap partition__#

        while true
            do
            echo -e 
            read  -p "Please do you want create swap part or not (y/n) : " AN2 #ANSWER2
            case $AN2 in 
                y|Y|YES|Yes|yes)
                    clear
                    echo -e 
                    echo -e "Note: Enter Values in 'MB' or 'GB' on Next step\n "
                    while true
                        do
                        read -p "Enter your Swap partition size please : " Swap
                        if [ -z "${Swap//[0-9]/}" -a ! -z "$Swap" ]; then
                                break
                        elif [ -z "${Swap##*[!0-9]*}" ]; then
                                echo -e "\n[+]enter just the number without GB or MB[+]\n"
                                count=`expr $count + 1`
                        else 
                                echo "enter vailde value !!"
                                count=`expr $count + 1`
                        fi
                        clean_screen
                        echo -e "Note: Enter Values in 'MB' or 'GB' on Next step\n"
                                    
                    done
                    echo -e 
                    break
                    ;;
                n|N|NO|No|no)
                    break
                    ;;
                *) 
                    echo -e "\n[+]Enter yes or no (y/n)[+]"
                    count=`expr $count + 1`
                    clean_screen
                    ;;
            esac
        done
        }

        #Determine_size
        function logic() {

            case $AN in 
                y|Y|yes|Yes|YES)

                    case $AN2 in 
                        y|Y|yes|Yes|YES)
                                logic=`expr ${RooP} + ${Homep} + ${Swap}` ;;
                    esac 
                    case $AN2 in 
                        n|N|no|No|NO)
                                logic=`expr ${RooP} + ${Homep}`;;
                    esac
                    ;;
                n|N|no|No|NO)

                    case $AN2 in 
                        y|Y|yes|Yes|YES)
                                logic=`expr ${RooP} + ${Swap}` ;;
                    esac
                    case $AN2 in 
                        n|N|no|No|NO)
                                ;;
                    esac
                    ;;
            esac
        } 
        #logic
        
        function check_logic() {
        while true
            do 
            echo -e "\nIs This The Total Volume For The Operation ${logic}GB ?\n"
            read -p "Enter 'Yes' To Continue or 'No' To Edit Size : " AL #ask logic
            case $AL in 
                y|Y|yes|Yes|YES)
                        break
                        ;;

                n|N|no|No|NO)

                        while true
                            do 
                            clear
                            echo -e "on next step GB is default\n"
                            read -p "Enter The Size With (number only): " logic
                            if [ -z "${logic//[0-9]/}" -a ! -z "$logic" ]; then
                                    clear
                                    echo -e "\n[+]The size for the process is ${logic}GB.[+] ."
                                    echo "[+]If it is not correct, try restarting the script and try again[+]."
                                    break
                            else 
                                    echo -e "\n[+]Enter Just The Number Without GB or Valid Value !![+]\n"
                                    count=`expr $count + 1`
                            fi
                            clean_screen
                        done
                        break
                        ;;
                *)
                        echo -e "\n[+]ENTER 'yes' or 'no' !!![+]\n"
                        count=`expr $count + 1`
                        ;;
            esac
            clean_screen 
        done

        }
            # check logic

        

        
        
    function MSPART () {
    
        function MSDOS(){
                        
            check_logic
            echo "n
            e
            
            
            +${logic}GB
            w
            "| fdisk ${DISK}
            if [ "$Mode" == "UEFI" ]; then
                    #___ efi part
                echo "n
                l
                
                +512M
                w
                " | fdisk ${DISK}
                EFI=`sudo partx -rgo NR -n -1:-1 ${DISK}`
            fi
                                ### root
            echo "n  
            l
            
            +${RooP}GB
            w
            " | fdisk ${DISK}
            ROOT=`sudo partx -rgo NR -n -1:-1 ${DISK}`

            case $AN in 
                y|Y|yes|Yes|YES)

                    case $AN2 in 
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
                            
                            
                            +${Swap}GB
                            w
                            "| fdisk ${DISK}
                            SWAP=`sudo partx -rgo NR -n -1:-1 ${DISK}`;;

                    esac 
                    case $AN2 in 
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

                    case $AN2 in 

                        y|Y|yes|Yes|YES)
                            echo "
                            n
                            l
                            
                            
                            +${Swap}GB
                            w
                            "| fdisk ${DISK}
                            SWAP=`sudo partx -rgo NR -n -1:-1 ${DISK}` ;;
                    esac

                    case $AN2 in 
                        n|N|no|No|NO) 
                            ;;
                                                ### if home and swap not created
                    esac
                    ;;

            esac
            }

            case $AN in
                n|N|no|No|NO)
                    case $AN2 in
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



    function GPT(){
        echo "
        n  


        +${RooP}GB
        w
        " | fdisk ${DISK}
        ROOT=`sudo partx -rgo NR -n -1:-1 ${DISK}`

        case $AN in 
            y|Y|yes|Yes|YES)

                case $AN2 in 
                    y|Y|yes|Yes|YES)

                        echo "n


                        +${Homep}GB
                        w
                        " | fdisk ${DISK}  
                        HOME=`sudo partx -rgo NR -n -1:-1 ${DISK}`
                                                        #____home
                        echo "
                        n


                        +${Swap}GB
                        w
                        " | fdisk ${DISK}
                        SWAP=`sudo partx -rgo NR -n -1:-1 ${DISK}` ;;

                esac 
                case $AN2 in 
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

                case $AN2 in 
                    y|Y|yes|Yes|YES)

                        echo "
                        n


                        +${Swap}GB
                        w
                        " | fdisk ${DISK}
                        SWAP=`sudo partx -rgo NR -n -1:-1 ${DISK}` ;;

                esac

                case $AN2 in 
                    n|N|no|No|NO) 
                        ;;
                                    ###nothing

                esac
                ;;
        esac   
                        
    }



    function CONVERT() {

        echo "y" | mkfs.ext4 "${DISK}${ROOT}"
        
        case $AN in 
            y|Y|yes|Yes|YES)

                case $AN2 in 
                    y|Y|yes|Yes|YES)
                                    
                        echo "y" | mkfs.ext4 "${DISK}${HOME}" #partition (Home)
                        mkswap "${DISK}${SWAP}" #partition (Swap)
                        swapon "${DISK}${SWAP}" ;;

                esac 
                case $AN2 in 
                    n|N|no|No|NO)
                        echo "y" | mkfs.ext4 "${DISK}${HOME}" ;;
                esac
                ;;

            n|N|no|No|NO)

                case $AN2 in 
                    y|Y|yes|Yes|YES)
                                    
                        mkswap "${DISK}${SWAP}" #partition  (Swap)
                        swapon "${DISK}${SWAP}";;
                esac

                case $AN2 in 
                    n|N|no|No|NO)
                        ;;
                                #nothing

                esac
                ;;
        esac 
    }




    function MOUNT () {
                
        mount "${DISK}${ROOT}" /mnt
        case $AN in 
            y|Y|yes|Yes|YES)
                mkdir /mnt/home
                mount "${DISK}${HOME}" /mnt/home ;;

            n|N|no|No|NO)
                        # nothing 
                ;;
        esac
    }


    function LAST() { 
                
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
        echo "--------------------------------------"
        echo "-- Arch Install on Main Drive       --"
        echo "--------------------------------------"
        pacstrap /mnt --noconfirm base base-devel linux linux-firmware vim nano sudo micro
        genfstab -U /mnt >> /mnt/etc/fstab

        #### To prepare step 2 ####
        cp ~/arc/step2.sh /mnt/
        chmod a+x /mnt/step2.sh
        echo "$DISK" > /mnt/ID
        echo "$Mode" > /mnt/GrubID
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


    function ESP() {
        #___ efi part
        echo "n


        +512M
        w
        " | fdisk ${DISK}
        EFI=`sudo partx -rgo NR -n -1:-1 ${DISK}`

    }

                     #------    CREATE PARTITIONS ON BIOS MODE -------#

    #####################################################################################################################

    #  NOTE: Every line Here Is Important Even If It Is Empty. If You Delete Any Line Here, It Will Be A Problem
    #               You Must Understand How the "FDISK" Partition Works To Understand It

    ################################################################################################################## 

    if [ "$Mode" == "BIOS" ]  ######### IF IS BIOS MODE #######
        then       
        clear
        Determine_size
        logic
        clear
        echo -e ""

        
        DT=`sudo parted ${DISK} print | grep -i '^Partition Table' | sed 's/Partition Table: //g'`
        if [ "${DT}" == 'msdos' ]; then
            
            MSPART
                #___________________IF IS GPT ON BIOS _______________#
        elif [ "${DT}" == 'gpt' ]; then
            ESP
            GPT

        fi

        ##_______________________________SELECT CONVERT TO __________________#
        sleep 1

        CONVERT

            #_____________ MOUNT THE POINTS PARTITIONS  _______________#

        MOUNT
        #_______________________________________________________________________#
        clear

        LAST


####______________________________________________________________________________________________________________________##### 
####______________________________________________________________________________________________________________________#####  

    elif [ "$Mode" == "$N2" ] # ---------- IF IS UEFI MODE ---------#
        then
        clear

        Determine_size
        logic
        
        clear
        #_____________________ IF MSDOS ON BIOS __________________# 

        DT=`sudo parted ${DISK} print | grep -i '^Partition Table' | sed 's/Partition Table: //g'`
        if [ "${DT}" == 'msdos' ]; then
            
            #ESP
            MSPART
            clear

            #________________________IF IS GPT ON UEFI _______________#
        elif [ "${DT}" == 'gpt' ]; then
            

            ESP
                #___root
            GPT #GPT()
                
        fi

        #_____________ mount the point ___________#

        echo "y" | mkfs.fat -F32 "${DISK}${EFI}"

        CONVERT ## convert partition
            #---------  mount the points partitions  --------------#

        MOUNT #MOUNT POINT()

        mkdir /mnt/boot
        mkdir /mnt/boot/efi
        mount "${DISK}${EFI}" /mnt/boot/efi

        clear
        LAST

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


