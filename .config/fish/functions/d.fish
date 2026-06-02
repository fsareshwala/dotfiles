function d
    if at_work
        if in_google3
            hg diff $argv
        else
            git diff $argv
        end
    else
        git diff
    end
end
