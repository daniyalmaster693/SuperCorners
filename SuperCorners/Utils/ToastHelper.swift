//
//  ToastHelper.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-24.
//

import SwiftUI

func showSuccessToast(_ message: String = "Action Completed", icon: Image? = nil) {
    DispatchQueue.main.async {
        let toast = ToastWindowController()
        toast.showToast(
            message: message,
            icon: icon ?? Image(systemName: "checkmark.circle.fill")
        )
    }
}

func showErrorToast(_ message: String = "Action Failed", icon: Image? = nil) {
    DispatchQueue.main.async {
        let toast = ToastWindowController()
        toast.showToast(
            message: message,
            icon: icon ?? Image(systemName: "x.circle.fill")
        )
    }
}
