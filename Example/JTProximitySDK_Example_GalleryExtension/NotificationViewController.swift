//
//  NotificationViewController.swift
//  JTProximitySDK_Example_GalleryExtension
//
//  Created by Marco Fraccaroli on 19/09/25.
//  Copyright © 2025 Marco Fraccaroli. All rights reserved.
//
import UIKit
import JTProximitySDK
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    private let galleryView = JTNotificationGalleryView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.galleryView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.galleryView)
        NSLayoutConstraint.activate([
            self.galleryView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.galleryView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.galleryView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.galleryView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    func didReceive(_ notification: UNNotification) {
        self.galleryView.configure(with: notification, in: self.extensionContext)
    }
}

