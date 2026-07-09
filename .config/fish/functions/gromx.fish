function gromx --description 'Run a command on every commit since origin/master'
    git rebase --exec "$argv" origin/master
end
