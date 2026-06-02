function on_cloudtop --description 'Check if running on Cloudtop virtual workstation'
    set -l value (hostname)
    if string match -q 'fsareshwala-cloudtop*' $value
        return 0
    end

    return 1
end

