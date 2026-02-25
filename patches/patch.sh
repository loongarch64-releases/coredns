#/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

version="$1"
major_ver=$(echo "$version" | cut -d. -f1)
minor_ver=$(echo "$version" | cut -d. -f2)
patch_ver=$(echo "$version" | cut -d. -f3)

echo "patching ..."

# 升级依赖包
if [ "$major_ver" -eq 1 ] && [ "$minor_ver" -lt 11 ]; then
    go get golang.org/x/net@v0.12.0
    if [ "$minor_ver" -lt 10 ]; then
        go get golang.org/x/sys@v0.11.0
    fi

    go_ver=$(awk '/^[[:space:]]*go[[:space:]]+[0-9]/ {print $2; exit}' go.mod)
    if [ "$(echo -e "1.16\n$go_ver" | sort -V | head -n1)" = "1.16" ]; then
        tidy_arg="-compat=$go_ver"
    else
        tidy_arg=""
    fi

    go mod tidy $tidy_arg
elif [ "$major_ver" -eq 1 ] && [ "$minor_ver" -eq 11 ] && [ "$patch_ver" -eq 0 ]; then
    go get github.com/quic-go/quic-go@v0.37.4
    go mod tidy
fi

echo "done"

