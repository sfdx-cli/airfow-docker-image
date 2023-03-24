FROM apache/airflow:2.5.2
USER root
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
         vim \
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Airflow config
ARG AIRFLOW_USER_HOME=/opt/airflow
ARG AIRFLOW_DEPS=""
ARG PYTHON_DEPS=""
ENV AIRFLOW_HOME=${AIRFLOW_USER_HOME}


RUN chown -R airflow: ${AIRFLOW_USER_HOME}

EXPOSE 8080 5555 8793

# Use the airflow user
USER airflow
WORKDIR ${AIRFLOW_USER_HOME}



# Copy custom DAGs nad scripts
COPY dags/ ${AIRFLOW_USER_HOME}/dags/
COPY scripts/ ${AIRFLOW_USER_HOME}/scripts/

# airflow db init
RUN airflow db init
# airflow users create
RUN airflow users create \
    --username admin \
    --firstname admin \
    --lastname admin \
    --role Admin \
    --email demo@demo.com \
    --password admin

# start airflow webserver and scheduler
# RUN airflow schedul
# CMD ["webserver" ]

# start airflow webserver and scheduler
CMD ["standalone"]