import SwiftUI

public struct AddAssignmentSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store: ScheduleStore
    
    @State private var selectedCourseId: UUID? = nil
    @State private var title: String = ""
    @State private var dueDate: Date = Date().addingTimeInterval(86400 * 2) // Default +2 days
    @State private var priority: Priority = .medium
    @State private var notes: String = ""
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (selectedCourseId != nil || !store.courses.isEmpty)
    }
    
    public var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Mata Kuliah")) {
                    if store.courses.isEmpty {
                        Text("Belum ada mata kuliah terdaftar. Silakan tambah mata kuliah di menu Jadwal terlebih dahulu.")
                            .font(AppFont.subheadline())
                            .foregroundColor(Theme.crimson)
                    } else {
                        Picker("Pilih Mata Kuliah", selection: Binding(
                            get: { selectedCourseId ?? store.courses.first?.id ?? UUID() },
                            set: { selectedCourseId = $0 }
                        )) {
                            ForEach(store.courses) { course in
                                HStack {
                                    Circle()
                                        .fill(course.accentColor)
                                        .frame(width: 8, height: 8)
                                    Text(course.name)
                                }
                                .tag(course.id)
                            }
                        }
                    }
                }
                
                Section(header: Text("Detail Tugas")) {
                    TextField("Judul Tugas (misal: Laporan Praktikum)", text: $title)
                    
                    DatePicker("Batas Waktu (Deadline)", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    
                    Picker("Prioritas", selection: $priority) {
                        ForEach(Priority.allCases) { p in
                            Text(p.rawValue).tag(p)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Catatan Tambahan (Opsional)")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
                }
            }
            .navigationTitle("Catat Tugas Baru")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Simpan") {
                        let finalCourseId = selectedCourseId ?? store.courses.first?.id ?? UUID()
                        let newAssignment = Assignment(
                            courseId: finalCourseId,
                            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                            dueDate: dueDate,
                            priority: priority,
                            isCompleted: false,
                            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                        store.addAssignment(newAssignment)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(!isFormValid)
                }
            }
            .onAppear {
                if selectedCourseId == nil {
                    selectedCourseId = store.courses.first?.id
                }
            }
        }
    }
}
