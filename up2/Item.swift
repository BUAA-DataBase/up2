//
//  Item.swift
//  up2
//
//  Created by 周子皓 on 2024/9/27.
//

import Foundation
import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
