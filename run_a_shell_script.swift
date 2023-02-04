#!/usr/bin/env swift

//https://stackoverflow.com/questions/26971240/how-do-i-run-a-terminal-command-in-a-swift-script-e-g-xcodebuild 
//https://rderik.com/blog/using-swift-for-scripting/

import Foundation

func shell(_ command: String) -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.launchPath = "/bin/zsh"
    task.standardInput = nil
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return output
}

// Example usage:
shell("ls -la")



@discardableResult // Add to suppress warnings when you don't want/need a result
func safeShell(_ command: String) throws -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated
    task.standardInput = nil

    try task.run() //<--updated
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return output
}

// Example usage capturing error:
do {
    try safeShell("ls -la")
}
catch {
    print("\(error)") //handle or silence the error here
}

// Example usage where you don't care about the error and want a nil back instead
let result = try? safeShell("ls -la")

// Example usage where you don't care about the error or the return value
try? safeShell("ls -la")


//ALSO
let ls = Process()
ls.executableURL = URL(fileURLWithPath: "/usr/bin/env")
ls.arguments = ["ls", "-al"]
do{
  try ls.run()
} catch { //TODO: write catch for executing command
}