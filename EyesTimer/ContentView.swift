//
//  ContentView.swift
//  EyesTimer
//
//  Created by 탐코퍼레이션 iMac2 on 9/25/23.
//

import AudioToolbox
import SwiftUI

struct ContentView: View {
    @State private var isATimerRunning = false
    @State private var isBTimerRunning = false
    @State private var aElapsedTime: TimeInterval = 0
    @State private var bElapsedTime: TimeInterval = 0
    @State private var aTimer: Timer? = nil
    @State private var bTimer: Timer? = nil

    private var aTimerTime: Double = 30 * 60
    private var bTimerTime: Double = 2 * 60 * 60

    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("인공 눈물: \(formattedTime(aTimerTime - aElapsedTime))")
                Button(action: {
                    toggleATimer()
                }) {
                    Text(isATimerRunning ? "정지 및 초기화" : "시작")
                }
            }
            Spacer()
            VStack {
                Text("항생제 / 근시퇴행 안약: \(formattedTime(bTimerTime - bElapsedTime))")
                Button(action: {
                    toggleBTimer()
                }) {
                    Text(isBTimerRunning ? "정지 및 초기화" : "시작")
                }
            }
            Spacer()
        }
    }

    func toggleATimer() {
        isATimerRunning.toggle()

        if isATimerRunning {
            aTimer?.invalidate()
            aTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if aElapsedTime < aTimerTime {
                    aElapsedTime += 1
                } else {
                    aTimer?.invalidate()
                    isATimerRunning = false
                }
                if Int(aElapsedTime) % Int(aTimerTime) == 0 {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    aElapsedTime = 0
                }
            }
            aTimer?.fire()
        } else {
            aTimer?.invalidate()
            aElapsedTime = 0
        }
    }

    func toggleBTimer() {
        isBTimerRunning.toggle()

        if isBTimerRunning {
            bTimer?.invalidate()
            bTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if bElapsedTime < bTimerTime {
                    bElapsedTime += 1
                } else {
                    bTimer?.invalidate()
                    isBTimerRunning = false
                }
                if Int(bElapsedTime) % Int(bTimerTime) == 0 {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    bElapsedTime = 0
                }
            }
            bTimer?.fire()
        } else {
            bTimer?.invalidate()
            bElapsedTime = 0
        }
    }

    func formattedTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

#Preview {
    ContentView()
}
