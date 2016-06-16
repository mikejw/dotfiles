



# macports
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

# apache
alias starthttpd="sudo /opt/local/apache2/bin/apachectl restart"

# java
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

# maven
export PATH="~/softwares/apache-maven-3.2.3/bin:$PATH"
#alias mvnstuff="mvn clean install; mvn tomcat:redeploy"
alias mvnstuff="mvn tomcat:redeploy"

# mongo
export PATH="~/softwares/mongodb-osx-x86_64-2.6.5/bin:$PATH"


# mongodb
# taken from: https://github.com/codeforamerica/ohana-api/wiki/Installing-MongoDB-with-MacPorts-on-OS-X

alias mongostart="sudo mongod -f /opt/local/etc/mongodb/mongod.conf --httpinterface"

mongostop_func () {
  local mongopid=`less /opt/local/var/db/mongodb_data/mongod.lock`;
  if [[ $mongopid =~ [[:digit:]] ]]; then
      sudo kill -15 $mongopid;
      echo mongod process $mongopid terminated;
  else
      echo mongo process $mongopid not exist;
  fi
}

alias mongostop="mongostop_func"




# elasticsearch
export PATH="~/softwares/elasticsearch-1.4.0/bin:$PATH"

# python stuff
export PATH="/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH"

# php
#alias php="/opt/local/bin/php70"

# mariadb
export PATH="/opt/local/lib/mariadb/bin:$PATH"
# start server with
alias startdb="sudo cd '/opt/local' ; sudo /opt/local/lib/mariadb/bin/mysqld_safe --datadir='/opt/local/var/db/mariadb'"


# node
export PATH="/opt/node/bin:$PATH"

# perl stuff (macports + local-lib)
alias perl="/opt/local/bin/perl"
[ $SHLVL -eq 1 ] && eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"

# elastic tools
export PATH="~/code/mikejw/java-tools/elastic:$PATH"

# memcached
alias start_memcached="memcached -d -m 24 -p 11211"

# docker
export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=/Users/mike/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1

docker-enter() {
  boot2docker ssh '[ -f /var/lib/boot2docker/nsenter ] || docker run --rm -v /var/lib/boot2docker/:/target jpetazzo/nsenter'
  boot2docker ssh -t sudo /var/lib/boot2docker/docker-enter "$@"
}


