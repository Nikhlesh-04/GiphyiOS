//
//  IndexManager.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import SwiftUI

public final class IndexManager: ObservableObject {
    
    // MARK: - Properties
    
    public private(set) var index: Int = -1
    
    // MARK: - Methods
    
    public func increment(cap: Int) -> Bool {
        guard index < cap - 1 else { return false }
        index += 1
        return true
    }
    
    public func resetView() {
        self.index = -1
    }
}
