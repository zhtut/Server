import App
import Vapor
import Foundation

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer {
    print("系统退出了")
    app.shutdown()
}

try configure(app)
try app.start()

/// 当主线程增加一个runloop防止退出
RunLoop.current.add(SocketPort(), forMode: .default)
RunLoop.current.run()
