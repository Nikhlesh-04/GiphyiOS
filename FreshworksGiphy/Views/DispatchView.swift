//
//  DispatchView.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import SwiftUI

struct DispatchView: View {
    
    @EnvironmentObject var state: AppState
    @Environment(\.colorScheme) var colorScheme

    // MARK: - Body

    var body: some View {
        Constants.setupAppearance(colorScheme: colorScheme)
        FileManager.default.createFolderInsideDocumentDirectory(folderName: Constants.appName)
        switch state.user.state {
            case .login:
                return AnyView(Login().environmentObject(state))

            case .isReady:
                return AnyView(MainContainer().environmentObject(state))

        }
        
    }
}
