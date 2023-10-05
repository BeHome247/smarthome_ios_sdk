//
//  DevicesViewModel.swift
//  BHSmartHomeSDK_SampleProject
//
//  Created by Maximiliano Chiesa on 9/26/23.
//

import Foundation
import BHSmartHomeFramework

@MainActor class DevicesViewModel: ObservableObject {
    @Published var shouldShowDeviceDetail = false
    @Published var shouldShowConnectionSettings = false
    @Published var devices: [Device] = []

    var selectedDevice: Device?

    init() {
        GatewayManager.shared.add(observer: self)
    }

    deinit {
        GatewayManager.shared.remove(observer: self)
    }

    func fetchDevices() {
        GatewayManager.shared.send(.deviceList)
    }

    func select(device: Device) {
        selectedDevice = device
        shouldShowDeviceDetail = true
    }
}

extension DevicesViewModel: GatewayObserver {
    func notify(_ notification: BHSmartHomeFramework.GatewayUpdateNotification) {
        guard notification.operation == .deviceList else {
            return
        }

        devices = notification.data as? [Device] ?? []
    }

    func notify(error: BHSmartHomeFramework.GatewayError) {

    }
}
