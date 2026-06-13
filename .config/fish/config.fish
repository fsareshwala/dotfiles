# Check if running interactively
status is-interactive; or return

# Disable software control flow (ctrl-s and ctrl-q)
stty -ixon

stty werase undef

# Environment Variables
set -gx EDITOR nvim
set -gx GOPATH $HOME/go
set -gx MANPAGER "batcat -l man -p"
set -gx MANROFFOPT -c
set -gx VISUAL nvim

# FZF Configuration
function _fzf_compgen_path
    fd --hidden --follow --exclude ".git" . "$argv[1]"
end

function _fzf_compgen_dir
    fd --type d --hidden --follow --exclude ".git" . "$argv[1]"
end

set -gx FZF_DEFAULT_COMMAND "rg --files --no-ignore-vcs --hidden --color=never *"
set -gx FZF_DEFAULT_OPTS '--height 20% --reverse'

# Path building -- whenever I stop working on fuchsia/pigweed, this can return to the standard
# fish_add_path so that I don't have to build it on every prompt.
function set_path --on-event fish_prompt --description 'Regenerate path completely dynamically'
    # Pigweed overrides and handles its own path environments via source activate.sh
    if in_pigweed
        return
    end

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

# Aliases
alias -- .........='cd ../../../../../../../..'
alias -- ........='cd ../../../../../../..'
alias -- .......='cd ../../../../../..'
alias -- ......='cd ../../../../..'
alias -- .....='cd ../../../..'
alias -- ....='cd ../../..'
alias -- ...='cd ../..'
alias -- ..='cd ..'
alias bc='bc -lq'
alias diff="diff --color=auto"
alias dlmp3='yt-dlp -x --audio-format mp3 --audio-quality 0 --embed-thumbnail'
alias dlvid='yt-dlp --recode-video mp4 --add-metadata'
alias gdb='cgdb --directory=. -quiet'
alias grep="rg --color=auto"
alias json='python3 -m json.tool'
alias lg='lazygit'
alias ll='ls -l'
alias lp='lp -o sides=two-sided-long-edge'
alias ls='ls --color'
alias mkdir='mkdir -p'
alias patch='patch -merge --no-backup-if-mismatch'
alias pmake='make -j (nproc)'
alias rgdb='rust-gdb --tui'
alias s='source ~/.config/fish/config.fish'
alias thes='aiksaurus'
alias vim='nvim -O'
alias vimf='nvim (fzf)'
alias watch='watch --color'
alias which='type -p'

if is_mac_os
    alias cat='bat'
else
    alias cat='batcat'
    alias fd='fdfind'
end

alias b='git branch'
alias ba='git branch -a'
alias dc='git diff --cached'
alias ga='git add'
alias gap='git add -p'
alias gb='git checkout @{-1}'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gf='git fx'
alias gm='git commit -m'
alias gpr='git pull --rebase'
alias gri='git rebase -i'
alias griom='git rebase -i origin/master'
alias grom='git rebase origin/master'
complete -c gm -a "(__fish_complete_directories)"

# --- Work Specific Configs ---
if at_work
    gcertstatus --check_remaining=60m >/dev/null 2>&1; or gcert -s

    set -gx FX_ENV "$HOME/code/fuchsia/scripts/fx-env.fish"
    test -e $FX_ENV; and source $FX_ENV

    set -gx NINJA_PERSISTENT_MODE 1
    set -gx FX_BUILD_WITH_LABELS 1

    alias gmsh='gmosh fsareshwala-cloudtop.c.googlers.com'
    alias gssh='ssh fsareshwala-cloudtop.c.googlers.com'
    alias pw='pw --no-banner'
    alias wk='vim ~/personal/career/google.md'

    alias ha='hg add'
    alias hab='hg absorb'
    alias hai='hg amend -i'
    alias ham='hg amend'
    alias hb='hg blame -udcw'
    alias hca='hg commit --amend'
    alias hci='hg commit -i'
    alias he='hg histedit'
    alias hm='hg commit -m'
    alias hrm='hg resolve --mark'
    alias hs='hg export'
    alias hst='hg diff -r .^:. --stat'
    alias rdrop='hg cls-drop -p --skip-confirmation -c'
    alias rsubmit='hg submit'

    alias cd-abt='cd ~/code/fuchsia/vendor/google/starnix/android/hal/bluetooth_hidl'
    alias cd-bt='cd ~/code/pigweed/pw_bluetooth_sapphire'
    alias cd-btfidl='cd ~/code/fuchsia/sdk/fidl/fuchsia.bluetooth.le'
    alias cd-f='cd ~/code/fuchsia'
    alias cd-fbt='cd ~/code/fuchsia/src/connectivity/bluetooth'
    alias cd-g3='cd ~/code/google3'
    alias cd-i='cd ~/code/google3/corp/hiring/interview_questions/questions/g3doc/genswe'
    alias cd-p='cd ~/code/pigweed; and source activate.fish'
    alias cd-uwb='cd ~/code/fuchsia/vendor/google/starnix/android/hal/uwb_aidl'

    alias btemboss='bazelisk run -c opt //:refresh_compile_commands_for_fuchsia_sdk ; pw ide sync ; and pw ide cpp --set pw_strict_host_clang_debug ; and pw ide cpp --process'
    alias btnew='bugged create --format=MARKDOWN 1472729'
    alias embfmt='~/code/emboss/emboss-format ~/code/pigweed/pw_bluetooth/public/pw_bluetooth/hci_*.emb'
    alias fupdate='pushd third_party/glslang/src ; and git fetch --tags --force ; and popd ; and git pull --rebase ; and jiri update -gc -rebase-all -rebase-untracked'
    alias mdformat='/google/bin/releases/corpeng-engdoc/tools/mdformat'

    set -l btcmd_args '--config googletest --config asan'
    if on_cloudtop
        set btcmd_args "$btcmd_args --config remote_cache"
    end

    alias m="bazelisk build $btcmd_args //pw_bluetooth_sapphire/host/..."
    alias t="bazelisk test $btcmd_args //pw_bluetooth_sapphire/host/..."

    set -l common_test bazel-bin/pw_bluetooth_sapphire/host/common/common_test
    alias common_test="m ; and $common_test"
    alias common_debug="m ; and lldb -o run $common_test --"

    set -l hci_test bazel-bin/pw_bluetooth_sapphire/host/hci/hci_test
    alias hci_test="m ; and $hci_test"
    alias hci_debug="m ; and lldb -o run $hci_test --"

    set -l gap_test bazel-bin/pw_bluetooth_sapphire/host/gap/gap_test
    alias gap_test="m ; and $gap_test"
    alias gap_debug="m ; and lldb -o run $gap_test --"

    set -l gatt_test bazel-bin/pw_bluetooth_sapphire/host/gatt/gatt_test
    alias gatt_test="m ; and $gatt_test"
    alias gatt_debug="m ; and lldb -o run $gatt_test --"

    set -l l2cap_test bazel-bin/pw_bluetooth_sapphire/host/l2cap/l2cap_test
    alias l2cap_test="m ; and $l2cap_test"
    alias l2cap_debug="m ; and lldb -o run $l2cap_test --"

    set -l sm_test bazel-bin/pw_bluetooth_sapphire/host/sm/sm_test
    alias sm_test="m ; and $sm_test"
    alias sm_debug="m ; and lldb -o run $sm_test --"

    set -l transport_test bazel-bin/pw_bluetooth_sapphire/host/transport/transport_test
    alias transport_test="m ; and $transport_test"
    alias transport_debug="m ; and lldb -o run $transport_test --"

    set -l btcmd_paths " //pw_bluetooth/... //pw_bluetooth_hci/... //pw_bluetooth_proxy/... //pw_bluetooth_sapphire/..."
    alias btbuild="bazelisk build $btcmd_args $btcmd_paths"
    alias bttest="bazelisk test $btcmd_args $btcmd_paths"

    set -l fx_set 'fx set  --assembly-override //local:include_ssh_keys'
    set -l fx_asan '--variant host_asan --variant asan'

    if on_cloudtop
        set fx_set "$fx_set --rbe-mode=cloudtop"
    else
        set fx_set "$fx_set --rbe-mode=workstation"
    end

    set -l bluetooth_hidl "--with //vendor/google/starnix/android/hal/bluetooth_hidl:tests --with //vendor/google/starnix/android/hal/uwb_aidl:tests"

    alias fx-core="$fx_set core.x64"
    alias fx-core-asan="fx-core $fx_asan"

    alias fx-astro="$fx_set smart_display_eng.astro"
    alias fx-astro-asan="fx-astro $fx_asan"

    alias fx-nelson="$fx_set smart_display_m3_eng.nelson"
    alias fx-nelson-asan="fx-nelson  $fx_asan"

    alias fx-sherlock="$fx_set smart_display_max_eng.sherlock"
    alias fx-sherlock-asan="fx-sherlock $fx_asan"

    alias fx-sorrel="$fx_set minimal.sorrel"
    alias fx-sorrel-asan="fx-sorrel $fx_asan"

    alias fx-sorrel-full="fx set fuchsia_internal.arm64 --assembly-override //local:include_ssh_keys --main-pb //vendor/google/products/pixel_watch:pixel_watch_eng.sorrel --with //src/connectivity/bluetooth/tools"
    alias fx-sorrel-full-asan="fx-sorrel_full $fx_asan"
end
