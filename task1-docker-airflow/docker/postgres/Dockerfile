FROM library/postgres:12
COPY data_efishery.csv /
RUN chown postgres:postgres data_efishery.csv
COPY init.sql /docker-entrypoint-initdb.d/
