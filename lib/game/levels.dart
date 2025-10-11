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
          taskUrl: 'https://code.visualstudio.com/',
          explanationUrl: 'https://flutter.dev/docs/get-started/install',
        ),
        Task(
          name: 'Hello World',
          description: 'İlk programını yaz.',
          durationSeconds: 4,
          taskUrl: 'https://dartpad.dev/',
          explanationUrl: 'https://flutter.dev/docs/get-started/codelab',
        ),
        Task(
          name: 'Git Kurulumu',
          description: 'Versiyon kontrol aracı kur.',
          durationSeconds: 3,
          taskUrl: 'https://git-scm.com/downloads',
          explanationUrl: 'https://git-scm.com/book/en/v2/Getting-Started-Installing-Git',
        ),
        Task(
          name: 'Basit Değişkenler',
          description: 'Değişken tanımla ve kullan.',
          durationSeconds: 5,
          taskUrl: 'https://dart.dev/language/variables',
          explanationUrl: 'https://www.google.com/search?q=dart+variables+tutorial',
        ),
        Task(
          name: 'İlk Commit',
          description: 'Kodunu Git ile kaydet.',
          durationSeconds: 3,
          taskUrl: 'https://github.com/',
          explanationUrl: 'https://git-scm.com/docs/git-commit',
        ),
      ];
    case 2:
      return [
        Task(
          name: 'Fonksiyon Yaz',
          description: 'Basit bir fonksiyon oluştur.',
          durationSeconds: 4,
          taskUrl: 'https://dart.dev/language/functions',
          explanationUrl: 'https://www.google.com/search?q=dart+functions+tutorial',
        ),
        Task(
          name: 'Döngü Kullan',
          description: 'For/while döngüsü uygula.',
          durationSeconds: 5,
          taskUrl: 'https://dart.dev/language/control-flow#for-loops',
          explanationUrl: 'https://www.google.com/search?q=dart+loops+tutorial',
        ),
        Task(
          name: 'Hata Ayıkla',
          description: 'Kodda hata bul ve düzelt.',
          durationSeconds: 6,
          taskUrl: 'https://dart.dev/tools/debugger',
          explanationUrl: 'https://www.google.com/search?q=debugging+dart+code',
        ),
        Task(
          name: 'Yorum Satırı Ekle',
          description: 'Koduna açıklama ekle.',
          durationSeconds: 3,
          taskUrl: 'https://dart.dev/language/comments',
          explanationUrl: 'https://www.google.com/search?q=dart+comments+tutorial',
        ),
        Task(
          name: 'Küçük Proje',
          description: 'Mini bir uygulama geliştir.',
          durationSeconds: 9,
          taskUrl: 'https://flutter.dev/docs/get-started/codelab',
          explanationUrl: 'https://www.google.com/search?q=flutter+simple+project+ideas',
        ),
      ];
    case 3:
      return [
        Task(
          name: 'Fonksiyon Testi',
          description: 'Fonksiyonunu test et.',
          durationSeconds: 40,
          taskUrl: 'https://flutter.dev/docs/cookbook/testing/unit/introduction',
          explanationUrl: 'https://www.google.com/search?q=flutter+unit+test+tutorial',
        ),
        Task(
          name: 'Basit Sınıf',
          description: 'Bir sınıf oluştur.',
          durationSeconds: 60,
          taskUrl: 'https://dart.dev/language/classes',
          explanationUrl: 'https://www.google.com/search?q=dart+classes+tutorial',
        ),
        Task(
          name: 'Dosya Okuma',
          description: 'Bir dosyadan veri oku.',
          durationSeconds: 50,
          taskUrl: 'https://dart.dev/tutorials/server/cmdline#reading-and-writing-files',
          explanationUrl: 'https://www.google.com/search?q=dart+read+file',
        ),
        Task(
          name: 'Veri Yazma',
          description: 'Bir dosyaya veri yaz.',
          durationSeconds: 50,
          taskUrl: 'https://dart.dev/tutorials/server/cmdline#reading-and-writing-files',
          explanationUrl: 'https://www.google.com/search?q=dart+write+file',
        ),
        Task(
          name: 'Kod Gözden Geçirme',
          description: 'Kodunu gözden geçir.',
          durationSeconds: 40,
          taskUrl: 'https://www.atlassian.com/agile/bitbucket/code-review',
          explanationUrl: 'https://www.google.com/search?q=code+review+best+practices',
        ),
      ];
    case 4:
      return [
        Task(
          name: 'API Çağrısı',
          description: 'Basit bir API çağrısı yap.',
          durationSeconds: 60,
          taskUrl: 'https://dart.dev/tutorials/server/fetch-data',
          explanationUrl: 'https://www.google.com/search?q=dart+http+request',
        ),
        Task(
          name: 'JSON Parse',
          description: 'JSON verisini işle.',
          durationSeconds: 50,
          taskUrl: 'https://flutter.dev/docs/development/data-and-backend/json',
          explanationUrl: 'https://www.google.com/search?q=flutter+json+parsing',
        ),
        Task(
          name: 'Hata Yönetimi',
          description: 'Try-catch ile hata yönet.',
          durationSeconds: 60,
          taskUrl: 'https://dart.dev/language/error-handling',
          explanationUrl: 'https://www.google.com/search?q=dart+try+catch',
        ),
        Task(
          name: 'Basit UI',
          description: 'Küçük bir arayüz oluştur.',
          durationSeconds: 70,
          taskUrl: 'https://flutter.dev/docs/development/ui/widgets-intro',
          explanationUrl: 'https://www.google.com/search?q=flutter+beginner+ui+tutorial',
        ),
        Task(
          name: 'Kod Temizliği',
          description: 'Gereksiz kodları sil.',
          durationSeconds: 40,
          taskUrl: 'https://www.sonarsource.com/solutions/clean-code/',
          explanationUrl: 'https://www.google.com/search?q=what+is+clean+code',
        ),
      ];
    case 5:
      return [
        Task(
          name: 'Pull Request',
          description: 'Kodunu ekibe gönder.',
          durationSeconds: 50,
          taskUrl: 'https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request',
          explanationUrl: 'https://www.google.com/search?q=how+to+create+a+pull+request',
        ),
        Task(
          name: 'Code Review',
          description: 'Başkasının kodunu incele.',
          durationSeconds: 60,
          taskUrl: 'https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/about-pull-request-reviews',
          explanationUrl: 'https://www.google.com/search?q=how+to+do+a+code+review',
        ),
        Task(
          name: 'Merge İşlemi',
          description: 'Kodları birleştir.',
          durationSeconds: 40,
          taskUrl: 'https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/merging-a-pull-request',
          explanationUrl: 'https://www.google.com/search?q=how+to+merge+a+pull+request',
        ),
        Task(
          name: 'Dokümantasyon',
          description: 'Küçük bir doküman hazırla.',
          durationSeconds: 60,
          taskUrl: 'https://www.writethedocs.org/',
          explanationUrl: 'https://www.google.com/search?q=how+to+write+good+documentation',
        ),
        Task(
          name: 'Junior Final',
          description: 'Tüm görevleri tamamla.',
          durationSeconds: 90,
          taskUrl: 'https://www.google.com/',
          explanationUrl: 'https://www.google.com/search?q=what+is+next+after+junior+developer',
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
          taskUrl: 'https://refactoring.guru/',
          explanationUrl: 'https://www.google.com/search?q=what+is+code+refactoring',
        ),
        Task(
          name: 'Unit Test Yaz',
          description: 'Birim testi uygula.',
          durationSeconds: 70,
          taskUrl: 'https://flutter.dev/docs/cookbook/testing/unit/introduction',
          explanationUrl: 'https://www.google.com/search?q=flutter+unit+testing+best+practices',
        ),
        Task(
          name: 'CI/CD Pipeline',
          description: 'Otomasyon süreci kur.',
          durationSeconds: 80,
          taskUrl: 'https://www.atlassian.com/continuous-delivery/ci-cd',
          explanationUrl: 'https://www.google.com/search?q=what+is+ci+cd',
        ),
        Task(
          name: 'Veritabanı Tasarımı',
          description: 'Basit bir veritabanı tasarla.',
          durationSeconds: 90,
          taskUrl: 'https://www.lucidchart.com/pages/database-diagram',
          explanationUrl: 'https://www.google.com/search?q=database+design+tutorial',
        ),
        Task(
          name: 'Performans Analizi',
          description: 'Kodun performansını ölç.',
          durationSeconds: 60,
          taskUrl: 'https://flutter.dev/docs/perf/rendering/ui-performance',
          explanationUrl: 'https://www.google.com/search?q=flutter+performance+analysis',
        ),
      ];
    case 2:
      return [
        Task(
          name: 'API Geliştirme',
          description: 'REST API geliştir.',
          durationSeconds: 90,
          taskUrl: 'https://restfulapi.net/',
          explanationUrl: 'https://www.google.com/search?q=rest+api+design+tutorial',
        ),
        Task(
          name: 'Cache Kullanımı',
          description: 'Veri önbellekleme uygula.',
          durationSeconds: 70,
          taskUrl: 'https://aws.amazon.com/caching/',
          explanationUrl: 'https://www.google.com/search?q=caching+strategies',
        ),
        Task(
          name: 'Loglama',
          description: 'Uygulama loglarını yönet.',
          durationSeconds: 60,
          taskUrl: 'https://www.loggly.com/ultimate-guide/logging-best-practices/',
          explanationUrl: 'https://www.google.com/search?q=logging+best+practices',
        ),
        Task(
          name: 'Ortak Kütüphane',
          description: 'Paylaşılan bir kütüphane yaz.',
          durationSeconds: 80,
          taskUrl: 'https://dart.dev/guides/libraries/create-library-packages',
          explanationUrl: 'https://www.google.com/search?q=creating+a+dart+library',
        ),
        Task(
          name: 'Kod Standartları',
          description: 'Kod standartlarını uygula.',
          durationSeconds: 60,
          taskUrl: 'https://dart.dev/effective-dart',
          explanationUrl: 'https://www.google.com/search?q=dart+code+style',
        ),
      ];
    case 3:
      return [
        Task(
          name: 'Çok Katmanlı Mimari',
          description: 'Katmanlı yapı kur.',
          durationSeconds: 100,
          taskUrl: 'https://www.oreilly.com/library/view/software-architecture-patterns/9781491971437/',
          explanationUrl: 'https://www.google.com/search?q=multilayered+architecture',
        ),
        Task(
          name: 'Socket Programlama',
          description: 'Gerçek zamanlı iletişim kur.',
          durationSeconds: 90,
          taskUrl: 'https://dart.dev/tutorials/server/https-servers#web-sockets',
          explanationUrl: 'https://www.google.com/search?q=dart+websockets',
        ),
        Task(
          name: 'Test Otomasyonu',
          description: 'Testleri otomatikleştir.',
          durationSeconds: 80,
          taskUrl: 'https://flutter.dev/docs/testing',
          explanationUrl: 'https://www.google.com/search?q=flutter+test+automation',
        ),
        Task(
          name: 'Versiyon Yükseltme',
          description: 'Bağımlılıkları güncelle.',
          durationSeconds: 60,
          taskUrl: 'https://dart.dev/tools/pub/cmd/pub-upgrade',
          explanationUrl: 'https://www.google.com/search?q=flutter+dependency+management',
        ),
        Task(
          name: 'Kod Analizi',
          description: 'Statik analiz uygula.',
          durationSeconds: 70,
          taskUrl: 'https://dart.dev/tools/linter-rules',
          explanationUrl: 'https://www.google.com/search?q=dart+static+analysis',
        ),
      ];
    case 4:
      return [
        Task(
          name: 'Takım Yönetimi',
          description: 'Küçük bir ekibi yönet.',
          durationSeconds: 90,
          taskUrl: 'https://www.atlassian.com/agile/project-management',
          explanationUrl: 'https://www.google.com/search?q=agile+team+management',
        ),
        Task(
          name: 'Mentorluk',
          description: 'Bir junior geliştiriciye mentorluk yap.',
          durationSeconds: 80,
          taskUrl: 'https://www.pluralsight.com/blog/software-development/mentoring-junior-developers',
          explanationUrl: 'https://www.google.com/search?q=how+to+mentor+junior+developers',
        ),
        Task(
          name: 'Sprint Planlama',
          description: 'Sprint planı hazırla.',
          durationSeconds: 70,
          taskUrl: 'https://www.atlassian.com/agile/scrum/sprint-planning',
          explanationUrl: 'https://www.google.com/search?q=sprint+planning',
        ),
        Task(
          name: 'Release Yönetimi',
          description: 'Yayın sürecini yönet.',
          durationSeconds: 80,
          taskUrl: 'https://www.atlassian.com/continuous-delivery/release-management',
          explanationUrl: 'https://www.google.com/search?q=release+management',
        ),
        Task(
          name: 'Dokümantasyon Geliştirme',
          description: 'Gelişmiş doküman hazırla.',
          durationSeconds: 70,
          taskUrl: 'https://www.writethedocs.org/guide/writing/beginners-guide-to-docs/',
          explanationUrl: 'https://www.google.com/search?q=advanced+technical+writing',
        ),
      ];
    case 5:
      return [
        Task(
          name: 'Kod Denetimi',
          description: 'Kodun güvenliğini denetle.',
          durationSeconds: 80,
          taskUrl: 'https://owasp.org/www-project-code-review-guide/',
          explanationUrl: 'https://www.google.com/search?q=code+security+audit',
        ),
        Task(
          name: 'Performans Optimizasyonu',
          description: 'Uygulamayı optimize et.',
          durationSeconds: 90,
          taskUrl: 'https://flutter.dev/docs/perf',
          explanationUrl: 'https://www.google.com/search?q=flutter+performance+optimization',
        ),
        Task(
          name: 'Büyük Proje Teslimi',
          description: 'Kapsamlı bir projeyi teslim et.',
          durationSeconds: 120,
          taskUrl: 'https://www.pmi.org/learning/library/project-delivery-framework-7541',
          explanationUrl: 'https://www.google.com/search?q=project+delivery+methodologies',
        ),
        Task(
          name: 'Senior Final',
          description: 'Tüm görevleri tamamla.',
          durationSeconds: 100,
          taskUrl: 'https://www.google.com/',
          explanationUrl: 'https://www.google.com/search?q=what+is+next+after+senior+developer',
        ),
        Task(
          name: 'Sunum Hazırlığı',
          description: 'Projeyi sunuma hazırla.',
          durationSeconds: 80,
          taskUrl: 'https://www.harvardbusiness.org/how-to-give-a-killer-presentation/',
          explanationUrl: 'https://www.google.com/search?q=how+to+prepare+a+project+presentation',
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
          taskUrl: 'https://www.ted.com/talks',
          explanationUrl: 'https://www.google.com/search?q=how+to+give+a+technical+presentation',
        ),
        Task(
          name: 'Open Source Katkı',
          description: 'Açık kaynak projeye katkı sağla.',
          durationSeconds: 100,
          taskUrl: 'https://github.com/explore',
          explanationUrl: 'https://www.google.com/search?q=how+to+contribute+to+open+source',
        ),
        Task(
          name: 'Yenilikçi Çözüm',
          description: 'Yeni bir çözüm üret.',
          durationSeconds: 110,
          taskUrl: 'https://www.ideo.com/blog/seven-tips-for-better-brainstorming',
          explanationUrl: 'https://www.google.com/search?q=how+to+innovate',
        ),
        Task(
          name: 'Topluluk Etkinliği',
          description: 'Bir etkinlikte konuş.',
          durationSeconds: 90,
          taskUrl: 'https://www.meetup.com/',
          explanationUrl: 'https://www.google.com/search?q=public+speaking+tips',
        ),
        Task(
          name: 'Mentor Programı',
          description: 'Mentor programı başlat.',
          durationSeconds: 100,
          taskUrl: 'https://www.mentoring.org/',
          explanationUrl: 'https://www.google.com/search?q=how+to+start+a+mentoring+program',
        ),
      ];
    case 2:
      return [
        Task(
          name: 'Makale Yazımı',
          description: 'Teknik makale yaz.',
          durationSeconds: 120,
          taskUrl: 'https://medium.com/',
          explanationUrl: 'https://www.google.com/search?q=how+to+write+a+technical+article',
        ),
        Task(
          name: 'Teknik Değerlendirme',
          description: 'Başka bir projeyi değerlendir.',
          durationSeconds: 100,
          taskUrl: 'https://www.codacy.com/',
          explanationUrl: 'https://www.google.com/search?q=how+to+do+a+technical+assessment',
        ),
        Task(
          name: 'Yenilikçi Proje',
          description: 'Yenilikçi bir proje başlat.',
          durationSeconds: 130,
          taskUrl: 'https://www.ycombinator.com/library',
          explanationUrl: 'https://www.google.com/search?q=how+to+start+an+innovative+project',
        ),
        Task(
          name: 'Eğitim Verme',
          description: 'Bir konuda eğitim ver.',
          durationSeconds: 110,
          taskUrl: 'https://www.coursera.org/',
          explanationUrl: 'https://www.google.com/search?q=how+to+give+a+training+session',
        ),
        Task(
          name: 'Master Final',
          description: 'Tüm görevleri tamamla.',
          durationSeconds: 120,
          taskUrl: 'https://www.google.com/',
          explanationUrl: 'https://www.google.com/search?q=what+is+next+after+master+developer',
        ),
      ];
    case 3:
      return [
        Task(
          name: 'Teknik Liderlik',
          description: 'Büyük bir projede liderlik yap.',
          durationSeconds: 140,
          taskUrl: 'https://www.atlassian.com/agile/teams/team-lead',
          explanationUrl: 'https://www.google.com/search?q=technical+leadership+skills',
        ),
        Task(
          name: 'Yazılım Mimarisi',
          description: 'Mimari tasarım yap.',
          durationSeconds: 130,
          taskUrl: 'https://aws.amazon.com/architecture/',
          explanationUrl: 'https://www.google.com/search?q=software+architecture+design',
        ),
        Task(
          name: 'Topluluk Yönetimi',
          description: 'Geliştirici topluluğu yönet.',
          durationSeconds: 120,
          taskUrl: 'https://community.cmxhub.com/',
          explanationUrl: 'https://www.google.com/search?q=developer+community+management',
        ),
        Task(
          name: 'Kariyer Danışmanlığı',
          description: 'Geliştiricilere kariyer danışmanlığı yap.',
          durationSeconds: 110,
          taskUrl: 'https://www.linkedin.com/advice',
          explanationUrl: 'https://www.google.com/search?q=career+advice+for+developers',
        ),
        Task(
          name: 'Global Proje',
          description: 'Uluslararası bir projede çalış.',
          durationSeconds: 150,
          taskUrl: 'https://www.toptal.com/',
          explanationUrl: 'https://www.google.com/search?q=working+on+global+projects',
        ),
      ];
    case 4:
      return [
        Task(
          name: 'Teknoloji Konferansı',
          description: 'Konferansta konuşmacı ol.',
          durationSeconds: 150,
          taskUrl: 'https://www.papercall.io/',
          explanationUrl: 'https://www.google.com/search?q=how+to+speak+at+a+tech+conference',
        ),
        Task(
          name: 'Patent Başvurusu',
          description: 'Bir buluş için patent başvurusu yap.',
          durationSeconds: 130,
          taskUrl: 'https://www.uspto.gov/patents/basics/apply-patent',
          explanationUrl: 'https://www.google.com/search?q=how+to+apply+for+a+patent',
        ),
        Task(
          name: 'Kitap Yazımı',
          description: 'Teknik kitap yaz.',
          durationSeconds: 180,
          taskUrl: 'https://www.amazon.com/kdp',
          explanationUrl: 'https://www.google.com/search?q=how+to+write+a+technical+book',
        ),
        Task(
          name: 'Masterclass',
          description: 'Uzmanlık dersi ver.',
          durationSeconds: 140,
          taskUrl: 'https://www.masterclass.com/',
          explanationUrl: 'https://www.google.com/search?q=how+to+create+a+masterclass',
        ),
        Task(
          name: 'Master Zirvesi',
          description: 'Zirveye katıl ve sunum yap.',
          durationSeconds: 160,
          taskUrl: 'https://www.weforum.org/',
          explanationUrl: 'https://www.google.com/search?q=how+to+present+at+a+summit',
        ),
      ];
    case 5:
      return [
        Task(
          name: 'Master Final Proje',
          description: 'Tüm seviyeleri tamamla ve oyunu bitir.',
          durationSeconds: 200,
          taskUrl: 'https://www.google.com/',
          explanationUrl: 'https://www.google.com/search?q=what+is+the+end+of+a+career',
        ),
        Task(
          name: 'Topluluk Liderliği',
          description: 'Topluluğa liderlik et.',
          durationSeconds: 150,
          taskUrl: 'https://www.cmxhub.com/',
          explanationUrl: 'https://www.google.com/search?q=community+leadership',
        ),
        Task(
          name: 'Teknoloji Yatırımı',
          description: 'Bir teknolojiye yatırım yap.',
          durationSeconds: 120,
          taskUrl: 'https://www.angellist.com/',
          explanationUrl: 'https://www.google.com/search?q=how+to+invest+in+technology',
        ),
        Task(
          name: 'Global Sunum',
          description: 'Dünya çapında sunum yap.',
          durationSeconds: 180,
          taskUrl: 'https://www.ted.com/',
          explanationUrl: 'https://www.google.com/search?q=how+to+give+a+global+presentation',
        ),
        Task(
          name: 'Kariyer Zirvesi',
          description: 'Kariyerinin zirvesine ulaş.',
          durationSeconds: 200,
          taskUrl: 'https://www.google.com/',
          explanationUrl: 'https://www.google.com/search?q=what+is+the+pinnacle+of+a+career',
        ),
      ];
    default:
      return [];
  }
}