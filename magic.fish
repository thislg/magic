#!/usr/bin/env fish

function magic_from
    set -l dir "$argv[1]"

    if test -z "$dir"
        return
    end

    while test "$dir" != "/"
        if test -r "$dir/.spells.fish"
            echo "$dir"
        end
        set dir (dirname "$dir")
    end
end

function magic_load --description "Load/unload spells based on current directory"
    if test "$PWD" != "$MAGIC_LAST"

        set -l uninstall (magic_from "$MAGIC_LAST")
        set -l install (magic_from "$PWD" | tac)

        if test "$uninstall" != "$install"

            # Unload spells from directories we're leaving
            if test -n "$uninstall"
                for magic in $uninstall
                    if test -n "$magic"
                        set -l spells (grep -oP '^function \K\S+' "$magic/.spells.fish" 2>/dev/null)
                        for spell in $spells
                            functions -e "$spell" 2>/dev/null
                        end
                    end
                end
            end

            # Load spells from directories we're entering
            if test -n "$install"
                for magic in $install
                    if test -n "$magic"
                        source "$magic/.spells.fish" 2>/dev/null
                    end
                end
            end
        end

        set -g MAGIC_LAST "$PWD"
    end
end

# Hook magic_load on directory change
function __magic_chdir --on-variable PWD
    magic_load
end
