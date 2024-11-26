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
            HStack{
                Text("B")
                    .foregroundColor(.white)
                    .font(.system(size: 150))
                Text("x")
                    .foregroundColor(.white)
                    .font(.system(size: 120))
                    .offset(y: -12)
                Text("N")
                    .foregroundColor(.white)
                    .font(.system(size: 150))
            }
        }
    }
}

#Preview {
    Temp()
}
