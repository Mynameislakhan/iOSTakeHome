//
//  PillView.swift
//  05-iOSTakeHome
//
//  Created by kopresh desai on 18/09/25.
//

import SwiftUI

struct PillView: View {
    
    let id: Int
    
    var body: some View {
        
        Text("#\(id)")
            .font(
                .system(.caption, design: .rounded)
                .bold()
            )
            .foregroundColor(.white)
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(Theme.pill, in: Capsule())
    }
}



#Preview(traits: .fixedLayout(width: 375, height: 600)) {
    PillView(id: 0)
}
