// WebViewController.swift
// Copyright © RoadMap. All rights reserved.

import FirebaseDatabase
import UIKit
import WebKit

/// WebViewController-
final class WebViewController: UIViewController {
    // MARK: IBOutlet

    @IBOutlet var wkWebView: WKWebView! {
        didSet {
            wkWebView.navigationDelegate = self
        }
    }

    // MARK: private peroperties

    private var service = APIService()
    private let ref = Database.database().reference(withPath: "users")

    // MARK: WebViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        loadStartPage()
    }

    // MARK: private methods

    private func loadStartPage() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7936587"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "friends,wall"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]

        guard let url = urlComponents.url else { return }
        let request = URLRequest(url: url)

        wkWebView.load(request)
    }

    private func saveUserIDToFirebase(id: String) {
        let user = UserFirebase()
        user.id = id
        ref.setValue(user.toAnyObject())
    }
}

// MARK: WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
    ) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html",
              let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }

        let params = fragment.components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        guard let token = params["access_token"] else { return }
        guard let userID = params["user_id"] else { return }

        print(token)
        print(userID)

        saveUserIDToFirebase(id: userID)

        UserInfo.userInfo.token = token
        UserInfo.userInfo.userID = userID

        performSegue(withIdentifier: "openMainInterface", sender: nil)

        decisionHandler(.cancel)
    }
}
