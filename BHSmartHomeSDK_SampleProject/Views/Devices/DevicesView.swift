//
//  DevicesView.swift
//  BHSmartHomeSDK_SampleProject
//
//  Created by Maximiliano Chiesa on 9/26/23.
//

import SwiftUI

struct DevicesView: View {
    @StateObject var viewModel = DevicesViewModel()

    var body: some View {
        List(viewModel.devices) { device in
            Button {
                viewModel.select(device: device)
            } label: {
                VStack(alignment: .leading, spacing: 8) {
                    Text(device.name)
                        .fontWeight(.bold)
                        .font(.headline)
                    Text("Device Type: \(device.type)")
                        .font(.subheadline)
                    Text("Model: \(device.model)")
                        .font(.subheadline)
                    Text("Manufacturer: \(device.manufacturer)")
                        .font(.subheadline)
                    Text("Firmware: \(device.firmware)")
                        .font(.subheadline)
                    Text("Hardware: \(device.hardware)")
                        .font(.subheadline)
                    Text("Protocol: \(device.deviceProtocol)")
                        .font(.subheadline)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Connected Devices")
        .navigationDestination(isPresented: $viewModel.shouldShowDeviceDetail) {
            viewForSelectedDevice()
        }
        .navigationDestination(isPresented: $viewModel.shouldShowConnectionSettings) {
            ConnectionView()
        }
        .toolbar {
            ToolbarItem {
                Button("Settings") {
                    viewModel.shouldShowConnectionSettings.toggle()
                }
            }
        }
        .onAppear {
            viewModel.fetchDevices()
        }
    }

    @ViewBuilder
    func viewForSelectedDevice() -> some View {
        switch viewModel.selectedDevice {
        case .thermostat(let thermostat):
            let viewModel = ThermostatViewModel(thermostat: thermostat)
            ThermostatView(viewModel: viewModel)
        case .lock(let lock):
            let viewModel = LockViewModel(lock: lock)
            LockView(viewModel: viewModel)
        case .dimmer(let dimmer):
            let viewModel = DimmerViewModel(dimmer: dimmer)
            DimmerView(viewModel: viewModel)
        case .lightSwitch(let lightSwitch):
            let viewModel = LightSwitchViewModel(lightSwitch: lightSwitch)
            LightSwitchView(viewModel: viewModel)
        default:
            Text("View not implemented for this device.")

        }
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView()
    }
}
