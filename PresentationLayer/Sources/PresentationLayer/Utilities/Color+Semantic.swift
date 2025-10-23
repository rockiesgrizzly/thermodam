//
//  Color+Semantic.swift
//  PresentationLayer
//
//  Created by Josh MacDonald on 10/23/25.
//
//  Semantic colors that adapt to light/dark mode and work cross-platform

import SwiftUI

extension Color {
    // MARK: - Backgrounds

    /// Primary background color (white in light mode, black in dark mode)
    static var systemBackground: Color {
        #if os(iOS)
        Color(UIColor.systemBackground)
        #elseif os(macOS)
        Color(NSColor.windowBackgroundColor)
        #endif
    }

    /// Secondary background color (light gray in light mode, dark gray in dark mode)
    static var secondaryBackground: Color {
        #if os(iOS)
        Color(UIColor.secondarySystemBackground)
        #elseif os(macOS)
        Color(NSColor.controlBackgroundColor)
        #endif
    }

    // MARK: - Text/Foreground

    /// Primary text color (black in light mode, white in dark mode)
    static var label: Color {
        #if os(iOS)
        Color(UIColor.label)
        #elseif os(macOS)
        Color(NSColor.labelColor)
        #endif
    }

    /// Secondary text color (dimmed)
    static var secondaryLabel: Color {
        #if os(iOS)
        Color(UIColor.secondaryLabel)
        #elseif os(macOS)
        Color(NSColor.secondaryLabelColor)
        #endif
    }

    /// Tertiary text color (most dimmed)
    static var tertiaryLabel: Color {
        #if os(iOS)
        Color(UIColor.tertiaryLabel)
        #elseif os(macOS)
        Color(NSColor.tertiaryLabelColor)
        #endif
    }
}
