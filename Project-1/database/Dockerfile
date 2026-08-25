#mysql file
FROM mysql/mysql-server:5.7
ENV MYSQL_USER=root
ENV MYSQL_ROOT_PASSWORD=root
EXPOSE 3306
COPY database.sql /docker-entrypoint-initdb.d/database.sql
