//
//  CommentsViewController.swift
//  TimeLineModel
//
//  Created by Stephen on 7/29/15.
//  Copyright (c) 2015 Zake. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var timeLine : TimeLine!
    var manager : CoreDataManager!
    var comments : NSArray!
    
    @IBOutlet weak var commentsTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        manager = CoreDataManager()
        comments = manager.fetchCommentsByTimeLine(timeLine)
        commentsTable.dataSource = self
        commentsTable.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CommentsViewController {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell") as! UITableViewCell
        let comment = comments[indexPath.row] as! Comment
        cell.imageView?.image = UIImage(named: comment.personComment.avatar)
        cell.textLabel?.text = comment.content
        return cell
    }
}
