// ViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// ViewController-
class ViewController: UIViewController {
    // MARK: IBOutlet

    @IBOutlet private var loginScrollView: UIScrollView!
    @IBOutlet private var loginTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!

    // MARK: private properties

    private var scrollViewTapGestureRecognizer = UITapGestureRecognizer()

    // MARK: ViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardWillShown(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: private methods

    private func setupScrollView() {
        scrollViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        loginScrollView.addGestureRecognizer(scrollViewTapGestureRecognizer)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)

        alert.addAction(action)
        present(alert, animated: true)
    }

    @objc private func keyBoardWillShown(notification: Notification) {
        let info = notification.userInfo as NSDictionary?
        let kbSize = (info?.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue)?.cgRectValue.size

        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kbSize?.height ?? 0, right: 0)

        loginScrollView.contentInset = contentInset
        loginScrollView.scrollIndicatorInsets = contentInset
    }

    @objc private func keyBoardWillHide(notification: Notification) {
        loginScrollView.contentInset = UIEdgeInsets.zero
        loginScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }

    @objc private func hideKeyboard() {
        loginScrollView.endEditing(true)
    }

    // MARK: IBAction

    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let login = loginTextField.text, let password = passwordTextField.text else { return }

        if login.isEmpty, password.isEmpty {
            showAlert(title: "Ошибка!", message: "Неправильный логин/пароль")
        }
    }
}
