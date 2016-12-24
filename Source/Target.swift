import Foundation
import Alamofire

/// Protocol to define the base URL, path, method, parameters and sample data for a target.
public protocol TargetType {
    /// The base URL for the target
    var baseURL: URL { get }

    /// The path to be appended to the baseURL (defaults to none)
    var path: String { get }

    /// The HTTP method to be used (defaults to `get`)
    var method: Moya.Method { get }

    /// The parameters to be sent in the request (defaults to `nil`)
    var parameters: [String: Any]? { get }

    /// The `ParameterEncoding` to be used in the request (defaults to `URLEncoding`)
    var parameterEncoding: ParameterEncoding { get }

    /// Sample data to be used in testing (defaults to an empty `Data`)
    var sampleData: Data { get }

    /// The type of task to be used (dafaults to `request`)
    var task: Task { get }

    /// Whether Alamofire validation should be applied (defaults to `false`)
    var validate: Bool { get }
}

public extension TargetType {
    var path: String { return "" }
    var method: Moya.Method { return .get }
    var parameters: [String: Any]? { return nil }
    var parameterEncoding: ParameterEncoding { return URLEncoding.default }
    var sampleData: Data { return Data() }
    var task: Task { return .request }
    var validate: Bool { return false }
}

/// A `TargetType` that represents a GET request to a single `URL` with no parameters.
public struct SingleURLTarget: TargetType {
    public let baseURL: URL

    /// Initialize a SingleURLTarget
    public init(url: URL) {
        baseURL = url
    }
}

/// Represents an HTTP method.
public typealias Method = Alamofire.HTTPMethod

extension Method {
    public var supportsMultipart: Bool {
        switch self {
        case .post,
             .put,
             .patch,
             .connect:
            return true
        default:
            return false
        }
    }
}

public enum StubBehavior {
    case never
    case immediate
    case delayed(seconds: TimeInterval)
}

public enum UploadType {
    case file(URL)
    case multipart([MultipartFormData])
}

public enum DownloadType {
    case request(DownloadDestination)
}

public enum Task {
    case request
    case upload(UploadType)
    case download(DownloadType)
}

public struct MultipartFormData {
    public enum FormDataProvider {
        case data(Foundation.Data)
        case file(URL)
        case stream(InputStream, UInt64)
    }

    public init(provider: FormDataProvider, name: String, fileName: String? = nil, mimeType: String? = nil) {
        self.provider = provider
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }

    public let provider: FormDataProvider
    public let name: String
    public let fileName: String?
    public let mimeType: String?
}
