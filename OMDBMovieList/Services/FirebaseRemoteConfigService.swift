//
//  FirebaseRemoteConfigService.swift
//  OMDBMovieList
//
//  Created by özcan yılmaz on 12.09.2023.
//

import FirebaseRemoteConfig

class FirebaseRemoteConfigService {
    
    static let shared = FirebaseRemoteConfigService()
    
    private init() {
        configureRemoteConfig()
    }
    
    private func configureRemoteConfig() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let defaultValue: [String: NSObject] = [
            welcomeText: defaultText as NSObject
        ]
        remoteConfig.setDefaults(defaultValue)
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    }
    
    func fetchRemoteConfigValues(completion: @escaping () -> Void) {
        let remoteConfig = RemoteConfig.remoteConfig()
        
        remoteConfig.fetch { status, error in
            if status == .success {
                remoteConfig.activate { _, _ in
                    completion()
                }
            } else {
                completion()
            }
        }
    }
    
    func getWelcomeText() -> String {
        let remoteConfig = RemoteConfig.remoteConfig()
        return remoteConfig[welcomeText].stringValue?.splitIntoChunks(ofLength: 32) ?? defaultText
    }
}
