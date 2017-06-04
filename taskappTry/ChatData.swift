//
//  ChatData.swift
//  taskappTry
//
//  Created by 田村崚 on 2017/06/03.
//  Copyright © 2017年 ryo.tamura. All rights reserved.
//

import RealmSwift

class CategoryData: Object {
    dynamic var categoryName = ""
    dynamic var date = NSDate()
}

class ChatData: Object {
    dynamic var message = ""
    dynamic var category = ""
    dynamic var date = NSDate()
    dynamic var senderId = "me"
    dynamic var senderDisplayName = "M"
}

class SetData: Object {
    dynamic var message = ""
    dynamic var category = ""
    dynamic var sendDate = NSDate()
}


