## Struktur Folder dan Tanggung Jawab

Aplikasi Course Explorer menggunakan pemisahan tanggung jawab agar kode lebih mudah dipelihara dan dikembangkan.

- **`models/`**: Mendefinisikan struktur data aplikasi, seperti model `Course`, serta proses konversi data JSON menjadi objek.
- **`services/`**: Menangani sumber data dan detail teknis pengambilan data, seperti membaca file JSON dari assets.
- **`repositories/`**: Menjadi perantara antara Provider dan Service serta menyediakan akses data bagi aplikasi.
- **`providers/`**: Mengelola shared state, seperti daftar mata kuliah, status loading, pesan error, dan daftar favorit, serta memberi tahu UI ketika state berubah.
- **`screens/`**: Menyediakan halaman aplikasi, seperti daftar mata kuliah, detail mata kuliah, dan halaman favorit.
- **`widgets/`**: Menyimpan komponen UI yang dapat digunakan kembali, seperti kartu mata kuliah.
- **`main.dart`**: Menjadi titik masuk aplikasi dan mengatur pemasangan Provider pada widget utama.

Arah dependency yang digunakan adalah **Screen/Widget → Provider → Repository → Service/Data Source**. Dengan pemisahan ini, UI tidak membaca JSON secara langsung dan setiap layer memiliki tanggung jawab yang jelas.
## Dokumentasi REST API

### 1. Informasi Endpoint

- **Base URL:** `https://course-api-pearl.vercel.app`
- **Endpoint:** `/courses`
- **URL lengkap:** `https://course-api-pearl.vercel.app/courses`
- **HTTP Method:** `GET`
- **Status Code:** `200 OK`
- **Format respons:** JSON

### 2. Deskripsi Endpoint

Endpoint `/courses` digunakan untuk mengambil daftar mata kuliah dari server. Hasil pengujian melalui PowerShell menunjukkan bahwa server berhasil mengembalikan data dalam format array JSON.

### 3. Struktur Data

| Field | Tipe Data | Keterangan |
|---|---|---|
| `id` | Integer | Identitas mata kuliah |
| `code` | String | Kode mata kuliah |
| `title` | String | Nama mata kuliah |
| `credits` | Integer | Jumlah kredit |
| `status` | String | Status mata kuliah |
| `created_at` | String | Waktu pembuatan data |

### 4. Contoh Respons JSON

```json
[
  {
    "id": 4,
    "code": "MOB04",
    "title": "State Management Provider",
    "credits": 1,
    "status": "done",
    "created_at": "2026-10-21T03:28:09.576271Z"
  }
]
```

### 5. Hasil Pengujian

Pengujian dilakukan menggunakan PowerShell dengan metode GET. Server mengembalikan status HTTP `200 OK` dan 16 objek mata kuliah dalam respons JSON. Data berhasil diterima tanpa pesan kesalahan.
