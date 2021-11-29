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
        
        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            return
        }
        
        // fix
//        for extensionItem in extensionItems {
//            if let itemProviders = extensionItem.attachments as? [NSItemProvider] {
//                for itemProvider in itemProviders {
//                    if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeText as String) {
//
//                        itemProvider.loadItem(forTypeIdentifier: kUTTypeText as String, options: nil, completionHandler: { text, error in
//                            let newtext = text as! String
//                            DispatchQueue.main.async {
//                                self.textView.text = newtext
//                            }
//                        })
//                    }
//                }
//            }
//        }
        
        
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
                
                // fix
//                if let inputItem = returnedItems?.first as? NSExtensionItem {
//                    if let itemProvider = inputItem.attachments?.first {
//                        itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (string, error) in
//
//                            let newtext = string as! String
//                            DispatchQueue.main.async {
//                                self?.textView.text = newtext
//                            }
//                        }
//                    }
//                }
            }
        }
        
    }
}
    
