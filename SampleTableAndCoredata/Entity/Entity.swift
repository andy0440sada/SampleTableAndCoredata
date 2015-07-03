//
//  Entity.swift
//  SampleTableAndCoredata
//
//  Created by 安東貞義 on 2015/07/04.
//  Copyright (c) 2015年 Andy Show. All rights reserved.
//

import Foundation
import CoreData

@objc(Entity)
class Entity: NSManagedObject {

    @NSManaged var text: String

}
