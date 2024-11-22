//
//  Animation+ModalSpring.swift
//  T2iles
//
//  Created by Astemir Eleev on 19.05.2020.
//  Copyright © 2020 Astemir Eleev. All rights reserved.
//

import SwiftUI

public extension Animation {
    static var modalSpring: Animation {
        .spring(response: 0.5, dampingFraction: 0.777, blendDuration: 0)
    }

    static func modalSpring(duration: Double) -> Animation {
        .spring(response: 0.5, dampingFraction: 0.777, blendDuration: duration)
    }
}
