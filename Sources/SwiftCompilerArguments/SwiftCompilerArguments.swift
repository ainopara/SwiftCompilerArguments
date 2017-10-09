//
//  SwiftCompilerArguments.swift
//  SwiftCompilerArguments
//
//  Created by Zheng Li on 07/10/2017.
//

import Foundation

public class SwiftCompilerArguments: ArgumentParser {
    public var patterns: [Pattern] = []

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
    public var cCompilerArguments: CCompilerArguments = CCompilerArguments()
    public var llvmArguments: LLVMCompilerArguments = LLVMCompilerArguments()

    public init(arguments: [String]) {
        var xccArguments = [String]()
        var xllvmArguments = [String]()

        patterns.append(FlagPattern(name: "-frontend", action: { [weak self] in self?.frontend = true }))
        patterns.append(ArgumentPattern(name: "-module-name", action: { [weak self] in self?.moduleName = $0 }))
        patterns.append(ArgumentPattern(name: "-swift-version", action: { [weak self] in self?.swiftVersionString = $0 }))
        patterns.append(ArgumentPattern(name: "-primary-file", action: { [weak self] in self?.primarySourceFile = $0 }))
        patterns.append(ArgumentPattern(name: "-sdk", action: { [weak self] in self?.sdkRoot = $0 }))
        patterns.append(ArgumentPattern(name: "-target", action: { [weak self] in self?.target = $0 }))
        patterns.append(ArgumentPattern(name: "-D", action: { [weak self] in self?.defines.append($0) }))
        patterns.append(ArgumentPattern(name: "-I", action: { [weak self] in self?.importPaths.append($0) }))
        patterns.append(ArgumentPattern(name: "-F", action: { [weak self] in self?.frameworkSearchPaths.append($0) }))
        patterns.append(ArgumentPattern(name: "-module-cache-path", action: { [weak self] in self?.moduleCachePath = $0 }))
        patterns.append(ArgumentPattern(name: "-j", position: [.prefix], action: { [weak self] in self?.threads = Int($0) }))

        patterns.append(ArgumentPattern(name: "-Xcc", action: { xccArguments.append($0) }))
        patterns.append(ArgumentPattern(name: "-Xllvm", action: { xllvmArguments.append($0) }))
        patterns.append(CustomPattern<Void>(ruleBlock: { $0.hasSuffix(".swift") ? () : nil }, actionBlock: { [weak self] (_, value, _) in self?.otherSourceFiles.append(value) }))

        parse(arguments: arguments)

        cCompilerArguments = CCompilerArguments(arguments: xccArguments)
        llvmArguments = LLVMCompilerArguments(arguments: xllvmArguments)
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
        result.append(name: "-D", defines)
        result.append(name: "-Xcc", cCompilerArguments.arguments())
        result.append(name: "-Xllvm", llvmArguments.arguments())

        result += customFlags

        return result
    }
}

public class CCompilerArguments: ArgumentParser {
    public var patterns: [Pattern] = []
    public var importPaths: [String] = []
    public var customFlags: [String] = []

    init() {}

    public init(arguments: [String]) {
        patterns.append(ArgumentPattern(names: ["-I"], action: { [weak self] (value) in
            self?.importPaths.append(value)
        }))

        parse(arguments: arguments)
    }

    public func arguments(combined: Bool = true) -> [String] {
        var result = [String]()

        result.append(name: "-I", importPaths, combined: combined)
        result += customFlags

        return result
    }
}

public class LLVMCompilerArguments: ArgumentParser {
    public var patterns: [Pattern] = []
    public var customFlags: [String] = []

    init() {}

    public init(arguments: [String]) {

        parse(arguments: arguments)
    }

    public func arguments(combined: Bool = true) -> [String] {
        var result = [String]()

        result += customFlags

        return result
    }
}

// MARK: - Helpers

extension String {
    func removePrefix(n: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: n)...])
    }
}

extension Array where Element == String {
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
