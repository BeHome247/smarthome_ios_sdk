//
//  MotionSensorView.swift
//  BHSmartHomeSDK_SampleProject
//
//  Created by Maximiliano Chiesa on 10/6/23.
//

import SwiftUI
import BHSmartHomeFramework

struct MotionSensorView: View {
    @StateObject var viewModel: MotionSensorViewModel

    var body: some View {
        VStack {
            Toggle("Armed?", isOn: $viewModel.isArmed)
                .navigationTitle(viewModel.title)
                .onChange(of: viewModel.isArmed) { newValue in
                    viewModel.arm(newValue)
                }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct MotionSensorView_Previews: PreviewProvider {
    static var previews: some View {
        let sensor = MotionSensor(id: "", name: "")
        let viewModel = MotionSensorViewModel(motionSensor: sensor)
        MotionSensorView(viewModel: viewModel)
    }
}
