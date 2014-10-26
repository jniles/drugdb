## Installation Instructions for DrugDB

In order to build the DrugDB application, make sure you have the following
dependencies installed.  The examples below have been tested on Linux Mint 17.

### Step 1: Download the Dependencies
The application's dependencies are as follows:
- Ruby 1.9.1 (or greater)
- MySQL
- SQLite3
- Bundler (Ruby installer)

On a debian-based linux distribution, the follows commands should work to get
you up and running:
```bash

$ # Note: Requires root privilages
$ apt-get install ruby mysql sqlite3 libsqlite3-dev bundler
```

### Step 2: Get the source file
The source code is kept in a public repository on Github.  You can clone it using
git or download it as a zip file.  The example belows uses git.

```bash

$ # Fetch the source code
$ git clone https://github.com/jniles/drug_inventory
Cloning into drug_inventory...
```
### Step 3: Use Bundler to Download and Install the Gems
DrugDB uses a variety of third party packages to interface with databases
and form the foundation of the web app.  Use `bundler` to install them.

```bash
$ bundle install
```
###### Note
If you experince crashes or errors during the bundler command, check to make
sure that you have all the required dependencies.  Often, the installation of
an interface requires the development files of a particular dependency.  For example,
make sure you have the development version of SQLite3 installed (on debian-based : 
`apt-get install libsqlite3-dev`) and the same for Ruby.


### Step 4: Build the SQL database
Build the SQL database by importing the file `ddrugdb.sql`.  This can be done through
the MySQL command line or a GUI of your choosing.  For example,

```bash
$ mysql -u [username] -p[password] <ddrugdb.sql
```
where `[username]` is replaced by your MySQL user and `[password]` by the associated password.

### Step 5 : Run and Test the Application
The server is contained in the `main.rb` file.  Execute it with ruby.

```bash
$ # run the server
$ rackup -p 1234 server.rb
```

There terminal should output a few lines then wait.  Navigate to `localhost:4567` in your
browser and verify that are you immediately rerouted to `localhost:4567/home`.

### Congratulations!
You have successfully installed DrugDB!  All feedback is appreciated.  Send an email to 
jonathan dot niles at ncf dot edu with comments and critiques.  Enjoy!
