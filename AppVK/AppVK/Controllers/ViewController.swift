// ViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// ViewController-
final class ViewController: UIViewController {
    // MARK: IBOutlet

    @IBOutlet private var loginScrollView: UIScrollView!
    @IBOutlet private var loginTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet var buttonLogin: UIButton!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var firstDotView: UIView!
    @IBOutlet var secondDotView: UIView!
    @IBOutlet var thirdDotView: UIView!

    // MARK: private properties

    private var scrollViewTapGestureRecognizer = UITapGestureRecognizer()
    private var tabBarShowID = "tabBarShow"

    // MARK: ViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        loadingView.isHidden = true
        setupScrollView()
        setupDots()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addNotificationObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeNotificationObservers()
    }

    // MARK: private methods

    private func addViewAnimation() {
        loadingView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.loadingView.backgroundColor = .white
        }
        UIView.animate(withDuration: 0.7, delay: 0, options: .repeat) {
            self.firstDotView.alpha = 1
        }

        UIView.animate(withDuration: 0.7, delay: 0.05, options: .repeat) {
            self.secondDotView.alpha = 1
        }

        UIView.animate(withDuration: 0.7, delay: 0.1, options: .repeat) {
            self.thirdDotView.alpha = 1
        }
    }

    private func setupDots() {
        firstDotView.layer.cornerRadius = firstDotView.frame.width / 2
        secondDotView.layer.cornerRadius = firstDotView.frame.width / 2
        thirdDotView.layer.cornerRadius = firstDotView.frame.width / 2
    }

    private func addNotificationObservers() {
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

    private func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

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

        addViewAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.performSegue(withIdentifier: self.tabBarShowID, sender: self.buttonLogin)
        }

        if login.isEmpty, password.isEmpty {
            showAlert(title: "Ошибка!", message: "Неправильный логин/пароль")
        }
    }
}
