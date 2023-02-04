#!/usr/bin/env swift
import Foundation

//https://theswiftdev.com/how-to-build-better-command-line-apps-and-tools-using-swift/

/// print using custom separator & terminator
print("This", "is", "fun", separator: "-", terminator: "!")

/// write to the standard output
"This goes to the standard error output"
    .data(using: .utf8)
    .map(FileHandle.standardError.write)

/// print to the standard output using a custom stream
final class StandardErrorOutputStream: TextOutputStream {
    func write(_ string: String) {
        FileHandle.standardError.write(Data(string.utf8))
    }
}

var outputStream = StandardErrorOutputStream()
print("This is also an error", to: &outputStream)


/// clears the console (@NOTE: won't work in Xcode)
func clear() {
    print("\u{1B}[2J")
    print("\u{1B}[\(1);\(0)H", terminator: "")
}

print("foooooooooooooooooooooo")
clear()
print("Hello, world!")


/// print colorful text using ANSI escape codes
/// https://en.wikipedia.org/wiki/ANSI_escape_code
print("\u{1b}[31;1m\u{1b}[40;1m\("Hello, world!")\u{1b}[m")
print("\u{1b}[32;1m\("Hello, world!")\u{1b}[m")