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

                Text("Available Gateways (tap one to connect)")
                    .bold()
                    .padding(.top, 48)
                List(viewModel.gatewayItems) { item in
                    HStack {
                        Text("ID \(item.id)")
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                    .onTapGesture {
                        Task {
                            await viewModel.connect(gatewayItem: item)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            .navigationTitle("Fetch Gateways")
        }

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        GatewaysView()
    }
}
