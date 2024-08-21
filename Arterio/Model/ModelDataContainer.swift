//
//  ModelDataContainer.swift
//  Arterio
//
//  Created by Roland Kajatin on 16/08/2024.
//

import SwiftUI

struct ModelDataContainerViewModifier: ViewModifier {
    let manager: ModelContainerManager
    
    init(inMemory: Bool) {
        if inMemory {
            manager = ModelContainerManager.sharedInMemory
        } else {
            manager = ModelContainerManager.shared
        }
    }
    
    func body(content: Content) -> some View {
        content
            .modelContainer(manager.container)
    }
}

public extension View {
    func modelDataContainer(inMemory: Bool = false) -> some View {
        modifier(ModelDataContainerViewModifier(inMemory: inMemory))
    }
}
