//
//  TopBarFakePill.swift
//  Leitmotif
//
//  Created by William Martin on 6/15/24.
//

import SwiftUI

struct TopBarFakePill: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 16) {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 20, weight: .medium))
                VStack(alignment: .leading) {
                    Text("Text")
                        .font(Font.system(size: 19))
                    Text("Text")
                        .font(Font.system(size: 13))
                }
                Spacer()
            }
        }
        .padding(.vertical, 12)
        .opacity(opacity)
    }
    
    var opacity: Double {
        #if targetEnvironment(simulator)
            return 1
        #else
            return 0
        #endif
    }
}

#Preview {
    TopBarFakePill()
}
