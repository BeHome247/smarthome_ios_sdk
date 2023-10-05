//
//  LockView.swift
//  BHSmartHomeSDK_SampleProject
//
//  Created by Maximiliano Chiesa on 9/27/23.
//

import SwiftUI
import BHSmartHomeFramework

struct LockView: View {
    @StateObject var viewModel: LockViewModel

    var body: some View {
        Form {
            Section {
                Toggle(viewModel.isLocked ? "Locked" : "Unlocked", isOn: $viewModel.isLocked)
            }

            Section("Lock's Access Codes") {
                ForEach(viewModel.codes) { code in
                    HStack {
                        Text(code.name)
                        Spacer()
                        Text(code.pincode)
                    }
                }
            }
        }
        .navigationTitle(viewModel.title)
        .onChange(of: viewModel.isLocked) { newValue in
            viewModel.lock(newValue)
        }
        .onAppear {
            viewModel.fetchAccessCodes()
        }
    }
}

struct LockView_Previews: PreviewProvider {
    static var previews: some View {
        let lock = Lock(id: "1234", name: "Test Lock")
        let viewModel = LockViewModel(lock: lock)
        LockView(viewModel: viewModel)
    }
}
