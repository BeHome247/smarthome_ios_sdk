//
//  LightSwitchView.swift
//  BHSmartHomeSDK_SampleProject
//
//  Created by Maximiliano Chiesa on 9/28/23.
//

import SwiftUI
import BHSmartHomeFramework

struct LightSwitchView: View {
    @StateObject var viewModel: LightSwitchViewModel

    var body: some View {
        Form {
            Toggle("\(viewModel.isOn ? "On" : "Off")", isOn: $viewModel.isOn)
        }
        .navigationTitle(viewModel.title)
        .onChange(of: viewModel.isOn) { newValue in
            viewModel.turn(on: newValue)
        }
    }
}

struct LightSwitchView_Previews: PreviewProvider {
    static var previews: some View {
        let light = Switch(id: "", name: "")
        let viewModel = LightSwitchViewModel(lightSwitch: light)

        LightSwitchView(viewModel: viewModel)
    }
}
