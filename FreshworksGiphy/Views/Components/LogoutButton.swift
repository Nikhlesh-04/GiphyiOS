//
//  LogoutButton.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import SwiftUI

struct LogoutButton: View {
    @EnvironmentObject var state: AppState
    var body: some View {
        Button("Logout") {
            Constants.kUserDefaults.removeObject(forKey: UserDefaultsConstants.userState)
            state.user.state = .login
        }
    }
}

struct LogoutButton_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ForEach(Constants.typeSizes, id: \.self) { size in
                LogoutButton()
                    .environment(\.dynamicTypeSize, size)
                    .previewDisplayName("\(size)")
            }
            LogoutButton()
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("dark")
        }.previewLayout(.sizeThatFits)
    }
}
