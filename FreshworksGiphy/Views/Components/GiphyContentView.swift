//
//  GiphyContentView.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import SwiftUI

struct GiphyContentView: View {
    
    private let colors: [Color] = [.red, .green, .yellow, .blue]
    
    @Binding var gridType:ListType
    @ObservedObject var model:FavoriteViewModel
    
    var body: some View {
        VStack {
            gridCompositionalViewFactory(columns: gridType.columns)
            if model.favoriteCount == 0 {
                VStack {
                    Text(ConstantsMessages.noFavourites)
                        .bold()
                        .multilineTextAlignment(.center)
                        .font(.footnote)
                        .foregroundColor(Color(.systemGray))
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Helper Private Methods
    private func gridCompositionalViewFactory(columns: [[GridItem]]) -> some View {
        GridCompositionalView(items: model.favoriteCount,
                              columns: columns) { (index) -> AnyView in
            gridCellView(for: index)
        }
    }
    
    private func gridCellView(for index: Int) -> AnyView {
        if let fav = self.model.getFavorite(index: index) {
            return AnyView(
                GiphyImageView(isSelected: fav.isFavorate, index: index, animitedView: self.model) {isSelected in
                    self.model.favorate(index: index, isFavorate: isSelected)
                }
                .accessibilityIdentifier(Identifiers.cellImageView)
                .background(colors[index % colors.count])
                .cornerRadius(2)
            )
        }
        return AnyView(EmptyView())
    }
}

struct GiphyContentView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            ForEach(Constants.typeSizes, id: \.self) { size in
                GiphyContentView(gridType: .constant(.grid), model: FavoriteViewModel())
            }
            GiphyContentView(gridType: .constant(.grid), model: FavoriteViewModel())
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("dark")
        }.previewLayout(.sizeThatFits)
    }
}
