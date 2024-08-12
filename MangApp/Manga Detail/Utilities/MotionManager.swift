//
//  MotionManager.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-10.
//

import Foundation
import CoreMotion

#if !os(macOS)
class MotionManager: ObservableObject {
    @Published var yRotation: Double = 0.0
    private var motionManager: CMMotionManager
    
    init() {
        motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = 1 / 60
        startMotionUpdates()
    }
    
    private func startMotionUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (motion, error) in
                guard let motion,
                      let self else { return }
                let rotationRate = motion.attitude.roll
                DispatchQueue.main.async {
                    self.yRotation = rotationRate * (180 / .pi) * -1
                }
            }
        }
    }
    
    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
}
#endif
