# Tech Baseline: Jadwal-In

## 1. Stack & Runtime
- **Target OS:** iOS 16.0+
- **Toolchain:** Xcode 14.2+ / Swift 5.7+
- **UI Framework:** SwiftUI (Declarative, reactive UI)
- **Architecture Pattern:** MVVM (Model - View - ViewModel) didukung Shared Observable Store
- **Third-Party Dependencies:** **ZERO** (Hanya menggunakan Apple Foundation, SwiftUI, Combine, dan OS standard libraries).

## 2. State & Data Persistence
- **State Management:** `ObservableObject` dengan properti `@Published` untuk pembaruan UI instan.
- **Penyimpanan:** Dokumen lokal JSON persisten (`jadwalin_store.json`) di direktori dokumen sandbox aplikasi (`FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)`).
- **Integritas Data:** Atomic writing (`Data.write(to:options: .atomic)`) untuk menjamin tidak ada korupsi berkas saat crash atau interupsi sistem.
- **Offline First:** 100% fungsional tanpa koneksi internet.

## 3. Batasan Teknis & Aturan Rekayasa
- **No Third-Party Bloat:** Dilarang memasukkan library pihak ketiga jika fiturnya dapat diselesaikan menggunakan standard library Swift/SwiftUI.
- **Thread Safety:** Semua mutasi state UI dan store wajib dijalankan di `@MainActor`.
- **Date Handling:** Menggunakan `Calendar.current` dan `DateFormatter` standar dengan locale `id_ID` untuk tampilan hari dan jam kuliah di Indonesia.
