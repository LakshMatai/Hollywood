//
//  MovieVC.swift
//  project
//
//  Created by Laksh on 31/03/18.
//  Copyright © 2018 Laksh. All rights reserved.
//

import UIKit
import Alamofire

class MovieVC: UIViewController {

    //Outlets
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var ratings: UILabel!
    @IBOutlet weak var actorCollectionView: UICollectionView!
    var selectedMovieName:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = selectedMovieName
        tryAlamo()
        bgImage.image = UIImage(named: "3")
    }

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    var overviewText:String = ""
    var genreText = [String]()
    var genreT: String = "Genres: "
    
    func tryAlamo(){
        
        request("https://inf551-aecfc.firebaseio.com/movies.json?orderBy=%22title%22&equalTo=%22The%20Avengers%22&limitToFirst=1").responseJSON{ response in
            if let JSON = response.result.value{
                var jsonObject = JSON as! [String:AnyObject]
             //   var origin = jsonObject["origin"] as! String
               // var url = jsonObject as! NSDictionary
              //  print (jsonObject["a000!%5362657"]!["overview"])
                //print(jsonObject.startIndex)
                for(key,value) in jsonObject{
                    self.overviewLabel.text = jsonObject[key]!["overview"] as! String
                   // self.ratings.text = "\(jsonObject[key]!["vote_average"])"
                   self.ratings.text = String( describing: jsonObject[key]!["vote_average"] as! NSNumber)
                    print(self.overviewText)
                    var genres = jsonObject[key]!["genres"] as! [Dictionary<String,AnyObject>]
                    for gen in genres{
                        //self.genreText.append (gen["name"] as! String)
                        self.genreT += gen["name"] as! String
                        self.genreT += ", "
                    }
                    self.genreT = self.genreT.substring(to: self.genreT.index(before: self.genreT.endIndex))
                    self.genreT = self.genreT.substring(to: self.genreT.index(before: self.genreT.endIndex))
                    self.genreLabel.text = self.genreT
                }
            }
            
            
        }
        
    }
        
        
    }

