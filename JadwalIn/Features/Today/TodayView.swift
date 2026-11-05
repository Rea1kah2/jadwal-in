import SwiftUI

public struct TodayView: View {
    @EnvironmentObject var store: ScheduleStore
    @State private var showingAddAssignment = false
    @State private var showingAddCourse = false
    
    private var todayDayOfWeek: DayOfWeek {
        DayOfWeek.from(date: Date())
    }
    
    private var todayCourses: [Course] {
        store.coursesFor(day: todayDayOfWeek)
    }
    
    private var urgentTasks: [Assignment] {
        store.activeAssignments.filter { task in
            let diffH = task.dueDate.timeIntervalSince(Date()) / 3600
            return diffH <= 48
        }
    }
    
    private var nextUpcomingCourse: Course? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let currentHM = formatter.string(from: Date())
        return todayCourses.first(where: { $0.startTime > currentHM })
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 1. Technical Header Strip
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("JADWAL-IN // ACADEMIC OS")
                                .font(AppFont.monoTag())
                                .foregroundColor(Theme.safetyOrange)
                            
                            Spacer()
                            
                            Text("STATUS: AKTIF")
                                .font(AppFont.monoCaption())
                                .foregroundColor(Theme.inkSecondary)
                        }
                        
                        Text(Date().localizedDayAndDate.uppercased())
                            .font(AppFont.monoHeading())
                            .foregroundColor(Theme.inkPrimary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    Divider()
                        .background(Theme.inkPrimary)
                    
                    // 2. NOW / NEXT GLANCE BOX
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("BERIKUTNYA HARI INI")
                                .font(AppFont.monoCaption())
                                .foregroundColor(Theme.canvasBg)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Theme.inkPrimary)
                                .cornerRadius(2)
                            
                            Spacer()
                            
                            if let next = nextUpcomingCourse {
                                Text("MULAI: [\(next.startTime)]")
                                    .font(AppFont.monoTag())
                                    .foregroundColor(Theme.safetyOrange)
                            } else {
                                Text("[✓ SEMUA KELAS SELESAI]")
                                    .font(AppFont.monoTag())
                                    .foregroundColor(Theme.emeraldSuccess)
                            }
                        }
                        
                        if let next = nextUpcomingCourse {
                            Text(next.name)
                                .font(AppFont.headline())
                                .foregroundColor(Theme.inkPrimary)
                            
                            HStack(spacing: 12) {
                                Text("RUANG: [\(next.room.isEmpty ? "TBA" : next.room)]")
                                Text("DOSEN: [\(next.lecturer.isEmpty ? "TBA" : next.lecturer)]")
                            }
                            .font(AppFont.monoCaption())
                            .foregroundColor(Theme.inkSecondary)
                        } else {
                            Text(todayCourses.isEmpty ? "Tidak ada perkuliahan hari ini." : "Seluruh perkuliahan hari ini telah berakhir.")
                                .font(AppFont.body())
                                .foregroundColor(Theme.inkSecondary)
                        }
                    }
                    .padding(14)
                    .background(Theme.surfaceBg)
                    .cornerRadius(2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(Theme.borderCrisp, lineWidth: 1)
                    )
                    .padding(.horizontal, 16)
                    
                    // 3. TIMELINE KULIAH HARI INI
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("01 // TIMELINE KULIAH HARI INI")
                                .font(AppFont.monoHeading())
                                .foregroundColor(Theme.inkPrimary)
                            
                            Spacer()
                            
                            Text("[\(todayCourses.count) KELAS]")
                                .font(AppFont.monoCaption())
                                .foregroundColor(Theme.inkMuted)
                        }
                        .padding(.horizontal, 16)
                        
                        if todayCourses.isEmpty {
                            Text("[TIDAK ADA JADWAL KULIAH HARI INI]")
                                .font(AppFont.monoBody())
                                .foregroundColor(Theme.inkMuted)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 24)
                                .background(Theme.surfaceBg)
                                .cornerRadius(2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(Theme.borderCrisp, style: StrokeStyle(lineWidth: 1, dash: [4]))
                                )
                                .padding(.horizontal, 16)
                        } else {
                            VStack(spacing: 8) {
                                ForEach(Array(todayCourses.enumerated()), id: \.element.id) { index, course in
                                    CourseCard(course: course)
                                    
                                    // Visual break indicator between classes
                                    if index < todayCourses.count - 1 {
                                        let next = todayCourses[index + 1]
                                        HStack {
                                            Rectangle()
                                                .frame(height: 1)
                                                .foregroundColor(Theme.borderCrisp)
                                            
                                            Text("--- ☕ JEDA KULIAH (\(course.endTime) s/d \(next.startTime)) ---")
                                                .font(AppFont.monoCaption())
                                                .foregroundColor(Theme.inkSecondary)
                                                .padding(.horizontal, 4)
                                            
                                            Rectangle()
                                                .frame(height: 1)
                                                .foregroundColor(Theme.borderCrisp)
                                        }
                                        .padding(.vertical, 4)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    
                    // 4. DEADLINE KRITIS (< 48 JAM)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("02 // DEADLINE KRITIS (< 48 JAM)")
                                .font(AppFont.monoHeading())
                                .foregroundColor(Theme.safetyOrange)
                            
                            Spacer()
                            
                            Text("[\(urgentTasks.count) TUGAS]")
                                .font(AppFont.monoCaption())
                                .foregroundColor(Theme.safetyOrange)
                        }
                        .padding(.horizontal, 16)
                        
                        if urgentTasks.isEmpty {
                            Text("[DEADLINE HORIZON CLEAR // NOL TUGAS MENDESAK]")
                                .font(AppFont.monoBody())
                                .foregroundColor(Theme.inkMuted)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 20)
                                .background(Theme.surfaceBg)
                                .cornerRadius(2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(Theme.borderCrisp, style: StrokeStyle(lineWidth: 1, dash: [4]))
                                )
                                .padding(.horizontal, 16)
                        } else {
                            VStack(spacing: 8) {
                                ForEach(urgentTasks) { task in
                                    AssignmentRow(
                                        assignment: task,
                                        course: store.course(for: task.courseId),
                                        onToggle: {
                                            withAnimation(.easeInOut(duration: 0.15)) {
                                                store.toggleAssignmentCompletion(id: task.id)
                                            }
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    
                    Spacer(minLength: 32)
                }
            }
            .background(Theme.canvasBg.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { showingAddAssignment = true }) {
                            Label("Catat Tugas Baru", systemImage: "checklist")
                        }
                        Button(action: { showingAddCourse = true }) {
                            Label("Tambah Mata Kuliah", systemImage: "plus.rectangle.on.rectangle")
                        }
                    } label: {
                        Text("+ ENTRY")
                            .font(AppFont.monoTag())
                            .foregroundColor(Theme.canvasBg)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Theme.inkPrimary)
                            .cornerRadius(2)
                    }
                }
            }
            .sheet(isPresented: $showingAddAssignment) {
                AddAssignmentSheet()
            }
            .sheet(isPresented: $showingAddCourse) {
                AddCourseSheet()
            }
        }
    }
}
