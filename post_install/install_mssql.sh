#!/bin/bash

set -e

sa_pass="P@ss1234"

yay -Syu --noconfirm mssql-server mssql-tools

INSTALL_MSSQL=$(sudo expect -c "
spawn /opt/mssql/bin/mssql-conf setup

expect \"Enter your edition(1-8):\"
send \"2\r\"

expect \"Do you accept the license terms?\"
send \"Yes\r\"

expect \"Enter the SQL Server system administrator password:\"
send \"${sa_pass}\r\"

expect \"Confirm the SQL Server system administrator password:\"
send \"${sa_pass}\r\"

expect \"Setup has completed successfully. SQL Server is now starting.\"
send \"\"

expect eof
")

echo "${INSTALL_MSSQL}"
