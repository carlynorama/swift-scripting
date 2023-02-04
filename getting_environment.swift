#!/usr/bin/env swift
import Foundation

//https://theswiftdev.com/how-to-build-better-command-line-apps-and-tools-using-swift/

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