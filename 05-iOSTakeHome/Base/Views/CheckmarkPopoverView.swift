//
//  CheckmarkPopoverView.swift
//  05-iOSTakeHome
//
//  Created by kopresh desai on 22/09/25.
//

import SwiftUI

struct CheckmarkPopoverView: View {
    var body: some View {
        Symbols.checkmark
            .font(.system(.largeTitle, design: .rounded).bold())
            .padding()
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10,
                                                            style: .continuous))
    }
}

#Preview {
    CheckmarkPopoverView()
        .previewLayout(.sizeThatFits)
        .padding()
        .background(.blue)
}
