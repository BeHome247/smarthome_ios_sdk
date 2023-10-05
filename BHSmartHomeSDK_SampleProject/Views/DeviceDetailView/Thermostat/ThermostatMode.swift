//
//  ThermostatMode.swift
//  BHSmartHomeSDK_SampleProject
//
//  Created by Maximiliano Chiesa on 10/2/23.
//

import Foundation

public enum ThermostatFanMode: String, CaseIterable {
    case autoLow = "auto_low"
    case low
    case off
}

public enum ThermostatMode: String, CaseIterable {
    case off, heat, cool, auto
}
