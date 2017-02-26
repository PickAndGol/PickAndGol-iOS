
import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {

    var registerViewModel: RegisterViewModel!

    @IBOutlet weak var usarNameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    func setViewModel(viewModel: RegisterViewModel) {
        registerViewModel = viewModel
    }

    @IBAction func registerButtonTapped(_ sender: Any) {

        registerViewModel.registerUser().subscribe(
            onNext: { userModelStruct in
                self.dismiss(animated: true, completion: { 
                    self.showAlert("exito", message: userModelStruct.name)
                })
        },
            onError: { error in
                self.showAlert("error", message: error.localizedDescription)
        },
                                                   onCompleted: nil,
                                                   onDisposed: nil)
            .addDisposableTo(disposeBag)

        updateFormStatus()
    }

    func bindViewModel() {
        let userName = usarNameTextField.rx.text
        userName.subscribe(onNext:{ text in
            guard let text = text else {
                return
            }
            // hacer un weakself?
            self.registerViewModel.userName = text
            self.updateFormStatus()

//            self.textFieldDidChange(textField: self.usarNameTextField)
        }).addDisposableTo(disposeBag)

        let userEmail = userEmailTextField.rx.text
        userEmail.subscribe(onNext:{ _ in
            self.textFieldDidChange(textField: self.userEmailTextField)
        }).addDisposableTo(disposeBag)

        let userPassword = userPasswordTextField.rx.text
        userPassword.subscribe(onNext:{ _ in
            self.textFieldDidChange(textField: self.userPasswordTextField)
        }).addDisposableTo(disposeBag)
    }

    func textFieldDidChange(textField: UITextField?) {
        guard let textField = textField,
            let text = textField.text else {
                return
        }

        if textField == usarNameTextField {
            registerViewModel.userName = text
        } else if textField == userEmailTextField{
            registerViewModel.userEmail = text
        } else if textField == userPasswordTextField {
            registerViewModel.userPassword = text
        }

        updateFormStatus()
    }

    func updateFormStatus() {
        usarNameTextField.layer.borderWidth = 1.0
        userEmailTextField.layer.borderWidth = 1.0
        userPasswordTextField.layer.borderWidth = 1.0

        // hacer el layer reactivo
        usarNameTextField.layer.borderColor = registerViewModel.userNameValid ? UIColor.green.cgColor : UIColor.red.cgColor
        userEmailTextField.layer.borderColor =  registerViewModel.userEmailValid ? UIColor.green.cgColor : UIColor.red.cgColor
        userPasswordTextField.layer.borderColor = registerViewModel.userPasswordValid ? UIColor.green.cgColor : UIColor.red.cgColor
    }

    fileprivate func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
    }
}
