import UIKit
import UniformTypeIdentifiers

class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard
            let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = extensionItem.attachments?.first else {
                finish()
                return
            }
        
        if (itemProvider.hasItemConformingToTypeIdentifier(UTType.url.identifier)) {
            itemProvider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { url, error in
                if let error {
                    NSLog(error.localizedDescription)
                    self.finish()
                }
                
                if url is URL {
                    // show view
                }
            }
        }
        else if (itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier)) {
            itemProvider.loadItem(forTypeIdentifier: UTType.movie.identifier, options: nil) { video, error in
                if let error {
                    NSLog(error.localizedDescription)
                    self.finish()
                }
                
                let _ = itemProvider.loadFileRepresentation(for: UTType.movie) { url, b, error in
                    
                }
                
            }
        }
        else if (itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier)) {
            
        }
        else {
            finish()
        }
    }
    
    func finish() {
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        return
    }

}
