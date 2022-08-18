import XCTest
@testable import ArgumentMagics

struct MyArgument: Argument
{
    //  //= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =\\
    //  MARK: Lifecycle -
    //  \\= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =//
    init(definition: Definition, value: String? = nil)
    {
        self.definition = definition
        self.value = value
    }
    
    //  //= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =\\
    //  MARK: Argument protocol implementation -
    //  \\= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =//
    struct Definition: ArgumentDefinition, Equatable
    {
        static let appId = Self(name: "app-id", shortName: "a", shouldHaveValue: true)
        static let versionName = Self(name: "version-name", shortName: "v", shouldHaveValue: true)
        static let username = Self(name: "username", shortName: "u", shouldHaveValue: true)
        static let password = Self(name: "password", shortName: "p", shouldHaveValue: true)
        static let sharelinkPassword = Self(name: "sharelink-password", shortName: "s", shouldHaveValue: true)
        static let environment = Self(name: "environment", shortName: "e", shouldHaveValue: true)
        static let printSharelinks = Self(name: "print-sharelinks", shortName: "l", shouldHaveValue: false)
//        static let bla = Self(name: "bla", shortName: "b", shouldHaveValue: false)
//        static let nja = Self(name: "print-sharelinks", shortName: "l", shouldHaveValue: false)

        var name: String
        var shortName: String?
        var shouldHaveValue: Bool
        
        static func == (lhs: MyArgument.Definition, rhs: MyArgument.Definition) -> Bool
        {
            return lhs.name == rhs.name
        }
    }
    
    static var expectedDefinitions: [Definition]
    {
        [.appId, .versionName, .username, .password, .sharelinkPassword, .environment, .printSharelinks]
    }
            
    var value: String? = nil
    let definition: Definition
}


final class ArgumentMagicsTests: XCTestCase
{
    func testSuccess() throws
    {
        let testInput = ["-v",
                         "1.0.0",
                         "--username",
                         "nekiUsername",
                         "--app-id",
                         "121",
                         "-l"]
        let arguments: [MyArgument] = try CommandLine.parse(testInput)
        
        assert(definition: .versionName, value: "1.0.0", arguments: arguments)
        assert(definition: .username, value: "nekiUsername", arguments: arguments)
        assert(definition: .appId, value: "121", arguments: arguments)
        assert(definition: .printSharelinks, value: nil, arguments: arguments)
    }
    
    private func assert(definition: MyArgument.Definition, value: String?, arguments: [MyArgument])
    {
        XCTAssert(arguments.contains(where: {$0.definition == definition && $0.value == value }), "Argument definition \(definition) error")
    }
}
