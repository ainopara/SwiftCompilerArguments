//
//  SwiftCompilerArguments.swift
//  SwiftCompilerArguments
//
//  Created by Zheng Li on 07/10/2017.
//

import Foundation


public class SwiftCompilerArguments: Codable {
    public var frontend: Bool = false
    public var incremental: Bool = false
    public enum EmitDebugInfoMode: String, Codable {
        case normal = ""
        case none = "none"
    }
    public var emitDebugInfoMode: EmitDebugInfoMode? = nil

    // Input
    public var primarySourceFile: String? = nil
    public var otherSourceFiles: [String] = []
    public var moduleName: String? = nil
    public var sdkRoot: String? = nil
    public var importPaths: [String] = []
    public var frameworkSearchPaths: [String] = []

    public var target: String? = nil
    public var customFlags: [String] = []
    public var defines: [String] = []
    public var moduleCachePath: String? = nil
    public var enforceExclusivity: String? = nil
    public var optimize: String? = nil
    public var threads: Int? = nil
    public var swiftVersionString: String? = nil

    // Output
    public var emitObject: Bool = false
    public var emitAssembly: Bool = false
    public var output: String? = nil
    public var emitModule: Bool = false
    public var emitModulePath: String? = nil
    public var emitObjcHeader: Bool = false
    public var emitObjcHeaderPath: String? = nil
    public var indexStorePath: String? = nil
    public var outputFileMap: String? = nil

    // Others
    public var cCompilerArguments: CCompilerArguments = CCompilerArguments()
    public var llvmArguments: LLVMArguments = LLVMArguments()
    public var frontendArguments: SwiftFrontendArguments = SwiftFrontendArguments()

    public func arguments() -> [String] {
        var result = [String]()

        result.append(name: "-frontend", frontend)
        result.append(name: "-incremental", incremental)
        result.append(name: "-c", emitObject)
        result.append(name: "-S", emitAssembly)
        result.append(name: "-module-name", moduleName)
        result.append(name: "-swift-version", swiftVersionString)
        result.append(name: "-primary-file", primarySourceFile)
        result += otherSourceFiles
        result.append(name: "-sdk", sdkRoot)
        result.append(name: "-target", target)
        result.append(name: "-I", importPaths)
        result.append(name: "-F", frameworkSearchPaths)
        result.append(name: "-module-cache-path", moduleCachePath)
        result.append(name: "-enforce-exclusivity", enforceExclusivity, combination: .equal)
        result.append(name: "-j", threads, combination: .join)
        result.append(name: "-O", optimize, combination: .join)
        result.append(name: "-D", defines)
        result.append(name: "-g", emitDebugInfoMode, combination: .join)
        result.append(name: "-emit-module", emitModule)
        result.append(name: "-emit-module-path", emitModulePath)
        result.append(name: "-emit-objc-header", emitObjcHeader)
        result.append(name: "-emit-objc-header-path", emitObjcHeaderPath)
        result.append(name: "-index-store-path", indexStorePath)
        result.append(name: "-output-file-map", outputFileMap)
        result.append(name: "-o", output)
        result.append(name: "-Xcc", cCompilerArguments.arguments())
        result.append(name: "-Xllvm", llvmArguments.arguments())
        result.append(name: "-Xfrontend", frontendArguments.arguments())

        result += customFlags

        return result
    }
}

public class SwiftCompilerArgumentParser: ArgumentParser {
    public typealias Model = SwiftCompilerArguments

    public required init() {}

    public static func patterns() -> [Pattern] {
        return [
            FlagPattern(name: "-frontend"),
            FlagPattern(name: "-incremental"),
            FlagPattern(name: "-emit-module"),
            ArgumentPattern(name: "-emit-module-path"),
            FlagPattern(name: "-emit-objc-header"),
            ArgumentPattern(name: "-emit-objc-header-path"),
            ArgumentPattern(name: "-index-store-path"),
            ArgumentPattern(name: "-module-name"),
            ArgumentPattern(name: "-swift-version"),
            ArgumentPattern(name: "-primary-file"),
            ArgumentPattern(name: "-sdk", key: "sdkRoot"),
            ArgumentPattern(name: "-target"),
            ArgumentPattern(name: "-D", key: "defines", valueAction: .array),
            ArgumentPattern(name: "-I", key: "importPaths", valueAction: .array),
            ArgumentPattern(name: "-F", key: "frameworkSearchPaths", valueAction: .array),
            ArgumentPattern(name: "-module-cache-path"),
            ArgumentPattern(name: "-j", key: "threads", position: [.prefix], valueAction: .integer),
            ArgumentPattern(name: "-O", key: "optimize", position: [.prefix]),
            ArgumentPattern(name: "-g", key: "emitDebugInfoMode", position: [.prefix]),
            ArgumentPattern(name: "-output-file-map"),
            FlagPattern(names: ["-emit-object", "-c"]),
            FlagPattern(names: ["-emit-assembly", "-S"]),
            ArgumentPattern(name: "-o", key: "output", position: [.front]),
            ArgumentPattern(name: "-enforce-exclusivity"),
            PassbyPattern(name: "-Xcc", key: "cCompilerArguments", parserType: CCompilerArguments.self),
            PassbyPattern(name: "-Xllvm", key: "llvmArguments", parserType: LLVMArguments.self),
            PassbyPattern(name: "-Xfrontend", key: "swiftFrontendArguments", parserType: SwiftFrontendArguments.self),
            CustomPattern<Void>(ruleBlock: { $0.hasSuffix(".swift") ? () : nil }, actionBlock: { (_, value, _, model) in
                model.appendArray(key: "otherSourceFiles", value: value)
            })
        ]
    }
}

public class SwiftFrontendArguments: ArgumentParser, Codable {
    public typealias Model = SwiftFrontendArguments
    public var groupInfoPath: String? = nil
    public var customFlags: [String] = []

    public required init() {}

    public func arguments(combination: Combination = .join) -> [String] {
        var result = [String]()
        result.append(name: "-group-info-path", groupInfoPath)
        result += customFlags
        return result
    }

    public static func patterns() -> [Pattern] {
        return [
            ArgumentPattern(name: "-group-info-path")
        ]
    }
}

public class CCompilerArguments: ArgumentParser, Codable {
    public typealias Model = CCompilerArguments
    public var importPaths: [String] = []
    public var customFlags: [String] = []

    public required init() {}

    public func arguments(combination: Combination = .join) -> [String] {
        var result = [String]()
        result.append(name: "-I", importPaths, combination: combination)
        result += customFlags
        return result
    }

    public static func patterns() -> [Pattern] {
        return [
            ArgumentPattern(names: ["-I"], key: "importPaths", valueAction: .array)
        ]
    }
}

public class LLVMArguments: ArgumentParser, Codable {
    public typealias Model = CCompilerArguments
    public var customFlags: [String] = []

    public required init() {}

    public func arguments(combination: Combination = .join) -> [String] {
        var result = [String]()
        result += customFlags
        return result
    }

    public static func patterns() -> [Pattern] {
        return []
    }
}

// MARK: - Helpers

extension String {
    func removePrefix(n: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: n)...])
    }
}

public enum Combination {
    case space
    case join
    case equal
}

extension Array where Element == String {
    mutating func append(name: String, _ value: String?, combination: Combination = .space) {
        if let value = value {
            switch combination {
            case .space:
                self += [name, value]
            case .join:
                self += [name + value]
            case .equal:
                self += [name + "=" + value]
            }
        }
    }

    mutating func append(name: String, _ value: Int?, combination: Combination = .space) {
        self.append(name: name, value.map { "\($0)" }, combination: combination)
    }

    mutating func append(name: String, _ array: [String], combination: Combination = .space) {
        for value in array {
            self.append(name: name, value, combination: combination)
        }
    }

    mutating func append<T: RawRepresentable>(name: String, _ value: T?, combination: Combination = .space) {
        self.append(name: name, value.map { "\($0.rawValue)" }, combination: combination)
    }

    mutating func append(name: String, _ appear: Bool) {
        if appear {
            self += [name]
        }
    }
}

extension Dictionary where Key == String, Value == Any {
    mutating func appendArray(key: String, value: String) {
        let currentValues = self[key] as? [String] ?? [String]()
        let newValues = currentValues + [value]
        self[key] = newValues
    }
}
