//
//  Favorite.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.

import SwiftUI

struct FavoriteView: View {
    
    @State private var listType:ListType = .grid
    @State private var selectedSegment = 0
    
    @ObservedObject private var model = FavoriteViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("ListType", selection: $selectedSegment) {
                    ForEach(0..<ListType.allCases.count, id: \.self) { index in
                        Text(ListType.allCases[index].name).tag(index)
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedSegment) { newValue in
                    if selectedSegment < ListType.allCases.count, let grid = ListType(rawValue: selectedSegment) {
                        self.listType = grid
                    }
                }
                GiphyContentView(gridType: $listType, model: model)
            }
            .navigationTitle(ConstantsMessages.navigationFavoriteTitle)
            .toolbar {
                LogoutButton()
            }
            .onAppear {
                self.selectedSegment = 0
                self.model.refreshView()
            }
        }
    }
}

struct Favorite_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ForEach(Constants.typeSizes, id: \.self) { size in
                FavoriteView()
                    .environment(\.dynamicTypeSize, size)
                    .previewDisplayName("\(size)")
            }
            FavoriteView()
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("dark")
        }.previewLayout(.sizeThatFits)
    }
}
