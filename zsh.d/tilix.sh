if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi

tps() {
    if [[ $TILIX_PROFILE == "dark" ]] 
    then
        export TILIX_PROFILE="light"
    else
        export TILIX_PROFILE="dark"
    fi
}
