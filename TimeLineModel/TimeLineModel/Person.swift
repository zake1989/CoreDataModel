//
//  Person.swift
//  TimeLineModel
//
//  Created by Stephen on 7/29/15.
//  Copyright (c) 2015 Zake. All rights reserved.
//

import Foundation
import CoreData

class Person: NSManagedObject {

    @NSManaged var avatar: String
    @NSManaged var name: String
    @NSManaged var comment: NSSet
    @NSManaged var likedTimeLine: NSSet
    @NSManaged var shared: NSSet
    @NSManaged var timeLine: NSSet

}

//add some required function
extension Person {
    
    //function remove a time line 
    func removeCreatedTimeLine(timeLine : TimeLine) {
        //make the set to mutable
        var liked = self.mutableSetValueForKey("timeLine");
        liked.removeObject(timeLine)
    }
    
    //function remove the comment 
    func removeCreatedComment(comment : Comment) {
        //make the set to mutable
        var comments = self.mutableSetValueForKey("comment")
        comments.removeObject(comment)
    }
    
    //function set up many to many relation between person and timeline when person like a timeline post
    func likeTimeLine(timeLine : TimeLine) {
        //make the set to mutable
        var liked = self.mutableSetValueForKey("likedTimeLine");
        liked.addObject(timeLine)
    }
    
    //function to remove a many to many relation between person and timeline when person unlike a timeline post
    func removeLikedTimeLine(timeLine : TimeLine) {
        var liked = self.mutableSetValueForKey("likedTimeLine");
        liked.removeObject(timeLine)
    }
    
    //function set up many to many relation between person and timeline when person share a timeline post
    func shareTimeLine(timeLine : TimeLine) {
        var timeLineShared = self.mutableSetValueForKey("shared")
        timeLineShared.addObject(timeLine)
    }
    
    //function remove the share relation, this may not be used in our case
    func removeTimeLine(timeLine : TimeLine) {
        var timeLineShared = self.mutableSetValueForKey("shared")
        timeLineShared.removeObject(timeLine)
    }
    
}