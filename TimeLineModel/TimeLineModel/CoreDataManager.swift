//
//  CoreDataManager.swift
//  TimeLineModel
//
//  Created by Stephen on 7/29/15.
//  Copyright (c) 2015 Zake. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
   
    var managedContext: NSManagedObjectContext!
    var testModel : Bool!
    
    override init() {
        //create the managed object context object which mapping the entire database
        managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        testModel = false
    }
    
    //common method use for save any changes on data base
    func saveManagedObjectContent() {
        //error for database operation fail
        var error: NSError?
        //save the context with the error display
        if !managedContext.save(&error) {
            if testModel == true {
                println("database opration fail \(error), \(error?.userInfo)")
            }
        } else {
            if testModel == true {
                println("database operation success")
            }
        }
    }
}

//all person operation
extension CoreDataManager {
    //create a new person object
    func createNewPerson() -> Person {
        //create a new managed object as person and insert it into managed object context
        let person = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: managedContext) as! Person
        return person
    }
    
    func deletePerson(person: Person) {
        //delete one person
        managedContext.deleteObject(person)
        saveManagedObjectContent()
    }
    
    func fetchPerson(predicate: NSPredicate?) -> [Person] {
        //create a fetch request
        let fetchRequest = NSFetchRequest(entityName:"Person")
        //set query for fetch request
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        
        var error: NSError?//error for fetch request
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [Person]
        //check the fetch result
        if let results = fetchedResults {
            //do something when fetch success
            if testModel == true {
                for person in results {
                    println(person.name + " " + person.avatar)
                    println("_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ ")
                }
            }
            return fetchedResults!
        } else {
            //fetch fail return an empty array and print the error
            println("Could not fetch \(error), \(error!.userInfo)")
            return [Person]()
        }
    }
    
    //update example based on logic it may be changed, so this is the only update method here
    func updateUserName(person : Person, name: String) {
        person.name = name
        saveManagedObjectContent()
    }
    
    //one person like a time line
    func person(person : Person, LikeTimeLinePost timeLine :TimeLine) {
        //here is one many to many relation. to handle any opration in this kind of relation, manipulate either side of nsset works
        person.likeTimeLine(timeLine)
        saveManagedObjectContent()
    }
    
    //one person unlike a time line
    func person(person : Person, UnlikeTimeLinePost timeLine : TimeLine) {
        person.removeLikedTimeLine(timeLine)
        saveManagedObjectContent()
    }
    
    //one person share a time line
    func person(person : Person, ShareTimeLine timeLine : TimeLine) {
        person.shareTimeLine(timeLine)
        saveManagedObjectContent()
    }
    
    //one person remvoe the share (not gonnar use in our logic)
    func person(person : Person, RemoveShareTimeLine timeLine : TimeLine) {
        person.removeTimeLine(timeLine)
        saveManagedObjectContent()
    }
    
}

// all time line operation
extension CoreDataManager {
    //create a new time line object
    func createNewTimeLine() -> TimeLine {
        let timeLine = NSEntityDescription.insertNewObjectForEntityForName("TimeLine", inManagedObjectContext: managedContext) as! TimeLine
        return timeLine
    }
    
    func fetchTimeLine(predicate: NSPredicate?) -> [TimeLine] {
        let fetchRequest = NSFetchRequest(entityName:"TimeLine")
        
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        
//        let predicate = NSPredicate(format: "person == %@", person)
        
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [TimeLine]
        
        if let results = fetchedResults {
            if testModel == true {
                for timeLine in results {
                    println(timeLine.comment.count)
                    println("__________________________________")
                }
            }
            return fetchedResults!
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
            return [TimeLine]()
        }
    }
    
    func deleteTimeLine(timeLine: TimeLine, ForPerson person: Person) {
        //delete time line
        //to handle the one to many relation here. we need to delete both side object here
        //here the many side is on person so remove the time line object at person's nsset then the time line object can be removed
        person.removeCreatedTimeLine(timeLine)
        for comment in timeLine.comment.allObjects as! [Comment] {
            comment.personComment.removeCreatedComment(comment)
            timeLine.removeCreatedComment(comment)
            managedContext.deleteObject(comment)
        }
        managedContext.deleteObject(timeLine)
        saveManagedObjectContent()
    }
    
}

// all comments operation
extension CoreDataManager {
    //create a new comment object
    func createNewComment(ByPerson person: Person, ForTimeLine timeLine: TimeLine) -> Comment {
        let comment = NSEntityDescription.insertNewObjectForEntityForName("Comment", inManagedObjectContext: managedContext) as! Comment
        comment.personComment = person
        comment.timeLineCommented = timeLine
        return comment
    }

    // normal fetch in comment
    func fetchComment(predicate : NSPredicate?) -> [Comment] {
        let fetchRequest = NSFetchRequest(entityName:"Comment")
        
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [Comment]
        
        if let results = fetchedResults {
            if testModel == true {
                for comment in results {
                    println("comment by " + comment.personComment.name)
                    println("__________________________________")
                }
            }
            return fetchedResults!
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
            return [Comment]()
        }
    }
    
    //fetch comments by person
    func fetchCommentsByPerson(person : Person) -> [Comment] {
        let predicate = NSPredicate(format: "personComment == %@", person)
        return fetchComment(predicate)
    }
    
    //fetch comments by time line
    func fetchCommentsByTimeLine(timeLine : TimeLine) -> [Comment] {
        let predicate = NSPredicate(format: "timeLineCommented == %@", timeLine)
        return fetchComment(predicate)
    }
    
    //fetch comments by person and time line
    func fetchCommentsBy(person : Person, timeLine: TimeLine) -> [Comment] {
        let predicate = NSPredicate(format: "(personComment == %@) AND (timeLineCommented == %@)", person, timeLine)
        return fetchComment(predicate)
    }

    func deleteComment(comment: Comment, PostBy person : Person, ForTimeLine timeLine : TimeLine) {
        //to delete an comment all relation must be deleted which means both one to many relation in person and time line should be manipulated
        person.removeCreatedComment(comment) //delete the comment in preson
        timeLine.removeCreatedComment(comment) //delete the comment in time line
        managedContext.deleteObject(comment) //delete the comment object
        saveManagedObjectContent()
    }
}

