//
//  SelectedCornerState.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-31.
//

import Foundation

enum SelectedCornerPosition {
    case topLeft, topRight, bottomLeft, bottomRight, top, left, right, bottom
}

var currentlySelectedCorner: SelectedCornerPosition?
