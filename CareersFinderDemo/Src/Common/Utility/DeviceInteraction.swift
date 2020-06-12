import UIKit

class DeviceInteraction {
    
    private var controller: (UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate)!

    public init(_ controller: UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        self.controller = controller
    }
    
    public var mediaTypeMovie: Bool = false

    public func cameraOptionsAlert() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let openCameraAction = UIAlertAction(title: "Open Camera", style: .default) { [unowned self] _ in
            self.presentCamera()
        }
        let chooseLibraryAction = UIAlertAction(title: "Open Library", style: .default) { [unowned self] _ in
            self.presentImageLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {  _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(openCameraAction)
        alert.addAction(chooseLibraryAction)
        alert.addAction(cancelAction)

        return alert
    }

    private func presentCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = controller
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            if mediaTypeMovie {
                imagePicker.mediaTypes = ["public.movie"]
            }
            controller.present(imagePicker, animated: true, completion: nil)
        }
    }

    private func presentImageLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = controller
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            if mediaTypeMovie {
                imagePicker.mediaTypes = ["public.movie"]
            }
            controller.present(imagePicker, animated: true, completion: nil)
        }
    }

}
