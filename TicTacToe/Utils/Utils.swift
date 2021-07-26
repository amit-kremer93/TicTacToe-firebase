//
//  Utils.swift
//  TicTacToe
//
//  Created by Amit Kremer on 11/07/2021.
//

import Foundation
struct Utils {
    static func MessagesArrayForFireBase(msgArr: [Message]) -> [Dictionary<String, String>]{
        var arr = [Dictionary<String, String>]()
        for msgObj in msgArr {
            let dic = msgObj.toString()
            arr.append(dic)
        }
        return arr
    }
}
