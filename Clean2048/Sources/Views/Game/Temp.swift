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
            Text("2048")
                .foregroundColor(.white)
                .font(.system(size: 150))
        }
    }
}

#Preview {
    Temp()
}
