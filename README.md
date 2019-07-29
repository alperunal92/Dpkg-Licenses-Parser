# Dpkg Licenses Parser

A command line tool which lists the licenses of all installed packages in a Debian-based system (like Ubuntu)

# How to run the Dpkg Licenses Parser in the command terminal (Give Permission on lib files)

~#cd dpkg-licenses <br />
~/dpkg-licenses# bash ./dpkg-licenses.sh >output.txt 2>error.txt

# The output quality on an average workspace Ubuntu installation looks like this

$ cat output.txt | cut -c135- | wc -l <br />
2230 <br />
$ cat output.txt | cut -c135- | grep unknown | wc -l <br />
228
