# 📱 Quran-in-Bangla App

Welcome to the **Quran-in-Bangla** mobile app — a simple and peaceful way to listen to the Quran in Bangla with visual ayah display. Built using **Flutter** and **GetX**, this app offers smooth navigation and API-driven audio playback to bring the divine message closer to your heart.

---

## ✨ Features

- 🎧 **Bangla Audio Playback** of Quranic verses  
- 📖 **Ayah Display with Images** for each verse  
- ⚡ **Fast and Reactive UI** powered by **GetX**  
- 🌐 **Fetches Audio & Images via API** (no need for YouTube or manual search)  
- 📲 Lightweight and smooth Flutter experience

---

## 🔗 API Integration

This app uses the [Quran Audio in Bangla API](https://github.com/abusayed0206/banglaquran/tree/main) for fetching surah data.

- **Sample Endpoint:** `/api/1`  
- **Returns:** Surah info with ayah images and audio file links

Example response:
```json
{
  "surah_number": "1",
  "surah_name": "আল ফাতিহা",
  "total_ayahs": 7,
  "ayah": [
    { "img": "/imgs/bangla/1-1.png", "audio": "/audio/bangla/1-1.mp3" },
    { "img": "/imgs/bangla/1-2.png", "audio": "/audio/bangla/1-2.mp3" },
    { "img": "/imgs/bangla/1-3.png", "audio": "/audio/bangla/1-3.mp3" },
    { "img": "/imgs/bangla/1-4.png", "audio": "/audio/bangla/1-4.mp3" },
    { "img": "/imgs/bangla/1-5.png", "audio": "/audio/bangla/1-5.mp3" },
    { "img": "/imgs/bangla/1-6.png", "audio": "/audio/bangla/1-6.mp3" },
    { "img": "/imgs/bangla/1-7.png", "audio": "/audio/bangla/1-7.mp3" }
  ]
}
