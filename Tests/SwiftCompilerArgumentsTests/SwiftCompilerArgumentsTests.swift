import XCTest
@testable import SwiftCompilerArguments

class SwiftCompilerArgumentsTests: XCTestCase {
    func testInvariant0() {
        let originalArguments = "-incremental -module-name SwiftCompilerArguments -Onone -enforce-exclusivity=checked -DSWIFT_PACKAGE -DXcode -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.13.sdk -target x86_64-apple-macosx10.10 -g -module-cache-path /Users/ainopara/Library/Developer/Xcode/DerivedData/ModuleCache -Xfrontend -serialize-debugging-options -enable-testing -index-store-path /Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Index/DataStore -swift-version 4 -I /Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Build/Products/Debug -F /Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Build/Products/Debug -F /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -c -j8 /Users/ainopara/Documents/Projects/SwiftCompilerArguments/Sources/SwiftCompilerArguments/JSONModelEncoder.swift /Users/ainopara/Documents/Projects/SwiftCompilerArguments/Sources/SwiftCompilerArguments/ArgumentParser.swift /Users/ainopara/Documents/Projects/SwiftCompilerArguments/Sources/SwiftCompilerArguments/SwiftCompilerArguments.swift -output-file-map /Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Build/Intermediates.noindex/SwiftCompilerArguments.build/Debug/SwiftCompilerArguments.build/Objects-normal/x86_64/SwiftCompilerArguments-OutputFileMap.json -parseable-output -serialize-diagnostics -emit-dependencies -emit-module -emit-module-path /Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Build/Intermediates.noindex/SwiftCompilerArguments.build/Debug/SwiftCompilerArguments.build/Objects-normal/x86_64/SwiftCompilerArguments.swiftmodule -Xcc -I/Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Build/Intermediates.noindex/SwiftCompilerArguments.build/Debug/SwiftCompilerArguments.build/swift-overrides.hmap -Xcc -I/Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Build/Products/Debug/include -Xcc -I/Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Build/Intermediates.noindex/SwiftCompilerArguments.build/Debug/SwiftCompilerArguments.build/DerivedSources/x86_64 -Xcc -I/Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Build/Intermediates.noindex/SwiftCompilerArguments.build/Debug/SwiftCompilerArguments.build/DerivedSources -emit-objc-header -emit-objc-header-path /Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Build/Intermediates.noindex/SwiftCompilerArguments.build/Debug/SwiftCompilerArguments.build/Objects-normal/x86_64/SwiftCompilerArguments-Swift.h -Xcc -working-directory/Users/ainopara/Documents/Projects/SwiftCompilerArguments".split(separator: " ").map(String.init)

        let parser = SwiftCompilerArgumentParser()
        do {
            let swiftcArguments = try parser.parse(arguments: originalArguments)
            let dumpedArguments = try parser.parse(arguments: swiftcArguments.arguments())
            XCTAssertEqual(swiftcArguments.arguments(), dumpedArguments.arguments())
            print(swiftcArguments)
        } catch {
            print(error)
        }
    }
    func testInvariant() {
        let originalArguments = "-frontend -c -primary-file /Users/ainopara/Documents/Projects/SwiftCompilerArguments/Sources/SwiftCompilerArguments/SwiftCompilerArguments.swift -target arm64-apple-ios11.0 -Xllvm -aarch64-use-tbi -enable-objc-interop -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS11.0.sdk -I /Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Build/Products/Debug-iphoneos -F /Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Build/Products/Debug-iphoneos -F /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Frameworks -enable-testing -g -module-cache-path /Users/ainopara/Library/Developer/Xcode/DerivedData/ModuleCache -swift-version 4 -enforce-exclusivity=checked -D SWIFT_PACKAGE -D Xcode -serialize-debugging-options -Xcc -I/Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Build/Intermediates.noindex/SwiftCompilerArguments.build/Debug-iphoneos/SwiftCompilerArguments.build/swift-overrides.hmap -Xcc -I/Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Build/Products/Debug-iphoneos/include -Xcc -I/Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Build/Intermediates.noindex/SwiftCompilerArguments.build/Debug-iphoneos/SwiftCompilerArguments.build/DerivedSources/arm64 -Xcc -I/Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Build/Intermediates.noindex/SwiftCompilerArguments.build/Debug-iphoneos/SwiftCompilerArguments.build/DerivedSources -Xcc -working-directory/Users/ainopara/Documents/Projects/SwiftCompilerArguments -emit-module-doc-path /Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Build/Intermediates.noindex/SwiftCompilerArguments.build/Debug-iphoneos/SwiftCompilerArguments.build/Objects-normal/arm64/SwiftCompilerArguments~partial.swiftdoc -serialize-diagnostics-path /Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Build/Intermediates.noindex/SwiftCompilerArguments.build/Debug-iphoneos/SwiftCompilerArguments.build/Objects-normal/arm64/SwiftCompilerArguments.dia -Onone -parse-as-library -module-name SwiftCompilerArguments -emit-module-path /Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Build/Intermediates.noindex/SwiftCompilerArguments.build/Debug-iphoneos/SwiftCompilerArguments.build/Objects-normal/arm64/SwiftCompilerArguments~partial.swiftmodule -emit-dependencies-path /Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Build/Intermediates.noindex/SwiftCompilerArguments.build/Debug-iphoneos/SwiftCompilerArguments.build/Objects-normal/arm64/SwiftCompilerArguments.d -emit-reference-dependencies-path /Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Build/Intermediates.noindex/SwiftCompilerArguments.build/Debug-iphoneos/SwiftCompilerArguments.build/Objects-normal/arm64/SwiftCompilerArguments.swiftdeps -o /Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Build/Intermediates.noindex/SwiftCompilerArguments.build/Debug-iphoneos/SwiftCompilerArguments.build/Objects-normal/arm64/SwiftCompilerArguments.o -embed-bitcode-marker -index-store-path /Users/ainopara/Library/Developer/Xcode/DerivedData/SwiftCompilerArguments-gpvtxpjfqribcueuzolpjfulsfnm/Index/DataStore -index-system-modules".split(separator: " ").map(String.init)

        let parser = SwiftCompilerArgumentParser()
        do {
            let swiftcArguments = try parser.parse(arguments: originalArguments)
            let dumpedArguments = try parser.parse(arguments: swiftcArguments.arguments())
            XCTAssertEqual(swiftcArguments.arguments(), dumpedArguments.arguments())
            print(swiftcArguments)
        } catch {
            print(error)
        }
    }

    func testMethodDispatch() {
        let normalClass = A()
        let normalClassAsProtocol = normalClass as P
        XCTAssertEqual(normalClass.x(), ImplementationSource.typeExtension)
        XCTAssertEqual(normalClass.y(), ImplementationSource.typeExtension)
        XCTAssertEqual(normalClass.z(), ImplementationSource.protocolExtension)
        XCTAssertEqual(normalClass.m(), ImplementationSource.typeBody)
        XCTAssertEqual(normalClass.n(), ImplementationSource.typeBody)
        XCTAssertEqual(normalClassAsProtocol.x(), ImplementationSource.typeExtension)
        XCTAssertEqual(normalClassAsProtocol.y(), ImplementationSource.protocolExtension)
        XCTAssertEqual(normalClassAsProtocol.z(), ImplementationSource.protocolExtension)
        XCTAssertEqual(normalClassAsProtocol.m(), ImplementationSource.typeBody)
        XCTAssertEqual(normalClassAsProtocol.n(), ImplementationSource.protocolExtension)
        let objcClass = A()
        let objcClassAsProtocol = objcClass as P
        XCTAssertEqual(objcClass.x(), ImplementationSource.typeExtension)
        XCTAssertEqual(objcClass.y(), ImplementationSource.typeExtension)
        XCTAssertEqual(objcClass.z(), ImplementationSource.protocolExtension)
        XCTAssertEqual(objcClass.m(), ImplementationSource.typeBody)
        XCTAssertEqual(objcClass.n(), ImplementationSource.typeBody)
        XCTAssertEqual(objcClassAsProtocol.x(), ImplementationSource.typeExtension)
        XCTAssertEqual(objcClassAsProtocol.y(), ImplementationSource.protocolExtension)
        XCTAssertEqual(objcClassAsProtocol.z(), ImplementationSource.protocolExtension)
        XCTAssertEqual(objcClassAsProtocol.m(), ImplementationSource.typeBody)
        XCTAssertEqual(objcClassAsProtocol.n(), ImplementationSource.protocolExtension)
        let finalClass = D()
        let finalClassAsProtocol = finalClass as P
        XCTAssertEqual(finalClass.x(), ImplementationSource.typeExtension)
        XCTAssertEqual(finalClass.y(), ImplementationSource.typeExtension)
        XCTAssertEqual(finalClass.z(), ImplementationSource.protocolExtension)
        XCTAssertEqual(finalClass.m(), ImplementationSource.typeBody)
        XCTAssertEqual(finalClass.n(), ImplementationSource.typeBody)
        XCTAssertEqual(finalClassAsProtocol.x(), ImplementationSource.typeExtension)
        XCTAssertEqual(finalClassAsProtocol.y(), ImplementationSource.protocolExtension)
        XCTAssertEqual(finalClassAsProtocol.z(), ImplementationSource.protocolExtension)
        XCTAssertEqual(finalClassAsProtocol.m(), ImplementationSource.typeBody)
        XCTAssertEqual(finalClassAsProtocol.n(), ImplementationSource.protocolExtension)
        let normalStruct = C()
        let normalStructAsProtocol = normalStruct as P
        XCTAssertEqual(normalStruct.x(), ImplementationSource.typeExtension)
        XCTAssertEqual(normalStruct.y(), ImplementationSource.typeExtension)
        XCTAssertEqual(normalStruct.z(), ImplementationSource.protocolExtension)
        XCTAssertEqual(normalStruct.m(), ImplementationSource.typeBody)
        XCTAssertEqual(normalStruct.n(), ImplementationSource.typeBody)
        XCTAssertEqual(normalStructAsProtocol.x(), ImplementationSource.typeExtension)
        XCTAssertEqual(normalStructAsProtocol.y(), ImplementationSource.protocolExtension)
        XCTAssertEqual(normalStructAsProtocol.z(), ImplementationSource.protocolExtension)
        XCTAssertEqual(normalStructAsProtocol.m(), ImplementationSource.typeBody)
        XCTAssertEqual(normalStructAsProtocol.n(), ImplementationSource.protocolExtension)
    }

    static var allTests = [
        ("testInvariant", testInvariant),
    ]
}

enum ImplementationSource {
    case protocolExtension
    case typeBody
    case typeExtension
}
protocol P {
    func x() -> ImplementationSource
    func m() -> ImplementationSource
}
extension P {
    func x() -> ImplementationSource { return .protocolExtension }
    func y() -> ImplementationSource { return .protocolExtension }
    func z() -> ImplementationSource { return .protocolExtension }

    func m() -> ImplementationSource { return .protocolExtension }
    func n() -> ImplementationSource { return .protocolExtension }
}

class A {
    func m() -> ImplementationSource { return .typeBody }
    func n() -> ImplementationSource { return .typeBody }
}
extension A: P {
    func x() -> ImplementationSource { return .typeExtension }
    func y() -> ImplementationSource { return .typeExtension }
}

@objc class B: NSObject {
    func m() -> ImplementationSource { return .typeBody }
    func n() -> ImplementationSource { return .typeBody }
}
extension B: P {
    func x() -> ImplementationSource { return .typeExtension }
    func y() -> ImplementationSource { return .typeExtension }
}

final class D {
    func m() -> ImplementationSource { return .typeBody }
    func n() -> ImplementationSource { return .typeBody }
}
extension D: P {
    func x() -> ImplementationSource { return .typeExtension }
    func y() -> ImplementationSource { return .typeExtension }
}

struct C {
    func m() -> ImplementationSource { return .typeBody }
    func n() -> ImplementationSource { return .typeBody }
}
extension C: P {
    func x() -> ImplementationSource { return .typeExtension }
    func y() -> ImplementationSource { return .typeExtension }
}
