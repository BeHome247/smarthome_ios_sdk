//
//  ThermostatView.swift
//  BHSmartHomeSDK_SampleProject
//
//  Created by Maximiliano Chiesa on 9/26/23.
//

import SwiftUI
import BHSmartHomeFramework

struct ThermostatView: View {
    @StateObject var viewModel: ThermostatViewModel

    var body: some View {
        Form {
            HStack {
                Text("Setpoint: \(viewModel.setpoint)")
                    .bold()
                Spacer()
            }

            HStack {
                Text("Cool: \(viewModel.setpointCooling)")
                    .bold()
                Spacer()
                Button("+") {
                    viewModel.updateSetpointCooling(plus: true)
                }
                .buttonStyle(BorderlessButtonStyle())
                Button("-") {
                    viewModel.updateSetpointCooling(plus: true)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .disabled(viewModel.mode != .cool)

            HStack {
                Text("Heat: \(viewModel.setpointHeating)")
                    .bold()
                Spacer()
                Button("+") {
                    viewModel.updateSetpointHeating(plus: true)
                }
                .buttonStyle(BorderlessButtonStyle())
                Button("-") {
                    viewModel.updateSetpointHeating(plus: false)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .disabled(viewModel.mode != .heat)

            HStack {
                Picker("Mode", selection: $viewModel.mode) {
                    ForEach(GatewayThermostatModeOption.allCases, id: \.self) { mode in
                        Text(mode.rawValue.capitalized)
                    }
                }
                .pickerStyle(.menu)
            }
        }
        .navigationTitle(viewModel.thermostatName)
        .onChange(of: viewModel.mode) { newValue in
            viewModel.update(mode: newValue)
        }
    }
}

struct ThermostatView_Previews: PreviewProvider {
    static var previews: some View {
        let thermostat = Thermostat(id: "123", name: "Thermostat")
        ThermostatView(viewModel: ThermostatViewModel(thermostat: thermostat))
    }
}
