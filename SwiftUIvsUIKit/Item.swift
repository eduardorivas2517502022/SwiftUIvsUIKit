//
//  Item.swift
//  SwiftUIvsUIKit
//
//  Created by user on 11/4/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
