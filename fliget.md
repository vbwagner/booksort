Flibusta archive manager
========================

This script handles search and extraction of e-books from flibusta.net
archive as distributed via torrents.

Script expects that archive contains montly zipfiles with ebooks and
archives of windows-based programs with dumps of mySQL databases.

Script loads these mySQL dumps into sqlite database and uses it to
search.

Modes of operation
==================

Database (re)build
------------------

```
  fliget [--rebuild|-R]
```

If database exists it checks whether archive with mySQL dumps is newer,
and if so, truncates all tables and loads new ones. Truncate and reload
mode is chosen because records of old books can be changed in database
(i.e. marked as deleted).


If database doesn't exist, script creates it using builtin schema
definition.

Database should be rebuilt each time as monthly update is downloaded via
torrents.

Search 
------

```
 fliget [-x|--exact] [-t|--title title] [-T|--title-or-seq title or sequence] 
        [-a|--author author] [-g|--get] [-s|--sequence sequence]
```

Searches database for given book. Unless `--get` is given, just print
filenames author names, titles and sequences if any.

If option `--exact` search patterns must exactly match appropriate
metainformation, otherwise SQL LIKE is used to find pattern anywhere in
fields.

Option `--title-or-seq` search for text in the book title or sequence
name. 

If `--get` is given, all found books are extrected to separate file

List of authors and genres
--------------------------

   fliget -lg [pattern]

list genres. If pattern is specified, only ones maching

   fliget [-x] -la name

list authors matching pattern. Uses same name match rules as seqrch
query.

Extraction
----------

```
    fliget [-g|--get] book_id...
``` 
    fliget -g [query options]

Extracts all specified books into directory, specified in configuration
file. You can specify either list of numeric book ids or search query.

Configuration file
==================

By default **fliget** reads configuration file `${HOME}/.config/fliget.conf`

If no such file exists, sensible defaults are provided. These defaults
assume that flibusta archive is on external drive with label LIBRARY in
the `Flubusta.Net` directory and metainformation database is in sqlite
format in the `flubusta.db`file on the same drive.

Alternate location for configuration file can be specified using
`--config` command line op option.

Configuratuion is ini style file with following sections:

[archive]
---------

Specifies location of Flibusta.Net archive as downloaded from torrents.
Contains following opions:

**path** - path to archive directory

**dbdump** name of archive with `multilib` program containing sql dumps

**dumpprefix** prefix of sql files inside archive

[database]
----------

Database parameters. Contains 

**driver** - name if database driver. Can be name of python module which
implements DB API 2.0. Also `sqlite` is recognized as synonym of
`sqlite3` from standard library and `pgsql` causes search for psycopg or
psycopg2 in this order (nowadays psycopg is psychopg3).

All other parameters are passed to module `connect` function as keyword
arguments.

[output]
--------

Where to extract files from archive. 
Contains following parameters: 

**path** directory where to extracct

**name** name of file, which can include following format specifiers:

`%A' first letter of authors last name

`%l` author's last name

`%f` author's first name

`%m` author's muddle name

`%s` sequence name

`%N` number in sequense

`%t` file type (extension)

`%g` genre

**coauthor_links** - boolean parameter. If true, hard links are created
for each author and genre of book. If false, only first one is used.
