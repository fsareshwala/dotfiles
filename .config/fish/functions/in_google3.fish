function in_google3
    if string match -q "$HOME/code/google3*" "$PWD"
        return 0
    else
        return 1
    end
end
