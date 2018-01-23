//
//  ViewController.swift
//  LetsCapture
//
//  Created by Sanchit Garg on 13/01/18.
//  Copyright © 2018 Sanchit Garg. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController,UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupCollectionView()
        setupNavigationBar()
    }
    override func viewDidAppear(_ animated: Bool) {
        getImages()
        collectionView?.reloadData()
    }
    func getImages() {
        images.removeAll()
        let imageUrls = realm.objects(Image.self)
        for imageUrl in imageUrls {
            if let image = UIImage(contentsOfFile: imageUrl.path) {
                images.append(image)
            }
        }
    }
    func setupCollectionView() {
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.itemSize = CGSize(width: (view.frame.width-2)/4, height: (view.frame.width-2)/4)
            flowLayout.minimumInteritemSpacing = 0.5
            flowLayout.minimumLineSpacing = 0.5
        }
        collectionView?.backgroundColor = .red
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: "cellId")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ImageCell
        cell.image = images[indexPath.item]
        return cell
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(openCamera))
    }
    
    @objc func openCamera() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("captured image")
        print(info)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let imagePreviewController = ImagePreviewController()
        imagePreviewController.imagePreview = image
        
        self.dismiss(animated: true) {
            self.present(imagePreviewController, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

