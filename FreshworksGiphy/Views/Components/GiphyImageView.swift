//
//  GiphyImageView.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import SwiftUI
import SDWebImageSwiftUI
import UIKit

public protocol AnimitedView {
    func fetchView(index: Int) -> AnyView
}

struct GiphyImageView<T:AnimitedView>: View {

    var isSelected:Bool
    
    var index:Int = -1
    var animitedView: T?
    var actionBlock: ((_ isSelected:Bool) -> Void)?
    
    var body: some View {
        ZStack {
            self.makeView(index: self.index, view: self.animitedView!)
            VStack(alignment:.trailing) {
                HStack {
                    Spacer()
                    Button(action: {
                       // self.isSelected = !self.isSelected
                        actionBlock?(!self.isSelected)
                    }) {
                        HStack {
                            let image = self.isSelected ? ConstantImage.favorite : ConstantImage.unfavorite
                            Image(image)
                                .accessibilityIdentifier(Identifiers.favoriteButtonImageView)
                        }
                    }
                    .accessibilityIdentifier(Identifiers.favoriteButton)
                    .frame(width: 60, height: 60)
                    .padding(.top,-5)
                }
                Spacer()
            }.buttonStyle(PlainButtonStyle())
        }
    }
    
    func makeView<T:AnimitedView>(index:Int, view:T) -> AnyView {
        return view.fetchView(index: index)
        
    }
}

/*
struct GiphyImageView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            ForEach(Constants.typeSizes, id: \.self) { size in
                GiphyImageView(isSelected: false, index: 0, animitedView: TrendingViewModel(), actionBlock: nil)
                    .environment(\.dynamicTypeSize, size)
                    .previewDisplayName("\(size)")
            }
            GiphyImageView(isSelected: false, index: 0, animitedView: TrendingViewModel(), actionBlock: nil)
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("dark")
        }.previewLayout(.sizeThatFits)
    }
}*/
