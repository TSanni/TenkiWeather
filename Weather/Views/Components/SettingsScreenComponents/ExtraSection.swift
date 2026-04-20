//
//  ExtraSection.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 4/18/26.
//

import SwiftUI

struct ExtraSection: View {
    private let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    @EnvironmentObject var appStateViewModel: AppStateViewModel

    var body: some View {
        Section {
            Text("Privacy Policy").onTapGesture { appStateViewModel.showPrivacyWebsite = true }
            Text("Terms and Conditions").onTapGesture { appStateViewModel.showTermsAndConditionsWebsite = true }
            Text("App Version: \(appVersionString)")
        }
    }
}

#Preview {
    ExtraSection()
}
