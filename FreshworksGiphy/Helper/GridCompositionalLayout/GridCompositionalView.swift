//
//  GridCompositionalView.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import SwiftUI

public struct GridCompositionalView: View, CompositionalGridLayout  {
    
    public var indexManager = IndexManager()
   
    public var incrementedContent: AnyView {
        guard indexManager.increment(cap: items) else  {
            return AnyView(EmptyView())
        }
        return AnyView(content(indexManager.index))
    }
    
    public let items: Int
    public let itemInsets: CGSize
    public let padding: (edgeInsets: Edge.Set, lenght: CGFloat)

    public var columns: [[GridItem]]
    public let content: (_ index: Int) -> AnyView
        
    public init(items: Int,
                itemInsets: CGSize = .init(width: 16, height: 16),
                padding: (edgeInsets: Edge.Set, lenght: CGFloat) = (.all, 16),
                columns: [[GridItem]],
                @ViewBuilder content: @escaping (_ index: Int) -> AnyView) {
        self.items = items
        self.itemInsets = itemInsets
        self.padding = padding
        self.columns = columns
        self.content = content
    }
    
    public var body: some View {
        ScrollView() {
            ForEach(0..<contentLenght(), id: \.self) { _ in
                ForEach(0..<columns.count, id:\.self) { row in
                    section(column: columns[row])
                }
            }
            .padding(padding.edgeInsets, padding.lenght)
        }
    }
    
    private func section(column: [GridItem]) -> some View {
        func items() -> some View {
            ForEach(0..<column.count, id:\.self) { index in
                incrementedContent
            }
        }
        return LazyVGrid(columns: column, spacing: itemInsets.height) {
            items()
        }
    }
}

