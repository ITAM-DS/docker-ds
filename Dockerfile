# Version: 0.0.1

FROM nanounanue/docker-base
MAINTAINER Adolfo De Unánue Tiscareño "adolfo.deunanue@itam.mx"

USER root

RUN gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9
RUN gpg -a --export E084DAB9 | apt-key add -

RUN echo deb http://cran.rstudio.com/bin/linux/ubuntu trusty/ >> /etc/apt/sources.list
RUN echo deb http://mx.archive.ubuntu.com/ubuntu trusty universe >> /etc/apt/sources.list
RUN echo deb http://mx.archive.ubuntu.com/ubuntu trusty restricted  >> /etc/apt/sources.list
RUN apt-get update

RUN apt-get install libhdf5-dev
RUN apt-get install hdf5
RUN apt-get install postgresql postgresql-client-common libpq5 libpq-dev postgresql-contrib
RUN apt-get install r-base r-base-dev littler python-rpy python-rpy-doc
RUN apt-get install octave gdebi-core libapparmor1
ADD http://download2.rstudio.org/rstudio-server-0.98.1091-amd64.deb
RUN dpkg -i  rstudio-server-0.98.1091-amd64.deb

RUN pip install numpy sympy matplotlib scipy pandas
RUN pip install ipython[notebook] pyzmq jinja2 pygments bokeh

RUN pip install cython https://github.com/scikit-learn/scikit-learn/archive/master.zip
RUN pip install brewer2mpl prettyplotlib pymc numexpr

RUN pip install h5py
RUN pip install tables


EXPOSE 8787
EXPOSE 8888
