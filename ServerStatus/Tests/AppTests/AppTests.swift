@testable import App
import XCTVapor
@testable import SSCommon

final class AppTests: XCTestCase {
    func testHelloWorld() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "hello", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "Hello, world!")
        })
    }
    
    func testArray() {
        let arr = [123, 456]
        let strArr = arr.map(String.init)
        print(strArr)
    }
    
    func testHome() async throws {
        let home = try await runCommand("echo $HOME")
        print(home)
    }
    
    func testStatus() async throws  {
        let home = try await runCommand("/bin/ps -u tuguangzhou")
        print(home)
    }
}
