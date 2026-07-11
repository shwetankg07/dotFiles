if status is-interactive
    # Commands to run in interactive sessions can go here
    fastfetch --logo (pokemon-colorscripts -r --no-title | psub) --logo-type file-raw --logo-padding 3 --logo-padding-top 8
end
starship init fish | source

# adding fish to obey zoxide
zoxide init fish | source
fzf --fish | source

#
# Modern ls replacement (simple aliases work fine for these)
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --grid --git'
alias lt='eza --tree --level=2 --icons'

# --- Hardware Controls ---

function minictl
    sudo systemctl stop damx-daemon.service
    and arch-sense $argv
end

function ctlctr
    sudo systemctl start damx-daemon.service
    and begin
        # Fish uses >/dev/null 2>&1 for clean redirection
        DAMX >/dev/null 2>&1 &
        disown
    end
end

# --- Default Applications ---
# Sets the standard environment variable for scripts and CLI tools
set -gx TERMINAL kitty

# Forces xdg-terminal-exec to prioritize Kitty
# (This ensures SUPER+RETURN opens Kitty via Omarchy's wrapper)
set -gx XDG_TERMINAL_EXEC_DEBUG kitty.desktop

# Since you use Neovim, these are great to have as well
set -gx EDITOR nvim
set -gx VISUAL nvim


alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'


direnv hook fish | source


