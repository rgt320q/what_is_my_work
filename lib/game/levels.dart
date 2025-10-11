import 'models.dart';

List<Level> buildLevels() {
  return [
    Level(
      type: LevelType.junior,
      stages: List.generate(
        5,
        (stageIdx) =>
            Stage(stageNumber: stageIdx + 1, tasks: _juniorTasks(stageIdx + 1)),
      ),
    ),
    Level(
      type: LevelType.senior,
      stages: List.generate(
        5,
        (stageIdx) =>
            Stage(stageNumber: stageIdx + 1, tasks: _seniorTasks(stageIdx + 1)),
      ),
    ),
    Level(
      type: LevelType.master,
      stages: List.generate(
        5,
        (stageIdx) =>
            Stage(stageNumber: stageIdx + 1, tasks: _masterTasks(stageIdx + 1)),
      ),
    ),
  ];
}

List<Task> _juniorTasks(int stage) {
  switch (stage) {
    case 1:
      return [
        Task(
          name: 'IDE Kurulumu',
          description: 'Geliştirme ortamını kur.',
          durationSeconds: 3,
          documentationUrl: 'https://flutter.dev/docs/get-started/install',
        ),
        Task(
          name: 'Hello World',
          description: 'İlk programını yaz.',
          durationSeconds: 4,
          documentationUrl: 'https://flutter.dev/docs/get-started/codelab',
        ),
        Task(
          name: 'Git Kurulumu',
          description: 'Versiyon kontrol aracı kur.',
          durationSeconds: 3,
          documentationUrl: 'https://git-scm.com/book/en/v2/Getting-Started-Installing-Git',
        ),
        Task(
          name: 'Basit Değişkenler',
          description: 'Değişken tanımla ve kullan.',
          durationSeconds: 5,
          documentationUrl: 'https://dart.dev/language/variables',
        ),
        Task(
          name: 'İlk Commit',
          description: 'Kodunu Git ile kaydet.',
          durationSeconds: 3,
          documentationUrl: 'https://git-scm.com/docs/git-commit',
        ),
      ];
    case 2:
      return [
        Task(
          name: 'Fonksiyon Yaz',
          description: 'Basit bir fonksiyon oluştur.',
          durationSeconds: 4,
        ),
        Task(
          name: 'Döngü Kullan',
          description: 'For/while döngüsü uygula.',
          durationSeconds: 5,
        ),
        Task(
          name: 'Hata Ayıkla',
          description: 'Kodda hata bul ve düzelt.',
          durationSeconds: 6,
        ),
        Task(
          name: 'Yorum Satırı Ekle',
          description: 'Koduna açıklama ekle.',
          durationSeconds: 3,
        ),
        Task(
          name: 'Küçük Proje',
          description: 'Mini bir uygulama geliştir.',
          durationSeconds: 9,
        ),
      ];
    case 3:
      return [
        Task(
          name: 'Fonksiyon Testi',
          description: 'Fonksiyonunu test et.',
          durationSeconds: 40,
        ),
        Task(
          name: 'Basit Sınıf',
          description: 'Bir sınıf oluştur.',
          durationSeconds: 60,
        ),
        Task(
          name: 'Dosya Okuma',
          description: 'Bir dosyadan veri oku.',
          durationSeconds: 50,
        ),
        Task(
          name: 'Veri Yazma',
          description: 'Bir dosyaya veri yaz.',
          durationSeconds: 50,
        ),
        Task(
          name: 'Kod Gözden Geçirme',
          description: 'Kodunu gözden geçir.',
          durationSeconds: 40,
        ),
      ];
    case 4:
      return [
        Task(
          name: 'API Çağrısı',
          description: 'Basit bir API çağrısı yap.',
          durationSeconds: 60,
        ),
        Task(
          name: 'JSON Parse',
          description: 'JSON verisini işle.',
          durationSeconds: 50,
        ),
        Task(
          name: 'Hata Yönetimi',
          description: 'Try-catch ile hata yönet.',
          durationSeconds: 60,
        ),
        Task(
          name: 'Basit UI',
          description: 'Küçük bir arayüz oluştur.',
          durationSeconds: 70,
        ),
        Task(
          name: 'Kod Temizliği',
          description: 'Gereksiz kodları sil.',
          durationSeconds: 40,
        ),
      ];
    case 5:
      return [
        Task(
          name: 'Pull Request',
          description: 'Kodunu ekibe gönder.',
          durationSeconds: 50,
        ),
        Task(
          name: 'Code Review',
          description: 'Başkasının kodunu incele.',
          durationSeconds: 60,
        ),
        Task(
          name: 'Merge İşlemi',
          description: 'Kodları birleştir.',
          durationSeconds: 40,
        ),
        Task(
          name: 'Dokümantasyon',
          description: 'Küçük bir doküman hazırla.',
          durationSeconds: 60,
        ),
        Task(
          name: 'Junior Final',
          description: 'Tüm görevleri tamamla.',
          durationSeconds: 90,
        ),
      ];
    default:
      return [];
  }
}

List<Task> _seniorTasks(int stage) {
  switch (stage) {
    case 1:
      return [
        Task(
          name: 'Kod Refaktörü',
          description: 'Kodun yapısını iyileştir.',
          durationSeconds: 60,
        ),
        Task(
          name: 'Unit Test Yaz',
          description: 'Birim testi uygula.',
          durationSeconds: 70,
        ),
        Task(
          name: 'CI/CD Pipeline',
          description: 'Otomasyon süreci kur.',
          durationSeconds: 80,
        ),
        Task(
          name: 'Veritabanı Tasarımı',
          description: 'Basit bir veritabanı tasarla.',
          durationSeconds: 90,
        ),
        Task(
          name: 'Performans Analizi',
          description: 'Kodun performansını ölç.',
          durationSeconds: 60,
        ),
      ];
    case 2:
      return [
        Task(
          name: 'API Geliştirme',
          description: 'REST API geliştir.',
          durationSeconds: 90,
        ),
        Task(
          name: 'Cache Kullanımı',
          description: 'Veri önbellekleme uygula.',
          durationSeconds: 70,
        ),
        Task(
          name: 'Loglama',
          description: 'Uygulama loglarını yönet.',
          durationSeconds: 60,
        ),
        Task(
          name: 'Ortak Kütüphane',
          description: 'Paylaşılan bir kütüphane yaz.',
          durationSeconds: 80,
        ),
        Task(
          name: 'Kod Standartları',
          description: 'Kod standartlarını uygula.',
          durationSeconds: 60,
        ),
      ];
    case 3:
      return [
        Task(
          name: 'Çok Katmanlı Mimari',
          description: 'Katmanlı yapı kur.',
          durationSeconds: 100,
        ),
        Task(
          name: 'Socket Programlama',
          description: 'Gerçek zamanlı iletişim kur.',
          durationSeconds: 90,
        ),
        Task(
          name: 'Test Otomasyonu',
          description: 'Testleri otomatikleştir.',
          durationSeconds: 80,
        ),
        Task(
          name: 'Versiyon Yükseltme',
          description: 'Bağımlılıkları güncelle.',
          durationSeconds: 60,
        ),
        Task(
          name: 'Kod Analizi',
          description: 'Statik analiz uygula.',
          durationSeconds: 70,
        ),
      ];
    case 4:
      return [
        Task(
          name: 'Takım Yönetimi',
          description: 'Küçük bir ekibi yönet.',
          durationSeconds: 90,
        ),
        Task(
          name: 'Mentorluk',
          description: 'Bir junior geliştiriciye mentorluk yap.',
          durationSeconds: 80,
        ),
        Task(
          name: 'Sprint Planlama',
          description: 'Sprint planı hazırla.',
          durationSeconds: 70,
        ),
        Task(
          name: 'Release Yönetimi',
          description: 'Yayın sürecini yönet.',
          durationSeconds: 80,
        ),
        Task(
          name: 'Dokümantasyon Geliştirme',
          description: 'Gelişmiş doküman hazırla.',
          durationSeconds: 70,
        ),
      ];
    case 5:
      return [
        Task(
          name: 'Kod Denetimi',
          description: 'Kodun güvenliğini denetle.',
          durationSeconds: 80,
        ),
        Task(
          name: 'Performans Optimizasyonu',
          description: 'Uygulamayı optimize et.',
          durationSeconds: 90,
        ),
        Task(
          name: 'Büyük Proje Teslimi',
          description: 'Kapsamlı bir projeyi teslim et.',
          durationSeconds: 120,
        ),
        Task(
          name: 'Senior Final',
          description: 'Tüm görevleri tamamla.',
          durationSeconds: 100,
        ),
        Task(
          name: 'Sunum Hazırlığı',
          description: 'Projeyi sunuma hazırla.',
          durationSeconds: 80,
        ),
      ];
    default:
      return [];
  }
}

List<Task> _masterTasks(int stage) {
  switch (stage) {
    case 1:
      return [
        Task(
          name: 'Teknik Sunum',
          description: 'Teknik bir konuda sunum yap.',
          durationSeconds: 90,
        ),
        Task(
          name: 'Open Source Katkı',
          description: 'Açık kaynak projeye katkı sağla.',
          durationSeconds: 100,
        ),
        Task(
          name: 'Yenilikçi Çözüm',
          description: 'Yeni bir çözüm üret.',
          durationSeconds: 110,
        ),
        Task(
          name: 'Topluluk Etkinliği',
          description: 'Bir etkinlikte konuş.',
          durationSeconds: 90,
        ),
        Task(
          name: 'Mentor Programı',
          description: 'Mentor programı başlat.',
          durationSeconds: 100,
        ),
      ];
    case 2:
      return [
        Task(
          name: 'Makale Yazımı',
          description: 'Teknik makale yaz.',
          durationSeconds: 120,
        ),
        Task(
          name: 'Teknik Değerlendirme',
          description: 'Başka bir projeyi değerlendir.',
          durationSeconds: 100,
        ),
        Task(
          name: 'Yenilikçi Proje',
          description: 'Yenilikçi bir proje başlat.',
          durationSeconds: 130,
        ),
        Task(
          name: 'Eğitim Verme',
          description: 'Bir konuda eğitim ver.',
          durationSeconds: 110,
        ),
        Task(
          name: 'Master Final',
          description: 'Tüm görevleri tamamla.',
          durationSeconds: 120,
        ),
      ];
    case 3:
      return [
        Task(
          name: 'Teknik Liderlik',
          description: 'Büyük bir projede liderlik yap.',
          durationSeconds: 140,
        ),
        Task(
          name: 'Yazılım Mimarisi',
          description: 'Mimari tasarım yap.',
          durationSeconds: 130,
        ),
        Task(
          name: 'Topluluk Yönetimi',
          description: 'Geliştirici topluluğu yönet.',
          durationSeconds: 120,
        ),
        Task(
          name: 'Kariyer Danışmanlığı',
          description: 'Geliştiricilere kariyer danışmanlığı yap.',
          durationSeconds: 110,
        ),
        Task(
          name: 'Global Proje',
          description: 'Uluslararası bir projede çalış.',
          durationSeconds: 150,
        ),
      ];
    case 4:
      return [
        Task(
          name: 'Teknoloji Konferansı',
          description: 'Konferansta konuşmacı ol.',
          durationSeconds: 150,
        ),
        Task(
          name: 'Patent Başvurusu',
          description: 'Bir buluş için patent başvurusu yap.',
          durationSeconds: 130,
        ),
        Task(
          name: 'Kitap Yazımı',
          description: 'Teknik kitap yaz.',
          durationSeconds: 180,
        ),
        Task(
          name: 'Masterclass',
          description: 'Uzmanlık dersi ver.',
          durationSeconds: 140,
        ),
        Task(
          name: 'Master Zirvesi',
          description: 'Zirveye katıl ve sunum yap.',
          durationSeconds: 160,
        ),
      ];
    case 5:
      return [
        Task(
          name: 'Master Final Proje',
          description: 'Tüm seviyeleri tamamla ve oyunu bitir.',
          durationSeconds: 200,
        ),
        Task(
          name: 'Topluluk Liderliği',
          description: 'Topluluğa liderlik et.',
          durationSeconds: 150,
        ),
        Task(
          name: 'Teknoloji Yatırımı',
          description: 'Bir teknolojiye yatırım yap.',
          durationSeconds: 120,
        ),
        Task(
          name: 'Global Sunum',
          description: 'Dünya çapında sunum yap.',
          durationSeconds: 180,
        ),
        Task(
          name: 'Kariyer Zirvesi',
          description: 'Kariyerinin zirvesine ulaş.',
          durationSeconds: 200,
        ),
      ];
    default:
      return [];
  }
}
