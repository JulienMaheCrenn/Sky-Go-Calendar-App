
import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    let skyLogo = UIImageView()
    let usernameLabel = UILabel()
    let usernameTextInput = UITextField()
    let passwordLabel = UILabel()
    let passwordTextInput = UITextField()
    let signUpButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign Up"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupLogo()
        setupLabels()
        setupTextFields()
        setupButton()
    }
    
    func setupButton() {
        view.addSubview(signUpButton)
        
        signUpButton.configuration = .filled()
        signUpButton.configuration?.baseBackgroundColor = .systemOrange
        signUpButton.configuration?.title = "Sign Up"
        signUpButton.configuration?.baseForegroundColor = .black
        
        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            signUpButton.widthAnchor.constraint(equalToConstant: 200),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        
    }
    
    
    @objc func handleSignUp() {
        let email:String = usernameTextInput.text!
        let password:String = passwordTextInput.text!
        
        Auth.auth().createUser(withEmail: email, password: password) {authResult, error in
            print(authResult ?? "No Data")
        }
        
    }
    
    func setupLogo() {
        skyLogo.image = UIImage(named: "skyLogo")
        view.addSubview(skyLogo)
        
        skyLogo.contentMode = .scaleAspectFit
        
        skyLogo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            skyLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skyLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            skyLogo.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    func setupLabels() {
        view.addSubview(usernameLabel)
        view.addSubview(passwordLabel)
        
        usernameLabel.text = "Username:"
        usernameLabel.textAlignment = .left
        
        passwordLabel.text = "Password:"
        passwordLabel.textAlignment = .left
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            usernameLabel.widthAnchor.constraint(equalToConstant: 200),
            usernameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            passwordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            passwordLabel.widthAnchor.constraint(equalToConstant: 200),
            passwordLabel.heightAnchor.constraint(equalToConstant: 50),

        ])
    }
    
    func setupTextFields() {
        view.addSubview(usernameTextInput)
        view.addSubview(passwordTextInput)
        
        usernameTextInput.borderStyle = .roundedRect
        usernameTextInput.textColor = .white
        
        passwordTextInput.borderStyle = .roundedRect
        passwordTextInput.textColor = .white
        
        usernameTextInput.translatesAutoresizingMaskIntoConstraints = false
        passwordTextInput.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameTextInput.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor, constant: 50),
            usernameTextInput.centerXAnchor.constraint(equalTo: usernameLabel.centerXAnchor),
            usernameTextInput.widthAnchor.constraint(equalToConstant: 200),
            usernameTextInput.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextInput.centerYAnchor.constraint(equalTo: passwordLabel.centerYAnchor, constant: 50),
            passwordTextInput.centerXAnchor.constraint(equalTo: passwordLabel.centerXAnchor),
            passwordTextInput.widthAnchor.constraint(equalToConstant: 200),
            passwordTextInput.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

}

