//
//  DevicesView.swift
//  BHSmartHomeSDK_SampleProject
//
//  Created by Maximiliano Chiesa on 9/26/23.
//

import SwiftUI
import BHSmartHomeFramework

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
                    Text("Model: \(device.model ?? "-")")
                        .font(.subheadline)
                    Text("Manufacturer: \(device.manufacturer ?? "-")")
                        .font(.subheadline)
                    Text("Firmware: \(device.firmware ?? "-")")
                        .font(.subheadline)
                    Text("Hardware: \(device.hardware ?? "-")")
                        .font(.subheadline)
                    Text("Protocol: \(device.deviceProtocol ?? "-")")
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
        let selectedDevice = viewModel.selectedDevice
        if let thermostat = selectedDevice as? Thermostat {
            let viewModel = ThermostatViewModel(thermostat: thermostat)
            ThermostatView(viewModel: viewModel)
        } else if let lock = selectedDevice as? Lock {
            let viewModel = LockViewModel(lock: lock)
            LockView(viewModel: viewModel)
        } else if let dimmer = selectedDevice as? Dimmer {
            let viewModel = DimmerViewModel(dimmer: dimmer)
            DimmerView(viewModel: viewModel)
        } else if let lightSwitch = selectedDevice as? Switch {
            let viewModel = LightSwitchViewModel(lightSwitch: lightSwitch)
            LightSwitchView(viewModel: viewModel)
        } else if let motionSensor = selectedDevice as? MotionSensor {
            let viewModel = MotionSensorViewModel(motionSensor: motionSensor)
            MotionSensorView(viewModel: viewModel)
        } else {
            Text("View not implemented for this device.")
        }
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView()
    }
}
