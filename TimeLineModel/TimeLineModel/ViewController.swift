//
//  ViewController.swift
//  TimeLineModel
//
//  Created by Stephen on 7/29/15.
//  Copyright (c) 2015 Zake. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var manager : CoreDataManager!

    @IBOutlet weak var personTable: UITableView!

    var personList : NSArray!
    var currentPerson : Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manager = CoreDataManager()
        manager.testModel = false
        
        if (manager.fetchPerson(nil).count > 0) {
            personList = manager.fetchPerson(nil)
        } else {
            createListOfPerson()
            createListOfTimeLine()
            createComments()
            personList = manager.fetchPerson(nil)
        }
        
        personTable.dataSource = self
        personTable.delegate = self
        
//        createListOfPerson()
//        createListOfTimeLine()
//        createComments()
        
//        let person = manager.fetchPerson(NSPredicate(format: "name == %@", "sheep")).first!
//      manager.deletePerson(person)
        
//        let snake = manager.fetchPerson(NSPredicate(format: "name == %@", "snake")).first
//        let timeLine = manager.fetchTimeLine(nil).first
        
//        let comment = manager.fetchCommentsBy(snake!, timeLine: timeLine!).first
//        
//        manager.deleteComment(comment!, PostBy: snake!, ForTimeLine: timeLine!)
        
//        manager.fetchCommentsByPerson(snake!)
//        println("~~~~~~~~~~~~~~~~~~~~~~~")
//        manager.fetchCommentsByTimeLine(timeLine!)
        
//        manager.person(person!, UnlikeTimeLinePost: timeLine!)
        
//        manager.deleteTimeLine(timeLine!, ForPerson: person!)
        
//        person!.removeCreatedTimeLine(timeLine!)
//        manager.saveManagedObjectContent()
////        manager.deleteTimeLine(timeLine)
//        manager.deletePerson(person)
        
//        let comment = manager.createNewComment(ByPerson: person!, ForTimeLine: timeLine!)
//        comment.content = "this is a comment"
//        comment.time = NSDate()
//        manager.saveManagedObjectContent()
        
        
    }
    
    func createListOfPerson() {
        let personList = ["snake","sheep","pig","dragon","cattle","bunny"]
        
        for name in personList as [String]{
            let person = manager.createNewPerson()
            person.name = name
            person.avatar = name
            manager.saveManagedObjectContent()
        }
    }
    
    func createListOfTimeLine() {
        let timeLines = ["snake":"hunter","sheep":"lara","pig":"vayne","dragon":"hunter","cattle":"lara","bunny":"vayne"]
        let keys = timeLines.keys
        for name in keys {
            let predicate = NSPredicate(format: "name == %@", name)
            let person = manager.fetchPerson(predicate).first!
            
            let timeLine = manager.createNewTimeLine()
            timeLine.person = person
            timeLine.image = timeLines[name]!
            timeLine.content = "this is the content we have"
            timeLine.linkURL = "the link use to show"
            timeLine.time = NSDate()
            manager.saveManagedObjectContent()
        }
    }
    
    func createComments() {
        let timeLines = manager.fetchTimeLine(nil)
        let person = manager.fetchPerson(NSPredicate(format: "name == %@", "snake")).first
        for timeLine in timeLines {
            let comment = manager.createNewComment(ByPerson: person!, ForTimeLine: timeLine)
            comment.content = "this is a comment"
            comment.time = NSDate()
            manager.saveManagedObjectContent()
        }
        
        let personList = ["dragon","cattle","bunny"]
        let tl = manager.fetchTimeLine(nil).first
        for name in personList {
            let p = manager.fetchPerson(NSPredicate(format: "name == %@", name)).first
            let comment = manager.createNewComment(ByPerson: p!, ForTimeLine: tl!)
            comment.content = "this is a comment"
            comment.time = NSDate()
            manager.saveManagedObjectContent()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addNewPerson(sender: AnyObject) {
        let person = manager.createNewPerson()
        person.name = "new person"
        person.avatar = "default"
        manager.saveManagedObjectContent()
        
        personList = manager.fetchPerson(nil)
        personTable.reloadData()
    }
}

extension ViewController {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personList.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        let person = personList[indexPath.row] as! Person
        cell.textLabel?.text = person.name
        cell.imageView?.image = UIImage(named: person.avatar)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentPerson = personList[indexPath.row] as! Person
        self.performSegueWithIdentifier("showPersonTimeLine", sender: self)
    }

}

extension ViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if  segue.identifier == "showPersonTimeLine" {
            let controller = segue.destinationViewController as! TimeLineViewController
            controller.person = currentPerson
        }
    }
}


