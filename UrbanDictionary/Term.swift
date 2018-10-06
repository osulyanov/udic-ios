//
//  Term.swift
//  UrbanDictionary
//
//  Created by Oleg Sulyanov on 06/10/2018.
//  Copyright © 2018 Oleg Sulyanov. All rights reserved.
//

import Foundation

struct Term: Codable {
    let defid: Int64
    let word: String
    let definition: String
    let example: String
    
//    let thumbsUp: Int64
//    let thumbsDown: Int64
//    let currentVote: Bool
//    let soundUrls: Array<String>
//    let author: String
//    let writtenOn: Date
}
