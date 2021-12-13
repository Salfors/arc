function disk_format(){
        while true
            do 
            echo -e ""
            echo "[1] Use it all and format the hard drive."
            echo "[2] Use only free disk space."
            echo -e ""
            read -p "Do you want to use all disk for installation or just free space : " UD #USE DISK

            if [ "$UD" == "1" ] 
            then
            clear
            sgdisk -Z ${DISK} # zap all on disk
            while true 
                do
                
                echo -e ""
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
            function freetable() {
                DT0=`sudo parted ${DISK} print | grep -i '^Partition Table' | sed 's/Partition Table: //g'`
                case $DT0 in
                    "unknown")
                            while true
                                do
                                echo -e ""
                                echo "you don't had any disk table choose one form them"
                                echo -e ""
                                echo "[1] MSDOS"
                                echo "[2] GPT"
                                read -p "your choice : " NT #New Table
                                case $NT in 
                                    "1")
                                        echo "o
                                        w
                                        "| fdisk ${DISK}
                                        break
                                        ;;
                                    "2")
                                        sgdisk -a 2048 -o ${DISK} 
                                        break
                                        ;;
                                    *)
                                        echo -e "\n[+]Choose 1 or 2 !!![+]\n"
                                        count=`expr $count + 1`
                                        ;;
                                esac
                                
                            done
                            ;; 
                        *)
                            break
                            ;;
                esac

            }
            freetable
            break 
            else
            echo -e "\n[+]Choose 1 or 2 !!![+]\n"
            count=`expr $count + 1`
            clean_screen
            fi
            
        done
            
}
disk_format
