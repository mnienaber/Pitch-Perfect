//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Michael Nienaber on 29/10/2015.
//  Copyright © 2015 Michael Nienaber. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}