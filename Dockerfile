FROM debian:latest
MAINTAINER TiToine <titoine@giroll.org> 

RUN apt-get update && apt-get install -y libmail-imapclient-perl libmail-spamassassin-perl libdbi-perl libdbd-sqlite3-perl unzip wget 

RUN cpan -i Mail::SpamAssassin Mail::IMAPClient DBI

RUN cd /opt && wget "https://framagit.org/kepon/ImapSpamScan.pl/raw/master/imapSpamScan.pl?inline=false" -O /opt/imapSpamScan.pl && chmod +x /opt/imapSpamScan.pl

RUN echo 'blacklist_from *@qq.com' >> /etc/spamassassin/local.cf

RUN echo "#!/usr/bin/env sh\n/opt/imapSpamScan.pl --debug --verbose --imapssl \${SSL} --imapsrv=\${SERVER} --imapuser=\${USER} --imappassword=\${PASSWORD} --db=/opt/imapSpamScan.db" >> /opt/docker-entrypoint.sh && chmod +x /opt/docker-entrypoint.sh

ENTRYPOINT ["/opt/docker-entrypoint.sh"]
