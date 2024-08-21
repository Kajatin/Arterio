//
//  ExpandHeader.swift
//  Arterio
//
//  Created by Roland Kajatin on 11/08/2024.
//

import SwiftUI

import SwiftUI

struct ExpandHeader: View {
    @Namespace private var namespace
    @State private var scrollOffset: CGFloat = 0
    @State private var isTransitioned = false
    
    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                VStack(spacing: 20) {
                    ForEach(0..<20) { index in
                        if index == 0 {
                            Text("Header")
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(isTransitioned ? Color.blue : Color.red)
                                .matchedGeometryEffect(id: "header", in: namespace)
                        } else {
                            Text("Item \(index)")
                                .frame(height: 50)
                        }
                    }
                }
                .background(GeometryReader { geometry in
                    Color.clear.preference(key: ScrollOffsetPreferenceKey.self,
                                           value: geometry.frame(in: .named("scroll")).origin.y)
                })
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = value
                    isTransitioned = scrollOffset < -50
                }
            }
        }
        .coordinateSpace(name: "scroll")
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

#Preview {
    ExpandHeader()
}
