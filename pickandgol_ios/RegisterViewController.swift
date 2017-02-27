
import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {

    var registerViewModel: RegisterViewModel!

    @IBOutlet weak var usarNameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!

    @IBOutlet weak var registerButton: UIButton!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        initTextFields()
    }

    func setViewModel(viewModel: RegisterViewModel) {
        registerViewModel = viewModel
    }

    @IBAction func registerButtonTapped(_ sender: Any) {

        registerViewModel.registerUser().subscribe(
            onNext: { userModelStruct in
                self.showAlert("Te has registrado con éxito", message: userModelStruct.name)
//                self.dismiss(animated: true, completion:nil)
        },
            onError: { error in
                self.showAlert("Ha habido algún problema en el registro", message: error.localizedDescription)
        },
                                                   onCompleted: nil,
                                                   onDisposed: nil)
            .addDisposableTo(disposeBag)
    }

    func initTextFields() {
        usarNameTextField.layer.borderWidth = 0
        userEmailTextField.layer.borderWidth = 0
        userPasswordTextField.layer.borderWidth = 0
    }
    func setupBindings() {
        usarNameTextField.rx.text
            .map { $0 ?? "" }
            .bindTo(registerViewModel.userName)
            .addDisposableTo(disposeBag)
        userEmailTextField.rx.text
            .map { $0 ?? "" }
            .bindTo(registerViewModel.userEmail)
            .addDisposableTo(disposeBag)
        userPasswordTextField.rx.text
            .map { $0 ?? "" }
            .bindTo(registerViewModel.userPassword)
            .addDisposableTo(disposeBag)

        registerViewModel.formIsValid
            .bindTo(registerButton.rx.isEnabled)
            .addDisposableTo(disposeBag)

        let userNameTF = usarNameTextField!
        let userEmailTF = userEmailTextField!
        let userPassTF = userPasswordTextField!

        registerViewModel.userNameIsValid
            .subscribe(onNext: { isValid in
                userNameTF.isValid(valid: isValid)
            })
            .addDisposableTo(disposeBag)
        registerViewModel.userEmailIsValid
            .subscribe(onNext: { isValid in
                userEmailTF.isValid(valid: isValid)
            })
            .addDisposableTo(disposeBag)
        registerViewModel.userPasswordIsValid
            .subscribe(onNext: { isValid in
                userPassTF.isValid(valid: isValid)
            })
            .addDisposableTo(disposeBag)
    }

    fileprivate func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
    }

}
