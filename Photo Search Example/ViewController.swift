//
//  ViewController.swift
//  Photo Search Example
//
//  Created by Deekshita Amaravadi on 2/28/16.
//  Copyright © 2016 Deekshita Amaravadi. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON


class ViewController: UIViewController,UISearchBarDelegate  {
    
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchInstagramByHashtag("dogs")
        
    }
    
    //MARK: Utility methods
    func searchInstagramByHashtag(searchString:String) {
        Alamofire.request(.GET, "https://api.instagram.com/v1/tags/\(searchString)/media/recent?access_token=273042469.1677ed0.4770b4b825b84a45b3f89194052f18dc")
            .responseJSON { response in
                
                if response.result.isSuccess {
                    let jsonDic = response.result.value as! NSDictionary
                    let responseData = jsonDic["data"] as! NSArray
                    debugPrint(responseData.count)
                    var urlArray:[String] = []
                    for data in responseData {
                        if let imageURLString = data.valueForKeyPath("images.standard_resolution.url") as? String {                             urlArray.append(imageURLString)
                        }
                    }
                    
                    self.scrollView.contentSize = CGSizeMake(320, 320 * CGFloat(responseData.count))
                    
                    for var i = 0; i < urlArray.count; i++ {
                        let imageView = UIImageView(frame: CGRectMake(0, 320 * CGFloat(i), 320, 320))
                       // imageView.frame = CGRectMake(0, 320 * CGFloat(i), 320, 320)
                        self.scrollView.addSubview(imageView)
                        
                        Alamofire.request(.GET, urlArray[i])
                            .responseImage { response in
                                if let image = response.result.value {
                                    imageView.image = image
                                }
                        }
                    }
                }
        }

    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
            searchInstagramByHashtag(searchText)
        }
        
    }
  
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == " " {
            return false
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

