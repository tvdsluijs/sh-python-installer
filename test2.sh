while true; do
    read -p "Updating Python directly on your OS is not a good Idea! Are you aware with the problems you can cause? [y/n] " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "Please read https://itheo.tech/stop-updating-python-on-your-raspberry-pi-os-or-ubuntu"; exit;;
        * ) echo "Please answer y (yes) or n (no).";;
    esac
done