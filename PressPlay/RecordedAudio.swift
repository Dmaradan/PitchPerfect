//
//  RecordedAudio.swift
//  PressPlay
//
//  Created by Diego Martin on 9/29/15.
//  Copyright © 2015 Diego Martin. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePath: NSURL!
    var title: String!
    
    init(url: NSURL, name: String)
    {
        filePath = url
        title = name
    }
}
