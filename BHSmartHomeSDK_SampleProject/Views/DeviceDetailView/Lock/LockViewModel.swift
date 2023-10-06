//
//  LockViewModel.swift
//  BHSmartHomeSDK_SampleProject
//
//  Created by Maximiliano Chiesa on 9/27/23.
//

import Foundation
import BHSmartHomeFramework

@MainActor class LockViewModel: ObservableObject {
    @Published var isLocked: Bool
    @Published var codes: [Pincode] = []

    let title: String
    private let lockId: String

    init(lock: Lock) {
        self.lockId = lock.id
        self.title = lock.name
        self.isLocked = lock.isLocked

        GatewayManager.shared.add(observer: self)
    }

    deinit {
        GatewayManager.shared.remove(observer: self)
    }

    func lock(_ isLocked: Bool) {
        if isLocked {
            GatewayManager.shared.send(.lock, deviceId: lockId)
        } else {
            GatewayManager.shared.send(.unlock, deviceId: lockId)
        }
    }

    func fetchAccessCodes() {
        GatewayManager.shared.send(.fetchCodes, deviceId: lockId)
    }

}

extension LockViewModel: GatewayObserver {
    func notify(_ notification: BHSmartHomeFramework.GatewayUpdateNotification) {
        switch notification.operation {
        case .lock:
            print("Locked")
            isLocked = true
        case .unlock:
            print("Unlocked")
            isLocked = false
        case .fetchCodes:
            codes = notification.data as? [Pincode] ?? []
        default:
            break
        }
    }

    func notify(error: BHSmartHomeFramework.GatewayError) {

    }
}
