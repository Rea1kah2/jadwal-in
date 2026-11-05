# Code Conventions & Design System: Jadwal-In

## 1. Aturan Penulisan Kode Swift
- **Naming:** Gunakan *UpperCamelCase* untuk tipe (`Course`, `ScheduleStore`) dan *lowerCamelCase* untuk variabel/metode (`dueDate`, `toggleCompletion`).
- **Immutability:** Selalu prioritaskan `let` kecuali nilai memang harus bermutasi (`var`).
- **Nil Safety:** Hindari *force unwrapping* (`!`). Gunakan `guard let` atau *optional chaining* (`?`).
- **View Decomposition:** Jangan biarkan sebuah `body` SwiftUI melebihi 100 baris. Pecah sub-komponen menjadi computed properties atau subview privat.

---

## 2. Tema Desain: Academic Modern
Desain mengacu pada standar editorial akademik modern: bersih, berwibawa, dan kontras tinggi untuk memudahkan membaca saat bergerak cepat di kampus.

### Token Warna (Color Tokens)
- **Deep Navy (Brand Primary):** `Color(hex: "0F172A")` / `Color.primary` di dark mode.
- **Slate Accent (Secondary):** `Color(hex: "334155")` dan `Color(hex: "64748B")`.
- **Warm Tangerine (Urgent Accent):** `Color(hex: "EA580C")` — Digunakan untuk deadline < 24 jam dan tombol aksi penting.
- **Academic Amber (Warning/Approaching):** `Color(hex: "F59E0B")` — Digunakan untuk deadline 1–3 hari.
- **Sage Success (Completed):** `Color(hex: "10B981")` — Untuk penanda tugas selesai.
- **Canvas Background:** `Color(hex: "F8FAFC")` di light mode / `Color(hex: "0B0F17")` di dark mode.
- **Card Surface:** `Color.white` di light mode / `Color(hex: "1E293B")` di dark mode.

### Hirarki Tipografi
- **Header Layar:** SF Pro Rounded, Bold, 28pt.
- **Nama Matkul / Judul Tugas:** SF Pro Text, Semibold, 17pt.
- **Info Jam / Ruangan:** SF Pro Text, Regular, 14pt (Slate secondary).
- **Badge Urgensi:** SF Pro Text, Bold, 12pt uppercase/pill.
