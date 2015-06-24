//
//  DetailViewController.swift
//  flyday
//
//  Created by javaing63 on 2015/6/5.
//  Copyright (c) 2015年 javaing63. All rights reserved.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet var tableView: UITableView!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var messageLabel: UILabel!
    
    var items = [String]()
    var itemsLink = [String]()
    
    
    var detailItem: [String: String]? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let _: AnyObject = self.detailItem {
//            if let label = self.detailDescriptionLabel {
//                label.text = detail.description
//            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "detaillcell")
        self.playButton.enabled = false
        self.playButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        
        self.navigationItem.title = detailItem?["title"]
        //self.navigationItem.rightBarButtonItem?.title = "上頁"

        
        let myURLStr = self.detailItem?["link"]
        if let myURL = NSURL(string: myURLStr!) {
            var error: NSError?
            //var nssencoding: NSStringEncoding
            //let myHtmlStr = NSString(contentsOfURL: myURL, usedEncoding: &nssencoding, error: &error)
            let myHtmlStr: NSString?
            do {
                myHtmlStr = try NSString(contentsOfURL: myURL, encoding: NSUTF8StringEncoding)
            } catch let error1 as NSError {
                error = error1
                myHtmlStr = nil
            }
            if let error = error {
                print("Error: \(error)")
            } else {
                print("HTML: \(myHtmlStr)")
                
                let data = NSData(contentsOfURL: myURL)!
                let doc = TFHpple(HTMLData: data)
                if let elements = doc.searchWithXPathQuery("//a") as? [TFHppleElement] {
                    for element in elements {
                        if element.content != "音檔" {
                            print(element.content)
                            items.append(element.content)
                            itemsLink.append(element.objectForKey("href"))

                        }
                        
                    }
                    items.removeAtIndex(0)
                    itemsLink.removeAtIndex(0)
                }
                
                
            }
            
        } else {
            print("not a valid URL")
        }
        
        
        //var tblView = UIView(frame: CGRectZero)
        //tableView.tableFooterView = tblView
        //tableView.tableFooterView?.hidden = true
        tableView.backgroundColor = UIColor.yellowColor()
        //self.configureView()
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "detaillcell")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
//     func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 2.0
//        }
//        else {
//            return 40.0
//        }
//    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section==0 {
//            return ""
//        }
//        else {
//            return ""
//        }
//    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 {
//            return UIView(frame: CGRectMake(0.0, 0.0, 640.0, 0.0))
//        }
//        return nil
//    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("detaillcell") as UITableViewCell!
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
    
    func pressed(sender: UIButton!) {
//        var alertView = UIAlertView();
//        alertView.addButtonWithTitle("Ok");
//        alertView.title = "title";
//        alertView.message = "message";
//        alertView.show();
        
        if self.messageLabel.text != "暫停" {
            player.pause()
            self.messageLabel.text = "暫停"
            //self.playButton..description == "PLAY"
            self.playButton.setTitle("PLAY", forState: .Normal)
        }
        else {
            player.play()
            self.messageLabel.text = "播放中..."
            self.playButton.setTitle("STOP", forState: .Normal)
            //self.playButton.description = "STOP"
        }
        
       
    }
    
    var player = AVPlayer()
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
//        if (indexPath.row==0)
//        {
//            self.navigationController?.popViewControllerAnimated(true)
//            return
//        }
        
        //println("select cell#\(indexPath.row)!")
        print(itemsLink[indexPath.row])
        
        let playerItem = AVPlayerItem( URL:NSURL( string:itemsLink[indexPath.row] )! )
        player = AVPlayer(playerItem:playerItem)
        player.rate = 1.0;
        player.play()
        self.messageLabel.text = "播放中..."
        self.playButton.enabled = true
        
        
//        self.messageLabel.text = "下載中..."
//        Downloader.load(NSURL(string: itemsLink[indexPath.row])!, callback: { (intCheck:Int) -> Void in
//            if intCheck==1 {
//                self.playButton.enabled = true
//                self.messageLabel.text = "可播放"
//            }
//            else {
//                self.playButton.enabled = false
//                self.messageLabel.text = "下載失敗"
//            }
//        })
    }

}

