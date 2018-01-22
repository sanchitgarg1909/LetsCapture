
import UIKit
import Realm

class ImagePreviewController: UIViewController {
    
    let imageView = UIImageView()
    let saveButton = UIButton()
    
    var imagePreview: UIImage? {
        didSet {
            imageView.image = imagePreview
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .clear
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        self.view.addSubview(imageView)
        self.view.addSubview(saveButton)
        
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = view.bounds
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
//        let margins = view.layoutMarginsGuide
        
//        imageView.widthAnchor.constraint(equalTo: margins.widthAnchor, constant: 0).isActive = true
        saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
//        imageView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: 0).isActive = true
        
    }
    
    @objc func saveImage() {
        print("save image here")
        
        if let data = UIImageJPEGRepresentation(imagePreview!, 1) {
            let filename = getDocumentsDirectory().appendingPathComponent("filename")
            let image = Image()
            image.path = filename.path
            try? data.write(to: filename)
            
            // Persist your data easily
            try! realm.write {
                realm.add(image)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}


