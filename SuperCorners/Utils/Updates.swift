//
//  Updates.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-18.
//

import Foundation
import AppKit

func checkForUpdates () {
    let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    guard let url = URL(string: "https://api.github.com/repos/daniyalmaster693/MenuScores/releases/latest") else {return}
    
    URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let tagName = json["tag_name"] as? String,
               let assets = json["assets"] as? [[String: Any]],
               let downloadURL = assets.first?["browser_download_url"] as? String {
                
                let latestVersion = tagName.replacingOccurrences(of: "v", with: "")
                
                if latestVersion.compare(currentVersion, options: .numeric) == .orderedDescending {
                    DispatchQueue.main.async {
                        let alert = NSAlert()
                        alert.messageText = "Update Available"
                        alert.informativeText = "A newer version (\(latestVersion)) of MenuScores is available."
                        alert.addButton(withTitle: "Download")
                        alert.addButton(withTitle: "Cancel")
                        let response = alert.runModal()
                        
                        if response == .alertFirstButtonReturn,
                           let downloadLink = URL(string: downloadURL) {
                            NSWorkspace.shared.open(downloadLink)
                        }
                    }
                }
            }
        }.resume()
    }
