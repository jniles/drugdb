Drug Inventory
==================================

#### A Drug Inventory Management Application for Planned Parenthood of Florida

##### Purpose

This application generates statistics on drug usage and alerts managers
of health centers to reorder drugs when supplies are low various health
centers in southwestern and central Florida.  The application is designed
to be minimalist, enabling unobtrusive alerts through email with some
analytical tooling to verify the alert process.

##### Environment

DrugInventory is designed to run on a Windows 2008 R2 server.  However,
the application should be easily portable to any environment that supports
Ruby, sqlite3, and a local mail server.

For a full list of dependencies, see the Gemfile.  However, in brief,
we are running:
 - Sinatra
 - DataMapper
 - SQLite3 (Database Adapter)
 - Pony (Mail Server Adapter)

##### Developer Notes

There are three tiers to this application: the scheduler, the parser(s), and
the web and mail servers.  Each component could easily operate separately from
the other, and it will be up to the project maintainers to decide how modular
to make the components.

The scheduler is highly system dependent, and responsible for scheduling the
parser and email report batch scripts.  The scheduler is likely either a shell
or batch file that ensure that the parser scripts are run every work day and
send mail at configured intervals.

The parser(s) are a collection of scripts responsible for importing data from
raw files put into folders.  Raw formats are Microsoft Excel 2003 and CSV.  The
parser decides which data must be parsed, opens up the required folder or folders,
reads in textual strings, and writes them as database objects in the drug.db
database.

The web/mail servers are responsible for all user-facing interaction.  They
provide a reporting system, a viewing system, and some administrator tools.
The web server is protected by authentication to prevent unauthorized tampering.
Both servers configuration information is contained in the sqlite3 database
drug.db.


##### Installation

See our INSTALL.md guide.

##### License

MIT
