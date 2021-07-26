//
//  Message.swift
//  ChatSample
//
//  Created by Hafiz on 20/09/2019.
//  Copyright © 2019 Nibs. All rights reserved.
//

import Foundation

enum MessageSide {
    case left
    case right
}

struct Message: Equatable {
    var text = ""
    var side: MessageSide = .right
    
    init(message: Any, side: Any) {
        self.text = message as! String
        if side as! String == "right" {
            self.side = .right
        } else {
            self.side = .left
        }
    }
    
    init(message: String, side: MessageSide) {
        self.text = message
        self.side = side
    }
    
    static func ==(lhs:Message, rhs:Message) -> Bool {
        return lhs.text == rhs.text && lhs.side == rhs.side
    }

    func toString() -> Dictionary<String, String> {
        var dic: [String: String] = [:]
        dic["message"] = self.text
        if (self.side == .right) {
            dic["side"] = "right"
        } else {
            dic["side"] = "left"
        }
        return dic
    }
}
