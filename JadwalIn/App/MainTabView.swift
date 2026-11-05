import SwiftUI

public struct MainTabView: View {
    @StateObject private var store = ScheduleStore()
    
    public init() {}
    
    public var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("Hari Ini", systemImage: "sun.max.fill")
                }
            
            ScheduleView()
                .tabItem {
                    Label("Jadwal", systemImage: "calendar")
                }
            
            AssignmentsView()
                .tabItem {
                    Label("Tugas", systemImage: "checklist")
                }
            
            SettingsView()
                .tabItem {
                    Label("Pengaturan", systemImage: "gearshape")
                }
        }
        .accentColor(Theme.tangerine)
        .environmentObject(store)
    }
}
