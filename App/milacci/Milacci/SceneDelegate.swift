//
//  SceneDelegate.swift
//  Milacci
//
//  Created by Michal Sousedik on 23/05/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import GoogleSignIn
import Alamofire
import Network
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var authService: AuthAPI = AuthService.shared
    var bag: DisposeBag = DisposeBag()
    let userSettingsApi: UserSettingsAPI = UserSettingsService.shared

    let monitor = NWPathMonitor()
    var labels: [UILabel] = []

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        GIDSignIn.sharedInstance().delegate = self
        guard let windowScene = (scene as? UIWindowScene)
        else { fatalError("Scene is not of type UIWindowScene") }

        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.appCoordinator = AppCoordinator.init(window: window)
        self.appCoordinator?.start()
        self.handleOfflineState()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}

extension SceneDelegate: GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else if (error as NSError).code == -10 {
                //TODO - handle access token expired
                print(error.localizedDescription)
                self.userSettingsApi.clearAll()
            }
            else {
                print(error.localizedDescription)
                self.userSettingsApi.clearAll()
            }
            self.appCoordinator?.reload()
            return
        }
        guard let accessToken = user.authentication.accessToken else {
            fatalError("Access token was not provided from Google Sign in")
        }
        self.signIn(accessToken: accessToken)

    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        self.userSettingsApi.clearAll()
        self.appCoordinator?.reload()
    }

}

private extension SceneDelegate {

    func signIn(accessToken: String){
        self.authService.signIn(accessToken: accessToken)
            .subscribe { [weak self] signInModel in
                self?.userSettingsApi.saveCredentials(credentials: signInModel.credentials)
                self?.userSettingsApi.saveUser(user: signInModel.user)
                self?.appCoordinator?.reload()
            } onError: { [weak self] error in
                self?.displayError(error: error, window: self?.window)
            }.disposed(by: bag)
    }

}

private extension SceneDelegate {

    func handleOfflineState() {
        monitor.start(queue: .global())
        monitor.pathUpdateHandler = {[weak self] path in
            if path.status == .satisfied {
                DispatchQueue.main.async{ [weak self] in
                    self?.labels.forEach{$0.removeFromSuperview()}
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    guard let self = self,
                          let window = self.window
                    else { print("Self or window does not exist"); return }
                    let label = self.labels.first ?? self.createOfflineView(frame: CGRect(x: 0, y: 0, width: window.bounds.width, height: window.bounds.height))
                    self.window?.rootViewController?.view.addSubview(label)
                }
            }
        }
    }

    func createOfflineView(frame: CGRect) -> UIView {
        let label = UILabel(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.red
        label.textAlignment = .center
        label.text = L10n.noInternetConnection
        self.labels.append(label)
        return label
    }

    func displayError(error: Error, window: UIWindow?) {
        guard let window = window else { print("No window found"); return }
        let vc = ErrorViewController.instantiate()
        window.rootViewController = vc
        window.makeKeyAndVisible()
        vc.handle(error, from: vc, retryHandler: nil)
    }

}
