//
//  MasterViewController.swift
//  flyday
//
//  Created by javaing63 on 2015/6/5.
//  Copyright (c) 2015年 javaing63. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    //var objects = [AnyObject]()
    var items = [String]()
    var itemsLink = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    func post(url: String, info: String, completionHandler: (responseString: NSString!, error: NSError!) -> ()) {
        let URL: NSURL = NSURL(string: url)!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "POST";
        var bodyData = info;
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()){
            
            response, data, error in
            
            var output: NSString!
            
            if data != nil {
                output = NSString(data: data!, encoding: NSUTF8StringEncoding)
            }
            
            completionHandler(responseString: output, error: error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        //self.navigationItem.rightBarButtonItem = addButton
        
        self.navigationItem.title = "佛學課程錄音"
        
        if let split = self.splitViewController {
            _ = split.viewControllers
            //self.detailViewController = controllers[controllers.count-1].topViewController as DetailViewController
        }
        
        
        
        
        let myURLStr = "http://buddha.flyday.com.tw/ShowAllPath.aspx"
       if let myURL = NSURL(string: myURLStr) {
            var error: NSError?
        
            do {
                let myHtmlStr = try NSString(contentsOfURL: myURL, encoding: NSUTF8StringEncoding)
                //let myHtmlStr = NSString(contentsOfURL: myURL, encoding: NSUTF8StringEncoding, error: &error)
                if let error = error {
                    print("Error: \(error)")
                } else {
                    //print("HTML: \(myHtmlStr)")
                    
                    //let data = NSData(contentsOfURL: myURL)!
                    let data = (myHtmlStr as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                    let doc = TFHpple(HTMLData: data)
                    if let elements = doc.searchWithXPathQuery("//a") as? [TFHppleElement] {
                        for element in elements {
                            
                            items.append(element.content)
                            itemsLink.append(element.objectForKey("href"))
                        }
                    }
                    
                    
                }
            } catch let error1 as NSError {
                print("\(error1)")
            }
            
            
        } else {
            print("not a valid URL")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                var dic:[String:String]=["author":"antique"]
                dic["link"] = itemsLink[indexPath.row]
                dic["title"] = items[indexPath.row]
                //controller.detailItem = itemsLink[indexPath.row]
                controller.detailItem = dic
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        //let object = objects[indexPath.row] as! NSDate
        cell.textLabel!.text = items[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            items.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
}

