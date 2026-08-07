//
//  Animation+Custom.swift
//  Bloom
//
//  Created by Аскольд on 19.06.2026.
//

import SwiftUI

extension Animation {
    static var quickSpring: Animation {
        .smooth(duration: 0.2)
    }
    
    static var normalSpring: Animation {
        .smooth(duration: 0.27)
    }
    
    static var slowSpring: Animation {
        .smooth(duration: 0.6)
    }
    
    static var springy: Animation {
        .bouncy(duration: 0.25, extraBounce: 0.2)
    }
    
}
