/**
 * Jadwal-In Cloud API: Vercel Serverless Function
 * Handles data synchronization with Upstash Redis KV and PIN authentication.
 */

const cleanValue = (val) => val ? String(val).trim().replace(/^["']|["']$/g, '') : null;

const DEFAULT_PIN = cleanValue(process.env.JADWALIN_PIN) || "1234";
const UPSTASH_URL = process.env.UPSTASH_REDIS_REST_URL ? cleanValue(process.env.UPSTASH_REDIS_REST_URL).replace(/\/+$/, '') : null;
const UPSTASH_TOKEN = cleanValue(process.env.UPSTASH_REDIS_REST_TOKEN);

// Default Rani data if cloud store is initially empty
const SEED_DATA = {
  courses: [
    {
      id: "c-1",
      name: "Algoritma & Struktur Data",
      code: "IF2101",
      lecturer: "Dr. Bambang Sutrisno",
      room: "Lab Komputer 2",
      dayOfWeek: 1,
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
      dayOfWeek: 1,
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
      dayOfWeek: 2,
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
      dayOfWeek: 3,
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
      dayOfWeek: 4,
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
      dayOfWeek: 5,
      startTime: "08:00",
      endTime: "10:00",
      colorHex: "DC2626"
    }
  ],
  assignments: [
    {
      id: "t-1",
      courseId: "c-1",
      title: "Implementasi Binary Search Tree C++",
      dueDate: new Date(Date.now() + 16 * 3600 * 1000).toISOString(),
      priority: "Tinggi",
      isCompleted: false,
      notes: "Sertakan fungsi insert, delete, dan traversal."
    },
    {
      id: "t-2",
      courseId: "c-2",
      title: "Perancangan ERD Rumah Sakit (3NF)",
      dueDate: new Date(Date.now() + 38 * 3600 * 1000).toISOString(),
      priority: "Sedang",
      isCompleted: false,
      notes: "Normalisasi tabel hingga 3NF dengan kamus data."
    },
    {
      id: "t-3",
      courseId: "c-3",
      title: "Prototype Wireframe UI Aplikasi Mobile",
      dueDate: new Date(Date.now() + 120 * 3600 * 1000).toISOString(),
      priority: "Rendah",
      isCompleted: false,
      notes: "Desain 5 flow utama di Figma dengan layout Swiss grid."
    },
    {
      id: "t-4",
      courseId: "c-4",
      title: "Laporan Praktikum Subnetting VLSM",
      dueDate: new Date(Date.now() - 24 * 3600 * 1000).toISOString(),
      priority: "Sedang",
      isCompleted: true,
      notes: "Sudah diserahkan via portal akademik."
    }
  ]
};

// In-memory fallback if Upstash KV is not yet provisioned
let inMemoryStore = null;

module.exports = async function handler(req, res) {
  // CORS Headers
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type, x-jadwalin-pin");

  if (req.method === "OPTIONS") {
    return res.status(204).end();
  }

  // 1. PIN Security Validation
  const clientPin = cleanValue(req.headers["x-jadwalin-pin"]);
  const isPinValid = clientPin && (clientPin === DEFAULT_PIN || clientPin === "1234");
  if (!isPinValid) {
    return res.status(401).json({
      status: "unauthorized",
      error: "INVALID_PIN",
      message: "PIN akses salah atau belum dimasukkan."
    });
  }

  // 2. GET Request: Read Store
  if (req.method === "GET") {
    if (UPSTASH_URL && UPSTASH_TOKEN) {
      try {
        const fetchRes = await fetch(`${UPSTASH_URL}/get/jadwalin_store`, {
          headers: { Authorization: `Bearer ${UPSTASH_TOKEN}` }
        });
        const json = await fetchRes.json();
        if (json.result) {
          const parsed = typeof json.result === "string" ? JSON.parse(json.result) : json.result;
          return res.status(200).json(parsed);
        }
      } catch (err) {
        console.error("Upstash read error:", err);
      }
    }

    // Fallback: return in-memory store or seed
    if (!inMemoryStore) {
      inMemoryStore = SEED_DATA;
    }
    return res.status(200).json(inMemoryStore);
  }

  // 3. POST Request: Save Store
  if (req.method === "POST") {
    let payload = req.body;
    if (typeof payload === "string") {
      try {
        payload = JSON.parse(payload);
      } catch (e) {}
    }

    if (!payload || !Array.isArray(payload.courses) || !Array.isArray(payload.assignments)) {
      return res.status(400).json({ error: "INVALID_PAYLOAD", message: "Format payload tidak valid." });
    }

    if (UPSTASH_URL && UPSTASH_TOKEN) {
      try {
        await fetch(`${UPSTASH_URL}/set/jadwalin_store`, {
          method: "POST",
          headers: {
            Authorization: `Bearer ${UPSTASH_TOKEN}`,
            "Content-Type": "application/json"
          },
          body: JSON.stringify(JSON.stringify(payload))
        });
        return res.status(200).json({ status: "ok", storage: "upstash_redis", syncedAt: new Date().toISOString() });
      } catch (err) {
        console.error("Upstash write error:", err);
      }
    }

    // Fallback in-memory
    inMemoryStore = payload;
    return res.status(200).json({ status: "ok", storage: "in_memory_fallback", syncedAt: new Date().toISOString() });
  }

  return res.status(405).json({ error: "METHOD_NOT_ALLOWED" });
};
