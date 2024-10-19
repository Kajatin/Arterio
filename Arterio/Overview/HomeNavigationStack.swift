//
//  HomeNavigationStack.swift
//  Arterio
//
//  Created by Roland Kajatin on 31/08/2024.
//

import SwiftUI

struct HomeNavigationStack: View {
    @State private var path: [BPRecord] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            Overview(navigationPath: $path)
        }
    }
}

#Preview {
    HomeNavigationStack()
}
