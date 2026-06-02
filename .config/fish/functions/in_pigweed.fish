function in_pigweed
    if string match -q "$HOME/code/pigweed*" "$PWD"
        return 0
    end

    return 1
end
