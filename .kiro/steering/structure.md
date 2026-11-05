# Project Structure: Jadwal-In

## 1. Directory Tree Architecture

```
jadwal-in/
├── .kiro/
│   ├── steering/
│   │   ├── product.md
│   │   ├── tech.md
│   │   ├── structure.md
│   │   └── code-conventions.md
│   └── specs/
│       └── core-schedule/
│           ├── requirements.md
│           ├── design.md
│           └── tasks.md
├── JadwalIn.xcodeproj/
├── JadwalIn/
│   ├── App/
│   │   ├── JadwalInApp.swift
│   │   └── MainTabView.swift
│   ├── Models/
│   │   ├── Course.swift
│   │   ├── Assignment.swift
│   │   ├── DayOfWeek.swift
│   │   └── Priority.swift
│   ├── Store/
│   │   └── ScheduleStore.swift
│   ├── Features/
│   │   ├── Today/
│   │   │   ├── TodayView.swift
│   │   │   └── TodayViewModel.swift
│   │   ├── Schedule/
│   │   │   ├── ScheduleView.swift
│   │   │   └── AddCourseSheet.swift
│   │   ├── Assignments/
│   │   │   ├── AssignmentsView.swift
│   │   │   ├── AddAssignmentSheet.swift
│   │   │   └── EditAssignmentSheet.swift
│   │   └── Settings/
│   │       └── SettingsView.swift
│   ├── Shared/
│   │   ├── Theme/
│   │   │   ├── ColorTokens.swift
│   │   │   └── Typography.swift
│   │   ├── Components/
│   │   │   ├── CourseCard.swift
│   │   │   ├── AssignmentRow.swift
│   │   │   ├── UrgencyBadge.swift
│   │   │   └── EmptyStateView.swift
│   │   └── Extensions/
│   │       └── Date+Extensions.swift
│   └── Assets.xcassets/
└── JadwalInTests/
    └── JadwalInTests.swift
```

## 2. Tanggung Jawab Modul
- **`Models/`**: Tipe data murni (`struct`) yang mematuhi `Identifiable`, `Codable`, `Hashable`.
- **`Store/`**: `ScheduleStore` mengelola state aplikasi dan berkas persisten JSON. Satu-satunya entitas yang berhak membaca/menulis ke disk.
- **`Features/`**: Antarmuka tampilan per domain navigasi (Today, Schedule, Assignments, Settings).
- **`Shared/`**: Komponen UI yang dipakai berulang, palet warna, tipografi, dan extension tanggal.
