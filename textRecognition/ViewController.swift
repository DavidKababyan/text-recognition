//
//  ViewController.swift
//  textRecognition
//
//  Created by David Kababyan on 03/12/2017.
//  Copyright © 2017 David Kababyan. All rights reserved.
//

import UIKit
import TesseractOCR

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    
    
    }


    //MARK: IBAction
    
    @IBAction func takePhotoButtonPressed(_ sender: Any) {
        
        view.endEditing(true)
        presentOptin()
    }
    
    func presentOptin() {
        
        let imageAction = UIAlertController(title: "Take photo", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { (action) in

            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        
        let libraryAction = UIAlertAction(title: "Choose Existing", style: .default) { (action) in
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        imageAction.addAction(cameraAction)
        imageAction.addAction(libraryAction)
        imageAction.addAction(cancelAction)
        
        present(imageAction, animated: true, completion: nil)

    }
    

    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as?  UIImage {
            
            let scaledPgoto = selectedImage.scaleImage(640)
                
            activityIndicator.startAnimating()
            
            dismiss(animated: true, completion: {
                
                print("start recognizing image")
                self.recognizeText(image: scaledPgoto!)
            })
            
        }
    }
    
    
    
    func recognizeText(image: UIImage) {
        
        if let tessaract = G8Tesseract(language: "eng") {
            tessaract.engineMode = .tesseractCubeCombined
            tessaract.pageSegmentationMode = .auto
            tessaract.image = image.g8_blackAndWhite()
            tessaract.recognize()
            textView.text = tessaract.recognizedText
            
        }
        activityIndicator.stopAnimating()
    }

}

extension UIImage {
    
    func scaleImage(_ maxDimension: CGFloat) -> UIImage? {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        
        if size.width > size.height {
            let scaleFactor = size.height / size.width
            scaledSize.height = scaledSize.width * scaleFactor
            
        } else {
            let scaleFactor = size.width / size.height
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}

