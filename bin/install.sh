#!/bin/bash

RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`

_OK_="${GREEN}[OK]  ${RESET}"
_ERR_="${RED}[ERR] ${RESET}"

tegia_folder=$(realpath ../../)


# ----------------------------------------------------------------------------------------
#
# Настраиваем подключение к MySQL
#
# ----------------------------------------------------------------------------------------

#
# HOST
#

mysql_host=$(echo $MYSQL_HOST)

#
# PORT
#


mysql_port=$(echo $MYSQL_PORT)

#
# TEGIA USER & PASSWORD
#

mysql_user='tegia_user'
mysql_password=$(echo $MYSQL_PASSWORD)

#
# SAVE tegia.cnf FILE
#

tee ../../tegia.cnf << EOF > /dev/null
[mysql]
host=$mysql_host
port=$mysql_port
user=$mysql_user
password=$mysql_password
EOF

echo "${_OK_}file '$tegia_folder/tegia.cnf' is saved"


# ----------------------------------------------------------------------------------------
#
# Устанавливаем зависимости
#
# ----------------------------------------------------------------------------------------

sudo apt install -y git mc screen jq
sudo apt install -y python build-essential default-libmysqlclient-dev libtool m4 automake uuid-dev libxml2-dev
sudo apt install -y libcurl4-openssl-dev libssl-dev
sudo apt install -y cmake zlibc
sudo apt install -y libbz2-dev libzip-dev unzip
sudo apt install -y pkg-config

sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
sudo apt install -y g++-11 gcc-11
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 60 --slave /usr/bin/g++ g++ /usr/bin/g++-11

# ----------------------------------------------------------------------------------------
#
# Настраиваем директории
#
# ----------------------------------------------------------------------------------------

mkdir -p $tegia_folder/vendors
mkdir -p $tegia_folder/configurations
mkdir -p $tegia_folder/nodes
mkdir -p $tegia_folder/debs
mkdir -p $tegia_folder/ui

# ----------------------------------------------------------------------------------------
#
# Загружаем и настраиваем используемые библиотеки
#
# ----------------------------------------------------------------------------------------

#
# nlohmann json
#

cd $tegia_folder/vendors
git clone https://github.com/nlohmann/json.git
cd json
mkdir -p build
cd build
cmake ..
make
sudo make install
sudo ldconfig

#
# json-schema-validator
#

cd $tegia_folder/vendors
git clone https://github.com/pboettch/json-schema-validator.git
cd json-schema-validator
mkdir -p build
cd build
cmake .. -DBUILD_SHARED_LIBS=ON ..
make
sudo make install
sudo ldconfig




#
# Gumbo parser
#

cd $tegia_folder/vendors
git clone https://github.com/google/gumbo-parser.git
cd gumbo-parser
./autogen.sh
./configure
make
sudo make install
sudo ldconfig

#
# xml2json
#

cd $tegia_folder/vendors
git clone https://github.com/Cheedoong/xml2json
sudo ln -fs $tegia_folder/vendors/xml2json /usr/include/xml2json


#
# fmt
#

cd $tegia_folder/vendors
git clone https://github.com/fmtlib/fmt.git
cd fmt
mkdir -p build
cd build
cmake -DBUILD_SHARED_LIBS=TRUE ..
make
sudo make install
sudo ldconfig

#
# libxml2 headers
#

#sudo ln -fs /usr/include/libxml2/libxml /usr/include/libxml

#
# vincentlaucsb / csv-parser
#

cd $tegia_folder/vendors
git clone https://github.com/vincentlaucsb/csv-parser.git

#
# tfussell / xlnt
#

cd $tegia_folder/vendors
git clone https://github.com/tfussell/xlnt.git
cd xlnt/third-party && rm -rf libstudxml
git clone https://git.codesynthesis.com/libstudxml/libstudxml.git
cd ../
cmake .
make -j 2
sudo make install
sudo ldconfig

#
# jwt
#

cd $tegia_folder/vendors
git clone https://github.com/arun11299/cpp-jwt.git

#
# DuckX - ms word .docx generator
#

sudo apt install -y libpugixml-dev

cd $tegia_folder/vendors
git clone https://github.com/amiremohamadi/DuckX.git
cd DuckX
mkdir -p build
cd build
cmake .. -DBUILD_SHARED_LIBS=TRUE ..
cmake --build .
sudo make install
sudo ln -fs /usr/local/lib/libduckx.so /usr/lib/libduckx.so

#
# graphviz-dev
#

sudo apt install -y graphviz-dev

#
# tegia include files
#

if [ -d /usr/include/tegia/ ]; then
	sudo rm -R /usr/include/tegia
fi

sudo ln -fs $tegia_folder/platform/include /usr/include/tegia


# ----------------------------------------------------------------------------------------
#
# Файл с флагами компиляции
#
# ----------------------------------------------------------------------------------------

tee $tegia_folder/Makefile.variable << EOF > /dev/null
ProdFlag			= -rdynamic -std=c++2a -march=native -m64 -O2
DevFlag				= -rdynamic -std=c++2a -march=native -m64 -Og -g -Wpedantic -Wshadow=compatible-local -Wl,--no-as-needed 
Flag = \$(DevFlag)
EOF


exit 0
