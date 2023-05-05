source .env
docker exec -it sqlserver-sqlserver-1 /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${SA_PASSWORD}

