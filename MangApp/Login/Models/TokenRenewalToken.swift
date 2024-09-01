//
//  TokenRenewalToken.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-25.
//

import SwiftUI
import BackgroundTasks

@Observable
class TokenRenewalToken {
    var lastRenewalDate: Date?
    private var interactor: NetworkInteractor
    
    private var tokenRefreshTaskIdentifier: String {
        return "com.moisesCordova.MangApp.tokenRefresh"
    }
    
    init(interactor: NetworkInteractor = NetworkInteractor.shared) {
        self.interactor = interactor
        lastRenewalDate = UserDefaults.standard.object(forKey: "lastRenewalDate") as? Date
        renewTokenIfNeeded()
    }
    
    func renewTokenIfNeeded(isFromBackGround: Bool = false) {
        guard !isFromBackGround,
              interactor.isLoggedIn,
              KeychainManager.shared.hasToken else { return }
        
        let now = Date()
        let calendar = Calendar.current
        
        if let lastRenewal = lastRenewalDate, let difference = calendar.dateComponents([.hour], from: lastRenewal, to: now).hour, difference < 24 {
            return
        }
        
        renewToken { success in
            if success {
                self.lastRenewalDate = Date()
                UserDefaults.standard.set(self.lastRenewalDate, forKey: "lastRenewalDate")
                self.renewTokenIfNeeded()
            }
        }
    }
    
    private func renewToken(completion: @escaping (Bool) -> Void) {
        Task {
            guard await interactor.renew() == .ok else {
                completion(false)
                return
            }
            completion(true)
        }
    }
}
