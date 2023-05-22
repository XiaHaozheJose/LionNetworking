import XCTest
import LionNetworking

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        //        networkMonitor()
        requestTest()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}

//MARK: NetworkMonitor
extension Tests {
    func networkMonitor() {
        let connectionType = LionNetworkMonitor.shared.connectionType
        switch connectionType {
        case .wifi:
            print("当前连接类型：Wi-Fi")
        case .cellular:
            print("当前连接类型：蜂窝数据")
        case .wiredEthernet:
            print("当前连接类型：有线以太网")
        case .unknown:
            print("当前连接类型：未知")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNetworkStatusChanged(_:)), name: .lionNetworkStatusChanged, object: nil)
    }
    
    @objc func handleNetworkStatusChanged(_ notification: Notification) {
        if LionNetworkMonitor.shared.isConnected {
            print("设备已连接到互联网")
        } else {
            print("设备未连接到互联网")
        }
    }
    
}

//MARK: Request
extension Tests {
    
    struct User: Codable {
        let id: Int
        let name: String
        let email: String
    }
    struct GetLionUserRequest: LionRequestConvertible {
        let userID: String
        
        func asLionRequest() -> LionNetworking.LionRequest {
            return LionRequest(
                //                method: .get,
                method: .post,
                url: "https://api.example.com/users/\(userID)",
                headers: ["Authorization": "Bearer <your_access_token>"]
            )
        }
        
    }
    
    //
    func requestTest() {
        /**
         let simpleRequest = LionRequest(method: .put, url: "https://api.example.com")
         simpleRequest.headers = ["Authorization": "Bearer token"]
         */
        
        let request = GetLionUserRequest(userID: "123").asLionRequest()
        Lion.shared.execute(request: request, responseDecoder: LionJSONResponseDecoder<User>()) { result in
            switch result {
            case.success(let user):
                print(user.name)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    struct UploadResponse: Decodable {
        let isSuccess: Bool
    }
    
    func uploadTest() {
        let fileURL = URL(fileURLWithPath: "app/test.pdf")
        let fileUploader = LionFileUploader()
        // 创建文件上传任务
        let files = [LionUploadableFile(data: fileURL.dataRepresentation, fileName: "", mimeType: LionDefaultMimeType.pdf)]
        
        fileUploader.upload(request: LionRequest(url: "www.upload.com"), files: files, responseDecoder: LionJSONResponseDecoder<UploadResponse>(), progressHandler: { (progress: Double) in
            print("progress: \(progress)")
        }) { result in
            // 处理上传完成的结果
            
        }
    }
    
    
}
