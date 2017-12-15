//
//  Models.swift
//  Appstore
//
//  Created by Riorden Weber on 12/15/17.
//  Copyright © 2017 Riorden Weber. All rights reserved.
//

import Foundation
import UIKit

class AppCategory: NSObject {
    var name: String?
    var apps: [App]?
    var type: String?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "apps" {
            apps = [App]()
            for dict in value as! [[String: AnyObject]] {
                let app = App()
                app.setValuesForKeys(dict)
                apps?.append(app)
            }
            
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    static func fetchFeaturedApps(completionHandler: @escaping ([AppCategory]) -> ()) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/featured"
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL) { (data, response, error) -> Void in
            if error != nil {
                print(error as Any)
                return
            }
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                
                var appCategories = [AppCategory]()
                
                for dict in json["categories"] as! [[String: AnyObject]] {
                    let appCategory = AppCategory()
                    appCategory.setValuesForKeys(dict)
                    appCategories.append(appCategory)
                }
                
                DispatchQueue.main.async { () -> Void in
                    completionHandler(appCategories)
                }
                
            } catch let err {
                print(err)
            }
            
            
        }.resume()
    }
    
    static func sampleAppCategories() -> [AppCategory] {
        
        
        
        // Best New Apps
        let bestNewAppsCategory = AppCategory()
        bestNewAppsCategory.name = "Best New Apps"
        
        var apps = [App]()
        
        let frozenApp = App()
        frozenApp.name = "Disney Build It: Frozen"
        frozenApp.imageName = "frozen"
        frozenApp.category = "Entertainment"
        frozenApp.price = NSNumber(value: 3.99)
        apps.append(frozenApp)
        
        bestNewAppsCategory.apps = apps
        
        // Best New Games
        let bestNewGamesCategory = AppCategory()
        bestNewGamesCategory.name = "Best New Games"
        
        var bestNewGamesApps = [App]()
        
        let telepaintApp = App()
        telepaintApp.name = "Telepaint"
        telepaintApp.imageName = "telepaint"
        telepaintApp.category = "Games"
        telepaintApp.price = NSNumber(value: 2.99)
        bestNewGamesApps.append(telepaintApp)
        
        bestNewGamesCategory.apps = bestNewGamesApps
        
        return [bestNewAppsCategory, bestNewGamesCategory]
    }
    
}

class App: NSObject {
    var id: NSNumber?
    var name: String?
    var category: String?
    var imageName: String?
    var price: NSNumber?
    
}
