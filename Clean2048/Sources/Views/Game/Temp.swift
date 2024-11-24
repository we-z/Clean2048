//
//  Temp.swift
//  Clean2048
//
//  Created by Wheezy Capowdis on 11/22/24.
//

import SwiftUI

struct Temp: View {
    var body: some View {
        ZStack {
            Color.black
//                .opacity(0.95)
            Text("2048\nBLK")
//                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .font(.system(size: 120))
        }
    }
}

#Preview {
    Temp()
}
