FROM centos:7
LABEL maintainer "Levent SAGIROGLU <LSagiroglu@gmail.com>"

EXPOSE 9000

ENV CFG_INCLUDE "/etc/opt/remi/php72/php-fpm.d/*.conf"

RUN \
    yum -y update wget yum-utils&& \
	yum -y install deltarpm && \
	yum -y install epel-release && \
	rpm --import http://rpms.famillecollet.com/RPM-GPG-KEY-remi && \
    rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && \
    curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/mssql-release.repo

RUN yum-config-manager --enable extras && \
	yum-config-manager --enable epel && \
	yum-config-manager --enable remi && \
	yum-config-manager --disable remi-php55 && \
	yum-config-manager --disable remi-php56 && \
	yum-config-manager --disable remi-php70 && \
    yum-config-manager --disable remi-php71 && \
    yum-config-manager --enable  remi-php72 && \
	yum -y install \
           openldap-clients \
           php72-php-fpm \
           php72-php-json \
           php72-php-xml \
           php72-php-mysqli \
           php72-php-mbstring \
           php72-php-mysqlnd \
           php72-php-gd \
           php72-php-ldap \
           php72-php-mcrypt \
           php72-php-pecl-zip \
           php72-php-soap \
           php72-php-intl && \

# for last version info : https://packages.microsoft.com/rhel/7/prod/

    ACCEPT_EULA=Y yum install -y msodbcsql17-17.2.0.1-1 mssql-tools-17.2.0.2-1 unixODBC-devel  && \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile && \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc  && \
    source ~/.bashrc && \
    ACCEPT_EULA=Y yum -y install php72-php-pdo \
                    php72-php-sqlsrv && \

    yum reinstall -y ca-certificates && \
    yum clean all && \
    ln -s /opt/remi/php72/root/sbin/php-fpm /usr/sbin/php-fpm && \
    sed -i '/^include=/c include=${CFG_INCLUDE}' /etc/opt/remi/php72/php-fpm.conf

CMD ["php-fpm", "--allow-to-run-as-root", "--nodaemonize"]