BOOKSORT
========

This is simple python3 script, which reads bunch of ebooks and stores
them into directory hierarchy under current directory using
first letter of author name as first level, author surname and given
name as second level, series as third and book title as file name

Supported formats
-----------------

Script supports fb2, epub pdf and djvu formats. External programs are
needed to extract metainformation  from pdf and djvu.

- djvused from [djvulibre tools](http://djvu.sourceforge.net/)
- pdftk from [pdftk-java](https://gitlab.com/pdftk-java/pdftk)

Author name handling
--------------------

In the fb2 files author name is split into last-name, middle-name and
first-name and each of them is supposed to be properly marked with
appropriate tags. In other formats set of heuristics is used to
find out whether author name is written first-name first or last-name
first. It is, of course error-prone.

Heuristics are mainly russian-language specific.
