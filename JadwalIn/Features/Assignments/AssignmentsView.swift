import SwiftUI

public struct AssignmentsView: View {
    @EnvironmentObject var store: ScheduleStore
    @State private var showingAddSheet = false
    @State private var selectedFilterCourseId: UUID? = nil
    @State private var selectedTab: Int = 0 // 0 = Aktif, 1 = Selesai
    @State private var assignmentToDelete: Assignment? = nil
    @State private var showingDeleteAlert = false
    
    private var filteredAssignments: [Assignment] {
        let baseList = selectedTab == 0 ? store.activeAssignments : store.completedAssignments
        if let courseId = selectedFilterCourseId {
            return baseList.filter { $0.courseId == courseId }
        }
        return baseList
    }
    
    // Horizon groupings for active tasks
    private var horizonTodayAndTomorrow: [Assignment] {
        filteredAssignments.filter { task in
            let diffH = task.dueDate.timeIntervalSince(Date()) / 3600
            return diffH <= 48
        }
    }
    
    private var horizonThisWeek: [Assignment] {
        filteredAssignments.filter { task in
            let diffH = task.dueDate.timeIntervalSince(Date()) / 3600
            return diffH > 48 && diffH <= 168
        }
    }
    
    private var horizonUpcoming: [Assignment] {
        filteredAssignments.filter { task in
            let diffH = task.dueDate.timeIntervalSince(Date()) / 3600
            return diffH > 168
        }
    }
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 1. Swiss Segmented Switch
                HStack(spacing: 0) {
                    Button(action: { selectedTab = 0 }) {
                        Text("TUGAS AKTIF (\(store.activeAssignments.count))")
                            .font(AppFont.monoTag())
                            .foregroundColor(selectedTab == 0 ? Theme.canvasBg : Theme.inkSecondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(selectedTab == 0 ? Theme.inkPrimary : Color.clear)
                    }
                    
                    Button(action: { selectedTab = 1 }) {
                        Text("TERSELESAIKAN (\(store.completedAssignments.count))")
                            .font(AppFont.monoTag())
                            .foregroundColor(selectedTab == 1 ? Theme.canvasBg : Theme.inkSecondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(selectedTab == 1 ? Theme.inkPrimary : Color.clear)
                    }
                }
                .border(Theme.inkPrimary, width: 1)
                .cornerRadius(2)
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 6)
                .background(Theme.canvasBg)
                
                // 2. Course Filter Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        Button(action: { selectedFilterCourseId = nil }) {
                            Text("[SEMUA MATKUL]")
                                .font(AppFont.monoTag())
                                .foregroundColor(selectedFilterCourseId == nil ? Theme.canvasBg : Theme.inkSecondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(selectedFilterCourseId == nil ? Theme.inkPrimary : Theme.canvasBg)
                                .cornerRadius(2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(Theme.borderCrisp, lineWidth: 1)
                                )
                        }
                        
                        ForEach(store.courses) { course in
                            let isSelected = selectedFilterCourseId == course.id
                            Button(action: { selectedFilterCourseId = course.id }) {
                                Text("[\(course.code.isEmpty ? course.name : course.code)]")
                                    .font(AppFont.monoTag())
                                    .foregroundColor(isSelected ? Theme.canvasBg : Theme.inkSecondary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(isSelected ? Theme.inkPrimary : Theme.canvasBg)
                                    .cornerRadius(2)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 2)
                                            .stroke(Theme.borderCrisp, lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                }
                .background(Theme.canvasBg)
                
                Divider()
                    .background(Theme.borderCrisp)
                
                // 3. Dynamic Horizon Assignments List
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        if filteredAssignments.isEmpty {
                            Text("[NOL TUGAS PADA HORIZON FILTER INI]")
                                .font(AppFont.monoBody())
                                .foregroundColor(Theme.inkMuted)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 36)
                                .background(Theme.surfaceBg)
                                .cornerRadius(2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(Theme.borderCrisp, style: StrokeStyle(lineWidth: 1, dash: [4]))
                                )
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                        } else if selectedTab == 1 {
                            // Archive section for completed
                            VStack(alignment: .leading, spacing: 8) {
                                Text("ARSIP TUGAS TERSELESAIKAN [\(filteredAssignments.count) ENTRI]")
                                    .font(AppFont.monoHeading())
                                    .foregroundColor(Theme.inkSecondary)
                                    .padding(.horizontal, 16)
                                    .padding(.top, 12)
                                
                                ForEach(filteredAssignments) { task in
                                    AssignmentRow(
                                        assignment: task,
                                        course: store.course(for: task.courseId),
                                        onToggle: {
                                            withAnimation(.easeInOut(duration: 0.15)) {
                                                store.toggleAssignmentCompletion(id: task.id)
                                            }
                                        }
                                    )
                                    .padding(.horizontal, 16)
                                }
                            }
                        } else {
                            // Active Tasks by Horizon
                            if !horizonTodayAndTomorrow.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("01 // HARI INI & BESOK (KRITIS)")
                                            .font(AppFont.monoHeading())
                                            .foregroundColor(Theme.safetyOrange)
                                        Spacer()
                                        Text("[\(horizonTodayAndTomorrow.count) TUGAS]")
                                            .font(AppFont.monoCaption())
                                            .foregroundColor(Theme.safetyOrange)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.top, 8)
                                    
                                    ForEach(horizonTodayAndTomorrow) { task in
                                        AssignmentRow(
                                            assignment: task,
                                            course: store.course(for: task.courseId),
                                            onToggle: {
                                                withAnimation(.easeInOut(duration: 0.15)) {
                                                    store.toggleAssignmentCompletion(id: task.id)
                                                }
                                            }
                                        )
                                        .padding(.horizontal, 16)
                                    }
                                }
                            }
                            
                            if !horizonThisWeek.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("02 // MINGGU INI (2 — 7 HARI)")
                                            .font(AppFont.monoHeading())
                                            .foregroundColor(Theme.inkPrimary)
                                        Spacer()
                                        Text("[\(horizonThisWeek.count) TUGAS]")
                                            .font(AppFont.monoCaption())
                                            .foregroundColor(Theme.inkMuted)
                                    }
                                    .padding(.horizontal, 16)
                                    
                                    ForEach(horizonThisWeek) { task in
                                        AssignmentRow(
                                            assignment: task,
                                            course: store.course(for: task.courseId),
                                            onToggle: {
                                                withAnimation(.easeInOut(duration: 0.15)) {
                                                    store.toggleAssignmentCompletion(id: task.id)
                                                }
                                            }
                                        )
                                        .padding(.horizontal, 16)
                                    }
                                }
                            }
                            
                            if !horizonUpcoming.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("03 // MENDATANG & PROYEK (> 7 HARI)")
                                            .font(AppFont.monoHeading())
                                            .foregroundColor(Theme.inkSecondary)
                                        Spacer()
                                        Text("[\(horizonUpcoming.count) TUGAS]")
                                            .font(AppFont.monoCaption())
                                            .foregroundColor(Theme.inkMuted)
                                    }
                                    .padding(.horizontal, 16)
                                    
                                    ForEach(horizonUpcoming) { task in
                                        AssignmentRow(
                                            assignment: task,
                                            course: store.course(for: task.courseId),
                                            onToggle: {
                                                withAnimation(.easeInOut(duration: 0.15)) {
                                                    store.toggleAssignmentCompletion(id: task.id)
                                                }
                                            }
                                        )
                                        .padding(.horizontal, 16)
                                    }
                                }
                            }
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
                        Text("+ TUGAS")
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
                AddAssignmentSheet()
            }
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("HAPUS TUGAS"),
                    message: Text("Tugas \(assignmentToDelete?.title ?? "") akan dihapus secara permanen."),
                    primaryButton: .destructive(Text("HAPUS")) {
                        if let task = assignmentToDelete {
                            store.deleteAssignment(id: task.id)
                        }
                    },
                    secondaryButton: .cancel(Text("BATAL"))
                )
            }
        }
    }
}
