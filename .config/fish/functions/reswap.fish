function reswap --description 'Cycle global swap constraints'
    sudo /sbin/swapoff -a
    sudo /sbin/swapon -a
end
