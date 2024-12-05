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
                .opacity(0.06)
            LinearGradient(gradient: Gradient(colors: [.white, .white]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                .aspectRatio(contentMode: .fit)
//            HStack{
                Text("B")
                .foregroundColor(.black)
                    .font(.system(size: 240))
//                Text("x")
//                    .foregroundColor(.white)
//                    .font(.system(size: 120))
//                    .offset(y: -12)
                Text("n")
                .foregroundColor(.black)
                    .font(.system(size: 120))
                    .offset(x: 90, y: -110)
//            }
        }
    }
}

#Preview {
    Temp()
}