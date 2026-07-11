function ll --wraps=ls --wraps='eza -a -1 --icons -l' --description 'alias ll=eza -a -1 --icons -l'
    eza -a -1 --icons -l $argv
end
