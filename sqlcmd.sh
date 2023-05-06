source .env
docker exec -it sqlserver-db-1 /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${SA_PASSWORD}

