//
//  Download.swift
//  flyday
//
//  Created by javaing63 on 2015/6/5.
//  Copyright (c) 2015年 javaing63. All rights reserved.
//

import Foundation

class Downloader {
    
    class func load(url: NSURL, callback:(Int)->Void) {
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory,
            inDomains: .UserDomainMask).first;
        
        // lets create your destination file url
        let destinationUrl = documentsUrl!.URLByAppendingPathComponent(url.lastPathComponent!)
        print(destinationUrl)
        
        // to check if it exists before downloading it
        if NSFileManager().fileExistsAtPath(destinationUrl.path!) {
            print("The file already exists at path")
            callback(1)
            // if the file doesn't exist
        } else {
            
            //  just download the data from your url
            if let myDataFromUrl = NSData(contentsOfURL: url){
                
                // after downloading your data you need to save it to your destination url
                if myDataFromUrl.writeToURL(destinationUrl, atomically: true) {
                    print("file saved")
                    callback(1)
                } else {
                    print("error saving file")
                    callback(0)
                }
            }
        }
    }
    
//    class func write(data: NSData, filename: String) {
//        let filemanager = NSFileManager.defaultManager()
//        let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
//        let destinationPath:String = documentsPath.stringByAppendingString(filename)
//        
//        if (!filemanager.fileExistsAtPath(destinationPath)) {
//            var theError: NSError?
//            //let url = "https://www.box.com/shared/static/4k43665bm1d65lqid55v.mp3"
//            //let data = NSData(contentsOfFile: url, options: nil, error: nil)
//            
//            if (data? != nil) {
//                let writePath = destinationPath.stringByAppendingPathComponent(url)
//                filemanager.copyItemAtPath(writePath,toPath:destinationPath, error: &theError)
//                
//                if (theError == nil) {
//                    println("The music files has been saved.")
//                } else {
//                    println("Error")
//                }
//                
//            }
//        } else {
//            println("The files already exist")
//        }
//    }
}