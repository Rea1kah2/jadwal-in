import SwiftUI

public struct AddCourseSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store: ScheduleStore
    
    @State private var name: String = ""
    @State private var code: String = ""
    @State private var lecturer: String = ""
    @State private var room: String = ""
    @State private var selectedDay: DayOfWeek = .monday
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date().addingTimeInterval(7200) // +2 hours
    @State private var selectedColorHex: String = "1E3A8A"
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    public var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informasi Mata Kuliah")) {
                    TextField("Nama Mata Kuliah (misal: Algoritma)", text: $name)
                    TextField("Kode Matkul (misal: IF2101)", text: $code)
                    TextField("Nama Dosen Pengampu", text: $lecturer)
                    TextField("Ruangan / Lab (misal: R.304)", text: $room)
                }
                
                Section(header: Text("Waktu Perkuliahan")) {
                    Picker("Hari Kuliah", selection: $selectedDay) {
                        ForEach(DayOfWeek.allCases) { day in
                            Text(day.localizedName).tag(day)
                        }
                    }
                    
                    DatePicker("Jam Mulai", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("Jam Selesai", selection: $endTime, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("Warna Penanda")) {
                    HStack(spacing: 12) {
                        ForEach(Course.presetColors, id: \.self) { colorHex in
                            ZStack {
                                Circle()
                                    .fill(Color(hex: colorHex))
                                    .frame(width: 32, height: 32)
                                
                                if selectedColorHex == colorHex {
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                        .frame(width: 24, height: 24)
                                }
                            }
                            .onTapGesture {
                                selectedColorHex = colorHex
                            }
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("Tambah Mata Kuliah")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Simpan") {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "HH:mm"
                        
                        let newCourse = Course(
                            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                            code: code.trimmingCharacters(in: .whitespacesAndNewlines),
                            lecturer: lecturer.trimmingCharacters(in: .whitespacesAndNewlines),
                            room: room.trimmingCharacters(in: .whitespacesAndNewlines),
                            dayOfWeek: selectedDay,
                            startTime: formatter.string(from: startTime),
                            endTime: formatter.string(from: endTime),
                            colorHex: selectedColorHex
                        )
                        store.addCourse(newCourse)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
}
