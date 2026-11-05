# Product: Jadwal-In

## 1. Product Discovery & Problem Framing

### A. Observasi & Pain Points Lapangan
1. **Pain Point Berulang:** Mahasiswa aktif rata-rata mengambil 6–8 mata kuliah per semester dengan jadwal, dosen, ruangan, dan deadline tugas yang heterogen. Sering kali tugas terlewat atau dikerjakan mepet (sistem kebut semalam) akibat ketiadaan visibilitas urgensi.
2. **Proses Manual yang Rawan Error:** Mayoritas mahasiswa mencatat deadline tugas di grup WhatsApp, sticky notes, atau aplikasi catatan umum (bawaan ponsel). Catatan ini terkubur dalam pesan chat harian dan tidak memiliki sistem pengingat kontekstual per mata kuliah.
3. **Kesenjangan Solusi yang Ada:**
   - *Aplikasi To-Do List Umum (Todoist, TickTick, Notion):* Terlalu banyak fitur (subtask, tags, projects, kanban) yang menimbulkan kelelahan konfigurasi (*cognitive load* tinggi).
   - *Buku Catatan / GoodNotes:* Pasif, tidak bisa menghitung countdown sisa jam deadline, dan tidak memberi indikator urgensi visual.

### B. User Persona
- **Nama Persona:** Rani, 20 tahun.
- **Profil:** Mahasiswa Semester 3 Jurusan Teknik / Sistem Informasi, mengambil 7 mata kuliah aktif.
- **Karakteristik & Perilaku:**
  - Membawa iPhone ke mana-mana di kampus.
  - Sering berpindah gedung kuliah setiap 2–3 jam.
  - Membutuhkan jawaban instan atas 2 pertanyaan setiap saat:
    1. *"Hari ini saya ada kelas apa saja dan di ruangan mana?"*
    2. *"Tugas apa yang paling mendesak harus dikumpulkan dalam 24–48 jam ke depan?"*
- **Toleransi Friction:** Nol toleransi untuk aplikasi rumit. Waktu buka aplikasi hingga tahu jadwal/tugas harus di bawah 3 detik.

### C. Problem Statement
> **"Mahasiswa aktif seperti Rani membutuhkan aplikasi pelacak jadwal kuliah dan deadline tugas yang terintegrasi, mudah diakses dalam < 3 detik, dan memiliki indikator visual urgensi yang jelas, karena sistem pencatatan manual sering terlupakan dan aplikasi to-do list umum terlalu kompleks untuk kebutuhan akademis harian."**

---

## 2. Definisi Cakupan MVP (Minimum Viable Product)

Untuk mencegah *scope creep*, fitur diklasifikasikan dengan ketat:

### Tier 1 (MVP Inti - Fokus Release 1.0)
- **Katalog Mata Kuliah:** Nama matkul, kode, dosen, ruangan, hari & jam kelas, serta kode warna pembeda.
- **Layar Today (Hari Ini):** Menampilkan kelas hari ini sesuai hari berjalan + daftar deadline tugas mendesak.
- **Layar Jadwal (Schedule):** Matriks jadwal mingguan (Senin s/d Sabtu).
- **Layar Tugas (Assignments):** Daftar tugas aktif, sortir otomatis berdasarkan deadline terdekat, dan filter per mata kuliah.
- **Urgensi Visual Cerdas:** Indikator badge warna (*Mendesak < 24 jam* [Oranye/Merah], *Mendekati < 3 hari* [Amber], *Aman* [Slate]).
- **Penyimpanan Offline Lokal:** 100% data tersimpan di perangkat tanpa butuh login atau server luar.

### Tier 2 (Post-MVP / Iterasi Berikutnya)
- Push notifications / local notifications background alert.
- Ekspor kalender ke format `.ics` / Apple Calendar.
- Widget iOS Home Screen & Lock Screen.
- Sinkronisasi CloudKit multi-device.

---

## 3. Core Principles
1. **Academic Context-First:** Semua tugas wajib terikat pada mata kuliah (tidak ada tugas mengambang tanpa konteks).
2. **Instant Clarity:** Waktu tersisa tugas dihitung secara dinamis dan ditampilkan dalam format manusiawi (*"Tersisa 14 jam"*, *"Besok, 23:59"*).
3. **Academic Modern Aesthetics:** Palet warna tenang (Navy `#0F172A`, Slate `#334155`) dengan aksen Tangerine/Amber tegas untuk urgensi tugas tanpa kesan berantakan.
4. **Zero Account Friction:** Buka langsung pakai, tidak ada formulir pendaftaran, offline-first.

---

## 4. KPI Sukses (Fase Evaluasi Pengguna)
- Waktu membuka aplikasi hingga melihat deadline terdekat ≤ 3 detik.
- Waktu membuat tugas baru ≤ 10 detik.
- Zero data loss saat aplikasi ditutup mendadak.
