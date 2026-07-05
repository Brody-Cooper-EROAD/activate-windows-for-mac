//
//  ActivateMacApp.swift
//  ActivateMac
//
//  Created by Bùi Đặng Bình on 5/4/25.
//  Modified by Brody Cooper on 2/7/26
//

import SwiftUI

@main
struct ActivateMacApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    var watermarkWindows: [NSWindow] = []
    var isVisible = true

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        registerFont(named: "segoeuil")
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screensChanged),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil
        )
        createWatermarkWindows()
        setupStatusBarItem()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func screensChanged() {
        watermarkWindows.forEach { $0.close() }
        watermarkWindows.removeAll()
        createWatermarkWindows()
    }
    
    func registerFont(named fileName: String) {
        guard let fontURL = Bundle.main.url(forResource: fileName, withExtension: "ttf"),
              let fontData = try? Data(contentsOf: fontURL),
              let provider = CGDataProvider(data: fontData as CFData),
              let font = CGFont(provider) else {
            print("Failed to load font: \(fileName)")
            return
        }

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            print("Error registering font: \(error.debugDescription)")
        }
    }

    func createWatermarkWindows() {
        
        for screen in NSScreen.screens {
            
            let contentView = WatermarkView()
            
            // bottom right corner pos
            let screenFrame = screen.visibleFrame
            let windowSize = NSSize(width: 300, height: 60)
            let windowOrigin = NSPoint(
                x: screenFrame.maxX - round(screenFrame.width * 0.02) - windowSize.width,
                y: screenFrame.minY + round(screenFrame.height * 0.04)
            )
            print("Min Y: \(screenFrame.minY)")
            
            let window = NSWindow(
                contentRect: NSRect(origin: windowOrigin, size: windowSize),
                styleMask: [.borderless],
                backing: .buffered,
                defer: false
            )
            
            window.contentView = NSHostingView(rootView: contentView)
            window.backgroundColor = .clear
            window.isOpaque = false
            window.hasShadow = false
            window.level = .floating
            window.ignoresMouseEvents = true
            window.collectionBehavior = [.canJoinAllSpaces, .stationary]
            
            window.makeKeyAndOrderFront(nil)
            
            watermarkWindows.append(window)
        }
    }

    func setupStatusBarItem() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusBarItem.button {
            button.title = "WM"
        }

        let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "Toggle Watermark", action: #selector(toggleWatermark(_:)), keyEquivalent: "t"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp(_:)), keyEquivalent: "q"))

        statusBarItem.menu = menu
    }

    @objc func toggleWatermark(_ sender: NSMenuItem) {
        isVisible.toggle()

        for window in watermarkWindows {
            if isVisible {
                window.makeKeyAndOrderFront(nil)
            } else {
                window.makeKeyAndOrderFront(nil)
            }
        }
    }

    @objc func quitApp(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
