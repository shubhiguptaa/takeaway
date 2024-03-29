
FROM debian:stretch-slim

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Airflow
ARG AIRFLOW_VERSION=1.10.4
ARG AIRFLOW_USER_HOME=/usr/local/airflow
ARG AIRFLOW_DEPS=""
ARG PYTHON_DEPS=""
ENV AIRFLOW_HOME=${AIRFLOW_USER_HOME}

# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8

RUN set -ex \
    && buildDeps=' \
        freetds-dev \
        libkrb5-dev \
        libsasl2-dev \
        libssl-dev \
        libffi-dev \
        libpq-dev \
        git \
    ' \
    && apt-get update -yqq \
    && apt-get upgrade -yqq \
    && apt-get install -yqq --no-install-recommends \
        $buildDeps \
        freetds-bin \
        build-essential \
        apt-utils \
        vim \
        curl \
        rsync \
        netcat \
        locales \
    && echo 'y' | apt-get install python \
    && echo 'y' | apt-get install python-pip \
    && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && useradd -ms /bin/bash -d ${AIRFLOW_USER_HOME} airflow \
    && pip install -U setuptools wheel \
    && pip install pytz \
#    && pip install pyOpenSSL \
#    && pip install ndg-httpsclient \
    && pip install pyasn1 \
    && pip install flask-bcrypt \
    && pip install auth \
    && pip install apache-airflow[postgres,ssh${AIRFLOW_DEPS:+,}${AIRFLOW_DEPS}]==${AIRFLOW_VERSION} \
    && pip install 'apache-airflow[statsd]' \
    && if [ -n "${PYTHON_DEPS}" ]; then pip install ${PYTHON_DEPS}; fi \
    && apt-get purge --auto-remove -yqq $buildDeps \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

COPY script/entrypoint.sh /entrypoint.sh
COPY script/add_user.py /add_user.py
COPY config/airflow.cfg ${AIRFLOW_USER_HOME}/airflow.cfg
RUN sed -i 's/catchup_by_default = True/catchup_by_default = False/' ${AIRFLOW_USER_HOME}/airflow.cfg
RUN sed -i'.orig' 's/max_threads = 2/max_threads = 1/g' ${AIRFLOW_USER_HOME}/airflow.cfg


RUN chown -R airflow: ${AIRFLOW_USER_HOME}

EXPOSE 8080

USER airflow
WORKDIR ${AIRFLOW_USER_HOME}
ENTRYPOINT ["/entrypoint.sh"] 
CMD ["webserver"] # set default arg for entrypoint
