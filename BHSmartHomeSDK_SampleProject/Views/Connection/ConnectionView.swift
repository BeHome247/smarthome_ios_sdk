//
//  ConnectionView.swift
//  BHSmartHomeSDK_SampleProject
//
//  Created by Maximiliano Chiesa on 10/2/23.
//

import SwiftUI

struct ConnectionView: View {
    @StateObject var viewModel = ConnectionViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if viewModel.isFetchingConnectionStatus {
                HStack {
                    ProgressView()
                    Text("Fetching connection status...")
                }
            } else {
                HStack {
                    Text("•")
                        .font(.largeTitle)
                        .foregroundColor(viewModel.statusColor)
                    Text(viewModel.statusDescription)
                }
            }

            HStack {
                Text("WiFi Networks")
                    .font(.title3)
                    .bold()
                Spacer()

                if viewModel.isFetchingWiFiNetworks {
                    ProgressView()
                }
            }

            List(viewModel.networks) { network in
                HStack(alignment: .top) {
                    Image(systemName: "dot.radiowaves.up.forward")
                    VStack(alignment: .leading, spacing: 8) {
                        Text(network.ssid)
                            .font(.headline)
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("\(network.encryption) - \(network.bssid)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Text("Channel: \(network.channel)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }

                    Spacer()
                }
            }
            .listStyle(.plain)
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .navigationTitle("Connection Settings")
        .onAppear {
            viewModel.fetch()
        }
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView()
    }
}
