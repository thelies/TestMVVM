//
//  Word.swift
//  TestMVVM
//
//  Created by Le Ngoc HOAN on 6/9/17.
//  Copyright © 2017 Le Ngoc HOAN. All rights reserved.
//

import Foundation
import RxRealm
import RealmSwift
import RxDataSources

class Word: Object {
    dynamic var id: Int = 0
    dynamic var title: String = ""
    dynamic var isLiked: Bool = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension Word: IdentifiableType {
    var identity: Int {
        return self.isInvalidated ? 0 : id
    }
}
