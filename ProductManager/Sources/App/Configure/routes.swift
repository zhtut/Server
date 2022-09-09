import Fluent
import Vapor

//Method    CURD
//GET    Read
//POST    Create
//PUT    Replace
//PATCH    Update
//DELETE    Delete
func routes(_ app: Application) throws {
    
    // body最大数据量，默认是16，这里改成128kb
    app.routes.defaultMaxBodySize = "128kb"
    // routes是否区分大小写，这里不区分
    app.routes.caseInsensitive = false

    try app.register(collection: ApiController())
    
    // 打印所有路由
    print(app.routes.all) // [Route]
}
