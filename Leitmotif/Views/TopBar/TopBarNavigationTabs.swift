//
//  TopBarNavigationTabs.swift
//  Leitmotif
//
//  Created by William Martin on 6/15/24.
//

import SwiftUI

struct TopBarNavigationTabs: View {
    @EnvironmentObject private var topBarStateController: TopBarStateController
    @Environment(\.colorScheme) private var colorScheme
    @Binding var isImageOverlayed: Bool
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 32) {
                ForEach(0..<tabNames.count, id: \.self) { i in
                    Button(action: {
                        withAnimation {
                            topBarStateController.selectedButton = i
                        }
                    }) {
                        Text(tabNames[i])
                            .foregroundStyle(Color(UIColor.label))
                    }
                        .font(Font.custom("UrbanistRoman-SemiBold", size: 16, relativeTo: .body))
                }
            }
            
            Rectangle()
                .frame(width: lineSize[topBarStateController.selectedButton], height: 2)
                .offset(x: linePos[topBarStateController.selectedButton]) // Twitter: 130,
                .padding(.top, 2)
                .animation(.easeInOut(duration: 0.3), value: topBarStateController.selectedButton)

        }
        .padding(.horizontal, 36)
        .padding(.top, 14)
        .background(isImageOverlayed ? Color(colorScheme == .dark ? UIColor.secondarySystemBackground : .white) : .clear)
        .clipShape(Capsule())
        .shadow(color: isImageOverlayed ? .black.opacity(0.1) : .clear, radius: 6, x: 0, y: 5)
    }
}

#Preview {
    TopBarNavigationTabs(isImageOverlayed: .constant(false))
        .environmentObject(TopBarStateController.previewObject(position: 0))
}
