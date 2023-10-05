//
//  ConnectionViewModel.swift
//  BHSmartHomeSDK_SampleProject
//
//  Created by Maximiliano Chiesa on 10/2/23.
//

import Foundation
import SwiftUI
import BHSmartHomeFramework

@MainActor class ConnectionViewModel: ObservableObject {
    @Published var isFetchingConnectionStatus = false
    @Published var isFetchingWiFiNetworks = false
    @Published var networks: [WiFiNetwork] = []
    @Published var connectionStatus = GatewayConnectionType.offline {
        didSet {
            switch connectionStatus {
            case .offline:
                statusColor = .red
                statusDescription = "Gateway Offline"
            default:
                statusColor = .green
                statusDescription = "Gateway Connected to \(connectionStatus.rawValue)"
            }
        }
    }

    var statusColor = Color.gray
    var statusDescription = ""

    init() {
        GatewayManager.shared.add(observer: self)
    }

    func fetch() {
        isFetchingConnectionStatus = true
        isFetchingWiFiNetworks = true

        GatewayManager.shared.send(.connectionStatus)
        GatewayManager.shared.send(.startWiFiScan)
    }

    func disconnect() {
        GatewayManager.shared.disconnect()
    }
}

extension ConnectionViewModel: GatewayObserver {
    func notify(_ notification: BHSmartHomeFramework.GatewayUpdateNotification) {
        switch notification.operation {
        case .connectionStatus:
            connectionStatus = notification.data as? GatewayConnectionType ?? .offline
            isFetchingConnectionStatus = false
        case .startWiFiScan:
            networks = notification.data as? [WiFiNetwork] ?? []
            isFetchingWiFiNetworks = false
        default:
            break
        }
    }

    func notify(error: BHSmartHomeFramework.GatewayError) {

    }
}
