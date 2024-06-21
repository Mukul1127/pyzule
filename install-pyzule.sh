#!/bin/bash

PZ_DIR=${HOME}/.config/pyzule

if [ ! -x "$(command -v unzip)" ]; then
    echo "[!] unzip is not installed."
    exit 1
fi

if [ -x "$(command -v python)" ]; then
    PYTHON=python
elif [ -x "$(command -v python3)" ]; then
    PYTHON=python3
else
    echo "[!] python is not installed."
    exit 1
fi

mkdir -p ${PZ_DIR}
if [ ! -d ${PZ_DIR}/venv ]; then
    echo "[*] installing required pip libraries.."
    $PYTHON -m venv ${PZ_DIR}/venv > /dev/null

    ${PZ_DIR}/venv/bin/pip install -U Pillow orjson requests lief &> /dev/null
fi

if [ ! -x "$(command -v ldid)" ]; then
    echo "[*] installing ldid.."
    sudo curl -so ${PATHPREFIX}/usr/local/bin/ldid https://raw.githubusercontent.com/Mukul1127/pyzule/main/deps/ldid_${OS}_$ARCH
    sudo chmod +x ${PATHPREFIX}/usr/local/bin/ldid
fi

if [ ! -x "$(command -v ipsw)" ]; then
    echo "[*] installing ipsw.."
    sudo curl -so ${PATHPREFIX}/usr/local/bin/ipsw https://raw.githubusercontent.com/Mukul1127/pyzule/main/deps/ipsw_${OS}_$ARCH
    sudo chmod +x ${PATHPREFIX}/usr/local/bin/ipsw
fi

if [ ! -x "$(command -v otool)" ]; then
    echo "[*] installing otool.."
    sudo curl -so ${PATHPREFIX}/usr/local/bin/otool https://raw.githubusercontent.com/Mukul1127/pyzule/main/deps/otool_$ARCH
    sudo chmod +x ${PATHPREFIX}/usr/local/bin/otool
fi

if [ ! -x "$(command -v install_name_tool)" ]; then
    echo "[*] installing install_name_tool.."
    sudo curl -so ${PATHPREFIX}/usr/local/bin/install_name_tool https://raw.githubusercontent.com/Mukul1127/pyzule/main/deps/install_name_tool_$ARCH
    sudo chmod +x ${PATHPREFIX}/usr/local/bin/install_name_tool
fi

# create (or update) hidden dir
if [ ! -d ${PZ_DIR}/libellekit.dylib ]; then
    echo "[*] downloading dependencies.."
    curl -so /tmp/zxcvbn_dir.zip https://raw.githubusercontent.com/Mukul1127/pyzule/main/zxcvbn_dir.zip
    unzip -o /tmp/zxcvbn_dir.zip -d ${PZ_DIR} > /dev/null
    rm /tmp/zxcvbn_dir.zip
fi

echo "[*] installing pyzule.."
curl -so ~/.config/pyzule/version.json https://raw.githubusercontent.com/Mukul1127/pyzule/main/version.json
sudo rm ${PATHPREFIX}/usr/local/bin/pyzule &> /dev/null  # yeah this is totally required leave me alone
sudo curl -so ${PATHPREFIX}/usr/local/bin/pyzule ${PYZULEURL}
sudo sed -i "1s|.*|#\!${PZ_DIR}/venv/bin/python|" ${PATHPREFIX}/usr/local/bin/pyzule
echo "[*] fixed interpreter path!"
sudo chmod +x ${PATHPREFIX}/usr/local/bin/pyzule
echo "[*] done!"
