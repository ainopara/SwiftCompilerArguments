//
//  ArgumentParser.swift
//  SwiftCompilerArguments
//
//  Created by Zheng Li on 09/10/2017.
//

import Foundation

public protocol Pattern {
    var ruleBlock: (String) -> Any? { get }
    var actionBlock: (Any, String, inout [String], inout [String: Any]) -> Void { get }
}

extension Pattern {
    /// `-module-cache-path` to `moduleCachePath`
    static func defaultKey(names: [String]) -> String {
        guard let name = names.first else { return UUID().uuidString }

        let pieces = name
            .split(separator: "-")
            .filter { $0.count > 0 }
            .map(String.init)

        guard pieces.count > 0 else { return UUID().uuidString }

        let firstPiece = pieces.first!.lowercased()
        let others = pieces.dropFirst().map { $0.capitalized }
        return firstPiece + others.joined()
    }
}

protocol TypedPattern: Pattern {
    associatedtype CheckResultType
    var typedRuleBlock: (String) -> CheckResultType? { get }
    var typedActionBlock: (CheckResultType, String, inout [String], inout [String: Any]) -> Void { get }
}

extension TypedPattern {
    public var ruleBlock: (String) -> Any? {
        return { self.typedRuleBlock($0) as Any? }
    }
    public var actionBlock: (Any, String, inout [String], inout [String: Any]) -> Void {
        return { self.typedActionBlock($0 as! CheckResultType, $1, &$2, &$3 ) }
    }
}

public class CustomPattern<T>: TypedPattern {
    typealias CheckResultType = T

    var typedRuleBlock: (String) -> CheckResultType?
    var typedActionBlock: (CheckResultType, String, inout [String], inout [String: Any]) -> Void

    public init(ruleBlock: @escaping (String) -> T?, actionBlock: @escaping (T, String, inout [String], inout [String: Any]) -> Void) {
        self.typedRuleBlock = ruleBlock
        self.typedActionBlock = actionBlock
    }
}

public class FlagPattern: TypedPattern {
    typealias CheckResultType = Void
    let typedRuleBlock: (String) -> CheckResultType?
    let typedActionBlock: (CheckResultType, String, inout [String], inout [String: Any]) -> Void

    public let names: Set<String>
    public let key: String

    public init(names: [String], key: String? = nil) {
        self.names = Set(names)
        let resolvedKey = key ?? FlagPattern.defaultKey(names: names)
        self.key = resolvedKey
        self.typedRuleBlock = { names.contains($0) ? () : nil }
        self.typedActionBlock = { (_,_,_, jsonModel) in jsonModel[resolvedKey] = true }
    }

    public convenience init(name: String, key: String? = nil) {
        self.init(names: [name], key: key)
    }
}

public class ArgumentPattern: TypedPattern {
    enum CheckResult {
        case front // -D DEBUG
        case prefix(name: String) // -DDEBUG
        case equal(name: String) // -D=DEBUG
    }
    typealias CheckResultType = CheckResult
    let typedRuleBlock: (String) -> CheckResultType?
    let typedActionBlock: (CheckResultType, String, inout [String], inout [String: Any]) -> Void

    public let names: Set<String>
    public let key: String

    public struct Position: OptionSet {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        public static let front = Position(rawValue: 1 << 0)
        public static let prefix = Position(rawValue: 1 << 1)
        public static let equal = Position(rawValue: 1 << 2)
        public static let all: Position = [.front, .prefix, .equal]
    }
    public let position: Position

    public enum Action {
        case string
        case integer
        case array
    }
    public let valueAction: Action?

    public convenience init(
        name: String,
        key: String? = nil,
        position: Position = .all,
        valueAction: Action = .string
        ) {
        self.init(names: [name], key: key, position: position, valueAction: valueAction)
    }
    public init(
        names: [String],
        key: String? = nil,
        position: Position = .all,
        valueAction: Action = .string
    ) {
        self.names = Set(names)
        let resolvedKey = key ?? ArgumentPattern.defaultKey(names: names)
        self.key = resolvedKey
        self.position = position
        self.valueAction = valueAction

        self.typedRuleBlock = { (argument: String) -> CheckResult? in
            if position.contains(.front) {
                if names.contains(argument) {
                    return .front
                }
            }
            if position.contains(.equal) {
                for name in names where argument.hasPrefix(name + "=") {
                    return .equal(name: name)
                }
            }
            if position.contains(.prefix) {
                for name in names where argument.hasPrefix(name) {
                    return .prefix(name: name)
                }
            }
            return nil
        }

        func action(_ value: String, _ jsonModel: inout [String: Any]) {
            switch valueAction {
            case .string:
                jsonModel[resolvedKey] = value
            case .integer:
                jsonModel[resolvedKey] = Int(value)
            case .array:
                jsonModel.appendArray(key: resolvedKey, value: value)
            }
        }

        self.typedActionBlock = { (result: CheckResult, argument: String, arguments: inout [String], jsonModel: inout [String: Any]) -> Void in
            switch result {
            case .front:
                action(arguments.popLast()!, &jsonModel)
            case let .prefix(name):
                action(argument.removePrefix(n: name.count), &jsonModel)
            case let .equal(name):
                action(argument.removePrefix(n: name.count + 1), &jsonModel)
            }
        }
    }
}

public class PassbyPattern: ArgumentPattern {
    let passbyBlock: ([String]) -> [String: Any]

    public init<T: ArgumentParser>(names: [String], key: String?, position: Position = .all, parserType: T.Type) {
        passbyBlock = { parserType.init().parseJSONModel(arguments: $0) }
        super.init(names: names, key: key, position: position, valueAction: .array)
    }
    public convenience init<T: ArgumentParser>(name: String, key: String?, position: Position = .all, parserType: T.Type) {
        self.init(names: [name], key: key, position: position, parserType: parserType)
    }
}

public protocol ArgumentParser: class {
    associatedtype Model: Decodable
    init()
    static func patterns() -> [Pattern]
}

extension ArgumentParser {
    public func parseJSONModel(arguments: [String]) -> [String: Any] {
        var jsonModel: [String: Any] = [:]
        var arguments: [String] = arguments.reversed()

        func tryMatch(argument: String, with pattern: Pattern) -> Bool {
            if let result = pattern.ruleBlock(argument) {
                pattern.actionBlock(result, argument, &arguments, &jsonModel)
                return true
            }
            return false
        }

        while let next = arguments.popLast() {
            var processed = false

            for pattern in Self.patterns() where !processed {
                processed = tryMatch(argument: next, with: pattern)
            }

            guard !processed else { continue }

            jsonModel.appendArray(key: "customFlags", value: next)
        }

        for case let pattern as PassbyPattern in Self.patterns()  {
            let currentArguments = jsonModel[pattern.key] as? [String] ?? [String]()
            let newCustomFlags = pattern.passbyBlock(currentArguments)
            jsonModel[pattern.key] = newCustomFlags
        }

        return jsonModel
    }

    public func parse(arguments: [String]) throws -> Model {
        let jsonModel = parseJSONModel(arguments: arguments)
        return try JSONModelDecoder().decode(Model.self, from: jsonModel)
    }
}
