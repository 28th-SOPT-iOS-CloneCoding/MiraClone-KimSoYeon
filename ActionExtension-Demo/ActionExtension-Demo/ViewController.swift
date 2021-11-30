//
//  ViewController.swift
//  ActionExtension-Demo
//
//  Created by soyeon on 2021/11/29.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func touchUpChangeButton(_ sender: UIButton) {
        var objectsToShare = [String]()
        
        if let text = textView.text {
            objectsToShare.append(text)
        }
        
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        self.present(activityVC, animated: true, completion: nil)
        
        activityVC.completionWithItemsHandler =
        { (activityType, completed, returnedItems, error) in
            
            if returnedItems!.count > 0 {
                
                let textItem: NSExtensionItem =
                returnedItems![0] as! NSExtensionItem

                let textItemProvider =
                textItem.attachments![0] as! NSItemProvider

                if textItemProvider.hasItemConformingToTypeIdentifier(
                    kUTTypeText as String) {

                    textItemProvider.loadItem(
                        forTypeIdentifier: kUTTypeText as String,
                        options: nil,
                        completionHandler: {(string, error) -> Void in
                            let newtext = string as! String
                            DispatchQueue.main.async {
                                self.textView.text = newtext
                            }
                        })
                }
            }
        }
        
    }
}
    
