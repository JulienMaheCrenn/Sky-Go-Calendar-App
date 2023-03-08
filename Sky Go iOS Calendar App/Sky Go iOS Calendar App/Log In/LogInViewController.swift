
import UIKit

class LogInViewController: UIViewController {
    
    let skyLogo = UIImageView()
    let usernameLabel = UILabel()
    let usernameTextInput = UITextField()
    let passwordLabel = UILabel()
    let passwordTextInput = UITextField()
    let logInButton = UIButton()
    let logOutButton = UIButton()
    let presenter: LogInPresenter

    init() {
        presenter = LogInPresenter()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Log In"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupLogo()
        setupLabels()
        setupTextFields()
        setupButtons()
    }
    
    func setupButtons() {
        view.addSubview(logInButton)
        view.addSubview(logOutButton)
        
        logInButton.configuration = .filled()
        logInButton.configuration?.baseBackgroundColor = .systemGreen
        logInButton.configuration?.title = "Log In"
        logInButton.configuration?.baseForegroundColor = .black
        
        
        logInButton.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
            logInButton.widthAnchor.constraint(equalToConstant: 200),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
        
        
    }
    
    
    @objc func handleLogIn() {
        let email:String = usernameTextInput.text!
        let password:String = passwordTextInput.text!
        
        presenter.handleLogin(email: email, password: password)
        
//        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
//          guard let _ = self else { return }   
//        }
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
        usernameTextInput.textColor = .black
        usernameTextInput.autocorrectionType = UITextAutocorrectionType.no
        usernameTextInput.autocapitalizationType = UITextAutocapitalizationType.none
        
        passwordTextInput.borderStyle = .roundedRect
        passwordTextInput.textColor = .black
        passwordTextInput.autocorrectionType = UITextAutocorrectionType.no
        passwordTextInput.autocapitalizationType = UITextAutocapitalizationType.none
        
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
