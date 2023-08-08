function mkGraph() {
    local resultDir
    local callDir="$(pwd)"

    # if an argument was passed, use it as resultDir, else use current directory
    if [[ -n $1 ]]; then
        resultDir=$1
    else
        resultDir="${callDir}/result"
    fi

    if [[ ! -d "$resultDir" ]]; then
        echo "$resultDir is not a directory"
        return 1
    fi

    nix-store --query --graph "$(readlink $resultDir)" | dot -Tsvg > "${callDir}/graph.svg"
}
