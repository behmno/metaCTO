import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // Check if user is already logged in
        let isLoggedIn = AuthService.shared.isLoggedIn
        
        let rootViewController: UIViewController
        if isLoggedIn {
            let featuresVC = FeaturesViewController()
            let navController = UINavigationController(rootViewController: featuresVC)
            rootViewController = navController
        } else {
            let loginVC = LoginViewController()
            let navController = UINavigationController(rootViewController: loginVC)
            rootViewController = navController
        }
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}