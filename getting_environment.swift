#!/usr/bin/env swift

import Foundation



let info = ProcessInfo.processInfo

print("Process info")
print("Process identifier:", info.processIdentifier)
print("System uptime:", info.systemUptime)
print("Globally unique process id string:", info.globallyUniqueString)
print("Process name:", info.processName)

print("Software info")
print("Host name:", info.hostName)
print("OS major version:", info.operatingSystemVersion.majorVersion)
print("OS version string", info.operatingSystemVersionString)

print("Hardware info")
print("Active processor count:", info.activeProcessorCount)
print("Physical memory (bytes)", info.physicalMemory)

/// same as CommandLine.arguments
print("Arguments")
print(ProcessInfo.processInfo.arguments)

print("Environment")
/// print available environment variables
print(info.environment)


//---------------------------------------------- C getenv & setenv work!
func getEnvironmentVar(_ name: String) -> String? {
    guard let rawValue = getenv(name) else { return nil }
    return String(utf8String: rawValue)
}
func setEnvironment(key:String, value:String, overwrite: Bool = false) {
    setenv(key, value, overwrite ? 1 : 0)
}

setEnvironment(key: "SECRET1", value: "(whispers I cant hear)", overwrite: true)
print(getEnvironmentVar("SECRET1") ?? "nothing")

//-------------------------------------------------- mini dotEnv handling
func loadEnvironmentVars() throws {
    //cleans out the comments could also "grep -v '^#' .env | xargs" 
    //if wanting a different format to parse. 
    let command = "grep -v '^#' .env"  
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

    let dictionary = parseEnvironmentVars(string: output)

    for (key, value) in dictionary {
        print(key, value)
        setEnvironment(key: key, value: value, overwrite: true)
    }
}

func parseEnvironmentVars(string:String) -> Dictionary<String, String> {
    var dictionary:Dictionary<String, String> = [:]
    let results = string.trimmingCharacters(in: .newlines).split(separator: "\n").map({ $0.split(separator: "=")})
    for result in results {
        dictionary[String(result[0])] = String(result[1])
    }
    return dictionary
} 


do {
    try loadEnvironmentVars()
    
    if let value = ProcessInfo.processInfo.environment["SECRET"] {
        print(value)
    } else {
        print("I don't know the secret.")
    }
}
catch {
    print("\(error)") //handle or silence the error here
}