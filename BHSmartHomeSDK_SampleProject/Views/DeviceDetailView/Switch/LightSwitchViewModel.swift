//
//  LightSwitchViewModel.swift
//  BHSmartHomeSDK_SampleProject
//
//  Created by Maximiliano Chiesa on 9/28/23.
//

import Foundation
import BHSmartHomeFramework

@MainActor class LightSwitchViewModel: ObservableObject {
    @Published var isOn: Bool

    let title: String
    private let switchId: String

    init(lightSwitch: Switch) {
        self.switchId = lightSwitch.id
        self.title = lightSwitch.name
        self.isOn = lightSwitch.isOn

        GatewayManager.shared.add(observer: self)
    }

    deinit {
        GatewayManager.shared.remove(observer: self)
    }

    func turn(on: Bool) {
        if on {
            GatewayManager.shared.send(.turnOn, deviceId: switchId)
        } else {
            GatewayManager.shared.send(.turnOff, deviceId: switchId)
        }
    }
}

extension LightSwitchViewModel: GatewayObserver {
    func notify(_ notification: BHSmartHomeFramework.GatewayUpdateNotification) {

    }

    func notify(error: BHSmartHomeFramework.GatewayError) {

    }
}
