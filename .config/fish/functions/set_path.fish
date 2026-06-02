function set_path --on-event fish_prompt --description 'Regenerate path completely dynamically'
    # Pigweed overrides and handles its own path environments via source activate.sh
    if in_pigweed
        return
    end

    # Explicit array initialization to prevent duplications cleanly
    set -l target_path \
        $HOME/prefix/bin \
        $GOPATH/bin \
        /usr/local/sbin \
        /usr/local/bin \
        /usr/sbin \
        /usr/bin \
        /sbin \
        /bin

    if in_fuchsia
        set -a target_path $HOME/code/fuchsia/.jiri_root/bin $HOME/code/fuchsia/scripts
    else
        # Fuchsia doesn't like the current directory in the path
        set -a target_path .
    end

    if is_mac_os
        set -a target_path /opt/homebrew/bin
    end

    set -gx PATH $target_path
end
