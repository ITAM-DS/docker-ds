## Version: 0.4

FROM nanounanue/docker-base
MAINTAINER Adolfo De Unánue Tiscareño "adolfo.deunanue@itam.mx"

ENV REFRESHED_AT 2016-08-19

ENV DEBIAN-FRONTEND noninteractive
ENV PATH /usr/lib/rstudio-server/bin/:$PATH

ENV RSTUDIO_VERSION 0.99.903

ENV RSTUDIO_URL=https://download2.rstudio.org/rstudio-server-${RSTUDIO_VERSION}-amd64.deb

## Cambiamos a root
USER root

RUN gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9
RUN gpg -a --export E084DAB9 | apt-key add -

RUN echo deb http://cran.rstudio.com/bin/linux/ubuntu trusty/ >> /etc/apt/sources.list

RUN apt-get -qq  update \
    && apt-get -y --no-install-recommends install r-base r-base-dev gdebi-core libapparmor1 libssl1.0.0 libssl-dev \
    psmisc supervisor poppler-utils postgresql-client-common libpq5 libpq-dev


RUN wget  -P /tmp - ${RSTUDIO_URL}

RUN dpkg -i  /tmp/rstudio-server-${RSTUDIO_VERSION}-amd64.deb \
&& rm /tmp/rstudio-server-${RSTUDIO_VERSION}-amd64.deb \
&& ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc /usr/local/bin \
&& ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin

## Templates para pandoc
RUN mkdir -p /opt/pandoc \
&& git clone https://github.com/jgm/pandoc-templates.git /opt/pandoc/templates \
&& chown -R root:staff /opt/pandoc/templates \
&& mkdir /root/.pandoc && mkdir /home/itam/.pandoc \
&& ln -s /opt/pandoc/templates /root/.pandoc/templates \
&& ln -s /opt/pandoc/templates /home/itam/.pandoc/templates

RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

## Montamos un volumen
VOLUME [ "/home/itam/proyectos" ]

# Para Rstudio
EXPOSE 8787

# Para IPython notebook
EXPOSE 8888


CMD ["/usr/bin/supervisord"]
