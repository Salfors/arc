
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
                    y|yes)

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
                            if [ "$count" -eq "$max" ]; then
                                clear
                                count=`expr $count - 3`
                            fi
                            ;;
                    esac
            done
            clear
                #_____Determine the size of the swap partition__#

            while true
                do
                echo -e 
                read  -p "Please do you want create home part or not (y/n) : " AN2 #ANSWER2
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

        Determine_size
        function logic() {
        if [ "$AN" == "YES" ] || [ "$AN" == "Yes" ] || [ "$AN" == "Y" ] || [ "$AN" == "yes" ] || [ "$AN" == "y" ] && [ "$AN2" == "NO" ] || [ "$AN2" == "N" ] || [ "$AN2" == "no" ] || [ "$AN2" == "n" ] || [ "$AN2" == "No" ]; then
            logic=`expr ${RooP} + ${Homep}`

            elif  [ "$AN2" == "YES" ] || [ "$AN2" == "Yes" ] || [ "$AN2" == "Y" ] || [ "$AN2" == "yes" ] || [ "$AN2" == "y" ] && [ "$AN" == "NO" ] || [ "$AN" == "N" ] || [ "$AN" == "no" ] || [ "$AN" == "n" ] || [ "$AN" == "No" ]; then
            logic=`expr ${RooP} + ${Swap}`

            elif [ "$AN" == "NO" ] || [ "$AN" == "N" ] || [ "$AN" == "no" ] || [ "$AN" == "n" ] || [ "$AN" == "No" ] && [ "$AN2" == "NO" ] || [ "$AN2" == "N" ] || [ "$AN2" == "no" ] || [ "$AN2" == "n" ] || [ "$AN2" == "No" ]; then
            logic=${RooP} 
            else
            logic=`expr ${RooP} + ${Homep} + ${Swap}`
        fi
        } 
        logic
        clear
        echo -e ""
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
        check_logic



DISK=/dev/vda

























function MSDOS(){
        echo "
        n 
        e 
        
        
        +${logic}GB
        w
        "| fdisk ${DISK}
                    #### root
        echo "
        n 
        l 
        
        +${RooP}GB
        w
        " | fdisk ${DISK}
        ROOT=`sudo partx -rgo NR -n -1:-1 /dev/vda`
                                
        if [ "$AN" == "YES" ] || [ "$AN" == "Yes" ] || [ "$AN" == "Y" ] || [ "$AN" == "yes" ] || [ "$AN" == "y" ] && [ "$AN2" == "YES" ] || [ "$AN2" == "Yes" ] || [ "$AN2" == "Y" ] || [ "$AN2" == "yes" ] || [ "$AN2" == "y" ]
            then 
            echo "
            n
            l
            
            +${Homep}GB
            w
            "| fdisk ${DISK}  
            HOME=`sudo partx -rgo NR -n -1:-1 /dev/vda`
                        #####
            echo "
            n
            l
            
            
            
            +${Swap}GB
            w
            "| fdisk ${DISK}
            SWAP=`sudo partx -rgo NR -n -1:-1 /dev/vda`
            #######                

            elif [ "$AN" == "NO" ] || [ "$AN" == "No" ] || [ "$AN" == "N" ] || [ "$AN" == "no" ] || [ "$AN" == "n" ] && [ "$AN2" == "Yes" ] || [ "$AN2" == "yes" ] || [ "$AN2" == "Y" ] || [ "$AN2" == "y" ]
            then 
            echo "
            n
            l
            
            
            
            +${Swap}GB  
            w
            "| fdisk ${DISK}
            SWAP=`sudo partx -rgo NR -n -1:-1 /dev/vda`
                        ### 
            elif [ "$AN" == "YES" ] || [ "$AN" == "Yes" ] || [ "$AN" == "Y" ] || [ "$AN" == "yes" ] || [ "$AN" == "y" ] && [ "$AN2" == "NO" ] || [ "$AN2" == "No" ] || [ "$AN2" == "N" ] || [ "$AN2" == "no" ] || [ "$AN2" == "n" ]
            then 
            echo "
            n
            l
            
            +${Homep}GB
            w
            "| fdisk ${DISK}
            HOME=`sudo partx -rgo NR -n -1:-1 /dev/vda`
                                        
        fi
}
MSDOS
echo "${ROOT}"
echo "${swap}"
echo "${HOME}"
