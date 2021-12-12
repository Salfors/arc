 sudo parted ${DISK} print | grep -i '^Partition Table' | sed 's/Partition Table: //g'
