FROM centos:7
LABEL maintainer "Levent SAGIROGLU <LSagiroglu@gmail.com>"

EXPOSE 9000

ENV CFG_INCLUDE "/etc/opt/remi/php73/php-fpm.d/*.conf"

RUN yum reinstall -y ca-certificates && \
	yum -y install epel-release && \
	rpm --import http://rpms.famillecollet.com/RPM-GPG-KEY-remi && \
    rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && \
    curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/mssql-release.repo  && \
    yum-config-manager --enable extras && \
	yum-config-manager --enable remi && \
    yum-config-manager --enable remi-php73 && \
	yum -y install \
           php73-php-fpm \
           php73-php-pdo \
           php73-php-json \
           php73-php-xml \
           php73-php-mysqli \
           php73-php-mbstring \
           php73-php-mysqlnd \
           php73-php-gd \
           php73-php-ldap \
           php73-php-mcrypt \
           php73-php-pecl-zip \
           php73-php-soap \
           php73-php-intl && \
    ACCEPT_EULA=Y yum -y install php73-php-sqlsrv && \
    yum clean all && \
    ln -s /opt/remi/php73/root/sbin/php-fpm /usr/sbin/php-fpm && \
	sed -i '/^listen = /c listen = 9000' /etc/opt/remi/php73/php-fpm.d/www.conf && \
	sed -i '/^listen.allowed_clients/c ;listen.allowed_clients' /etc/opt/remi/php73/php-fpm.d/www.conf && \	
    sed -i '/^include=/c include=${CFG_INCLUDE}' /etc/opt/remi/php73/php-fpm.conf
CMD ["php-fpm", "--allow-to-run-as-root", "--nodaemonize"]