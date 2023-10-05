//
//  ThermostatViewModel.swift
//  BHSmartHomeSDK_SampleProject
//
//  Created by Maximiliano Chiesa on 9/26/23.
//

import Foundation
import BHSmartHomeFramework

@MainActor class ThermostatViewModel: ObservableObject {
    @Published var setpoint = 0
    @Published var setpointCooling = 0
    @Published var setpointHeating = 0
    @Published var mode: ThermostatMode

    let thermostatName: String

    private let thermostatId: String

    init(thermostat: Thermostat) {
        self.thermostatId = thermostat.id
        self.thermostatName = thermostat.name
        self.setpoint = Int(thermostat.setPoint) ?? 0
        self.setpointCooling = Int(thermostat.cool) ?? 0
        self.setpointHeating = Int(thermostat.heat) ?? 0
        self.mode = ThermostatMode(rawValue: thermostat.mode) ?? .auto

        GatewayManager.shared.add(observer: self)
    }

    deinit {
        GatewayManager.shared.remove(observer: self)
    }

    func updateSetpointHeating(plus: Bool) {
        setpointHeating = plus ? setpointHeating + 1 : setpointHeating - 1
        updateSetpointHeating(temperature: setpointHeating)
    }

    func updateSetpointCooling(plus: Bool) {
        setpointCooling = plus ? setpointCooling + 1 : setpointCooling - 1
        updateSetpointCooling(temperature: setpointCooling)
    }

    func update(mode: ThermostatMode) {
        GatewayManager.shared.send(
            .updateThermostatMode,
            deviceId: thermostatId,
            data: ["mode": mode.rawValue]
        )
    }

    private func updateSetpointCooling(temperature: Int) {
        GatewayManager.shared.send(
            .updateThermostatSetpointCooling,
            deviceId: thermostatId,
            data: ["setpoint": temperature]
        )
    }

    private func updateSetpointHeating(temperature: Int) {
        GatewayManager.shared.send(
            .updateThermostatSetpointHeating,
            deviceId: thermostatId,
            data: ["setpoint": temperature]
        )
    }
}

extension ThermostatViewModel: GatewayObserver {
    func notify(_ notification: BHSmartHomeFramework.GatewayUpdateNotification) {
        switch notification.operation {
        case .updateThermostatSetpointHeating:
            print("Updated Setpoint Heating")
        case .updateThermostatSetpointCooling:
            print("Updated Setpoint Cooling")
        case .updateThermostatSetpoint:
            print("Updated Setpoint")
        case .updateThermostatMode:
            print("Updated Mode")
        case .updateThermostatFanMode:
            print("Updated Fan Mode")
        default:
            break
        }
    }

    func notify(error: BHSmartHomeFramework.GatewayError) {

    }
}
