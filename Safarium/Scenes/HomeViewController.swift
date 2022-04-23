//
//  ViewController.swift
//  Safarium
//
//  Created by Renato F. dos Santos Jr on 28/03/22.
//

import UIKit

import WebKit

class HomeViewController: UIViewController {
    
    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let web = WKWebView(frame: .zero, configuration: configuration)
        web.navigationDelegate = self
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }()
    
    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "Realize uma busca navegue até um site"
        search.searchBar.translatesAutoresizingMaskIntoConstraints = false
        search.obscuresBackgroundDuringPresentation = true
        search.searchResultsUpdater = self
        search.searchBar.delegate = self
        search.delegate = self
        return search
    }()
    
    lazy var userTextInput: String = "https://www.google.com" {
        didSet {
            setUpWebView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpWebView()
        setUpNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavBar()
    }
    
    private func setUpWebView() {
        let url: URL
        
        if userTextInput.isEmpty {
            return
        }
        
        if isValidUrl(url: "https://www.\(userTextInput)") {
            url = URL(string: "https://www.\(userTextInput)")!
        } else if isValidUrl(url: "https://\(userTextInput)") {
            url = URL(string: "https://\(userTextInput)")!
        } else if isValidUrl(url: userTextInput) {
            url = URL(string: userTextInput)!
        } else {
            url = URL(string: "https://www.google.com/search?q=\(userTextInput)")!
        }
        
//        if !isValidUrl(url: "https://www.\(userTextInput)"),
//           !isValidUrl(url: "https://\(userTextInput)"),
//           !isValidUrl(url: userTextInput) {
//            url = URL(string: "https://www.google.com/search?q=\(userTextInput)")!
//        } else {
//            url = URL(string: userTextInput)!
//        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func isValidUrl(url: String) -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }
    
    private func configureUI() {
        title = "Safarium"
        view.backgroundColor = .lightGray
        view.addSubview(webView) // verificar herancas para usar!
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor), // needed due rotation!
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setUpNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00) // TODO: Try another black color
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.tintColor = .gray
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.searchController = searchController
        
        let forwardBarItem = UIBarButtonItem(image: UIImage.init(systemName: "arrow.right"), style: .plain, target: self, action: #selector(forwardAction))
        
        let backBarItem = UIBarButtonItem(image: UIImage.init(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(backAction))
        
        let reloadBarItem = UIBarButtonItem(image: UIImage.init(systemName: "arrow.counterclockwise"), style: .plain, target: self, action: #selector(reloadAction))
        // TODO: Desabilitar estado do botão
        // TODO: Notificar loading... 
        
        navigationItem.leftBarButtonItem = reloadBarItem
        navigationItem.rightBarButtonItems = [forwardBarItem, backBarItem]
        
    }
}

extension HomeViewController {
    
    @objc private func forwardAction() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @objc private func backAction() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc private func reloadAction() {
        webView.reload()
    }
    
    @objc private func favoriteAction() {
        
    }
}

extension HomeViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Iniciando!")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Terminou!") // I can now remove load!
    }
}

extension HomeViewController: UISearchResultsUpdating {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let typedText = searchBar.text else { return }
        userTextInput = typedText.lowercased()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension HomeViewController: UISearchControllerDelegate {
    
}

extension HomeViewController: UISearchBarDelegate {
    
}
