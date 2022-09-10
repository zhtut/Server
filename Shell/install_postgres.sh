sudo apt install postgresql postgresql-contrib

sudo -u postgres psql -c "SELECT version();"

echo "允许远程访问"
echo "修改监听地址"
origin="#listen_addresses = 'localhost'"
replace="listen_addresses = '*'"
postgresql_conf="/etc/postgresql/*/main/postgresql.conf"
sudo sed -i "s|${origin}|${replace}|" ${postgresql_conf}
sudo cat ${postgresql_conf}

echo "修改可访问的ip段"
export host="host all all 0.0.0.0/0 md5"
export host_ipv6="host all all ::0/0 md5"
export pg_hba_conf="/etc/postgresql/*/main/pg_hba.conf"
sudo echo ${host} >>${pg_hba_conf}
sudo echo ${host_ipv6} >>${pg_hba_conf}
sudo cat ${pg_hba_conf}
