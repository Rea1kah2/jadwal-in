import SwiftUI

public struct SettingsView: View {
    @EnvironmentObject var store: ScheduleStore
    @State private var showingResetAlert = false
    @State private var showingClearAlert = false
    
    public var body: some View {
        NavigationView {
            Form {
                // Section Persona Info
                Section(header: Text("Profil Pengguna (Persona)")) {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(Theme.navy)
                                .frame(width: 48, height: 48)
                            Text("R")
                                .font(AppFont.title2())
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Rani")
                                .font(AppFont.headline())
                                .foregroundColor(Theme.navy)
                            Text("Mahasiswa Semester 3 • 7 Mata Kuliah")
                                .font(AppFont.subheadline())
                                .foregroundColor(Theme.slateMuted)
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                // Section Summary Stats
                Section(header: Text("Ringkasan Data")) {
                    HStack {
                        Label("Total Mata Kuliah", systemImage: "book")
                        Spacer()
                        Text("\(store.courses.count)")
                            .foregroundColor(Theme.slate)
                            .bold()
                    }
                    
                    HStack {
                        Label("Tugas Aktif", systemImage: "clock")
                        Spacer()
                        Text("\(store.activeAssignments.count)")
                            .foregroundColor(Theme.tangerine)
                            .bold()
                    }
                    
                    HStack {
                        Label("Tugas Selesai", systemImage: "checkmark.circle")
                        Spacer()
                        Text("\(store.completedAssignments.count)")
                            .foregroundColor(Theme.emerald)
                            .bold()
                    }
                }
                
                // Section Filosofi Produk
                Section(header: Text("Tentang Jadwal-In")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Solusi Terarah untuk Mahasiswa")
                            .font(AppFont.headline())
                            .foregroundColor(Theme.navy)
                        
                        Text("Jadwal-In dirancang khusus berdasarkan studi kasus kebutuhan mahasiswa nyata: menggabungkan jadwal kelas mingguan dan pelacak deadline berorientasi urgensi dalam antarmuka zero-friction.")
                            .font(AppFont.body())
                            .foregroundColor(Theme.slateMuted)
                    }
                    .padding(.vertical, 4)
                    
                    HStack {
                        Text("Penyimpanan")
                        Spacer()
                        Text("100% Offline Lokal (JSON)")
                            .foregroundColor(Theme.slateMuted)
                    }
                    
                    HStack {
                        Text("Versi")
                        Spacer()
                        Text("1.0.0 (MVP Release)")
                            .foregroundColor(Theme.slateMuted)
                    }
                }
                
                // Section Manajemen Data
                Section(header: Text("Pengaturan Data")) {
                    Button(action: { showingResetAlert = true }) {
                        Label("Muat Ulang Data Sampel Rani", systemImage: "arrow.counterclockwise")
                            .foregroundColor(Theme.tangerine)
                    }
                    
                    Button(role: .destructive, action: { showingClearAlert = true }) {
                        Label("Hapus Seluruh Data", systemImage: "trash")
                            .foregroundColor(Theme.crimson)
                    }
                }
            }
            .navigationTitle("Pengaturan")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showingResetAlert) {
                Alert(
                    title: Text("Muat Ulang Data Sampel?"),
                    message: Text("Data saat ini akan digantikan dengan set data awal jadwal kuliah dan tugas Rani."),
                    primaryButton: .default(Text("Muat Ulang")) {
                        store.loadSampleData()
                    },
                    secondaryButton: .cancel(Text("Batal"))
                )
            }
            .alert(isPresented: $showingClearAlert) {
                Alert(
                    title: Text("Hapus Seluruh Data?"),
                    message: Text("Tindakan ini akan mengosongkan seluruh mata kuliah dan tugas yang tersimpan."),
                    primaryButton: .destructive(Text("Hapus Semua")) {
                        store.clearAllData()
                    },
                    secondaryButton: .cancel(Text("Batal"))
                )
            }
        }
    }
}
