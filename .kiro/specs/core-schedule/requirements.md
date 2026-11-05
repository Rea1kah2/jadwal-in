# Requirements Specification: Jadwal-In Core Schedule & Assignments

## 1. Glosarium Istilah
- **Jadwal-In:** Aplikasi iOS native untuk manajemen jadwal kuliah mingguan dan pelacak tenggat waktu (deadline) tugas mahasiswa.
- **Course (Mata Kuliah):** Entitas mata kuliah akademik yang memuat nama, kode, nama dosen, ruangan kelas, hari dalam seminggu, jam mulai, jam selesai, dan warna penanda.
- **Assignment (Tugas):** Entitas tugas atau proyek yang wajib dikerjakan mahasiswa, terikat pada satu `Course`, memiliki judul, tanggal dan jam tenggat waktu (`dueDate`), tingkat prioritas, status selesai (`isCompleted`), dan catatan opsional.
- **Urgency Level:** Status kedekatan waktu pengumpulan tugas yang dikalkulasi otomatis:
  - *Mendesak (Critical):* Tenggat waktu < 24 jam ke depan (atau sudah lewat).
  - *Mendekati (Approaching):* Tenggat waktu antara 24 jam s/d 72 jam (1–3 hari).
  - *Santai (Upcoming):* Tenggat waktu > 72 jam (> 3 hari).

---

## 2. User Stories (Berdasarkan Persona Rani)
- **US-1 (Ikhtisar Hari Ini):** Sebagai mahasiswa yang sibuk, saya ingin melihat kelas apa saja yang saya miliki hari ini beserta tugas mendesak di satu layar utama, agar saya tidak salah ruang kelas dan tidak melewatkan tugas penting.
- **US-2 (Jadwal Mingguan Terstruktur):** Sebagai mahasiswa dengan 7 mata kuliah, saya ingin melihat jadwal kuliah Senin sampai Sabtu dalam tab khusus, agar saya dapat merencanakan kegiatan mingguan saya.
- **US-3 (Pencatatan Tugas Terkait Matkul):** Sebagai mahasiswa, saya ingin mencatat deadline tugas baru dengan menghubungkannya langsung ke mata kuliah yang bersangkutan, agar konteks tugas tetap jelas.
- **US-4 (Sortir Berdasarkan Urgensi):** Sebagai mahasiswa, saya ingin daftar tugas otomatis terurut dari deadline yang paling dekat dengan indikator visual yang mencolok, agar saya langsung tahu apa yang harus saya kerjakan duluan.
- **US-5 (Penyelesaian & Arsip):** Sebagai mahasiswa, saya ingin dapat mencentang tugas yang sudah selesai dan menyaring tampilan hanya tugas aktif, agar pikiran saya tidak terbebani tumpukan tugas lama.

---

## 3. Kriteria Penerimaan Berbasis EARS (MVP Tier 1)

### 3.1. Manajemen Mata Kuliah (Courses)
- **WHEN** pengguna membuka form tambah mata kuliah, **THE** Jadwal-In **SHALL** menampilkan form input yang mencakup nama matkul, kode, dosen, ruangan, hari kuliah, jam mulai, jam selesai, dan pilihan warna aksen.
- **IF** nama mata kuliah kosong atau jam selesai lebih awal dari jam mulai, **THEN THE** Jadwal-In **SHALL** menonaktifkan tombol simpan dan memberikan peringatan validasi form.
- **WHEN** form mata kuliah disimpan, **THE** Jadwal-In **SHALL** menyimpan mata kuliah ke dalam `ScheduleStore` dan memperbarui daftar mingguan seketika.
- **WHEN** pengguna menghapus mata kuliah, **THE** Jadwal-In **SHALL** menghapus seluruh data jadwal matkul tersebut dan menandai tugas terkait sebagai matkul tak bertuan atau menghapusnya secara bersih tanpa membuat aplikasi crash.

### 3.2. Layar Today (Ikhtisar Harian)
- **THE** Jadwal-In **SHALL** mendeteksi hari saat ini (`Date()`) dan secara otomatis menyaring serta menampilkan daftar kelas yang dijadwalkan pada hari tersebut, diurutkan berdasarkan jam mulai terawal.
- **IF** tidak ada jadwal kuliah pada hari tersebut, **THEN THE** Jadwal-In **SHALL** menyajikan pesan ramah *"Tidak ada kelas hari ini. Waktu tepat untuk menyelesaikan tugas!"*.
- **THE** Jadwal-In **SHALL** menampilkan daftar tugas aktif yang memiliki tenggat waktu terdekat (< 3 hari) di bawah daftar kelas hari ini.

### 3.3. Pelacak Deadline Tugas (Assignments)
- **WHEN** pengguna menekan tombol tambah tugas, **THE** Jadwal-In **SHALL** menampilkan sheet input dengan daftar pilihan mata kuliah yang sudah ada, input judul tugas, tanggal & waktu deadline (DatePicker), tingkat prioritas (Rendah, Sedang, Tinggi), dan catatan.
- **THE** Jadwal-In **SHALL** mengurutkan daftar tugas yang belum selesai berdasarkan waktu tenggat terdekat secara ascending (paling mendesak di urutan teratas).
- **WHEN** pengguna mengetuk lingkaran centang (*checkbox*) pada kartu tugas, **THE** Jadwal-In **SHALL** mengubah status `isCompleted` menjadi `true`, memberikan animasi centang visual, dan memindahkan tugas ke seksi *"Selesai"*.
- **WHEN** pengguna memilih filter mata kuliah tertentu pada daftar tugas, **THE** Jadwal-In **SHALL** menyaring daftar tugas sehingga hanya menampilkan tugas dari mata kuliah yang dipilih.

### 3.4. Indikator Urgensi Cerdas (Smart Urgency)
- **WHILE** waktu sekarang (`now`) berselisih kurang dari 24 jam dari waktu deadline tugas yang belum selesai, **THE** Jadwal-In **SHALL** menampilkan badge *Mendesak* dengan warna Warm Tangerine (`#EA580C`) beserta teks sisa jam (misal: *"Tersisa 8 jam"*).
- **WHILE** waktu sekarang berselisih antara 24 hingga 72 jam dari deadline, **THE** Jadwal-In **SHALL** menampilkan badge *Mendekati* dengan warna Amber (`#F59E0B`).
- **IF** waktu deadline telah terlampaui dan tugas belum selesai, **THEN THE** Jadwal-In **SHALL** menampilkan badge *Terlewat* dengan warna merah tegas (`#DC2626`).

### 3.5. Persistensi & Integritas Data
- **UBIQUITOUS:** **THE** Jadwal-In **SHALL** menyimpan setiap perubahan data (tambah, edit, hapus, toggle selesai) secara otomatis dan atomik ke berkas JSON lokal di direktori Dokumen aplikasi.
- **WHEN** aplikasi dibuka kembali setelah dihentikan (*kill*), **THE** Jadwal-In **SHALL** memuat ulang seluruh mata kuliah dan tugas persis seperti keadaan terakhir.

---

## 4. Kriteria Non-Fungsional
- **Responsivitas:** Waktu peluncuran aplikasi hingga tampilan Today siap interaksi ≤ 300ms.
- **Efisiensi Memori:** Memory footprint di bawah 40MB pada pemakaian normal.
- **Zero Network:** Tidak memerlukan koneksi internet sama sekali (100% offline).
