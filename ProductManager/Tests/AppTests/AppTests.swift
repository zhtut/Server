@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    let app = Application(.testing)
    
    func prepareApp() throws {
        defer { app.shutdown() }
        try configure(app)
    }
    
    func testHelloWorld() async throws {
        try prepareApp()
        try app.test(.GET, "hello", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "Hello, world!")
        })
    }
    
    func testProject() async throws {
        try prepareApp()
        try app.test(.POST, "project/add", beforeRequest: { req in
            try req.content.encode(["name": "HSMidEastSecurities", "git": "https://www.baidu.com", "desc": "中东项目"])
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
    }
}
