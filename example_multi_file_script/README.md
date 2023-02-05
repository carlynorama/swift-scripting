

Swift can't really do multifile "scripts" like python since Swift is a compliled language, but if you don't want to bother with making a package or running XCode this will get a similar result.  

compile with: `swiftc *swift -o myappname` where
- `swiftx`: swift complier
- `*swift`: include all files with names that end in `swift` (this directory nonrecursive but can point anywhere)
- `-o myappname`: `-o` means that you are about to give the compiler the name wanted for the output. 

for more info `swiftc --help`

or also ```swiftc `find . -name "*.swift" -maxdepth 1` -o myappname``` where
-  `.`: current directory
- `maxdepth`: how far down the filetree to look
- FYI: using backticks in a shell command is spawning a subshell, e.g. ``` ls -l `which python3` ```

the result will be a new item, an exectable, in the file directory which can then be run via the command line with `./myappname`

```otool -L ./myappname``` will print to the console all the libraries that the Linker believes are used of your app. This swiftc compile by default is a dynaimc compile  (vs static) so this is a lookup table. The files have not been copied into the app directory. `swiftc -static-executable` when compiling will do a static complie instead (if compiling for a non-Apple platform). 