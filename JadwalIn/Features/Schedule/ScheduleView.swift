import SwiftUI

public struct ScheduleView: View {
    @EnvironmentObject var store: ScheduleStore
    @State private var selectedDay: DayOfWeek = .monday
    @State private var showingAddSheet = false
    @State private var courseToDelete: Course? = nil
    @State private var showingDeleteAlert = false
    
    private var coursesForDay: [Course] {
        store.coursesFor(day: selectedDay)
    }
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 1. Day Selector Strip (Monospace Cells)
                HStack(spacing: 4) {
                    ForEach(DayOfWeek.allCases.filter { $0 != .sunday }) { day in
                        let isSelected = selectedDay == day
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.12)) {
                                selectedDay = day
                            }
                        }) {
                            VStack(spacing: 3) {
                                Text(day.shortName.uppercased())
                                    .font(AppFont.monoTag())
                                    .foregroundColor(isSelected ? Theme.canvasBg : Theme.inkPrimary)
                                
                                Rectangle()
                                    .fill(isSelected ? Theme.safetyOrange : Color.clear)
                                    .frame(width: 8, height: 2)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(isSelected ? Theme.inkPrimary : Theme.subtleBg)
                            .cornerRadius(2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(isSelected ? Theme.inkPrimary : Theme.borderCrisp, lineWidth: 1)
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Theme.canvasBg)
                
                Divider()
                    .background(Theme.borderCrisp)
                
                // 2. Schedule Timeline List
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("JADWAL KULIAH // \(selectedDay.localizedName.uppercased())")
                                .font(AppFont.monoHeading())
                                .foregroundColor(Theme.inkPrimary)
                            
                            Spacer()
                            
                            Text("[\(coursesForDay.count) MATA KULIAH]")
                                .font(AppFont.monoCaption())
                                .foregroundColor(Theme.inkMuted)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 14)
                        
                        if coursesForDay.isEmpty {
                            Text("[TIDAK ADA PERKULIAHAN DI HARI \(selectedDay.localizedName.uppercased())]")
                                .font(AppFont.monoBody())
                                .foregroundColor(Theme.inkMuted)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 32)
                                .background(Theme.surfaceBg)
                                .cornerRadius(2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(Theme.borderCrisp, style: StrokeStyle(lineWidth: 1, dash: [4]))
                                )
                                .padding(.horizontal, 16)
                        } else {
                            VStack(spacing: 8) {
                                ForEach(Array(coursesForDay.enumerated()), id: \.element.id) { index, course in
                                    CourseCard(course: course)
                                        .contextMenu {
                                            Button(role: .destructive, action: {
                                                courseToDelete = course
                                                showingDeleteAlert = true
                                            }) {
                                                Label("Hapus Mata Kuliah", systemImage: "trash")
                                            }
                                        }
                                    
                                    // Visual break indicator
                                    if index < coursesForDay.count - 1 {
                                        let next = coursesForDay[index + 1]
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
                        
                        Spacer(minLength: 32)
                    }
                }
                .background(Theme.canvasBg)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Text("+ MATKUL")
                            .font(AppFont.monoTag())
                            .foregroundColor(Theme.canvasBg)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Theme.inkPrimary)
                            .cornerRadius(2)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddCourseSheet()
            }
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("HAPUS MATA KULIAH"),
                    message: Text("Mata kuliah \(courseToDelete?.name ?? "") beserta seluruh data tugas terkait akan dihapus."),
                    primaryButton: .destructive(Text("HAPUS")) {
                        if let course = courseToDelete {
                            store.deleteCourse(id: course.id)
                        }
                    },
                    secondaryButton: .cancel(Text("BATAL"))
                )
            }
            .onAppear {
                let today = DayOfWeek.from(date: Date())
                if today != .sunday {
                    selectedDay = today
                }
            }
        }
    }
}
