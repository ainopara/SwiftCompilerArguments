//
//  SwiftCompilerArguments.swift
//  SwiftCompilerArguments
//
//  Created by Zheng Li on 07/10/2017.
//

import Foundation

public class SwiftCompilerArguments {
    public var frontend: Bool = false
    public var primarySourceFile: String? = nil
    public var otherSourceFiles: [String] = []
    public var moduleName: String?
    public var target: String? = nil
    public var sdkRoot: String? = nil
    public var importPaths: [String] = []
    public var frameworkSearchPaths: [String] = []
    public var customFlags: [String] = []
    public var defines: [String] = []
    public var moduleCachePath: String? = nil
    public var threads: Int? = nil
    public var swiftVersionString: String? = nil

    public init(arguments: [String]) {
        var arguments: [String] = arguments.reversed()

        while let next = arguments.popLast() {
            switch next {
            case "-frontend":
                frontend = true
            case "-module-name":
                moduleName = arguments.popLast()!
            case "-primary-file":
                primarySourceFile = arguments.popLast()!
            case "-sdk":
                sdkRoot = arguments.popLast()!
            case "-target":
                target = arguments.popLast()!
            case "-D":
                defines += [arguments.popLast()!]
            case "-I":
                importPaths += [arguments.popLast()!]
            case "-F":
                frameworkSearchPaths += [arguments.popLast()!]
            case "-module-cache-path":
                moduleCachePath = arguments.popLast()!
            case "-swift-version":
                swiftVersionString = arguments.popLast()!
            default:
                if next.hasPrefix("-j") {
                    threads = Int(next.removePrefix(n: 2))
                } else if next.hasPrefix("-D") {
                    defines += [next.removePrefix(n: 2)]
                } else if next.hasSuffix(".swift") {
                    otherSourceFiles += [next]
                } else {
                    customFlags += [next]
                }
            }
        }
    }

    // FIXME: Add missing parameters.
    public init(
        primarySourceFile: String? = nil,
        otherSourceFiles: [String] = [],
        sdkRoot: String? = nil,
        target: String? = nil,
        importPaths: [String] = [],
        frameworkSearchPaths: [String] = [],
        customFlags: [String] = []
    ) {
        self.primarySourceFile = primarySourceFile
        self.otherSourceFiles = otherSourceFiles
        self.target = target
        self.importPaths = importPaths
        self.frameworkSearchPaths = frameworkSearchPaths
        self.customFlags = customFlags
        self.sdkRoot = sdkRoot
    }

    public func arguments() -> [String] {
        var result = [String]()

        result.append(name: "-frontend", frontend)
        result.append(name: "-module-name", moduleName)
        result.append(name: "-swift-version", swiftVersionString)
        result.append(name: "-primary-file", primarySourceFile)
        result += otherSourceFiles
        result.append(name: "-sdk", sdkRoot)
        result.append(name: "-target", target)
        result.append(name: "-I", importPaths)
        result.append(name: "-F", frameworkSearchPaths)
        result.append(name: "-module-cache-path", moduleCachePath)
        result.append(name: "-j", threads, combined: true)
        result.append(name: "-D", defines, combined: true)

        result += customFlags

        return result
    }
}

// MARK: - Helpers

private extension String {
    func removePrefix(n: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: n)...])
    }
}

private extension Array where Element == String {
    mutating func append(name: String, _ value: String?, combined: Bool = false) {
        if let value = value {
            if !combined {
                self += [name, value]
            } else {
                self += [name + value]
            }
        }
    }

    mutating func append(name: String, _ value: Int?, combined: Bool = false) {
        self.append(name: name, value.map { "\($0)" }, combined: combined)
    }

    mutating func append(name: String, _ array: [String], combined: Bool = false) {
        for value in array {
            self.append(name: name, value, combined: combined)
        }
    }

    mutating func append(name: String, _ appear: Bool) {
        if appear {
            self += [name]
        }
    }
}
