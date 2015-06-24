//
//  ViewController.swift
//  SimpleTableView
//
//  Created by javaing63 on 2015/5/29.
//  Copyright (c) 2015年 javaing63. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet
    var tableView: UITableView!
    
    var items: [String] = []
    var itemsLink: [String]=[]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        
        let myURLStr = "http://buddha.flyday.com.tw/ShowAllPath.aspx"
        if let myURL = NSURL(string: myURLStr) {
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
                        //println(element.content)
                        //println(element.description)
                        items.append(element.content)
                    }
                }
                if let elements = doc.searchWithXPathQuery("//a/@href") as? [TFHppleElement] {
                    for element in elements {
                        //println(element.content)
                        //println(element.description)
                        itemsLink.append(element.content)
                    }
                }
                
                
                
            }

        } else {
            print("not a valid URL")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //println("select cell#\(indexPath.row)!")
        print(itemsLink[indexPath.row])
    }

}

