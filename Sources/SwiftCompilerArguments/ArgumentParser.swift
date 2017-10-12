//
//  ArgumentParser.swift
//  SwiftCompilerArguments
//
//  Created by Zheng Li on 09/10/2017.
//

import Foundation

public protocol Pattern {
    var ruleBlock: (String) -> Any? { get }
    var actionBlock: (Any, String, inout [String]) -> Void { get }
}

protocol TypedPattern: Pattern {
    associatedtype CheckResultType
    var typedRuleBlock: (String) -> CheckResultType? { get }
    var typedActionBlock: (CheckResultType, String, inout [String]) -> Void { get }
}

extension TypedPattern {
    public var ruleBlock: (String) -> Any? {
        return { self.typedRuleBlock($0) as Any? }
    }
    public var actionBlock: (Any, String, inout [String]) -> Void {
        return { self.typedActionBlock($0 as! CheckResultType, $1, &$2 ) }
    }
}

public class CustomPattern<T>: TypedPattern {
    typealias CheckResultType = T

    var typedRuleBlock: (String) -> CheckResultType?
    var typedActionBlock: (CheckResultType, String, inout [String]) -> Void

    public init(ruleBlock: @escaping (String) -> T?, actionBlock: @escaping (T, String, inout [String]) -> Void) {
        self.typedRuleBlock = ruleBlock
        self.typedActionBlock = actionBlock
    }
}

public class FlagPattern: TypedPattern {
    typealias CheckResultType = Void
    var typedRuleBlock: (String) -> CheckResultType?
    var typedActionBlock: (CheckResultType, String, inout [String]) -> Void

    public let names: Set<String>

    public init(names: Set<String>, action: @escaping () -> Void) {
        self.names = names
        self.typedRuleBlock = { names.contains($0) ? () : nil }
        self.typedActionBlock = { (_,_,_) in action() }
    }

    public convenience init(name: String, action: @escaping () -> Void) {
        self.init(names: Set(arrayLiteral: name), action: action)
    }
}

public class ArgumentPattern: TypedPattern {
    enum CheckResult {
        case front // -D DEBUG
        case prefix(name: String) // -DDEBUG
        case equal(name: String) // -D=DEBUG
    }
    typealias CheckResultType = CheckResult
    var typedRuleBlock: (String) -> CheckResultType?
    var typedActionBlock: (CheckResultType, String, inout [String]) -> Void

    public let names: Set<String>
    public struct Position: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let front = Position(rawValue: 1 << 0)
        public static let prefix = Position(rawValue: 1 << 1)
        public static let equal = Position(rawValue: 1 << 2)

        public static let all: Position = [.front, .prefix, .equal]
    }
    public let position: Position

    public init(names: Set<String>, position: Position = .all, action: @escaping (_ value: String) -> Void) {
        self.names = names
        self.position = position
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
        self.typedActionBlock = { (result: CheckResult, argument: String, arguments: inout [String]) -> Void in
            switch result {
            case .front:
                action(arguments.popLast()!)
            case let .prefix(name):
                action(argument.removePrefix(n: name.count))
            case let .equal(name):
                action(argument.removePrefix(n: name.count + 1))
            }
        }
    }

    public convenience init(name: String, position: Position = .all, action: @escaping (_ value: String) -> Void) {
        self.init(names: Set(arrayLiteral: name), position: position, action: action)
    }
}

public protocol ArgumentParser: class {
    var patterns: [Pattern] { get }
    var customFlags: [String] { get set }
}

extension ArgumentParser {
    func parse(arguments: [String]) {
        var arguments: [String] = arguments.reversed()

        func tryMatch(argument: String, with pattern: Pattern) -> Bool {
            if let result = pattern.ruleBlock(argument) {
                pattern.actionBlock(result, argument, &arguments)
                return true
            }
            return false
        }

        while let next = arguments.popLast() {
            var processed = false

            for pattern in patterns where !processed {
                processed = tryMatch(argument: next, with: pattern)
            }

            guard !processed else { continue }

            customFlags += [next]
        }
    }
}
