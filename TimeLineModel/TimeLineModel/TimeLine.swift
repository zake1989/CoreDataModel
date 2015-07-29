//
//  TimeLine.swift
//  TimeLineModel
//
//  Created by Stephen on 7/29/15.
//  Copyright (c) 2015 Zake. All rights reserved.
//

import Foundation
import CoreData

class TimeLine: NSManagedObject {

    @NSManaged var content: String
    @NSManaged var image: String
    @NSManaged var linkURL: String
    @NSManaged var time: NSDate
    @NSManaged var comment: NSSet
    @NSManaged var person: Person
    @NSManaged var personLiked: NSSet
    @NSManaged var shared: NSSet

}

extension TimeLine {
    
    //function remove the comment
    func removeCreatedComment(comment : Comment) {
        //make the set to mutable
        var comments = self.mutableSetValueForKey("comment")
        comments.removeObject(comment)
    }
    
}
