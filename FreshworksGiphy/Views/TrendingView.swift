//
//  TrendingView.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import SwiftUI

struct TrendingView: View {
    
    @EnvironmentObject var state: AppState
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject private var model = TrendingViewModel()
    @State var hudConfig = LoadingViewConfig()
    
    @State private var searchText = ""
    
    var body: some View {
        self.setupView()
        
        /* NOTE: Here we can use collection as list type as we use in FavoriteView so it's a reuable component
                But here, I use list because I want to show my skill in SwiftUI diffrent type of component design's
         */
        
        return VStack {
            LoadingView(isShowing: $model.hudVisible, config: hudConfig) {
                NavigationView {
                    ZStack {
                        List {
                            ForEach(0..<self.model.searchResults(searchText: searchText, completion: nil).count, id:\.self) { index in
                                let trend = self.model.searchResults(searchText: searchText, completion: nil)[index]
                                let isFav = trend.isFavorate
                                GiphyImageView(isSelected: isFav, index: index, animitedView: model) {isSelected in
                                    self.model.favorate(index: index, isFavorate: isSelected)
                                }
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                                .cornerRadius(2)
                                .listRowSeparator(.hidden)
                            }
                        }
                        .accessibilityIdentifier(Identifiers.trendingTable)
                    }
                    .searchable(text: $searchText)
                    .navigationTitle(ConstantsMessages.navigationTrendingTitle)
                    .toolbar {
                        LogoutButton()
                    }
                    .onAppear {
                        self.searchText = ""
                        self.model.refreshView()
                    }
                }
            }
        }.padding(.top, 1)
    }
    
    private func setupView() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
}

struct TrendingView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ForEach(Constants.typeSizes, id: \.self) { size in
                TrendingView()
                    .environment(\.dynamicTypeSize, size)
                    .previewDisplayName("\(size)")
            }
            TrendingView()
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("dark")
        }.previewLayout(.sizeThatFits)
    }
}
