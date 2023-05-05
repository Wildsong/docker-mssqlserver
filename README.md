# docker-mssqlserver

Deploy an instance of Microsoft SQL Server for testing and experimentation.

It's built on SQL Server running on Ubuntu.
It is for development and testing only, not production.

[Microsoft docs](https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-ver15&pivots=cs1-bash)

## Set up

Copy sample.env to .env and edit for your needs.

Note there are password complexity rules.
Minimum length is 8, mix of upper and lower case and symbols.

## Deploy

The compose.yaml is very simple because this is only a testing deployment,
so for example it will not restart after the host is rebooted.

Do a "pull" to make sure I have the latest image cached.

    docker pull mcr.microsoft.com/mssql/server:2019-latest
    docker compose up -d

If you can't get the server to start, leave off -d to see the log messages.

## Connect

You can get a command line on the server with this command. Or use the shell script sqlcmd.sh.

    docker exec -it sqlserver_sqlserver_1 /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P <your_password>

You can install SQL Server Management Studio (SSMS) on a Windows Desktop.
It is available here: https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms
It runs over port 1433.

Port 1433 is exposed on your local network, so you should be able
to see the SQL Server using the name of the hosting machine in SSMS.

## Loading data

(Microsoft docs on doing a backup)[https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/create-a-full-database-backup-sql-server?view=sql-server-ver15]

On my live server, I used SQL Server Management Studio (SSMS) from my desktop to do a full backup.
I logged in there as myself with Windows authetentication. I used this as the destination:
C:\Temp\ClatsopBackup.bak and when it was done the file was generated on the server, not my desktop. Well, I can deal with that.

(Microsoft migration notes)[https://docs.microsoft.com/en-us/sql/t-sql/statements/alter-database-transact-sql-compatibility-level?view=sql-server-ver15#compatibility-levels-and-database-engine-upgrades]
I am going from version 12 (2014) to version 15 (2019) which is a pretty big jump.
It looks like 2019 supports it though. 12 = level 120.

I copied the backup file from the production server into the volume of the Docker, this worked for me. It took a long time. Copying 5GB
from a pokey Windows server to a pokey Docker volume on a virtual machine, probably stored on the same Windows server. Modern life.

    docker cp /media/backups/MYBACKUPFILE_backup sqlserver_sqlserver_1:/var/opt/mssql/

I connected via SSMS from my Windows Desktop to the docker Sql Server and did the restore there.
Since this is a brand-new instance of SQL Server there are no accounts at all on it, except "sa", 
you set the password for that in the .env file, remember?

You have to restore the database from a "Device" but actually it lets you choose a file once you go down
that path.

Once you have the restore operation pointing at the file, it will fill in the database name for you,
instilling confidence you are in fact doing the right thing.

Options include "Overwrite the existing database".
What's the "Recovery State"?? You can see the description in the yellow box. I left it at the default.
I guess you should freeze the database before taking a backup to avoid problems here! There should be no uncommitted transactions.

I want database user "sde" to own the database. On the production server, one of our
users owns it, this seems fundamentally wrong to me. :-) I am here to learn.

The database was owned by "sa" after I restored it so I created an 'sde' login,
gave it a password, and made sde the owner of my geodatabase.
(Details on changing ownership)[https://www.sqlshack.com/different-ways-to-change-database-owners-in-sql-server/]

In the restored data I can see what appears to be windows owners but those are just SQL schemas.
For example there is Clatsop\bwilson. Most of them are showing dbo, like "dbo.BUILDINGS".

I created a login for myself in the database.

There is a process for upgrading the database queries, this probably won't affect us but
instructions are here (Upgrade DB Compatibility use QTA)[https://docs.microsoft.com/en-us/sql/relational-databases/performance/upgrade-dbcompat-using-qta?view=sql-server-ver15].
This process takes at least a day because step one is to capture data on the existing queries.

## Register the server as a data store in Server

(Register data with Server)[https://enterprise.arcgis.com/en/server/latest/manage-data/linux/registering-your-data-with-arcgis-server-using-manager.htm]
or
(Register from Pro)[https://enterprise.arcgis.com/en/server/latest/manage-data/windows/register-sql-server-with-arcgis-server.htm]

## Resources

## To Do

