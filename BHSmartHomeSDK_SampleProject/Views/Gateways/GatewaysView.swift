//
//  GatewaysView.swift
//  BHSmartHomeSDK_SampleProject
//
//  Created by Maximiliano Chiesa on 9/26/23.
//

import SwiftUI

struct GatewaysView: View {
    @StateObject var viewModel = GatewaysViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .textCase(.lowercase)
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
                TextField("Domain", text: $viewModel.domain)
                    .textFieldStyle(.roundedBorder)
                    .textCase(.lowercase)

                Button {
                    Task {
                        await viewModel.fetchGateways()
                    }
                } label: {
                    if viewModel.shouldShowLoadingIndicator {
                        ProgressView()
                    } else {
                        Text("Fetch")
                    }
                }
                .padding(.top, 24)

                Button("Disconnect") {
                    viewModel.disconnect()
                }

                if !viewModel.gateways.isEmpty {
                    HStack(alignment: .center) {
                        Text("Available Gateways (tap to connect)")
                            .bold()
                            .padding(.top, 48)
                        Spacer()
                        if viewModel.isConnectingToGateway {
                            ProgressView()
                        }
                    }
                }

                List(viewModel.gateways) { gateway in
                    Button {
                        Task {
                            await viewModel.connect(gateway: gateway)
                        }
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("ID: \(gateway.id.description)")
                                Text("Status: \(gateway.status ?? "UNKNOWN")")
                                Text("Battery Level: \(gateway.batteryLevel)")
                            }
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                    }
                }
                .listStyle(.plain)

                if viewModel.shouldShowConnectionError {
                    Text("Connection error. Check that the gateway is connected.")
                        .foregroundColor(.red)
                }

                if viewModel.shouldShowInvalidLoginError {
                    Text("Invalid credentials.")
                        .foregroundColor(.red)
                }


            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            .navigationTitle("Fetch Gateways")
            .navigationDestination(isPresented: $viewModel.shouldShowDevicesView) {
                DevicesView()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        GatewaysView()
    }
}
