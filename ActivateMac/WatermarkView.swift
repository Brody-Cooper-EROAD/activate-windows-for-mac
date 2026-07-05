//
//  WatermarkView.swift
//  ActivateMac
//
//  Created by Bùi Đặng Bình on 5/4/25.
//  Modified by Brody Cooper on 2/7/26
//

import SwiftUI

struct WatermarkView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Activate Windows")
                .font(.custom("Segoe UI Light", size: 20))
                .foregroundColor(.white.opacity(0.4))
            Text("Go to Settings to activate Windows.")
                .font(.custom("Segoe UI Light", size: 14))
                .foregroundColor(.white.opacity(0.4))
        }
        .padding(.leading, 12)
        .padding(.bottom, 12)
    }
}
