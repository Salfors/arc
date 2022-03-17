function Check_Hard_Disk_Status() {
    count=0
    max=3
    DISK=/dev/vda 

    dcy=ON  # Simple way to know if you are in the EDIT_HARD_DISK job stage or in the current job
    echo "F
    n
    " | fdisk ${DISK} > status.txt
    ESE=`sed -rn 's/(^|(.* ))([^ ]*) bytes,(( .*)|$)/\3/; T; p; q' status.txt`  #Empty space exists
    PRI=`sed -n 's/.* extended, \([^ ]*\).*/\1/p' status.txt`  # PRIMAY
    echo "p" | fdisk ${DISK} > status.txt
    EXT=`grep -o "Extended" status.txt` #Extended
    DT=`sudo parted ${DISK} print | grep -i '^Partition Table' | sed 's/Partition Table: //g'`
    rm -rf status.txt
    clear

    case $DT in
        "msdos")

          while true  #WHILE 0 
          do 
          if [ "$PRI" != "" ]; then
              #put this inside while loop
              case $PRI in
                "1")

                  function ROOT_CREATOR() {
                    while true
                    do
                      echo -e "\n${b}======================================================"
                      echo -e "[---]  ${p}Determine the size of the Root partition${rt}${b}  [---]"
                      echo -e "======================================================${rt}\n"
                      echo -e "\nNote:Enter Just The Number And Without GB or MB on Next steps"
                      read -p "Please Enter Size For Root Partition : " RooP #Root Partition
                      echo " free space : "
                      if [ -z "${RooP##*[!0-9]*}" ]; then
                        echo -e "\n${SM} Enter Just The Number And Without GB or MB. ${EM}"
                        count=`expr $count + 1`
                      else
                        echo -e "\n${SM} You Must Enter Root Partition Size !!! ${EM}\n"
                        count=`expr $count + 1`
                      fi
                      clean_screen

                      while true 
                      do 
                      read -p "please confirm [Y/N]" CONFR  # Confirm Root
                      case $CONFR in 
                        y|Y|YES|Yes|yes)
                          BRL= # to Break Root Loop
                          break ;;
                        n|N|no|No|NO)
                          break ;;
                        *)
                          echo "Enter the goddamn yes or no" ;;
                      esac
                      done

                      if $BRL >/dev/null 2>&1; then
                        break 
                      fi

                    done
                    clear
                    }
                    ROOT_CREATOR

                    # for Confirm the other partitions

                    while true
                    do
                      read  -p " do you want to edit your hard disk  [y/n] : " CONFOP # Confrim Other Partition
                      case $CONFOP in
                        y|Y|YES|Yes|yes)

                          EDIT_HARD_DISK
                          break;;
                        n|N|no|No|NO)
                          BWL0= # Confirm is ON for break main loop (WHILE 0 ) To Break While Loop 0
                          break;;

                        *)
                          echo -e "\n${SM} ENTER 'Yes' or 'No' !!! ${EM}\n"
                          count=`expr $count + 1`
                          clean_screen ;;

                      esac
                    done 

                    if $BWL0 >/dev/null 2>&1; then
                      break
                    fi ;;
                    # if CN=ON break main loop 

                "2")

                  while true #WHILE 1
                  do
                    ROOT_CREATOR
                    echo "you don't have Enough space to creat home and swap choose on "
                    echo "[1] HOME"
                    echo "[2] SWAP"
                    echo "[3] edit hard disk (to free up)"
                    echo "[0] skkip it"
                    read -p "your choise" Choose
                    case $Choose in
                      "1")
                        while true
                        do
                          count=0
                          echo -e "\n${b}======================================================"
                          echo -e "[---]  ${p}Determine The Size of The Home Partition${rt}${b}  [---]"
                          echo -e "======================================================${rt}\n"

                          read -p "Enter Your Home Partition Size Please : " Homep #Home Partition

                          if [ -z "${Homep##*[!0-9]*}" ]; then
                            echo -e "\n${SM} Enter Just The Number And Without GB or MB. ${EM}"
                            count=`expr $count + 1`
                          else
                            echo "\n${SM} Enter Valid Value !! ${EM}\n"
                            count=`expr $count + 1`
                          fi
                          clean_screen

                          while true 
                          do 
                          read -p "please confirm [Y/N]" CONFH # Confirm Home 

                          case $CONFH in 
                            y|Y|YES|Yes|yes)
                              BHL= # Break Home Loop
                              break ;;
                            n|N|no|No|NO)
                              break ;;
                            *)
                              echo "Enter the goddamn yes or no" ;;
                          esac
                          done

                          if $BHL >/dev/null 2>&1; then
                            break 
                          fi

                        done
                        break # To Break WHILE 1
                        ;;
                        #here home HOME_CREATOR
                      "2")
                        while true
                        do
                          count=0
                          echo -e "\n${b}======================================================"
                          echo -e "[---]  ${p}Determine The Size of the Swap Partition${rt}${b}  [---]"
                          echo -e "======================================================${rt}\n"
                          read -p "Enter Your Swap Partition Size Please : " Swp # Swap Partition

                          if [ -z "${Swp##*[!0-9]*}" ]; then
                            echo -e "\n${SM} Enter Just The Number And Without GB or MB. ${EM}"
                            count=`expr $count + 1`
                          else
                            echo -e "\n${SM} Enter Valid Value !! ${EM}\n"
                            count=`expr $count + 1`
                          fi
                          clean_screen

                          while true 
                          do 
                          read -p "please confirm [Y/N]" CONFS # Confirm Swap
                          case $CONFS in 
                            y|Y|YES|Yes|yes)
                              BSL= # Break Swap loop 
                              break ;;
                            n|N|no|No|NO)
                              break ;;
                            *)
                              echo "Enter the goddamn yes or no" ;;
                          esac
                          done

                          if $BSL  >/dev/null 2>&1; then
                            break 
                          fi
                        done
                        break # To break WHILE 1

                      ;;
        
                      "3")
                        EDIT_HARD_DISK
                        ;;
                      # edit hard disk
                      "0")
                        break
                        ;;
                      #here skip it with break loop (WHILE 1)
                      "*")
                        echo "enter on on there number"
                        count=`expr $count + 1`
                        clean_screen;;

                *)
                  ;;
              # here but function delimtez size 
              # for 3 or more  part 
              esac

              break
            fi  
            # for break WHILE 0      

            #else

              #echo -e "\n${SM} All Primary Partitions Are In Use. ${EM}\n"
              #EDIT_HARD_DISK
              #Check_Hard_Disk_Status

            #fi


            if [ 1 -eq "$(echo "${ESE} <= ${ES}" | bc)" ]; then
              echo -e "\n${SM} You Don't Have Enough Space To Install ${EM}\n"
              EDIT_HARD_DISK
              Check_Hard_Disk_Status
            fi

            clear

          done ;; 



            #if [ "$EXT" = "Extended" ]; then
          #      echo -e "\n${SM} The Extended Partition Are In Use, And You Need One To Continue ${EM}\n"
          #      EDIT_HARD_DISK
        #        Check_Hard_Disk_Status
      #      fi ;;

        "gpt")

            if [ 1 -eq "$(echo "${ESE} <= ${ES}" | bc)" ]; then
                echo -e "\n${SM} You Don't Have Enough Space To Install ${EM}\n"
                EDIT_HARD_DISK
                Check_Hard_Disk_Status
            fi ;;
    esac

}
Check_Hard_Disk_Status
