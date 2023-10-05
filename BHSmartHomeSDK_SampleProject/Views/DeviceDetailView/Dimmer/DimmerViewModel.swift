//
//  DimmerViewModel.swift
//  BHSmartHomeSDK_SampleProject
//
//  Created by Maximiliano Chiesa on 9/28/23.
//

import Foundation
import BHSmartHomeFramework

@MainActor class DimmerViewModel: ObservableObject {
    @Published var isOn: Bool
    @Published var intensity: Double

    let title: String
    private let dimmerId: String

    init(dimmer: Dimmer) {
        self.dimmerId = dimmer.id
        self.isOn = dimmer.isOn
        self.intensity = Double(dimmer.level)
        self.title = dimmer.name

        GatewayManager.shared.add(observer: self)
    }

    deinit {
        GatewayManager.shared.remove(observer: self)
    }

    func turn(on: Bool) {
        if on {
            GatewayManager.shared.send(.turnOn, deviceId: dimmerId)
        } else {
            GatewayManager.shared.send(.turnOff, deviceId: dimmerId)
        }
    }

    func dim(value: Double) {
        GatewayManager.shared.send(
            .dim,
            deviceId: dimmerId,
            data: ["value": Int(value)]
        )
    }
}

extension DimmerViewModel: GatewayObserver {

    func notify(_ notification: BHSmartHomeFramework.GatewayUpdateNotification) {
        switch notification.operation {
        case .turnOn:
            self.isOn = true
        case .turnOff:
            self.isOn = false
        case .dim:
            guard let dimValue = notification.data as? Int else {
                return
            }

            intensity = Double(dimValue)
        default:
            break
        }
    }

    func notify(error: BHSmartHomeFramework.GatewayError) {

    }
}
