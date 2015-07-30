//
//  TimeLineViewController.swift
//  TimeLineModel
//
//  Created by Stephen on 7/29/15.
//  Copyright (c) 2015 Zake. All rights reserved.
//

import UIKit

class TimeLineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var manager : CoreDataManager!
    var timeLines : NSArray!
    var person : Person!
    var selectedPost : TimeLine!
    
    @IBOutlet weak var timeLineTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        manager = CoreDataManager()
        manager.testModel = false

        timeLines = manager.fetchTimeLine(nil)
        
        self.timeLineTable.dataSource = self
        self.timeLineTable.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


//    MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if  segue.identifier == "showComments" {
            let controller = segue.destinationViewController as! CommentsViewController
            controller.timeLine = selectedPost
        }
    }
    

}

extension TimeLineViewController {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeLines.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : TimeLineCell = tableView.dequeueReusableCellWithIdentifier("timeLineCell") as! TimeLineCell
        let timeLinePost = timeLines[indexPath.row] as! TimeLine
        cell.name.text = timeLinePost.person.name
        cell.content.text = timeLinePost.content
        cell.timeLineImage.image = UIImage(named: timeLinePost.image)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedPost = timeLines[indexPath.row] as! TimeLine
        self.performSegueWithIdentifier("showComments", sender: self)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let timeLine = timeLines[indexPath.row] as! TimeLine
            let person = timeLine.person
            manager.deleteTimeLine(timeLine, ForPerson: person)
            
            timeLines = manager.fetchTimeLine(nil)
            timeLineTable.reloadData()
        }
    }
    
    @IBAction func showMyTimeLine(sender: AnyObject) {
        timeLines = manager.fetchTimeLine(NSPredicate(format: "person == %@", person))
        timeLineTable.reloadData()
    }
}
