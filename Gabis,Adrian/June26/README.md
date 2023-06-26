1. What is CLI used for?
A command-line interface (CLI) is a text-based user interface (UI) used to run programs, manage computer files and interact with the computer. Command-line interfaces are also called command-line user interfaces, console user interfaces and character user interfaces.It's most commonly used in the Unix and Linux operating systems, although it can also be used in Windows and the macOS as well.

2. Common CLI commands and their meanings
pwd - Prints the full name (the full path) of current/working directory
ls - List directory contents
ls -a - List all the content, including hidden files
ls -l - List the content and its information

mkdir foldername – Create a new directory foldername

cd foldername – Change the working directory to foldername
cd - Return to $HOME directory
cd .. - Go up a directory
cd - - Return to the previous directory

mv source destination - Move (or rename) a file from source to destination

rm file1 - Remove file1
rm -r folder - Remove a directory and its contents recursively

cat file – Print contents of file on the screen
less file - View and paginate file
head file - Show first 10 lines of file
tail file - Show last 10 lines of file

3. What is GIT for?
Git is a DevOps tool used for source code management. It is a free and open-source version control system used to handle small to very large projects efficiently. Git is used to tracking changes in the source code, enabling multiple developers to work together on non-linear development.

4. Common Git Commands and their meanings
*git clone
Git clone is a command for downloading existing source code from a remote repository (like Github, for example). In other words, Git clone basically makes an identical copy of the latest version of a project in a repository and saves it to your computer.

*git branch
Branches are highly important in the git world. By using branches, several developers are able to work in parallel on the same project simultaneously. We can use the git branch command for creating, listing and deleting branches.

Creating a new branch:

git branch <branch-name>

This command will create a branch locally. To push the new branch into the remote repository, you need to use the following command:

git push -u <remote> <branch-name>

Viewing branches:

git branch or git branch --list
Deleting a branch:

git branch -d <branch-name>

*git checkout
This is also one of the most used Git commands. To work in a branch, first you need to switch to it. We use git checkout mostly for switching from one branch to another. We can also use it for checking out files and commits.

git checkout <name-of-your-branch>
There are some steps you need to follow for successfully switching between branches:

The changes in your current branch must be committed or stashed before you switch
The branch you want to check out should exist in your local
There is also a shortcut command that allows you to create and switch to a branch at the same time:

git checkout -b <name-of-your-branch>
This command creates a new branch in your local (-b stands for branch) and checks the branch out to new right after it has been created.

*git status
git status
We can gather information like:

Whether the current branch is up to date
Whether there is anything to commit, push or pull
Whether there are files staged, unstaged or untracked
Whether there are files created, modified or deleted
resim-5

Git status gives information about the branch & files

*git add <file>
To add everything at once:

git add -A
When you visit the screenshot above in the 4th section, you will see that there are file names that are red - this means that they're unstaged files. The unstaged files won't be included in your commits.

To include them, we need to use git add:

resim-6
Files with green are now staged with git add
Important: The git add command doesn't change the repository and the changes are not saved until we use git commit.

*git commit -m "commit message"
Git commit is like setting a checkpoint in the development process which you can go back to later if needed.

We also need to write a short message to explain what we have developed or changed in the source code.

git commit -m "commit message"

*git push
git push <remote> <branch-name>
However, if your branch is newly created, then you also need to upload the branch with the following command:

git push --set-upstream <remote> <name-of-your-branch>
or

git push -u origin <branch_name>
Important: Git push only uploads changes that are committed.


*git pull <remote>
The git pull command is used to get updates from the remote repo. This command is a combination of git fetch and git merge which means that, when we use git pull, it gets the updates from remote repository (git fetch) and immediately applies the latest changes in your local (git merge).


This operation may cause conflicts that you need to solve manually.


