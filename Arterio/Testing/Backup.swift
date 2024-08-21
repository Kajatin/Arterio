//
//  Backup.swift
//  Arterio
//
//  Created by Roland Kajatin on 13/08/2024.
//

import SwiftUI

// systolic/diastolic
// heart rate?
// date
// position (sitting, lying, standing)
// arm (left right)
// time of day (morning, afternoon, evening, night)
// before or after specific activities (exercise, meal)
// general mood
// stress level (reported by user)
// tags + notes

struct BloodPressureHeader: View {
    let systolic: Int
    let diastolic: Int
    let namespace: Namespace.ID
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.green, .clear], startPoint: .top, endPoint: .bottom)
                .matchedGeometryEffect(id: "backgroundColor", in: namespace)
            //            Color.green
            
            VStack(alignment: .leading, spacing: 12) {
                // Systolic/diastolic values
                HStack(spacing: 60) {
                    VStack(alignment: .leading) {
                        Text("sys".uppercased())
                            .font(.system(size: 20, weight: .bold, design: .serif))
                            .foregroundStyle(.secondary)
                            .matchedGeometryEffect(id: "systolic", in: namespace)
                        Text("\(systolic)")
                            .font(.system(size: 60, weight: .black, design: .serif))
                            .matchedGeometryEffect(id: "systolicNumber", in: namespace)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("dia".uppercased())
                            .font(.system(size: 20, weight: .bold, design: .serif))
                            .foregroundStyle(.secondary)
                            .matchedGeometryEffect(id: "diastolic", in: namespace)
                        Text("\(diastolic)")
                            .font(.system(size: 60, weight: .black, design: .serif))
                            .matchedGeometryEffect(id: "diastolicNumber", in: namespace)
                    }
                }
                
                HStack {
                    // Time of day badge
                    Image(systemName: "moon.fill")
                        .padding(5)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 4))
                    
                    // Mood (1-10)
                    Image(systemName: "09.square.fill")
                        .padding(5)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 4))
                    
                    // Stress (1-10)
                    Image(systemName: "02.square.fill")
                        .padding(5)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 4))
                }
                .matchedGeometryEffect(id: "badges", in: namespace)
            }
        }
    }
}

struct BloodPressureHeaderSmall: View {
    let systolic: Int
    let diastolic: Int
    let namespace: Namespace.ID
    
    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(colors: [.green, .green], startPoint: .top, endPoint: .bottom)
                .matchedGeometryEffect(id: "backgroundColor", in: namespace)
            //            Color.green
            
            HStack(alignment: .center,spacing: 12) {
                // Systolic/diastolic values
                HStack(spacing: 12) {
                    VStack(alignment: .leading) {
                        //                        Text("sys".uppercased())
                        //                            .font(.system(size: 16, weight: .bold, design: .serif))
                        //                            .foregroundStyle(.secondary)
                        //                            .matchedGeometryEffect(id: "systolic", in: namespace)
                        Text("\(systolic)")
                            .font(.system(size: 60, weight: .black, design: .serif))
                            .matchedGeometryEffect(id: "systolicNumber", in: namespace)
                    }
                    
                    Text("/")
                        .font(.system(size: 32, weight: .bold, design: .serif))
                    
                    VStack(alignment: .leading) {
                        //                        Text("dia".uppercased())
                        //                            .font(.system(size: 16, weight: .bold, design: .serif))
                        //                            .foregroundStyle(.secondary)
                        //                            .matchedGeometryEffect(id: "diastolic", in: namespace)
                        Text("\(diastolic)")
                            .font(.system(size: 60, weight: .black, design: .serif))
                            .matchedGeometryEffect(id: "diastolicNumber", in: namespace)
                    }
                }
                
                Spacer()
                
                HStack {
                    // Time of day badge
                    Image(systemName: "moon.fill")
                        .padding(5)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 4))
                    
                    // Mood (1-10)
                    Image(systemName: "09.square.fill")
                        .padding(5)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 4))
                    
                    // Stress (1-10)
                    Image(systemName: "02.square.fill")
                        .padding(5)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 4))
                }
                .matchedGeometryEffect(id: "badges", in: namespace)
            }
            .padding(.horizontal)
        }
    }
}

struct Backup: View {
    @Namespace var headerWithMatchedGeometry
    @State private var isSmall = false
    
    var body2: some View {
        GeometryReader { proxy in
            ResizableHeaderView(size: proxy.size, safeArea: proxy.safeAreaInsets)
                .ignoresSafeArea(.all, edges: .top)
        }
    }
    
    var body: some View {
        ScrollView {
            if isSmall {
                BloodPressureHeaderSmall(systolic: 126, diastolic: 82, namespace: headerWithMatchedGeometry)
                    .frame(height: 150)
                    .ignoresSafeArea()
            } else {
                BloodPressureHeader(systolic: 126, diastolic: 82, namespace: headerWithMatchedGeometry)
                    .frame(height: 400)
                    .ignoresSafeArea()
            }
            
            Button {
                withAnimation {
                    isSmall.toggle()
                }
            } label: {
                Text("Toggle")
            }
            
            HStack {
                Image(systemName: "sun.horizon.fill")
                Image(systemName: "sun.max.fill")
                Image(systemName: "moon.fill")
                Image(systemName: "moon.stars.fill")
            }
            
            Spacer()
            
            VStack {
                Text("systolic")
                Text("diastolic")
                Text("sitting")
                Text("left")
                Text("morning")
                Text("after exercise")
                Text("mood good")
                Text("stress 3/10")
                Text("tags")
                Text("notes")
            }
        }
    }
}

#Preview {
    Backup()
}
