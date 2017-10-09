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

public class CustomPattern<T>: Pattern {
    public let ruleBlock: (String) -> Any?
    public let actionBlock: (Any, String, inout [String]) -> Void

    public init(ruleBlock: @escaping (String) -> T?, actionBlock: @escaping (T, String, inout [String]) -> Void) {
        self.ruleBlock = { ruleBlock($0) as Any? }
        self.actionBlock = { actionBlock($0 as! T, $1, &$2 ) }
    }
}

public class FlagPattern: CustomPattern<Void> {
    public let names: Set<String>

    public init(names: Set<String>, action: @escaping () -> Void) {
        self.names = names
        super.init(
            ruleBlock: { names.contains($0) ? () : nil },
            actionBlock: { (_,_,_) in action() }
        )
    }

    public convenience init(name: String, action: @escaping () -> Void) {
        self.init(names: Set(arrayLiteral: name), action: action)
    }
}

public enum ArgumentPatternCheckResult {
    case front
    case prefix(name: String)
}

public class ArgumentPattern: CustomPattern<ArgumentPatternCheckResult> {
    public let names: Set<String>
    public struct Position: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let front = Position(rawValue: 1 << 0)
        public static let prefix = Position(rawValue: 1 << 1)

        public static let all: Position = [.front, .prefix]
    }
    public let position: Position

    public init(names: Set<String>, position: Position = .all, action: @escaping (_ value: String) -> Void) {
        self.names = names
        self.position = position
        let ruleBlock = { (argument: String) -> ArgumentPatternCheckResult? in
            if position.contains(.front) {
                if names.contains(argument) {
                    return .front
                }
            }
            if position.contains(.prefix) {
                for name in names where argument.hasPrefix(name) {
                    return .prefix(name: name)
                }
            }
            return nil
        }
        let actionBlock = { (result: ArgumentPatternCheckResult, argument: String, arguments: inout [String]) -> Void in
            switch result {
            case .front:
                action(arguments.popLast()!)
            case let .prefix(name):
                action(argument.removePrefix(n: name.count))
            }
        }
        super.init(ruleBlock: ruleBlock, actionBlock: actionBlock)
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
