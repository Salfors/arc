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
              echo "$PRI"
              echo "fuck you work"
              break
          else
              echo "you bitch"
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
