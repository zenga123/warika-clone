// ColorExtension.swift
import SwiftUI

extension Color {
    static let walicaPrimary = Color(red: 242/255, green: 126/255, blue: 107/255)
    static let walicaBackground = Color(red: 245/255, green: 245/255, blue: 245/255)
    
    // 시스템 모드에 따라 자동으로 조정되는 색상들
    static let walicaBackgroundAuto = Color(UIColor.systemBackground)
    static let walicaCardBackground = Color(UIColor.secondarySystemBackground)
    static let walicaLabelPrimary = Color(UIColor.label)
    static let walicaLabelSecondary = Color(UIColor.secondaryLabel)
}
