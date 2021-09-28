# sqlserver

Deploy an instance of Microsoft SQL Server 2019
for use as an Esri Enterprise Geodatabase.

[Microsoft docs](https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-ver15&pivots=cs1-bash)

## Set up

Copy sample.env to .env and edit for your needs.

Note there are password complexity rules. Minimum length is 8, mix of
upper and lower case and symbols.

## Deploy

```bash
docker-compose up -d
```

If you can't get the server to start, leave off -d to see the log messages.

## Connect

docker exec -it sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P <your_password>
