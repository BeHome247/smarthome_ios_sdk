//
//  GatewaysViewModel.swift
//  BHSmartHomeSDK_SampleProject
//
//  Created by Maximiliano Chiesa on 9/26/23.
//

import Foundation
import BHSmartHomeFramework

struct GatewayItem: Identifiable {
    var id: Int

    init(gateway: Gateway) {
        self.id = gateway.gatewayId
    }
}

@MainActor class GatewaysViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var domain = ""
    @Published var shouldShowLoadingIndicator = false
    @Published var gatewayItems: [GatewayItem] = []

    private var gateways: [Gateway] = []

    init() {
        GatewayManager.shared.start(apiKey: "12345678")

        // Register as an observer to receive notifications from the Gateway
        GatewayManager.shared.add(observer: self)
    }

    deinit {
        GatewayManager.shared.remove(observer: self)
    }

    func fetchGateways() async {
        guard !email.isEmpty && !password.isEmpty && !domain.isEmpty else {
            return
        }
        
        shouldShowLoadingIndicator = true
        gateways = await GatewayManager.shared.fetchGateways(email: email, password: password, domain: domain)
        gatewayItems = gateways.map { GatewayItem(gateway: $0) }
        shouldShowLoadingIndicator = false
    }

    func connect(gatewayItem: GatewayItem) async {
        guard let gateway = gateways.first(where: {
            $0.gatewayId == gatewayItem.id
        }) else {
            return
        }

        await GatewayManager.shared.connect(gateway)
    }
}

extension GatewaysViewModel: GatewayObserver {
    func notify(_ notification: BHSmartHomeFramework.GatewayUpdateNotification) {

    }

    func notify(error: BHSmartHomeFramework.GatewayError) {

    }
}
