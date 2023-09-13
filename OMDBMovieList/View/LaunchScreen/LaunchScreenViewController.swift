import Foundation
import Lottie
import Network
import PopupDialog

class LaunchScreenViewController: UIViewController {
    
    let lotttieAnimation = LottieAnimations.shared
    let animationView = LottieAnimations.shared.animationView
    
    var popup: PopupDialog?
    
    let remoteConfigLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ReachabilityManager.shared.addListener(self)
        configure()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lotttieAnimation.stopAnimation()
    }
    
    deinit {
        ReachabilityManager.shared.removeListener(self)
    }
    
}

extension LaunchScreenViewController {
    private func configure() {
        animationView.play() { _ in
            self.animationView.removeFromSuperview()
            FirebaseRemoteConfigService.shared.fetchRemoteConfigValues {
                DispatchQueue.main.async {
                    let welcomeText = FirebaseRemoteConfigService.shared.getWelcomeText()
                    self.remoteConfigLabel.text = welcomeText
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.loadMainViewController()
                }
            }
        }
        
        OMDBAnalytics.log(event: .launchScreen(.controller))
        
        view.addSubview(remoteConfigLabel)
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            remoteConfigLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            remoteConfigLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 32)
        ])
        animationView.center = view.center
    }
    private func loadMainViewController() {
        let controller: MainViewController = UIStoryboard.main.instantiateViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension LaunchScreenViewController: NetworkStatusListener {
    func networkStatusDidChange(status: NWPath.Status) {
        DispatchQueue.main.async {
            if status == .satisfied {
                self.dismissNoInternetConnectionAlert()
            } else {
                self.presentNoInternetConnectionAlert()
            }
        }
    }
    
    func presentNoInternetConnectionAlert() {
        let alertContent = AlertContentConfig(alertImage: WIFI ?? UIImage(),
                                              alertTitleText: noInternetTitle,
                                              alertDetailText: noInternetInfo)
        let customVC = getDefaultAlertController(with: alertContent)
        
        popup = PopupDialog(viewController: customVC,
                            buttonAlignment: .horizontal,
                            transitionStyle: .fadeIn,
                            tapGestureDismissal: false,
                            panGestureDismissal: false)
        if let popup = popup {
            present(popup, animated: true, completion: nil)
        }
    }
    
    func dismissNoInternetConnectionAlert() {
        navigationController?.topViewController?.dismiss(animated: true)
    }
}
