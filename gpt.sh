   
       function Determine_Size() {

        #_____Determine the size of the root partition____#
        count=0
        sleep 2
        while true
            do
            echo -e "\n${b}======================================================"
            echo -e "[---]  ${p}Determine the size of the Home partition${rt}${b}  [---]"
            echo -e "======================================================${rt}\n"
            echo -e "\nNote:Enter Just The Number And Without GB or MB on Next steps"
            read -p "Please Enter Size For Root Partition : " RooP #Root Partition
            if [ -z "${RooP//[0-9]/}" -a ! -z "$RooP" ]; then 
                    echo "${RooP}"
                    break
            elif [ -z "${RooP##*[!0-9]*}" ]; then
                    echo -e "\n${SM} Enter Just The Number And Without GB or MB. ${EM}"
                    count=`expr $count + 1`
            else
                    echo -e "\n${SM} You Must Enter Root Partition Size !!! ${EM}\n"
                    count=`expr $count + 1`
            fi
            clean_screen
                
        done
        clear
        count=0       
        #____Determine the size of the home partition___#
        sleep 2
        while true
            do
            echo -e "\n${b}=========================================="
            echo -e "[---]  ${p}Select Create Home Partition${rt}${b}  [---]"
            echo -e "==========================================${rt}\n"
            read  -p "Please do you want create home part or not [y/n] : " CH #Create  Home 
            case $CH in 
                y|Y|YES|Yes|yes)

                    clear
                    echo -e 
                    sleep 2
                    while true
                        do
                        count=0
                        echo -e "\n${b}======================================================"
                        echo -e "[---]  ${p}Determine The Size of The Home Partition${rt}${b}  [---]"
                        echo -e "======================================================${rt}\n"
  
                        read -p "Enter Your Home Partition Size Please : " Homep #Home Partition
                        if [ -z "${Homep//[0-9]/}" -a ! -z "$Homep" ]; then
                                break
                        elif [ -z "${Homep##*[!0-9]*}" ]; then
                                echo -e "\n${SM} Enter Just The Number And Without GB or MB. ${EM}"
                                count=`expr $count + 1`
                        else 
                                echo "\n${SM} Enter Valid Value !! ${EM}\n"
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
                            echo -e "\n${SM} ENTER 'Yes' or 'No' !!! ${EM}\n"
                            count=`expr $count + 1`
                            clean_screen
                            ;;
            esac
        done
        clear
        count=0
        #_____Determine the size of the swap partition__#
        sleep 2
        while true
            do
            echo -e "\n${b}=========================================="
            echo -e "[---]  ${p}Select Create swap Partition${rt}${b}  [---]"
            echo -e "==========================================${rt}\n"
            read  -p "Please Do You Want Create Swap Part Or Not [y/n] : " CS #Create swap 
            case $CS in 
                y|Y|YES|Yes|yes)
                    clear
                    echo -e 
                    sleep 2
                    while true
                        do
                        count=0
                        echo -e "\n${b}======================================================"
                        echo -e "[---]  ${p}Determine The Size of the Swap Partition${rt}${b}  [---]"
                        echo -e "======================================================${rt}\n"
                        read -p "Enter Your Swap Partition Size Please : " Swp # Swap Partition
                        if [ -z "${Swp//[0-9]/}" -a ! -z "$Swp" ]; then
                                break
                        elif [ -z "${Swp##*[!0-9]*}" ]; then
                                echo -e "\n${SM} Enter Just The Number And Without GB or MB. ${EM}"
                                count=`expr $count + 1`
                        else 
                                echo -e "\n${SM} Enter Valid Value !! ${EM}\n"
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
                    echo -e "\n${SM} ENTER 'Yes' or 'No' !!! ${EM}\n"
                    count=`expr $count + 1`
                    clean_screen
                    ;;
            esac
        done
        }
   Determine_Size
    function GPT(){
        echo "
        n  


        +${RooP}GB
        w
        "| fdisk ${DISK} && ROOT=`sudo partx -rgo NR -n -1:-1 ${DISK}`

        case $CH in 
            y|Y|yes|Yes|YES)

                case $CS in 
                    y|Y|yes|Yes|YES)

                        echo "n


                        +${Homep}GB
                        w
                        " | fdisk ${DISK}  
                        HOME=`sudo partx -rgo NR -n -1:-1 ${DISK}`
                                                        
                        echo "
                        n


                        +${Swp}GB
                        w
                        "| fdisk ${DISK}
                        SWAP=`sudo partx -rgo NR -n -1:-1 ${DISK}` ;;

                esac 
                case $CS in 
                    n|N|no|No|NO)
                        echo "
                            n
                            
                            
                            +${Homep}GB
                            w
                            "| fdisk ${DISK}
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
                        "| fdisk ${DISK}
                        SWAP=`sudo partx -rgo NR -n -1:-1 ${DISK}` ;;

                esac

                case $CS in 
                    n|N|no|No|NO) 
                        ;;

                esac
                ;;
        esac   
                        
    }
    GPT
    
    echo "${ROOT}"
    echo "${HOME}"
    echo "${SWAP}"
