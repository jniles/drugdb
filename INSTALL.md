## Installation Instructions for DrugDB

In order to build the DrugDB application, make sure you have the following
dependencies installed.  The examples below have been tested on Linux Mint 17.

### Step 1: Download the Dependencies
The application's dependencies are as follows:
- Ruby 1.9.1 (or greater)
- SQLite3
- A mail server
- Bundler (Ruby installer)

On a debian-based linux distribution, the follows commands should work to get
you up and running:
```bash
$ # Note: Requires root privilages
$ apt-get install ruby sqlite3 libsqlite3-dev bundler
```

### Step 2: Get the source file
The source code is kept in a public repository on Github.  You can clone it using
git or download it as a zip file.  The example belows uses git.

```bash
$ # Fetch the source code
$ git clone https://github.com/New-College-of-Florida/Planned-Parenthood-Drug-Inventory drugdb
Cloning into drugdb ...
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


### Step 4: Use the parser to build the database
We built a script to ease the install parser.  The initial build reads from files
in the `/data/init` folder.  Feel free to edit any of the files, they will be imported
as the initial data for the database.

```bash
$ # From within the repository
$ ruby ./parser/main.rb --install
```

This will create a database at the `config.yaml` db path.

### Step 5 : Run and Test the Application
The server is contained in the `server.rb` file.  Run it using the `rackup` command.

```bash
$ # run the server
$ rackup -p 4567
```

There terminal should output a few lines then wait.  Navigate to `localhost:4567` in your
browser and verify that are you immediately rerouted to `localhost:4567/login.html`.

### Congratulations!
You have successfully installed Drug Inventory!  All feedback is appreciated.  Send an email to
jonathan dot niles at ncf dot edu with comments and critiques.  Enjoy!
