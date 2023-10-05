//
//  DimmerView.swift
//  BHSmartHomeSDK_SampleProject
//
//  Created by Maximiliano Chiesa on 9/28/23.
//

import SwiftUI
import BHSmartHomeFramework

struct DimmerView: View {
    @StateObject var viewModel: DimmerViewModel

    var body: some View {
        Form {
            Toggle(viewModel.isOn ? "On" : "Off", isOn: $viewModel.isOn)
            Slider(value: $viewModel.intensity, in: 0...100)
        }
        .navigationTitle(viewModel.title)
        .onChange(of: viewModel.isOn) { newValue in
            viewModel.turn(on: newValue)
        }
        .onChange(of: viewModel.intensity) { newValue in
            viewModel.dim(value: newValue)
        }
    }
}

struct DimmerView_Previews: PreviewProvider {
    static var previews: some View {
        let dimmer = Dimmer(id: "", name: "")
        let viewModel = DimmerViewModel(dimmer: dimmer)
        DimmerView(viewModel: viewModel)
    }
}
