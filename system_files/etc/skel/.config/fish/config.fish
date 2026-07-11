# Fish config

if status is-interactive
    zoxide init fish | source
end

set -Ux EDITOR hx
set -Ux VISUAL $EDITOR
