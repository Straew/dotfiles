# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
# End of lines configured by zsh-newuser-install

get_crtime() {

    for target in "${@}"; do
        inode=$(stat -c '%i' "${target}")
        fs=$(df  --output=source "${target}"  | tail -1)
        crtime=$(sudo debugfs -R 'stat <'"${inode}"'>' "${fs}" 2>/dev/null | 
        grep -oP 'crtime.*--\s*\K.*')
        printf "%s\t%s\n" "${target}" "${crtime}"
    done
}