function at_work --description 'Check if running on a work machine'
    set -l value (hostname)
    if string match -q 'fsareshwala-cloudtop*' $value
        return 0
    else if string match -q 'fsareshwala-macbookpro*' $value
        return 0
    end

    return 1
end
