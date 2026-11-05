# Implementation Tasks: Jadwal-In Core Schedule & Assignments

- [x] **1. Scaffolding Proyek & Konfigurasi Xcode**
  - [x] 1.1 Buat struktur direktori `JadwalIn/` (`App/`, `Models/`, `Store/`, `Features/`, `Shared/`, `Assets.xcassets/`)
  - [x] 1.2 Buat berkas konfigurasi proyek Xcode `JadwalIn.xcodeproj/project.pbxproj` yang mengikat seluruh target Swift

- [x] **2. Tipe Data Inti (Models Layer)**
  - [x] 2.1 Buat `DayOfWeek.swift` dengan urutan hari 1–7 (Senin–Minggu) dan nama lokal Indonesia
  - [x] 2.2 Buat `Priority.swift` dengan enum Rendah, Sedang, Tinggi beserta token warna aksen
  - [x] 2.3 Buat `Course.swift` dengan properti lengkap mata kuliah dan helper format rentang jam
  - [x] 2.4 Buat `Assignment.swift` dengan kalkulator dinamis sisa jam deadline, `UrgencyLevel`, dan format waktu manusiawi

- [x] **3. State Manager & Persistensi JSON (Store Layer)**
  - [x] 3.1 Buat `ScheduleStore.swift` dengan protokol `ObservableObject` dan properti `@Published`
  - [x] 3.2 Terapkan mekanisme atomic read/write JSON ke direktori App Documents
  - [x] 3.3 Tambahkan fungsi CRUD untuk Course dan Assignment
  - [x] 3.4 Sediakan dataset awal realistis (Rani's Semester 3 Sample Data) jika berkas storage belum ada

- [x] **4. Desain Sistem & Shared Components (Design System)**
  - [x] 4.1 Buat `ColorTokens.swift` (Deep Navy `#0F172A`, Slate, Warm Tangerine `#EA580C`, Academic Amber `#F59E0B`, Emerald)
  - [x] 4.2 Buat `Typography.swift` (standar hirarki tipografi SF Pro)
  - [x] 4.3 Buat `UrgencyBadge.swift` (penanda visual badge waktu sisa tugas)
  - [x] 4.4 Buat `EmptyStateView.swift` (tampilan ramah saat daftar kosong)
  - [x] 4.5 Buat `Date+Extensions.swift` (formatter tanggal & hari dalam Bahasa Indonesia)

- [x] **5. Fitur Layar Today (Daily Dashboard)**
  - [x] 5.1 Buat `TodayView.swift` menampilkan salam kontekstual & tanggal hari ini
  - [x] 5.2 Tampilkan kartu kelas hari ini yang diurutkan dari jam termuda
  - [x] 5.3 Tampilkan seksi "Deadline Mendesak" (< 3 hari) dengan indikator sisa waktu

- [x] **6. Fitur Layar Jadwal (Weekly Schedule)**
  - [x] 6.1 Buat `ScheduleView.swift` dengan pemilih hari (Senin s/d Sabtu)
  - [x] 6.2 Buat `CourseCard.swift` untuk menampilkan detail kelas, ruangan, dan dosen
  - [x] 6.3 Buat `AddCourseSheet.swift` untuk formulir penambahan mata kuliah baru

- [x] **7. Fitur Layar Tugas (Assignment Tracker)**
  - [x] 7.1 Buat `AssignmentsView.swift` dengan filter chip per mata kuliah dan tab Aktif / Selesai
  - [x] 7.2 Buat `AssignmentRow.swift` dengan tombol checklist interaktif dan badge urgensi
  - [x] 7.3 Buat `AddAssignmentSheet.swift` dengan pemilih matkul, DatePicker, dan selector prioritas

- [x] **8. Fitur Pengaturan & Navigasi Utama**
  - [x] 8.1 Buat `SettingsView.swift` (informasi persona Rani, statistik data tersimpan, tombol reset sample data)
  - [x] 8.2 Buat `MainTabView.swift` menghubungkan 4 tab (Hari Ini, Jadwal, Tugas, Pengaturan)
  - [x] 8.3 Buat `JadwalInApp.swift` sebagai App lifecycle entry point

- [x] **9. Pengujian Unit & Verifikasi Build**
  - [x] 9.1 Buat unit test suite `JadwalInTests.swift` (pengujian kalkulasi deadline, sorting, dan serialisasi store)
  - [x] 9.2 Jalankan build & unit tests menggunakan `xcodebuild` untuk memverifikasi nol error
