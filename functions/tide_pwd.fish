function tide_pwd
    argparse p-plain w/softlimit= -- $argv
    or return

    set -ql _flag_w
    and set -l softlimit $_flag_w
    or echo "$(set_color yellow) tide_pwd: -w or --softlimit required$(set_color normal)" 1>&2 && return 1

    set -q tide_pwd_color_truncated_dirs || set -l tide_pwd_color_truncated_dirs 8787AF
    set -q tide_pwd_color_anchors || set -l tide_pwd_color_anchors 00AFFF
    set -q tide_pwd_bg_color || set -l tide_pwd_bg_color normal
    set -q tide_pwd_color_dirs || set -l tide_pwd_color_dirs 0087AF
    set -q tide_pwd_icon_unwritable || set -l tide_pwd_icon_unwritable \uf023 # 
    set -q tide_pwd_icon_home || set -l tide_pwd_icon_home ""
    set -q tide_pwd_icon || set -l tide_pwd_icon ""
    set -q tide_pwd_markers || set -l tide_pwd_markers .git # .bzr .citc .git .hg .node-version .python-version .ruby-version .shorten_folder_marker .svn .terraform bun.lockb Cargo.toml composer.json CVS go.mod package.json build.zig

    set -l color_anchors
    set -l color_truncated
    set -l reset_to_color_dirs
    if not set -ql _flag_plain
        set_color -o $tide_pwd_color_anchors | read color_anchors
        set_color $tide_pwd_color_truncated_dirs | read color_truncated
        set reset_to_color_dirs (set_color normal -b $tide_pwd_bg_color; set_color $tide_pwd_color_dirs)
    end

    set -l unwritable_icon $tide_pwd_icon_unwritable' '
    set -l home_icon $tide_pwd_icon_home' '
    set -l pwd_icon $tide_pwd_icon' '

    if set -l split_pwd (string replace -r "^$HOME" '~' -- $PWD | string split /)
        test -w . && set -f split_output "$pwd_icon$split_pwd[1]" $split_pwd[2..] ||
            set -f split_output "$unwritable_icon$split_pwd[1]" $split_pwd[2..]
        set split_output[-1] "$color_anchors$split_output[-1]$reset_to_color_dirs"
    else
        set -f split_output "$home_icon$color_anchors~"
    end

    string join / -- $split_output | string length -V | read -g tide_pwd_len

    i=1 for dir_section in $split_pwd[2..-2]
        string join -- / $split_pwd[..$i] | string replace '~' $HOME | read -l parent_dir # Uses i before increment

        math $i+1 | read i

        if path is $parent_dir/$dir_section/$tide_pwd_markers
            set split_output[$i] "$color_anchors$dir_section$reset_to_color_dirs"
        else if test $tide_pwd_len -gt $_flag_softlimit
            string match -qr "(?<trunc>..|.)" $dir_section

            set -l glob $parent_dir/$trunc*/
            set -e glob[(contains -i $parent_dir/$dir_section/ $glob)] # This is faster than inverse string match

            while string match -qr "^$parent_dir/$(string escape --style=regex $trunc)" $glob &&
                    string match -qr "(?<trunc>$(string escape --style=regex $trunc).)" $dir_section
            end
            test -n "$trunc" && set split_output[$i] "$color_truncated$trunc$reset_to_color_dirs" &&
                string join / $split_output | string length -V | read tide_pwd_len
        end
    end

    string join -- / "$reset_to_color_dirs$split_output[1]" $split_output[2..] | read -l res
    if set -ql _flag_p
        echo "$res"
    else
        echo "$res"(set_color normal)
    end
end
