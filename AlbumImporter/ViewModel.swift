import Foundation
import UIKit

class ViewModel: ObservableObject {
    @Published var images: [ImageModel] = []
    @Published var hasMessage: Bool = false
    @Published var message: String? = nil {
        didSet {
            hasMessage = message != nil
        }
    }
    
    init() {
        loadImages()
    }
    
    func loadImages() {
        // this is another way:
        // let url = Bundle.main.bundleURL.appendingPathComponent("Image.bundle")
        // let files = try! FileManager.default.contentsOfDirectory(atPath: url.path)
        // images = files.map { ImageModel(image: UIImage(named: url.appendingPathComponent($0).path)!)}
        
        let urls = Bundle.main.urls(forResourcesWithExtension: nil, subdirectory: "Image.bundle")!
        images = urls.map { ImageModel(name: $0.lastPathComponent, image: UIImage(named: $0.path)!) }
    }
    
    func `import`() {
        message = nil
        let count = images.filter({ $0.selected }).count
        
        if count == 0 {
            message = "Please select images"
            return
        }
        
        for model in images {
            if model.selected {
                UIImageWriteToSavedPhotosAlbum(model.image, nil, nil, nil)
            }
        }
        
        images.removeAll(where: { $0.selected })
        message = "\(count) image\(count > 1 ? "s have" : " has") been imported"
    }
    
    func all(selected: Bool) {
        for i in 0..<images.count {
            images[i].selected = selected
        }
    }
}

struct ImageModel {
    let id = UUID()
    let name: String
    let image: UIImage
    var selected: Bool = false
}
