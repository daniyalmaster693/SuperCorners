//
//  SettingsView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-22.
//

import SwiftUI
import LaunchAtLogin

struct SettingsView: View {
    @AppStorage("notiGameStart") private var notiGameStart = false
    @AppStorage("notiGameComplete") private var notiGameComplete = false
    
    @AppStorage("refreshInterval") private var selectedOption = "15 seconds"
    let refreshOptions = ["10 seconds", "15 seconds","20 seconds", "30 seconds", "40 seconds", "50 seconds", "1 minute", "2 minutes", "5 minutes"]
    
    var refreshInterval: Double {
        switch selectedOption {
        case "10 seconds": return 10
        case "15 seconds": return 15
        case "20 seconds": return 20
        case "30 seconds": return 30
        case "40 seconds": return 40
        case "50 seconds": return 50
        case "1 minute": return 60
        case "2 minutes": return 120
        case "5 minutes": return 300
        default: return 15
        }
    }
    
    @AppStorage("enableNHL") private var enableNHL = true
    @AppStorage("enableNBA") private var enableNBA = true
    @AppStorage("enableWNBA") private var enableWNBA = true
    @AppStorage("enableNCAAM") private var enableNCAAM = true
    @AppStorage("enableNCAAF") private var enableNCAAF = true
    @AppStorage("enableNFL") private var enableNFL = true
    @AppStorage("enableMLB") private var enableMLB = true
    @AppStorage("enableF1") private var enableF1 = true
    @AppStorage("enablePGA") private var enablePGA = true
    @AppStorage("enableLPGA") private var enableLPGA = true
    @AppStorage("enableUEFA") private var enableUEFA = true
    @AppStorage("enableEPL") private var enableEPL = true
    @AppStorage("enableESP") private var enableESP = true
    @AppStorage("enableGER") private var enableGER = true
    @AppStorage("enableITA") private var enableITA = true
    @AppStorage("enableNLL") private var enableNLL = true
    
    var body: some View {
        Form {
            VStack(alignment: .leading, spacing: 40) {
                LabeledContent("Notifications") {
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Enable notifications for game start", isOn: $notiGameStart)
                        Text("Recieve notifications when games start")
                            .font(.callout)
                            .foregroundColor(.secondary)
                        
                        Toggle("Enable notifications for completed games", isOn: $notiGameComplete)
                        Text("Receive notifications when a game ends with its final score")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                }
                
                LabeledContent("Auto Refresh Interval") {
                    VStack(alignment: .leading, spacing: 4) {
                        Picker("", selection: $selectedOption) {
                            ForEach(refreshOptions, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: 140, alignment: .leading)
                        
                        Text("Control how often games and scores will update")
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .padding(.leading, 8)
                            .padding(.top, 2)
                    }
                }
                
                LabeledContent("Enabled Leagues") {
                    HStack(alignment: .top, spacing: 25) {
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("NHL", isOn: $enableNHL)
                            Toggle("NBA", isOn: $enableNBA)
                            Toggle("WNBA", isOn: $enableWNBA)
                            Toggle("NCAA M", isOn: $enableNCAAM)
                            Toggle("NCAA F", isOn: $enableNCAAF)
                            Toggle("NFL", isOn: $enableNFL)
                            
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("MLB", isOn: $enableMLB)
                            Toggle("F1", isOn: $enableF1)
                            Toggle("PGA", isOn: $enablePGA)
                            Toggle("LPGA", isOn: $enableLPGA)
                            Toggle("UEFA", isOn: $enableUEFA)
                            Toggle("EPL", isOn: $enableEPL)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("ESP", isOn: $enableESP)
                            Toggle("GER", isOn: $enableGER)
                            Toggle("ITA", isOn: $enableITA)
                            Toggle("NLL", isOn: $enableNLL)
                            
                        }
                    }
                }
                
                LabeledContent("Application") {
                    VStack(alignment: .leading, spacing: 8) {
                        LaunchAtLogin.Toggle()
                        
                        Button("Check for Updates") {
                            checkForUpdates()
                        }
                        .buttonStyle(.bordered)
                        .padding(.top, 8)
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .frame(maxWidth: 500, minHeight: 480, idealHeight: 800, maxHeight: .infinity)
    }
}
