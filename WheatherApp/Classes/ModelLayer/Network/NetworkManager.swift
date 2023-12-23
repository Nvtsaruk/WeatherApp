import Foundation
import Alamofire

enum ResultRequest<T> {
    case success(T)
    case failure(CustomErrors)
}

final class APIService {
    static let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        return Session(configuration: configuration)
    }()

    static func getData<T: Decodable>(_: T.Type,
                                    url: String,
                                    _ completion: @escaping (ResultRequest<T>) -> Void) {
        self.sessionManager.request(url, method: .get).validate().responseDecodable(of: T.self) { response in
            switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    switch error {
                        case .createURLRequestFailed(error: _):
                            CustomErrors.linkError.createAllert()
                        case .invalidURL(url: _):
                            CustomErrors.linkError.createAllert()
                        case .requestAdaptationFailed(error: _):
                            CustomErrors.dataError.createAllert()
                        case .responseSerializationFailed(reason: _):
                            CustomErrors.jsonDecodeError.createAllert()
                        default:
                            CustomErrors.otherError.createAllert()
                    }
            }
        }
    }
}

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        let connected = self.sharedInstance.isReachable
        return connected
    }
}
