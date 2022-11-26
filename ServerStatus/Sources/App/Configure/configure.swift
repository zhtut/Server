import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    switch app.environment {
        case .development:
            app.databases.use(.postgres(
                hostname: Environment.get("DATABASE_HOST") ?? "localhost",
                port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
                username: Environment.get("DATABASE_USERNAME") ?? "zhtut",
                password: Environment.get("DATABASE_PASSWORD") ?? "Zaq145236",
                database: Environment.get("DATABASE_NAME") ?? "Server"
            ), as: .psql)
        default:
            break
    }
    
    // Add 'Server: vapor' header to responses.
    app.http.server.configuration.serverName = "ServerStatus"
    
    // 支持的http版本，tls不支持的话，默认是http1，否则支持2个版本
//    app.http.server.configuration.supportVersions = [.one, .two]
    
    // Configure custom port.
    app.http.server.configuration.port = 8080
    
    // 最大连接数
    app.http.server.configuration.backlog = 256
    
    // Enable HTTP response compression. 允许使用gzip来压缩数据，压缩buffer设置为1024
    app.http.server.configuration.responseCompression = .enabled(initialByteBufferCapacity: 1024)
    
    // Enable HTTP request decompression. No decompression size limit 允许请求压缩，设置为允许，无限制
    app.http.server.configuration.requestDecompression = .enabled(limit: .none)
    
    // Support HTTP pipelining.是否支持管道
    app.http.server.configuration.supportPipelining = true
    
    // sessions中间件
    app.middleware.use(app.sessions.middleware)
    
    // 使用内存
    app.sessions.use(.memory)
    
    // 跨域资源共享（Cross-origin resource sharing，缩写：CORS）
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)
    // 清除现有的 middleware。
    app.middleware = .init()
    app.middleware.use(cors)
    
    // 错误
    let error = ErrorMiddleware.default(environment: app.environment)
    app.middleware.use(error)
    
    // 静态资源文件
    let file = FileMiddleware(publicDirectory: app.directory.publicDirectory)
    app.middleware.use(file)
    
    // 清理null值
    let filterNull = FilterNullMiddleware()
    app.middleware.use(filterNull)
    
    app.logger.logLevel = .notice

    // leaf
    app.views.use(.leaf)
    
    // register migrations
    try migrations(app)

    // register routes
    try routes(app)
}
