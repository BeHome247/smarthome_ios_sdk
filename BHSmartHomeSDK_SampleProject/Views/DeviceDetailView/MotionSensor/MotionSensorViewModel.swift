//
//  MotionSensorViewModel.swift
//  BHSmartHomeSDK_SampleProject
//
//  Created by Maximiliano Chiesa on 10/6/23.
//

import Foundation
import BHSmartHomeFramework

@MainActor class MotionSensorViewModel: ObservableObject {
    @Published var isArmed: Bool

    let title: String
    private let motionSensorId: String

    init(motionSensor: MotionSensor) {
        self.motionSensorId = motionSensor.id
        self.title = motionSensor.name
        self.isArmed = motionSensor.armed

        GatewayManager.shared.add(observer: self)
    }

    func arm(_ on: Bool) {
        if on {
            GatewayManager.shared.send(.arm, deviceId: motionSensorId)
        } else {
            GatewayManager.shared.send(.disarm, deviceId: motionSensorId)
        }
    }
}

extension MotionSensorViewModel: GatewayObserver {
    func notify(_ notification: BHSmartHomeFramework.GatewayUpdateNotification) {
        switch notification.operation {
        case .arm:
            isArmed = true
        case .disarm:
            isArmed = false
        default:
            break
        }
    }

    func notify(error: BHSmartHomeFramework.GatewayError) {

    }
}
