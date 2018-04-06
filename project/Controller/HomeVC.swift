//
//  HomeVC.swift
//  project
//
//  Created by Laksh on 15/03/18.
//  Copyright © 2018 Laksh. All rights reserved.
//

import UIKit
class HomeVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var imageArray = [UIImage(named:"1"),UIImage(named:"2"),UIImage(named:"3"),UIImage(named:"4"),UIImage(named:"5"),UIImage(named:"6")]
    var labelArray = ["Fault in our stars","Jaws","Avengers","Sherlock Holmes", "The Shawshank Redemption", "Moonlight"]
    
    var actorImages = [UIImage(named:"a"),UIImage(named:"b"),UIImage(named:"c"),UIImage(named:"d"),UIImage(named:"e"),UIImage(named:"f")]
    
    var actorNames = ["Robert Downey Jr.", "Zack Efron","Ryan Gosling", "Benedict Cumberbatch", "Chris Pratt", "Bradley Cooper"]
    var selectedMovieName:String = ""
    //Outlets
    @IBOutlet weak var menuBtn: UIButton!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    
    @IBOutlet weak var actorCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        
        //view.addGestureRecognizer(tap)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.imageCollectionView{
        return imageArray.count
        }
        else {
            return actorImages.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.imageCollectionView {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        cell.imageInCell.image = imageArray[indexPath.row]
        cell.labelInCell.text = labelArray[indexPath.row]
        
        return cell
        }
        else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActorCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
            
            cell.imageInCell.image = actorImages[indexPath.row]
            cell.labelInCell.text = actorNames[indexPath.row]
            
            return cell
        }
        }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetailsSegue"{
            let controller = segue.destination as! MovieVC
            controller.selectedMovieName = selectedMovieName
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedMovieName = labelArray[indexPath.row] as String
        self.performSegue(withIdentifier: "movieDetailsSegue", sender: self)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   
}
