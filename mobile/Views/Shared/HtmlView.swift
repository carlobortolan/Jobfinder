//
//  HtmlView.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import SwiftUI
import WebKit

struct HTMLView: UIViewRepresentable {
    let htmlString: String
    let fontSize: CGFloat

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let data = htmlString.data(using: .utf8) {
            uiView.load(data, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: URL(fileURLWithPath: ""))
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: HTMLView

        init(_ parent: HTMLView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.scrollView.isScrollEnabled = false
            webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                if let height = height as? CGFloat {
                    webView.frame.size.height = height
                }
            })
        }
    }
}
