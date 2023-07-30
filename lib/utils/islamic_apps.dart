class Apps {
  String? name, img;

  Apps(this.img, this.name);

  static List AppsList() {
    return [
      Apps("assets/apps/quran.png", "Quran"),
      Apps("assets/apps/adhan.png", "Adhan"),
      Apps("assets/apps/qibla.png", "Qibla"),
      Apps("assets/apps/dua.png", "Dua"),
      Apps("assets/apps/tafseer.png", "Tafseer"),
      Apps("assets/apps/tasbeeh.png", "Tasbeeh"),
      Apps("assets/apps/masjid.png", "Masjid"),
      Apps("assets/apps/kitab.png", "Kitabs"),
    ];
  }
}
