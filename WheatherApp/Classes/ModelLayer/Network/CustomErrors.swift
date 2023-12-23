import UIKit
enum CustomErrors: Error {
    case receivedError
    case linkError
    case dataError
    case jsonDecodeError
    case brokenAccessToken
    case authError
    case otherError
    
    func createAllert() {
        switch self {
            case .receivedError:
                showAlert(message: "Broken access token")
            case .linkError:
                showAlert(message: "Url error")
            case .dataError:
                showAlert(message: "Broken data")
            case .jsonDecodeError:
                showAlert(message: "JSON decoding error")
            case .brokenAccessToken:
                showAlert(message: "Broken access token")
            case .authError:
                showAlert(message: "Auth error")
            case .otherError:
                showAlert(message: "Connection error")
        }
    }
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(action)
        var rootViewController = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .last { $0.isKeyWindow }?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
}

final class ErrorHandler {
    static var shared = ErrorHandler()
    private init() {}
    
    func handleError(error: CustomErrors) {
        switch error {
            case .receivedError:
                CustomErrors.receivedError.createAllert()
            case .linkError:
                CustomErrors.linkError.createAllert()
            case .dataError:
                CustomErrors.dataError.createAllert()
            case .jsonDecodeError:
                CustomErrors.jsonDecodeError.createAllert()
            case .brokenAccessToken:
                CustomErrors.brokenAccessToken.createAllert()
            case .authError:
                CustomErrors.authError.createAllert()
            case .otherError:
                CustomErrors.otherError.createAllert()
        }
    }
}
