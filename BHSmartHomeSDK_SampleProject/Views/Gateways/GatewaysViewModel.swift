//
//  GatewaysViewModel.swift
//  BHSmartHomeSDK_SampleProject
//
//  Created by Maximiliano Chiesa on 9/26/23.
//

import Foundation
import BHSmartHomeFramework

@MainActor class GatewaysViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var domain = ""
    @Published var shouldShowLoadingIndicator = false
    @Published var shouldShowDevicesView = false
    @Published var isConnectingToGateway = false
    @Published var shouldShowConnectionError = false
    @Published var shouldShowInvalidLoginError = false
    @Published var gateways: [Gateway] = []

    init() {
        GatewayManager.shared.start(apiKey: "740a784c-62bf-11ee-8c99-0242ac120002")

        GatewayManager.shared.add(observer: self)
    }

    deinit {
        GatewayManager.shared.remove(observer: self)
    }

    func fetchGateways() async {
        guard !email.isEmpty && !password.isEmpty && !domain.isEmpty else {
            return
        }

        shouldShowInvalidLoginError = false
        shouldShowLoadingIndicator = true

        gateways = await GatewayManager.shared.fetchGateways(
            email: email,
            password: password,
            domain: domain
        )

        shouldShowLoadingIndicator = false
    }

    func connect(gateway: Gateway) async {
        shouldShowConnectionError = false
        isConnectingToGateway = true

        await GatewayManager.shared.connect(gateway)
    }

    func disconnect() {
        GatewayManager.shared.disconnect()

        gateways.removeAll()
    }
}

extension GatewaysViewModel: GatewayObserver {
    func notify(_ notification: BHSmartHomeFramework.GatewayUpdateNotification) {
        switch notification.operation {
        case .connect:
            shouldShowDevicesView = true
            isConnectingToGateway = false
        default:
            break
        }
    }

    func notify(error: BHSmartHomeFramework.GatewayError) {
        switch error {
        case .invalidCredentials:
            shouldShowInvalidLoginError = true
        case .connectionError:
            isConnectingToGateway = false
            shouldShowConnectionError = true
        default:
            break
        }
    }
}
