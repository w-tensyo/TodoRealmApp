//
//  Person.swift
//  TodoRealmApp
//
//  Created by 渡邉天彰 on 2020/06/11.
//  Copyright © 2020 takaaki watanabe. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    @objc dynamic var title = ""
    @objc dynamic var todoDetail = ""
    @objc dynamic var checked:Bool = false
    
}
