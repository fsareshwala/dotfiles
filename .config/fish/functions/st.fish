function st
    if at_work
        if in_google3
            hg status $argv
        else
            git status $argv
        end
    else
        git status
    end
end
