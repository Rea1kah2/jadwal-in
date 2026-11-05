/**
 * Jadwal-In: Swiss Technical Grid Engine
 * Architectural Timetable Timeline • Dynamic Time Horizon • Instant Scanability
 */

// ==========================================
// 1. BASELINE DATA (Rani Semester 3)
// ==========================================
const DEFAULT_COURSES = [
  {
    id: "c-1",
    name: "Algoritma & Struktur Data",
    code: "IF2101",
    lecturer: "Dr. Bambang Sutrisno",
    room: "Lab Komputer 2",
    dayOfWeek: 1, // Senin
    startTime: "08:00",
    endTime: "10:30",
    colorHex: "1E3A8A"
  },
  {
    id: "c-2",
    name: "Sistem Basis Data",
    code: "IF2102",
    lecturer: "Ir. Ratna Dewi, M.Kom",
    room: "Gedung B R.304",
    dayOfWeek: 1, // Senin
    startTime: "13:00",
    endTime: "15:30",
    colorHex: "0284C7"
  },
  {
    id: "c-3",
    name: "Pemrograman Web & Mobile",
    code: "IF2103",
    lecturer: "Faisal Rahman, S.T., M.T.",
    room: "Lab Software 1",
    dayOfWeek: 2, // Selasa
    startTime: "09:00",
    endTime: "11:30",
    colorHex: "059669"
  },
  {
    id: "c-4",
    name: "Jaringan Komputer & Lab",
    code: "IF2104",
    lecturer: "Ahmad Hidayat, M.Cs",
    room: "Gedung C R.201",
    dayOfWeek: 3, // Rabu
    startTime: "10:00",
    endTime: "12:30",
    colorHex: "D97706"
  },
  {
    id: "c-5",
    name: "Rekayasa Perangkat Lunak",
    code: "IF2105",
    lecturer: "Dr. Siti Nurhaliza",
    room: "Gedung A R.102",
    dayOfWeek: 4, // Kamis
    startTime: "08:30",
    endTime: "11:00",
    colorHex: "7C3AED"
  },
  {
    id: "c-6",
    name: "Statistika & Probabilitas",
    code: "IF2106",
    lecturer: "Drs. Hendro Wibowo",
    room: "Gedung B R.205",
    dayOfWeek: 5, // Jumat
    startTime: "08:00",
    endTime: "10:00",
    colorHex: "DC2626"
  }
];

function generateDefaultAssignments(courses) {
  const now = new Date();
  const c1 = courses[0]?.id || "c-1";
  const c2 = courses[1]?.id || "c-2";
  const c3 = courses[2]?.id || "c-3";
  const c4 = courses[3]?.id || "c-4";

  return [
    {
      id: "t-1",
      courseId: c1,
      title: "Implementasi Binary Search Tree C++",
      dueDate: new Date(now.getTime() + 16 * 3600 * 1000).toISOString(), // +16 jam (Kritis)
      priority: "Tinggi",
      isCompleted: false,
      notes: "Sertakan fungsi insert, delete, dan traversal inorder/postorder."
    },
    {
      id: "t-2",
      courseId: c2,
      title: "Perancangan ERD Rumah Sakit (3NF)",
      dueDate: new Date(now.getTime() + 38 * 3600 * 1000).toISOString(), // Besok (Kritis)
      priority: "Sedang",
      isCompleted: false,
      notes: "Normalisasi tabel hingga 3NF dengan kamus data lengkap."
    },
    {
      id: "t-3",
      courseId: c3,
      title: "Prototype Wireframe UI Aplikasi Mobile",
      dueDate: new Date(now.getTime() + 120 * 3600 * 1000).toISOString(), // 5 hari lagi (Minggu Ini)
      priority: "Rendah",
      isCompleted: false,
      notes: "Desain 5 flow utama di Figma dengan layout Swiss grid."
    },
    {
      id: "t-4",
      courseId: c4,
      title: "Laporan Praktikum Subnetting VLSM",
      dueDate: new Date(now.getTime() - 24 * 3600 * 1000).toISOString(), // Kemarin (Selesai)
      priority: "Sedang",
      isCompleted: true,
      notes: "Sudah diserahkan via portal akademik."
    }
  ];
}

// ==========================================
// 2. APP STATE
// ==========================================
const AppState = {
  courses: [],
  assignments: [],
  activeTab: 'tab-today',
  selectedScheduleDay: 1, // 1 = Senin
  selectedAssignmentStatus: 'active', // 'active' | 'completed'
  selectedFilterCourseId: 'all'
};

const DAY_NAMES = ["Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"];
const MONTH_NAMES = [
  "JANUARI", "FEBRUARI", "MARET", "APRIL", "MEI", "JUNI",
  "JULI", "AGUSTUS", "SEPTEMBER", "OKTOBER", "NOVEMBER", "DESEMBER"
];

// ==========================================
// 3. PERSISTENCE & SECURITY LAYER (Swiss Gate)
// ==========================================
let currentPin = '';

function updateSyncStatus(text, state = 'synced') {
  const el = document.getElementById('cloud-sync-status');
  if (!el) return;
  el.textContent = text;
  if (state === 'synced') {
    el.style.color = 'var(--signal-nominal)';
  } else if (state === 'syncing') {
    el.style.color = 'var(--signal-warning)';
  } else if (state === 'offline') {
    el.style.color = 'var(--signal-warning)';
  } else if (state === 'error') {
    el.style.color = 'var(--signal-critical)';
  }
}

function updatePinDots() {
  const dots = document.querySelectorAll('#pin-dots-group .pin-dot');
  dots.forEach((dot, index) => {
    if (index < currentPin.length) {
      dot.classList.add('active');
    } else {
      dot.classList.remove('active');
    }
    dot.classList.remove('error');
  });
}

function flashPinError(msg) {
  const errorEl = document.getElementById('pin-error-msg');
  if (errorEl) errorEl.textContent = msg || 'PIN SALAH. SILAKAN COBA LAGI.';
  const dots = document.querySelectorAll('#pin-dots-group .pin-dot');
  dots.forEach(d => d.classList.add('error'));
  setTimeout(() => {
    currentPin = '';
    updatePinDots();
  }, 600);
}

async function verifyAndUnlock(pin) {
  const errorEl = document.getElementById('pin-error-msg');
  if (errorEl) errorEl.textContent = 'MEMVERIFIKASI PIN KE CLOUD...';

  try {
    const res = await fetch('/api/data', {
      headers: { 'x-jadwalin-pin': pin }
    });

    if (res.status === 401) {
      flashPinError('PIN AKSES TIDAK VALID');
      return false;
    }

    if (res.ok) {
      const data = await res.json();
      localStorage.setItem('jadwalin_user_pin', pin);
      if (data && data.courses && data.courses.length > 0) {
        AppState.courses = data.courses;
        AppState.assignments = data.assignments || [];
      } else {
        const localCourses = localStorage.getItem('jadwalin_courses');
        if (localCourses) {
          AppState.courses = JSON.parse(localCourses);
          AppState.assignments = JSON.parse(localStorage.getItem('jadwalin_assignments') || '[]');
        } else {
          AppState.courses = [...DEFAULT_COURSES];
          AppState.assignments = generateDefaultAssignments(AppState.courses);
        }
        await saveData();
      }

      localStorage.setItem('jadwalin_courses', JSON.stringify(AppState.courses));
      localStorage.setItem('jadwalin_assignments', JSON.stringify(AppState.assignments));
      updateSyncStatus('[CLOUD // 🟢 SYNCED]', 'synced');
      document.getElementById('pin-lock-overlay').classList.add('hidden');
      currentPin = '';
      updatePinDots();
      if (errorEl) errorEl.textContent = '';
      renderAll();
      showToast("[AUTH // AKSES DIIZINKAN]");
      return true;
    }
  } catch (err) {
    console.warn("Backend server offline during PIN verification, evaluating local fallback:", err);
  }

  // Offline fallback: compare against previously stored PIN or default 1234
  const cachedPin = localStorage.getItem('jadwalin_user_pin') || '1234';
  if (pin === cachedPin || pin === '1234') {
    localStorage.setItem('jadwalin_user_pin', pin);
    const localCourses = localStorage.getItem('jadwalin_courses');
    const localAssignments = localStorage.getItem('jadwalin_assignments');
    if (localCourses) {
      try {
        AppState.courses = JSON.parse(localCourses);
        AppState.assignments = JSON.parse(localAssignments || '[]');
      } catch (e) {}
    } else {
      AppState.courses = [...DEFAULT_COURSES];
      AppState.assignments = generateDefaultAssignments(AppState.courses);
    }
    updateSyncStatus('[OFFLINE // 🟡 LOCAL]', 'offline');
    document.getElementById('pin-lock-overlay').classList.add('hidden');
    currentPin = '';
    updatePinDots();
    if (errorEl) errorEl.textContent = '';
    renderAll();
    showToast("[AUTH // MODE OFFLINE AKTIF]");
    return true;
  }

  flashPinError('PIN SALAH (DEFAULT: 1234)');
  return false;
}

function lockApp() {
  localStorage.removeItem('jadwalin_user_pin');
  currentPin = '';
  updatePinDots();
  const errorEl = document.getElementById('pin-error-msg');
  if (errorEl) errorEl.textContent = '';
  document.getElementById('pin-lock-overlay').classList.remove('hidden');
  updateSyncStatus('[AUTH // 🔴 LOCKED]', 'error');
  showToast("[SECURITY // APLIKASI DIKUNCI]");
}

async function loadData() {
  const pin = localStorage.getItem('jadwalin_user_pin');
  if (!pin) {
    document.getElementById('pin-lock-overlay').classList.remove('hidden');
    updateSyncStatus('[AUTH // 🔴 LOCKED]', 'error');
    return false;
  }

  try {
    const res = await fetch('/api/data', {
      headers: { 'x-jadwalin-pin': pin }
    });

    if (res.status === 401) {
      localStorage.removeItem('jadwalin_user_pin');
      document.getElementById('pin-lock-overlay').classList.remove('hidden');
      updateSyncStatus('[AUTH // 🔴 LOCKED]', 'error');
      const errorEl = document.getElementById('pin-error-msg');
      if (errorEl) errorEl.textContent = 'SESI KADALUWARSA. MASUKKAN PIN KEMBALI.';
      return false;
    }

    if (res.ok) {
      const data = await res.json();
      if (data && data.courses && data.courses.length > 0) {
        AppState.courses = data.courses;
        AppState.assignments = data.assignments || [];
        localStorage.setItem('jadwalin_courses', JSON.stringify(AppState.courses));
        localStorage.setItem('jadwalin_assignments', JSON.stringify(AppState.assignments));
        updateSyncStatus('[CLOUD // 🟢 SYNCED]', 'synced');
        document.getElementById('pin-lock-overlay').classList.add('hidden');
        return true;
      }
    }
  } catch (err) {
    console.warn("Cloud server unreachable, loading offline cache:", err);
  }

  const localCourses = localStorage.getItem('jadwalin_courses');
  const localAssignments = localStorage.getItem('jadwalin_assignments');
  if (localCourses) {
    try {
      AppState.courses = JSON.parse(localCourses);
      AppState.assignments = JSON.parse(localAssignments || '[]');
      updateSyncStatus('[OFFLINE // 🟡 LOCAL]', 'offline');
      document.getElementById('pin-lock-overlay').classList.add('hidden');
      return true;
    } catch (e) {
      console.error(e);
    }
  }

  resetToSampleData();
  document.getElementById('pin-lock-overlay').classList.add('hidden');
  return true;
}

async function saveData() {
  localStorage.setItem('jadwalin_courses', JSON.stringify(AppState.courses));
  localStorage.setItem('jadwalin_assignments', JSON.stringify(AppState.assignments));

  const pin = localStorage.getItem('jadwalin_user_pin') || '1234';
  updateSyncStatus('[CLOUD // ⏳ SYNCING...]', 'syncing');

  try {
    const res = await fetch('/api/data', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-jadwalin-pin': pin
      },
      body: JSON.stringify({
        courses: AppState.courses,
        assignments: AppState.assignments
      })
    });

    if (res.status === 401) {
      updateSyncStatus('[AUTH // 🔴 LOCKED]', 'error');
      lockApp();
      return;
    }

    if (res.ok) {
      updateSyncStatus('[CLOUD // 🟢 SYNCED]', 'synced');
    } else {
      updateSyncStatus('[OFFLINE // 🟡 LOCAL]', 'offline');
    }
  } catch (err) {
    updateSyncStatus('[OFFLINE // 🟡 LOCAL]', 'offline');
  }
}

function resetToSampleData() {
  AppState.courses = [...DEFAULT_COURSES];
  AppState.assignments = generateDefaultAssignments(AppState.courses);
  saveData();
  renderAll();
  showToast("DATA SAMPEL RANI BERHASIL DIMUAT");
}

function clearAllData() {
  AppState.courses = [];
  AppState.assignments = [];
  saveData();
  renderAll();
  showToast("SELURUH DATA LOKAL DIKOSONGKAN");
}

// ==========================================
// 4. COMPUTED HELPERS & SWISS UTILITIES
// ==========================================
function getDayOfWeek(date = new Date()) {
  const d = date.getDay();
  return d === 0 ? 7 : d; // 1 = Senin, ..., 7 = Minggu
}

function getCourse(courseId) {
  return AppState.courses.find(c => c.id === courseId);
}

function timeStringToMinutes(timeStr) {
  const [h, m] = timeStr.split(':').map(Number);
  return h * 60 + m;
}

function minutesToDurationString(totalMinutes) {
  const h = Math.floor(totalMinutes / 60);
  const m = totalMinutes % 60;
  if (h === 0) return `${m} MENIT`;
  if (m === 0) return `${h} JAM`;
  return `${h} JAM ${m} MENIT`;
}

function formatCountdownBadge(dueDateStr, isCompleted) {
  if (isCompleted) {
    return { text: "[✓ SELESAI]", cssClass: "" };
  }

  const now = new Date();
  const due = new Date(dueDateStr);
  const diffMs = due - now;
  const hours = diffMs / (1000 * 3600);

  if (hours < 0) {
    const pastH = Math.abs(Math.floor(hours));
    return {
      text: pastH < 24 ? `[TERLEWAT ${pastH}J]` : `[TERLEWAT ${Math.floor(pastH / 24)}H]`,
      cssClass: "critical"
    };
  }

  if (hours <= 24) {
    const totalH = Math.floor(hours);
    const totalM = Math.floor((diffMs % 3600000) / 60000);
    return {
      text: `[T-${String(totalH).padStart(2, '0')}H:${String(totalM).padStart(2, '0')}M]`,
      cssClass: "critical"
    };
  } else if (hours <= 48) {
    const remainH = Math.floor(hours - 24);
    return {
      text: `[BESOK // +${remainH}J]`,
      cssClass: "critical"
    };
  } else if (hours <= 72) {
    const days = Math.ceil(hours / 24);
    return {
      text: `[T-${days} HARI]`,
      cssClass: "approaching"
    };
  } else {
    const days = Math.floor(hours / 24);
    return {
      text: `[T-${days} HARI]`,
      cssClass: ""
    };
  }
}

function formatIsoDateTime(dateStr) {
  const d = new Date(dateStr);
  const dayName = DAY_NAMES[d.getDay()].toUpperCase();
  const date = String(d.getDate()).padStart(2, '0');
  const month = MONTH_NAMES[d.getMonth()].slice(0, 3);
  const hours = String(d.getHours()).padStart(2, '0');
  const mins = String(d.getMinutes()).padStart(2, '0');
  return `${dayName}, ${date} ${month} • ${hours}:${mins}`;
}

// ==========================================
// 5. RENDERING: SWISS TECHNICAL TIMELINE
// ==========================================
function updateLiveClock() {
  const now = new Date();
  const h = String(now.getHours()).padStart(2, '0');
  const m = String(now.getMinutes()).padStart(2, '0');
  const s = String(now.getSeconds()).padStart(2, '0');
  document.getElementById('live-clock').textContent = `[${h}:${m}:${s}]`;

  const dayName = DAY_NAMES[now.getDay()].toUpperCase();
  const date = String(now.getDate()).padStart(2, '0');
  const month = MONTH_NAMES[now.getMonth()];
  const year = now.getFullYear();
  document.getElementById('header-date-label').textContent = `${dayName}, ${date} ${month} ${year}`;
}

function renderNowAndNextGlance(todayCourses) {
  const container = document.getElementById('today-glance-slot');
  if (todayCourses.length === 0) {
    container.innerHTML = `
      <div class="glance-card">
        <div class="glance-card-top">
          <span class="glance-state-badge">STATUS HARI INI</span>
          <span class="glance-time-remain" style="color: var(--ink-secondary);">[TIDAK ADA KELAS]</span>
        </div>
        <div class="glance-title">Tidak Ada Jadwal Kuliah Hari Ini</div>
        <div class="glance-meta">
          <span>Manfaatkan waktu untuk menyelesaikan tugas atau proyek akademik.</span>
        </div>
      </div>
    `;
    return;
  }

  const now = new Date();
  const currentMinutes = now.getHours() * 60 + now.getMinutes();

  let ongoingCourse = null;
  let nextCourse = null;

  for (const c of todayCourses) {
    const startM = timeStringToMinutes(c.startTime);
    const endM = timeStringToMinutes(c.endTime);

    if (currentMinutes >= startM && currentMinutes < endM) {
      ongoingCourse = { course: c, remainMinutes: endM - currentMinutes };
      break;
    } else if (currentMinutes < startM && !nextCourse) {
      nextCourse = { course: c, waitMinutes: startM - currentMinutes };
    }
  }

  if (ongoingCourse) {
    const c = ongoingCourse.course;
    container.innerHTML = `
      <div class="glance-card has-ongoing">
        <div class="glance-card-top">
          <span class="glance-state-badge ongoing">● SEDANG BERLANGSUNG</span>
          <span class="glance-time-remain">[SISA ${minutesToDurationString(ongoingCourse.remainMinutes)}]</span>
        </div>
        <div class="glance-title">${escapeHtml(c.name)}</div>
        <div class="glance-meta">
          <span>JAM: [${c.startTime} — ${c.endTime}]</span>
          <span>RUANG: [${escapeHtml(c.room || 'TBA')}]</span>
          <span>DOSEN: [${escapeHtml(c.lecturer || 'TBA')}]</span>
        </div>
      </div>
    `;
  } else if (nextCourse) {
    const c = nextCourse.course;
    container.innerHTML = `
      <div class="glance-card">
        <div class="glance-card-top">
          <span class="glance-state-badge">BERIKUTNYA HARI INI</span>
          <span class="glance-time-remain">[DIMULAI DALAM ${minutesToDurationString(nextCourse.waitMinutes)}]</span>
        </div>
        <div class="glance-title">${escapeHtml(c.name)}</div>
        <div class="glance-meta">
          <span>JAM: [${c.startTime} — ${c.endTime}]</span>
          <span>RUANG: [${escapeHtml(c.room || 'TBA')}]</span>
          <span>DOSEN: [${escapeHtml(c.lecturer || 'TBA')}]</span>
        </div>
      </div>
    `;
  } else {
    container.innerHTML = `
      <div class="glance-card">
        <div class="glance-card-top">
          <span class="glance-state-badge">SELESAI HARI INI</span>
          <span class="glance-time-remain" style="color: var(--accent-success);">[✓ SEMUA KELAS USAI]</span>
        </div>
        <div class="glance-title">Seluruh Perkuliahan Hari Ini Telah Berakhir</div>
        <div class="glance-meta">
          <span>Total ${todayCourses.length} kelas telah selesai dihadiri dengan baik.</span>
        </div>
      </div>
    `;
  }
}

function renderTimelineHTML(courses, showBreaks = true) {
  if (courses.length === 0) {
    return `
      <div class="technical-empty-state">
        <div class="empty-code">[EMPTY_SCHEDULE_ZERO_ENTRIES]</div>
        <div class="empty-message">Tidak ada perkuliahan yang terjadwal.</div>
      </div>
    `;
  }

  let html = '';
  for (let i = 0; i < courses.length; i++) {
    const c = courses[i];

    html += `
      <div class="timeline-item">
        <div class="timeline-time-col">
          <div>${c.startTime}</div>
          <div style="color: var(--ink-faint); font-size: 10px;">${c.endTime}</div>
        </div>
        <div class="timeline-card" style="border-left-color: #${c.colorHex || '0A0A0A'};">
          <div class="timeline-card-header">
            <span class="timeline-course-name">${escapeHtml(c.name)}</span>
            ${c.code ? `<span class="mono-tag">[${escapeHtml(c.code)}]</span>` : ''}
          </div>
          <div class="timeline-details">
            <span>RUANG: [${escapeHtml(c.room || '-')}]</span>
            <span>DOSEN: [${escapeHtml(c.lecturer || '-')}]</span>
          </div>
        </div>
      </div>
    `;

    // Calculate break between this course and next course
    if (showBreaks && i < courses.length - 1) {
      const nextC = courses[i + 1];
      const endM = timeStringToMinutes(c.endTime);
      const startNextM = timeStringToMinutes(nextC.startTime);
      const gapM = startNextM - endM;

      if (gapM >= 15) {
        html += `
          <div class="timeline-break">
            <span>--- ☕ JEDA ISTIRAHAT [${minutesToDurationString(gapM)}] ---</span>
            <span class="timeline-break-icon">FREE PERIOD</span>
          </div>
        `;
      }
    }
  }

  return html;
}

function renderTodayTab() {
  const currentDay = getDayOfWeek();
  const todayCourses = AppState.courses
    .filter(c => c.dayOfWeek === currentDay)
    .sort((a, b) => a.startTime.localeCompare(b.startTime));

  document.getElementById('today-timeline-metric').textContent = `${todayCourses.length} KELAS`;

  // Render Now / Next Glance
  renderNowAndNextGlance(todayCourses);

  // Render Today's Timeline
  document.getElementById('today-timeline-track').innerHTML = renderTimelineHTML(todayCourses, true);

  // Urgent Deadlines (< 48 jam)
  const urgentTasks = AppState.assignments
    .filter(a => !a.isCompleted)
    .filter(a => {
      const diffH = (new Date(a.dueDate) - new Date()) / 3600000;
      return diffH <= 48; // Critical threshold
    })
    .sort((a, b) => new Date(a.dueDate) - new Date(b.dueDate));

  document.getElementById('today-urgent-metric').textContent = `${urgentTasks.length} TUGAS`;
  const urgentContainer = document.getElementById('today-urgent-list');

  if (urgentTasks.length === 0) {
    urgentContainer.innerHTML = `
      <div class="technical-empty-state">
        <div class="empty-code">[DEADLINE_HORIZON_CLEAR]</div>
        <div class="empty-message">Nol tugas mendesak dalam 48 jam ke depan.</div>
      </div>
    `;
  } else {
    urgentContainer.innerHTML = urgentTasks.map(t => renderTechnicalTaskRow(t)).join('');
  }

  // Update Ticker Status
  const urgentCount = urgentTasks.length;
  document.getElementById('header-ticker-status').textContent = 
    `STATUS // ${todayCourses.length} KELAS HARI INI • ${urgentCount} TUGAS KRITIS`;
}

function renderScheduleTab() {
  const selectedDay = AppState.selectedScheduleDay;
  const dayName = DAY_NAMES[selectedDay === 7 ? 0 : selectedDay].toUpperCase();
  document.getElementById('schedule-day-label').textContent = `JADWAL KULIAH // ${dayName}`;

  const courses = AppState.courses
    .filter(c => c.dayOfWeek === selectedDay)
    .sort((a, b) => a.startTime.localeCompare(b.startTime));

  document.getElementById('schedule-timeline-track').innerHTML = renderTimelineHTML(courses, true);
}

// ==========================================
// 6. RENDERING: DYNAMIC TIME HORIZON (TUGAS)
// ==========================================
function renderAssignmentsTab() {
  const isCompletedTab = AppState.selectedAssignmentStatus === 'completed';
  const activeCount = AppState.assignments.filter(a => !a.isCompleted).length;
  const completedCount = AppState.assignments.filter(a => a.isCompleted).length;

  document.getElementById('count-active').textContent = activeCount;
  document.getElementById('count-completed').textContent = completedCount;

  // Filter Bar Chips
  const filterContainer = document.getElementById('course-filter-bar');
  filterContainer.innerHTML = `
    <button class="tech-chip ${AppState.selectedFilterCourseId === 'all' ? 'active' : ''}" data-course-id="all">[SEMUA MATKUL]</button>
    ${AppState.courses.map(c => `
      <button class="tech-chip ${AppState.selectedFilterCourseId === c.id ? 'active' : ''}" data-course-id="${c.id}">
        [${escapeHtml(c.code || c.name.slice(0, 8))}]
      </button>
    `).join('')}
  `;

  let tasks = AppState.assignments.filter(a => a.isCompleted === isCompletedTab);
  if (AppState.selectedFilterCourseId !== 'all') {
    tasks = tasks.filter(a => a.courseId === AppState.selectedFilterCourseId);
  }

  const container = document.getElementById('assignments-horizon-container');

  if (tasks.length === 0) {
    container.innerHTML = `
      <div class="technical-empty-state">
        <div class="empty-code">[NO_ASSIGNMENT_RECORDS]</div>
        <div class="empty-message">${isCompletedTab ? 'Belum ada riwayat tugas yang diselesaikan.' : 'Semua tugas pada horizon filter ini telah selesai.'}</div>
      </div>
    `;
    return;
  }

  if (isCompletedTab) {
    // Linear sorted list for completed tasks
    tasks.sort((a, b) => new Date(b.dueDate) - new Date(a.dueDate));
    container.innerHTML = `
      <div class="horizon-group">
        <div class="horizon-header">
          <span class="horizon-title">ARSIP TUGAS TERSELESAIKAN</span>
          <span class="horizon-count">[${tasks.length} ENTRI]</span>
        </div>
        ${tasks.map(t => renderTechnicalTaskRow(t)).join('')}
      </div>
    `;
    return;
  }

  // Active Tasks: Group into 3 Dynamic Time Horizons
  const now = new Date();
  const horizon1 = []; // Hari Ini & Besok (<= 48 jam)
  const horizon2 = []; // Minggu Ini (> 48 jam && <= 7 hari)
  const horizon3 = []; // Mendatang (> 7 hari)

  tasks.sort((a, b) => new Date(a.dueDate) - new Date(b.dueDate));

  for (const t of tasks) {
    const diffH = (new Date(t.dueDate) - now) / 3600000;
    if (diffH <= 48) {
      horizon1.push(t);
    } else if (diffH <= 168) { // 7 hari = 168 jam
      horizon2.push(t);
    } else {
      horizon3.push(t);
    }
  }

  let horizonHtml = '';

  if (horizon1.length > 0) {
    horizonHtml += `
      <div class="horizon-group">
        <div class="horizon-header">
          <span class="horizon-title critical">01 // HARI INI &amp; BESOK (KRITIS)</span>
          <span class="horizon-count">[${horizon1.length} TUGAS]</span>
        </div>
        ${horizon1.map(t => renderTechnicalTaskRow(t)).join('')}
      </div>
    `;
  }

  if (horizon2.length > 0) {
    horizonHtml += `
      <div class="horizon-group">
        <div class="horizon-header">
          <span class="horizon-title">02 // MINGGU INI (2 — 7 HARI)</span>
          <span class="horizon-count">[${horizon2.length} TUGAS]</span>
        </div>
        ${horizon2.map(t => renderTechnicalTaskRow(t)).join('')}
      </div>
    `;
  }

  if (horizon3.length > 0) {
    horizonHtml += `
      <div class="horizon-group">
        <div class="horizon-header">
          <span class="horizon-title">03 // MENDATANG &amp; PROYEK (&gt; 7 HARI)</span>
          <span class="horizon-count">[${horizon3.length} TUGAS]</span>
        </div>
        ${horizon3.map(t => renderTechnicalTaskRow(t)).join('')}
      </div>
    `;
  }

  container.innerHTML = horizonHtml;
}

function renderTechnicalTaskRow(task) {
  const course = getCourse(task.courseId);
  const countdown = formatCountdownBadge(task.dueDate, task.isCompleted);

  return `
    <div class="technical-task-row ${task.isCompleted ? 'completed' : ''}" data-id="${task.id}">
      <button class="swiss-checkbox" onclick="handleToggleTask('${task.id}')" aria-label="Toggle Selesai">
        <svg class="swiss-check-icon" viewBox="0 0 24 24" fill="none">
          <polyline points="20 6 9 17 4 12"></polyline>
        </svg>
      </button>
      <div class="task-content">
        <div class="task-meta-top">
          <span class="course-identifier">[${course ? escapeHtml(course.code || course.name) : 'MATKUL'}]</span>
          <span class="countdown-badge ${countdown.cssClass}">${countdown.text}</span>
        </div>
        <div class="task-title-text">${escapeHtml(task.title)}</div>
        ${task.notes ? `<div class="task-notes-snippet">${escapeHtml(task.notes)}</div>` : ''}
        <div class="task-due-line">DEADLINE: ${formatIsoDateTime(task.dueDate)}</div>
      </div>
      <button class="modal-close-btn" style="width: 20px; height: 20px; font-size: 10px; border-color: transparent;" onclick="handleDeleteTask('${task.id}')" title="Hapus Tugas">✕</button>
    </div>
  `;
}

function renderSettingsTab() {
  document.getElementById('stat-total-courses').textContent = `${AppState.courses.length} Mata Kuliah`;
  document.getElementById('stat-active-tasks').textContent = `${AppState.assignments.filter(a => !a.isCompleted).length} Tugas`;
  document.getElementById('stat-completed-tasks').textContent = `${AppState.assignments.filter(a => a.isCompleted).length} Tugas`;
}

function renderAll() {
  updateLiveClock();
  renderTodayTab();
  renderScheduleTab();
  renderAssignmentsTab();
  renderSettingsTab();
  populateCourseDropdown();
}

// ==========================================
// 7. USER ACTIONS
// ==========================================
window.handleToggleTask = function(taskId) {
  const task = AppState.assignments.find(a => a.id === taskId);
  if (task) {
    task.isCompleted = !task.isCompleted;
    saveData();
    renderAll();
    showToast(task.isCompleted ? "[STATUS // TUGAS TERSELESAIKAN]" : "[STATUS // TUGAS DIKEMBALIKAN KE AKTIF]");
  }
};

window.handleDeleteTask = function(taskId) {
  if (confirm("Hapus tugas ini dari database?")) {
    AppState.assignments = AppState.assignments.filter(a => a.id !== taskId);
    saveData();
    renderAll();
    showToast("[STATUS // TUGAS DIHAPUS]");
  }
};

function populateCourseDropdown() {
  const select = document.getElementById('task-course-select');
  if (AppState.courses.length === 0) {
    select.innerHTML = '<option value="">(Belum ada mata kuliah)</option>';
    return;
  }
  select.innerHTML = AppState.courses.map(c => `
    <option value="${c.id}">[${escapeHtml(c.code || 'MATKUL')}] ${escapeHtml(c.name)}</option>
  `).join('');
}

function showToast(message) {
  const container = document.getElementById('toast-container');
  const toast = document.createElement('div');
  toast.className = 'toast';
  toast.textContent = message;
  container.appendChild(toast);
  setTimeout(() => {
    toast.remove();
  }, 2200);
}

function escapeHtml(str) {
  if (!str) return '';
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

// ==========================================
// 8. EVENT LISTENERS & SETUP
// ==========================================
document.addEventListener('DOMContentLoaded', async () => {
  await loadData();
  
  // Auto set current weekday on load
  const currentDay = getDayOfWeek();
  if (currentDay <= 6) {
    AppState.selectedScheduleDay = currentDay;
    document.querySelectorAll('.day-cell-btn').forEach(btn => {
      btn.classList.toggle('active', parseInt(btn.dataset.day) === currentDay);
    });
  }

  renderAll();

  // 1-second live clock ticker
  setInterval(updateLiveClock, 1000);

  // Bottom Navigation Switching
  document.querySelectorAll('.bottom-nav-bar .nav-tab-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      const targetTab = btn.dataset.tab;
      AppState.activeTab = targetTab;

      document.querySelectorAll('.bottom-nav-bar .nav-tab-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');

      document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
      document.getElementById(targetTab).classList.add('active');
    });
  });

  // Schedule Day Strip Selector
  document.getElementById('schedule-day-strip').addEventListener('click', (e) => {
    const btn = e.target.closest('.day-cell-btn');
    if (!btn) return;
    document.querySelectorAll('.day-cell-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    AppState.selectedScheduleDay = parseInt(btn.dataset.day);
    renderScheduleTab();
  });

  // Assignments Segmented Switch
  document.getElementById('seg-active').addEventListener('click', () => {
    AppState.selectedAssignmentStatus = 'active';
    document.getElementById('seg-active').classList.add('active');
    document.getElementById('seg-completed').classList.remove('active');
    renderAssignmentsTab();
  });

  document.getElementById('seg-completed').addEventListener('click', () => {
    AppState.selectedAssignmentStatus = 'completed';
    document.getElementById('seg-completed').classList.add('active');
    document.getElementById('seg-active').classList.remove('active');
    renderAssignmentsTab();
  });

  // Course Filter Bar Chips
  document.getElementById('course-filter-bar').addEventListener('click', (e) => {
    const chip = e.target.closest('.tech-chip');
    if (!chip) return;
    document.querySelectorAll('#course-filter-bar .tech-chip').forEach(c => c.classList.remove('active'));
    chip.classList.add('active');
    AppState.selectedFilterCourseId = chip.dataset.courseId;
    renderAssignmentsTab();
  });

  // Modal Open & Close Handlers
  const modalTask = document.getElementById('modal-task');
  const modalCourse = document.getElementById('modal-course');

  document.getElementById('btn-open-task-modal').addEventListener('click', () => modalTask.classList.add('active'));
  document.getElementById('btn-close-task-modal').addEventListener('click', () => modalTask.classList.remove('active'));
  document.getElementById('btn-cancel-task').addEventListener('click', () => modalTask.classList.remove('active'));

  document.getElementById('btn-open-course-modal').addEventListener('click', () => modalCourse.classList.add('active'));
  document.getElementById('btn-close-course-modal').addEventListener('click', () => modalCourse.classList.remove('active'));
  document.getElementById('btn-cancel-course').addEventListener('click', () => modalCourse.classList.remove('active'));

  // Form: Tambah Tugas
  document.getElementById('form-add-task').addEventListener('submit', (e) => {
    e.preventDefault();
    const courseId = document.getElementById('task-course-select').value;
    const title = document.getElementById('task-title-input').value.trim();
    const date = document.getElementById('task-date-input').value;
    const time = document.getElementById('task-time-input').value;
    const priority = document.getElementById('task-priority-select').value;
    const notes = document.getElementById('task-notes-input').value.trim();

    if (!courseId) {
      alert("PILIH MATA KULIAH TERLEBIH DAHULU.");
      return;
    }

    const dueDateTime = new Date(`${date}T${time}:00`);

    const newTask = {
      id: "task-" + Date.now(),
      courseId,
      title,
      dueDate: dueDateTime.toISOString(),
      priority,
      isCompleted: false,
      notes
    };

    AppState.assignments.push(newTask);
    saveData();
    renderAll();
    modalTask.classList.remove('active');
    document.getElementById('form-add-task').reset();
    showToast("[ENTRY // TUGAS BARU TERSIMPAN]");
  });

  // Form: Tambah Mata Kuliah
  document.getElementById('form-add-course').addEventListener('submit', (e) => {
    e.preventDefault();
    const name = document.getElementById('course-name-input').value.trim();
    const code = document.getElementById('course-code-input').value.trim();
    const dayOfWeek = parseInt(document.getElementById('course-day-select').value);
    const startTime = document.getElementById('course-start-input').value;
    const endTime = document.getElementById('course-end-input').value;
    const room = document.getElementById('course-room-input').value.trim();
    const lecturer = document.getElementById('course-lecturer-input').value.trim();
    const colorHex = document.getElementById('course-color-select').value;

    const newCourse = {
      id: "course-" + Date.now(),
      name,
      code,
      dayOfWeek,
      startTime,
      endTime,
      room,
      lecturer,
      colorHex
    };

    AppState.courses.push(newCourse);
    saveData();
    renderAll();
    modalCourse.classList.remove('active');
    document.getElementById('form-add-course').reset();
    showToast("[ENTRY // MATA KULIAH TERSIMPAN]");
  });

  // Management Actions
  document.getElementById('btn-reset-sample').addEventListener('click', () => {
    if (confirm("Reset ulang dataset ke konfigurasi contoh Rani?")) {
      resetToSampleData();
    }
  });

  document.getElementById('btn-clear-data').addEventListener('click', () => {
    if (confirm("PERINGATAN KRITIS: Kosongkan seluruh data lokal?")) {
      clearAllData();
    }
  });

  // Set default date for task input (tomorrow)
  const tomorrow = new Date(Date.now() + 86400000);
  const year = tomorrow.getFullYear();
  const month = String(tomorrow.getMonth() + 1).padStart(2, '0');
  const day = String(tomorrow.getDate()).padStart(2, '0');
  document.getElementById('task-date-input').value = `${year}-${month}-${day}`;

  // PIN Keypad Numbers
  document.querySelectorAll('.pin-keypad .pin-btn[data-num]').forEach(btn => {
    btn.addEventListener('click', () => {
      if (currentPin.length < 4) {
        currentPin += btn.dataset.num;
        updatePinDots();
        if (currentPin.length === 4) {
          verifyAndUnlock(currentPin);
        }
      }
    });
  });

  // PIN Clear
  const btnPinClear = document.getElementById('btn-pin-clear');
  if (btnPinClear) {
    btnPinClear.addEventListener('click', () => {
      currentPin = '';
      updatePinDots();
      const errorEl = document.getElementById('pin-error-msg');
      if (errorEl) errorEl.textContent = '';
    });
  }

  // PIN Backspace
  const btnPinBackspace = document.getElementById('btn-pin-backspace');
  if (btnPinBackspace) {
    btnPinBackspace.addEventListener('click', () => {
      currentPin = currentPin.slice(0, -1);
      updatePinDots();
      const errorEl = document.getElementById('pin-error-msg');
      if (errorEl) errorEl.textContent = '';
    });
  }

  // Physical Keyboard Listener for PIN
  window.addEventListener('keydown', (e) => {
    const overlay = document.getElementById('pin-lock-overlay');
    if (!overlay || overlay.classList.contains('hidden')) return;

    if (e.key >= '0' && e.key <= '9') {
      if (currentPin.length < 4) {
        currentPin += e.key;
        updatePinDots();
        if (currentPin.length === 4) {
          verifyAndUnlock(currentPin);
        }
      }
    } else if (e.key === 'Backspace') {
      currentPin = currentPin.slice(0, -1);
      updatePinDots();
    } else if (e.key === 'Escape') {
      currentPin = '';
      updatePinDots();
    }
  });

  // Lock Application Action
  const btnLockNow = document.getElementById('btn-lock-now');
  if (btnLockNow) {
    btnLockNow.addEventListener('click', () => {
      lockApp();
    });
  }

  // Online / Offline Connectivity Listeners
  window.addEventListener('online', () => {
    updateSyncStatus('[CLOUD // 🟢 SYNCED]', 'synced');
    loadData().then(() => renderAll());
  });

  window.addEventListener('offline', () => {
    updateSyncStatus('[OFFLINE // 🟡 LOCAL]', 'offline');
  });
});
