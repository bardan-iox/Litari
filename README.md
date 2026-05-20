# Litari Flutter App

Implementasi Flutter dari desain UI aplikasi **Litari** — aplikasi pembelajaran berbasis tema Indonesia.

## Struktur File

```
lib/
├── main.dart                    # Entry point & MaterialApp
└── screens/
    ├── welcome_screen.dart      # Layar sambutan (Login / Register)
    └── login_screen.dart        # Layar login (username + kata sandi)
```

## Layar yang Diimplementasi

### 1. WelcomeScreen (`welcome_screen.dart`)
- Maskot Litari (digambar via `CustomPainter`)
- Nama app "LITARI" berwarna coklat
- Tombol **Login** (coklat) → navigasi ke LoginScreen
- Tombol **Register** (abu gelap)
- Animasi fade + slide saat pertama dibuka

### 2. LoginScreen (`login_screen.dart`)
- Form input **Username / Email** + **Kata Sandi** (dengan toggle show/hide)
- Tombol **Lanjut** dengan loading state
- Link **LUPA KATA SANDI**
- Tombol social login: **Facebook** & **Google**
- Teks syarat & ketentuan di bawah

## Cara Menjalankan

```bash
flutter pub get
flutter run
```

## Catatan
- Maskot dibuat menggunakan `CustomPainter` — untuk produksi, ganti dengan `Image.asset('assets/mascot.png')`
- Warna utama: `#B5651D` (coklat Litari), `#1A1F2E` (background gelap), `#252B3B` (card)
- Font: Roboto (default Flutter)
