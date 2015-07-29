//
//  Comment.swift
//  TimeLineModel
//
//  Created by Stephen on 7/29/15.
//  Copyright (c) 2015 Zake. All rights reserved.
//

import Foundation
import CoreData

class Comment: NSManagedObject {

    @NSManaged var content: String
    @NSManaged var time: NSDate
    @NSManaged var personComment: Person
    @NSManaged var timeLineCommented: TimeLine

}
