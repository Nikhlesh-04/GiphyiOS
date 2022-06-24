//
//  MainContainer.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import SwiftUI


import SwiftUI

struct MainContainer: View {
    
    @EnvironmentObject var state: AppState
    @State var hudConfig = LoadingViewConfig()
    
    var body: some View {
        TabView {
            TrendingView()
                .tabItem {
                    Label("", systemImage: ConstantImage.gallery)
                }
            FavoriteView()
                .tabItem {
                    Label("", systemImage: ConstantImage.heart)
                }
        }.accentColor(.primary)
    }
}

struct MainContainer_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            ForEach(Constants.typeSizes, id: \.self) { size in
                MainContainer()
                    .environment(\.dynamicTypeSize, size)
                    .previewDisplayName("\(size)")
            }
            MainContainer()
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("dark")
        }.previewLayout(.sizeThatFits)
    }
}
