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
func loadDotEnv() throws {

    let url = URL(fileURLWithPath: ".env")
    guard let envString = try? String(contentsOf: url) else {
       fatalError("no env file data")
    }

    envString
        .trimmingCharacters(in: .newlines)
        .split(separator: "\n")
        .lazy 
        .filter({$0.prefix(1) != "#"})  //is comment
        .map({ $0.split(separator: "=").map({String($0.trimmingCharacters(in: CharacterSet(charactersIn:"\"\'")))}) })
        .forEach({  addToEnv(result: $0) })

    func addToEnv(result:Array<String>) {
        if result.count == 2  {
            setEnvironment(key: result[0], value: result[1], overwrite: true)
        } else {
            //item would of had to have contained more than 1 "=" or none at all. I'd like to know about that for now. 
            print("Failed dotenv add: \(result)") 
        }
    }
}

do {
    try loadDotEnv()
    
    if let value = ProcessInfo.processInfo.environment["SECRET"] {
        print(value)
    } else {
        print("I don't know the secret.")
    }

    if let anotherValue = ProcessInfo.processInfo.environment["ANOTHER"] {
        print(anotherValue)
    } else {
        print("I don't know the other secret.")
    }
}
catch {
    print("\(error)") //handle or silence the error here
}