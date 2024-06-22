//
//  TopBarPill.swift
//  Leitmotif
//
//  Created by William Martin on 6/15/24.
//

import SwiftUI

struct TopBarPill: View {
    @EnvironmentObject private var topBarStateController: TopBarStateController
    @Environment(\.colorScheme) private var colorScheme
    @Binding var pillState: TopBarPillState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                switch topBarStateController.state {
                case .inactive:
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 20, weight: .medium))
                case .indeterminate:
                    ProgressView()
                case .unavailable:
                    Image(systemName: "exclamationmark.circle")
                        .font(.system(size: 20, weight: .medium))
                default:
                    CircularProgressView(progress: $topBarStateController.uploadProgress)
                }
                
                VStack(alignment: .leading) {
                    Text("Leitmotif")
                        .font(Font.custom("UrbanistRoman-SemiBold", size: 19, relativeTo: .title))
                    Text(topBarStateController.statusText)
                        .font(Font.custom("UrbanistRoman-Medium", size: 13, relativeTo: .caption))
                        .opacity(0.3)
                }
                Spacer()
            }
            if pillState == .expanded {
                TopBarPillOptions()
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : .white)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 36, height: 36)))
        .overlay(
            RoundedRectangle(cornerSize: CGSize(width: 36, height: 36))
                .stroke(colorScheme == .dark ? .clear : Color(red: 0.91, green: 0.91, blue: 0.91), lineWidth: 0.6)
        )
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 5)
    }
}

#Preview {
    TopBarPill(pillState: .constant(.standard))
        .environmentObject(TopBarStateController.previewObject(position: 0))
        .environmentObject(ConfigurationStateController(networkMode: .automatic))
}
