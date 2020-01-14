//
//  DetailViewController.swift
//  FMDBContactDemo
//
//

import UIKit
import AVFoundation
import Photos
import Contacts

class DetailViewController: UIViewController {

    var contact : ContactDetail? = nil
    
    @IBOutlet weak var txtCompanyName: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtLastname: UITextField!
    @IBOutlet weak var txtFirstname: UITextField!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBAction func btnCancelPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDonepressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    @objc func handleTap(){
        
    }
    
    func cameraAsscessRequest(){
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            let picker = UIImagePickerController.init()
            picker.delegate = self
            picker.sourceType = .camera
            self.navigationController?.present(picker, animated: true, completion: nil)
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted -> Void in
                let picker = UIImagePickerController.init()
                picker.delegate = self
                picker.sourceType = .camera
                self.navigationController?.present(picker, animated: true, completion: nil)
            }
        }
    }
    
    func galleryAsscessRequest(){
        PHPhotoLibrary.requestAuthorization { [weak self] result in
            if self != nil {
                if result == .authorized {
                    let picker = UIImagePickerController.init()
                    picker.delegate = self
                    picker.sourceType = .photoLibrary
                    self?.navigationController?.present(picker, animated: true, completion: nil)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.delegate = self as? UIGestureRecognizerDelegate // This is not required
        imgView.addGestureRecognizer(tap)
        self.txtFirstname.text = self.contact?.firstname
        self.txtLastname.text = self.contact?.lastname
        self.txtCompanyName.text = self.contact?.companyname
        
    
        
        let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            
            self.cameraAsscessRequest()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
            
            self.galleryAsscessRequest()
           
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
            print("User click Delete button")
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }

}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagename = "img_\(Date().timeIntervalSince1970)"
        
        if let image  = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.imgView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
}
