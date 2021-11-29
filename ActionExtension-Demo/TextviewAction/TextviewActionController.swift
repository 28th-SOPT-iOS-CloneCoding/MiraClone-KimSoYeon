//
//  TextviewActionController.swift
//  TextviewAction
//
//  Created by soyeon on 2021/11/29.
//

import UIKit
import MobileCoreServices

class TextviewActionController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var convertedString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textItem = self.extensionContext!.inputItems[0] as! NSExtensionItem
        let textItemProvider = textItem.attachments![0]
        
        if textItemProvider.hasItemConformingToTypeIdentifier(kUTTypeText as String) {
            textItemProvider.loadItem(forTypeIdentifier: kUTTypeText as String,
                                      options: nil,
                                      completionHandler: { (result, error) in
                self.convertedString = result as? String
                
                if self.convertedString != nil {
                    self.convertedString = self.convertedString!.appending("💖")
                    self.convertedString = self.convertedString?.uppercased()
                    DispatchQueue.main.async {
                        self.textView.text = self.convertedString!
                    }
                }
                
            })
        }
    }
    
    @IBAction func done() {
        let returnProvider =
        NSItemProvider(item: convertedString as NSSecureCoding?,
                       typeIdentifier: kUTTypeText as String)
        
        let returnItem = NSExtensionItem()
        
        returnItem.attachments = [returnProvider]
        returnItem.attributedContentText
        self.extensionContext!.completeRequest(
            returningItems: [returnItem], completionHandler: nil)
    }
    
}
