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
            Color.white
                .aspectRatio(contentMode: .fit)
//                .cornerRadius(90)
            Text("6")
                .foregroundColor(.black)
                .font(.system(size: 360))
//            Text("0")
//                .foregroundColor(.white)
//                .font(.system(size: 150))
//                .offset(x: 120, y: -100)
        }
    }
}

#Preview {
    Temp()
}
