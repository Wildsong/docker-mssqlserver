source .env
docker exec -it sqlserver_sqlserver_1 /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${SA_PASSWORD}

