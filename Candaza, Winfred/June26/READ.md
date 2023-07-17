1. What is CLI for
    A command-line interface (CLI) is a text-based user interface (UI) used to run programs, manage computer files and interact with the computer. Command-line interfaces are also called command-line user interfaces, console user interfaces and character user interfaces.
2. Common CLI commands and their meanings
    man command - Show manual for command

    pwd - Prints the full name (the full path) of current/working directory

    ls - List directory contents
    ls -a - List all the content, including hidden files
    ls -l - List the content and its information

    mkdir foldername – Create a new directory foldername

    cd foldername – Change the working directory to foldername
    cd - Return to $HOME directory
    cd .. - Go up a directory
    cd - - Return to the previous directory

    emacs, nano, vi – File editors

    cp source destination – Copy source to destination
    cp -r source destination – Copy a directory recursively from source to destination

    mv source destination - Move (or rename) a file from source to destination

    rm file1 - Remove file1
    rm -r folder - Remove a directory and its contents recursively

    cat file – Print contents of file on the screen
    less file - View and paginate file
    head file - Show first 10 lines of file
    tail file - Show last 10 lines of file
3. What is git for
    Git is a DevOps tool used for source code management. It is a free and open-source version control system used to handle small to very large projects efficiently. Git is used to tracking changes in the source code, enabling multiple developers to work together on non-linear development.
4. Common GIT commands and their meanings
    git init
        initialize a Git repository for our local project folder. Git will create a hidden .git directory and use it for     keeping its files organized in other subdirectories.
    git add
        This will add the specified file(s) into the Git repository, the staging area, where they are already being tracked by Git and now ready to be committed.
    git commit
        This command records or snapshots files permanently in the version history. All the files, which are there in the directory right now, are being saved in the Git file system.
    git status
        This command will show the modified status of an existing file and the file addition status of a new file, if any, that has to be committed.
    git remote
        Once everything is ready on our local system, we can start pushing our code to the remote (central) repository of the project.
    
    