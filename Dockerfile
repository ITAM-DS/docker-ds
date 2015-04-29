# Version: 0.1

FROM nanounanue/docker-base
MAINTAINER Adolfo De Unánue Tiscareño "adolfo.deunanue@itam.mx"

ENV REFRESHED_AT 2015-04-28

ENV DEBIAN-FRONTEND noninteractive
ENV PATH /usr/lib/rstudio-server/bin/:$PATH

# Cambiamos a root
USER root

RUN gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9
RUN gpg -a --export E084DAB9 | apt-key add -

RUN echo deb http://cran.rstudio.com/bin/linux/ubuntu trusty/ >> /etc/apt/sources.list

ENV RSTUDIO_VERSION 0.98.1103

## Instalar Julia
RUN add-apt-repository ppa:staticfloat/juliareleases \
&&  add-apt-repository ppa:staticfloat/julia-deps

RUN apt-get update

RUN apt-get -y --no-install-recommends install r-base r-base-dev littler python-rpy python-rpy-doc gawk
RUN apt-get -y --no-install-recommends install  gdebi-core libapparmor1 octave octave-common octave-doc octave-general octave-image octave-linear-algebra \
octave-odepkg octave-strings octave-symbolic octave-signal octave-io julia
RUN apt-get -y install libssl0.9.8 libssl-dev psmisc supervisor

ADD http://download2.rstudio.org/rstudio-server-$RSTUDIO_VERSION-amd64.deb /tmp

RUN dpkg -i  /tmp/rstudio-server-$RSTUDIO_VERSION-amd64.deb \
&& rm /tmp/rstudio-server-$RSTUDIO_VERSION-amd64.deb \
&& ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc /usr/local/bin \
&& ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin

RUN apt-get -y install poppler-utils jq # Cowsay, go, pdftotext (entre otras cosas) y jq
# jq se puede aprender como http://stedolan.github.io/jq/tutorial/

## Templates para pandoc
RUN mkdir -p /opt/pandoc \
&& git clone https://github.com/jgm/pandoc-templates.git /opt/pandoc/templates \
&& chown -R root:staff /opt/pandoc/templates \
&& mkdir /root/.pandoc && mkdir /home/itam/.pandoc \
&& ln -s /opt/pandoc/templates /root/.pandoc/templates \
&& ln -s /opt/pandoc/templates /home/itam/.pandoc/templates

RUN apt-get -y --no-install-recommends install libhdf5-dev
RUN apt-get -y --no-install-recommends install hdf5-tools hdf5-helpers
RUN apt-get -y --no-install-recommends install postgresql-client-common libpq5 libpq-dev

RUN pip install numpy sympy matplotlib scipy pandas
RUN pip install ipython[notebook] pyzmq jinja2 pygments bokeh

RUN pip install cython https://github.com/scikit-learn/scikit-learn/archive/master.zip
RUN pip install brewer2mpl prettyplotlib pymc numexpr

RUN pip install h5py
RUN pip install tables

## Para "scrapear"
RUN pip install beautifulsoup4 spyder requests

## Para conectarse a bases de datos
RUN pip install sqlalchemy

## Programación Probabilística
RUN pip install pymc

## Herramientas de líneas de comando
RUN pip install awscli # Línea de comandos de AWS
RUN pip install csvkit # http://csvkit.readthedocs.org


RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

## Montamos un volumen
VOLUME [ "/home/itam/proyectos" ]

# Para Rstudio
EXPOSE 8787

# Para IPython notebook
EXPOSE 8888

CMD ["/usr/bin/supervisord"]
