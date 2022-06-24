//
//  CompositionalGridLayout.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import SwiftUI

public protocol CompositionalGridLayout {
    
    // MARK: - Properties
    
    var items: Int { get }
    var indexManager: IndexManager { get }
    var columns: [[GridItem]] { get }
    var incrementedContent: AnyView { get }
    
    // MARK: - Methods
    
    func contentLenght() -> Int
}

public extension CompositionalGridLayout {
    func contentLenght() -> Int {
        let lenght = columns
            .compactMap { $0.count }
            .reduce(0) { $0 + $1 }
        return (items / lenght) + (items % lenght > 0 ? 1 : 0)
    }
}

