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
          questions: [
            Question(
              text: 'Flutter geliştirmek için en popüler IDE hangisidir?',
              options: [
                'Eclipse',
                'Visual Studio',
                'VS Code / Android Studio',
                'NetBeans',
              ],
              correctOptionIndex: 2,
              relatedTaskName: 'IDE Kurulumu',
            ),
            Question(
              text: "Bir IDE'nin temel amacı nedir?",
              options: [
                'Kod derlemek',
                'Hata ayıklamak',
                'Kod yazmayı kolaylaştırmak',
                'Hepsi',
              ],
              correctOptionIndex: 3,
              relatedTaskName: 'IDE Kurulumu',
            ),
            Question(
              text:
                  "Flutter SDK'sını kurduktan sonra hangi komutla kurulumu doğrulayabiliriz?",
              options: [
                'flutter doctor',
                'flutter run',
                'flutter build',
                'flutter check',
              ],
              correctOptionIndex: 0,
              relatedTaskName: 'IDE Kurulumu',
            ),
            Question(
              text: 'IDE için bir Flutter eklentisi ne işe yarar?',
              options: [
                'Sadece kod renklendirmesi sağlar',
                'Otomatik tamamlama ve hata ayıklama sunar',
                'Uygulamayı yayınlar',
                'İnternet bağlantısı sağlar',
              ],
              correctOptionIndex: 1,
              relatedTaskName: 'IDE Kurulumu',
            ),
            Question(
              text:
                  'Android Studio hangi şirket tarafından geliştirilmektedir?',
              options: ['Apple', 'Microsoft', 'Google', 'Facebook'],
              correctOptionIndex: 2,
              relatedTaskName: 'IDE Kurulumu',
            ),
          ],
        ),
        Task(
          name: 'Hello World',
          description: 'İlk programını yaz.',
          durationSeconds: 4,
          taskUrl: 'https://dartpad.dev/',
          explanationUrl: 'https://flutter.dev/docs/get-started/codelab',
          questions: [
            Question(
              text:
                  'Dart dilinde ekrana bir şey yazdırmak için hangi fonksiyon kullanılır?',
              options: [
                'console.log()',
                'print()',
                'System.out.println()',
                'echo()',
              ],
              correctOptionIndex: 1,
              relatedTaskName: 'Hello World',
            ),
            Question(
              text:
                  'Bir Flutter uygulamasının ana başlangıç noktası hangi fonksiyondur?',
              options: ['start()', 'runApp()', 'main()', 'run()'],
              correctOptionIndex: 2,
              relatedTaskName: 'Hello World',
            ),
            Question(
              text:
                  'StatelessWidget ve StatefulWidget arasındaki temel fark nedir?',
              options: [
                'Biri daha hızlıdır',
                'Biri durum (state) yönetebilir, diğeri yönetemez',
                'Biri sadece metin gösterir',
                'Hiçbir fark yoktur',
              ],
              correctOptionIndex: 1,
              relatedTaskName: 'Hello World',
            ),
            Question(
              text: "Flutter'da widget ağacı ne anlama gelir?",
              options: [
                "UI'ı oluşturan widget'ların hiyerarşisi",
                'Bir ağaç resmi çizen widget',
                'Veritabanı şeması',
                'Proje dosya yapısı',
              ],
              correctOptionIndex: 0,
              relatedTaskName: 'Hello World',
            ),
            Question(
              text: 'DartPad nedir?',
              options: [
                'Bir metin editörü',
                'Bir Flutter projesi',
                'Dart kodunu tarayıcıda denemek için bir araç',
                'Bir hata ayıklama aracı',
              ],
              correctOptionIndex: 2,
              relatedTaskName: 'Hello World',
            ),
          ],
        ),
        Task(
          name: 'Git Kurulumu',
          description: 'Versiyon kontrol aracı kur.',
          durationSeconds: 3,
          taskUrl: 'https://git-scm.com/downloads',
          explanationUrl:
              'https://git-scm.com/book/en/v2/Getting-Started-Installing-Git',
          questions: [
            Question(
              text: 'Hangi komut Git versiyonunu gösterir?',
              options: ['git --v', 'git -v', 'git --version', 'git version'],
              correctOptionIndex: 2,
              relatedTaskName: 'Git Kurulumu',
            ),
            Question(
              text: "Git'i kim geliştirdi?",
              options: [
                'Linus Torvalds',
                'Bill Gates',
                'James Gosling',
                'Guido van Rossum',
              ],
              correctOptionIndex: 0,
              relatedTaskName: 'Git Kurulumu',
            ),
            Question(
              text: 'Git bir ..... kontrol sistemidir.',
              options: ['Merkezi', 'Dağıtık', 'Yerel', 'Bulut'],
              correctOptionIndex: 1,
              relatedTaskName: 'Git Kurulumu',
            ),
            Question(
              text:
                  "Git'i kurduktan sonra yapılması gereken ilk yapılandırma nedir?",
              options: [
                'Depo oluşturmak',
                'Kullanıcı adı ve e-posta ayarlamak',
                "İlk commit'i atmak",
                'Dalı değiştirmek',
              ],
              correctOptionIndex: 1,
              relatedTaskName: 'Git Kurulumu',
            ),
            Question(
              text: 'Hangi dosya Git ayarlarını global olarak saklar?',
              options: [
                '.git/config',
                '~/.gitconfig',
                '/etc/gitconfig',
                'Hepsi',
              ],
              correctOptionIndex: 1,
              relatedTaskName: 'Git Kurulumu',
            ),
          ],
        ),
        Task(
          name: 'Basit Değişkenler',
          description: 'Değişken tanımla ve kullan.',
          durationSeconds: 5,
          taskUrl: 'https://dart.dev/language/variables',
          explanationUrl:
              'https://www.google.com/search?q=dart+variables+tutorial',
          questions: [
            Question(
              text:
                  "Dart'ta bir değişkenin değerinin sonradan değiştirilememesi için hangi anahtar kelime kullanılır?",
              options: ['const', 'static', 'final', 'let'],
              correctOptionIndex: 2,
              relatedTaskName: 'Basit Değişkenler',
            ),
            Question(
              text:
                  'Bir değişkenin türünü belirtmeden tanımlamak için ne kullanılır?',
              options: ['auto', 'any', 'var', 'object'],
              correctOptionIndex: 2,
              relatedTaskName: 'Basit Değişkenler',
            ),
            Question(
              text: 'String bir ifadeyi tanımlamak için hangisi kullanılmaz?',
              options: [
                'Tek tırnak (\' \')',
                'Çift tırnak (" ")',
                'Üç tek tırnak (\'\'\' \'\'\')',
                'Ters tırnak (` `)',
              ],
              correctOptionIndex: 3,
              relatedTaskName: 'Basit Değişkenler',
            ),
            Question(
              text: "Dart'ta ondalıklı sayı türü nedir?",
              options: ['float', 'decimal', 'double', 'number'],
              correctOptionIndex: 2,
              relatedTaskName: 'Basit Değişkenler',
            ),
            Question(
              text:
                  'Değeri null olabilen bir integer değişken nasıl tanımlanır?',
              options: [
                'int? a;',
                'int a?;',
                'int a = null;',
                'Nullable<int> a;',
              ],
              correctOptionIndex: 0,
              relatedTaskName: 'Basit Değişkenler',
            ),
          ],
        ),
        Task(
          name: 'İlk Commit',
          description: 'Kodunu Git ile kaydet.',
          durationSeconds: 3,
          taskUrl: 'https://github.com/',
          explanationUrl: 'https://git-scm.com/docs/git-commit',
          questions: [
            Question(
              text:
                  "Değişiklikleri commit'lemeden önce hazırlık alanına eklemek için hangi komut kullanılır?",
              options: ['git commit', 'git push', 'git add', 'git status'],
              correctOptionIndex: 2,
              relatedTaskName: 'İlk Commit',
            ),
            Question(
              text: 'Bir commit mesajı eklemek için hangi flag kullanılır?',
              options: ['-m', '-a', '-c', '-msg'],
              correctOptionIndex: 0,
              relatedTaskName: 'İlk Commit',
            ),
            Question(
              text: 'Projenin durumunu görmek için hangi komut kullanılır?',
              options: ['git log', 'git diff', 'git show', 'git status'],
              correctOptionIndex: 3,
              relatedTaskName: 'İlk Commit',
            ),
            Question(
              text:
                  "Tüm değişiklikleri hazırlık alanına ekleyip commit'lemek için tek komut hangisidir?",
              options: [
                'git commit -a -m "mesaj"',
                'git commit -am "mesaj"',
                'Her ikisi de doğru',
                'Hiçbiri',
              ],
              correctOptionIndex: 2,
              relatedTaskName: 'İlk Commit',
            ),
            Question(
              text: 'Commit geçmişini görmek için hangi komut kullanılır?',
              options: ['git history', 'git log', 'git commits', 'git show'],
              correctOptionIndex: 1,
              relatedTaskName: 'İlk Commit',
            ),
          ],
        ),
      ];
    case 2:
      return [
        Task(
          name: 'Fonksiyon Yaz',
          description: 'Basit bir fonksiyon oluştur.',
          durationSeconds: 4,
          taskUrl: 'https://dart.dev/language/functions',
          explanationUrl:
              'https://www.google.com/search?q=dart+functions+tutorial',
          questions: [
            Question(
              text:
                  "Dart'ta bir fonksiyonun geri dönüş tipi belirtilmezse varsayılan nedir?",
              options: ['void', 'Object', 'dynamic', 'null'],
              correctOptionIndex: 2,
              relatedTaskName: 'Fonksiyon Yaz',
            ),
            Question(
              text: 'Bir fonksiyona isteğe bağlı parametre nasıl eklenir?',
              options: [
                '[] içine alarak',
                '{} içine alarak',
                '() içine alarak',
                '? ekleyerek',
              ],
              correctOptionIndex: 0,
              relatedTaskName: 'Fonksiyon Yaz',
            ),
            Question(
              text: 'Arrow syntax (=>) ne zaman kullanılır?',
              options: [
                'Sadece tek satırlık ifade içeren fonksiyonlarda',
                'Sadece geri dönüşü olmayan fonksiyonlarda',
                'Sadece asenkron fonksiyonlarda',
                'Her zaman kullanılır',
              ],
              correctOptionIndex: 0,
              relatedTaskName: 'Fonksiyon Yaz',
            ),
            Question(
              text:
                  'Bir fonksiyona isimli parametre göndermek için ne kullanılır?',
              options: [
                'func(param: value)',
                'func({param: value})',
                'func([param: value])',
                'func(value)',
              ],
              correctOptionIndex: 1,
              relatedTaskName: 'Fonksiyon Yaz',
            ),
            Question(
              text: 'main() fonksiyonunun görevi nedir?',
              options: [
                'Uygulamanın başlangıç noktasıdır',
                'Tüm değişkenleri sıfırlar',
                'Ekrana yazı yazar',
                'Dosya okur',
              ],
              correctOptionIndex: 0,
              relatedTaskName: 'Fonksiyon Yaz',
            ),
          ],
        ),
        Task(
          name: 'Döngü Kullan',
          description: 'For/while döngüsü uygula.',
          durationSeconds: 5,
          taskUrl: 'https://dart.dev/language/control-flow#for-loops',
          explanationUrl: 'https://www.google.com/search?q=dart+loops+tutorial',
          questions: [
            Question(
              text:
                  'Bir listenin her elemanı için işlem yapmakta en yaygın kullanılan döngü hangisidir?',
              options: ['while', 'do-while', 'for-in', 'switch'],
              correctOptionIndex: 2,
              relatedTaskName: 'Döngü Kullan',
            ),
            Question(
              text: 'Sonsuz bir döngü nasıl oluşturulur?',
              options: ['for(;;)', 'while(true)', 'Her ikisi de', 'Hiçbiri'],
              correctOptionIndex: 2,
              relatedTaskName: 'Döngü Kullan',
            ),
            Question(
              text:
                  'Bir döngüyü mevcut iterasyonu atlayıp bir sonrakine geçirmek için ne kullanılır?',
              options: ['break', 'return', 'exit', 'continue'],
              correctOptionIndex: 3,
              relatedTaskName: 'Döngü Kullan',
            ),
            Question(
              text:
                  'Bir döngüden tamamen çıkmak için hangi anahtar kelime kullanılır?',
              options: ['continue', 'break', 'stop', 'next'],
              correctOptionIndex: 1,
              relatedTaskName: 'Döngü Kullan',
            ),
            Question(
              text: 'while ve do-while döngüleri arasındaki temel fark nedir?',
              options: [
                'do-while en az bir kez çalışır',
                'while daha hızlıdır',
                'do-while sadece listelerde çalışır',
                'Fark yoktur',
              ],
              correctOptionIndex: 0,
              relatedTaskName: 'Döngü Kullan',
            ),
          ],
        ),
        Task(
          name: 'Hata Ayıkla',
          description: 'Kodda hata bul ve düzelt.',
          durationSeconds: 6,
          taskUrl: 'https://dart.dev/tools/debugger',
          explanationUrl: 'https://www.google.com/search?q=debugging+dart+code',
          questions: [
            Question(
              text:
                  'Kodda belirli bir satırda durup değişkenleri incelemek için ne kullanılır?',
              options: [
                'Stop-point',
                'Breakpoint',
                'Pause-point',
                'Check-point',
              ],
              correctOptionIndex: 1,
              relatedTaskName: 'Hata Ayıkla',
            ),
            Question(
              text:
                  'Hata ayıklama sırasında bir sonraki satıra geçmek için hangi komut kullanılır?',
              options: ['Step Over', 'Step Into', 'Continue', 'Step Out'],
              correctOptionIndex: 0,
              relatedTaskName: 'Hata Ayıkla',
            ),
            Question(
              text:
                  'Bir fonksiyonun içine girmek için hangi hata ayıklama komutu kullanılır?',
              options: ['Step Over', 'Step Into', 'Continue', 'Step Out'],
              correctOptionIndex: 1,
              relatedTaskName: 'Hata Ayıkla',
            ),
            Question(
              text: "IDE'de hata ayıklama konsolunun amacı nedir?",
              options: [
                'Kod yazmak',
                'Anlık ifadeler çalıştırmak ve değişkenleri görmek',
                'Dosyaları yönetmek',
                'Uygulamayı derlemek',
              ],
              correctOptionIndex: 1,
              relatedTaskName: 'Hata Ayıkla',
            ),
            Question(
              text: 'Call Stack (Çağrı Yığını) neyi gösterir?',
              options: [
                'Sıradaki fonksiyonu',
                'Mevcut noktaya gelene kadar çağrılan fonksiyonların listesini',
                'Tüm değişkenleri',
                'Hata mesajlarını',
              ],
              correctOptionIndex: 1,
              relatedTaskName: 'Hata Ayıkla',
            ),
          ],
        ),
        Task(
          name: 'Yorum Satırı Ekle',
          description: 'Koduna açıklama ekle.',
          durationSeconds: 3,
          taskUrl: 'https://dart.dev/language/comments',
          explanationUrl:
              'https://www.google.com/search?q=dart+comments+tutorial',
          questions: [
            Question(
              text: "Dart'ta tek satırlık bir yorum nasıl başlatılır?",
              options: ['#', '//', '/*', '--'],
              correctOptionIndex: 1,
              relatedTaskName: 'Yorum Satırı Ekle',
            ),
            Question(
              text: 'Çok satırlı bir yorum bloğu nasıl oluşturulur?',
              options: [
                '// ... //',
                '/* ... */',
                '<!-- ... -->',
                '""" ... """',
              ],
              correctOptionIndex: 1,
              relatedTaskName: 'Yorum Satırı Ekle',
            ),
            Question(
              text:
                  'Otomatik dokümantasyon oluşturmak için kullanılan özel yorum satırı hangisidir?',
              options: ['##', '/** ... */', '///', 'Her ikisi de (b ve c)'],
              correctOptionIndex: 3,
              relatedTaskName: 'Yorum Satırı Ekle',
            ),
            Question(
              text: 'İyi bir yorum satırının özelliği ne olmalıdır?',
              options: [
                'Kodun ne yaptığını tekrar etmeli',
                'Kodun neden o şekilde yazıldığını açıklamalı',
                'Mümkün olduğunca uzun olmalı',
                'Sadece değişkenleri açıklamalı',
              ],
              correctOptionIndex: 1,
              relatedTaskName: 'Yorum Satırı Ekle',
            ),
            Question(
              text:
                  'Geçici olarak bir kod bloğunu devre dışı bırakmak için yorum satırı kullanmaya ne denir?',
              options: ['Commenting out', 'Blocking', 'Hiding', 'Ghosting'],
              correctOptionIndex: 0,
              relatedTaskName: 'Yorum Satırı Ekle',
            ),
          ],
        ),
        Task(
          name: 'Küçük Proje',
          description: 'Mini bir uygulama geliştir.',
          durationSeconds: 9,
          taskUrl: 'https://flutter.dev/docs/get-started/codelab',
          explanationUrl:
              'https://www.google.com/search?q=flutter+simple+project+ideas',
          questions: [
            Question(
              text:
                  "Flutter'da bir projenin bağımlılıkları hangi dosyada yönetilir?",
              options: [
                'project.json',
                'build.gradle',
                'pubspec.yaml',
                'package.json',
              ],
              correctOptionIndex: 2,
              relatedTaskName: 'Küçük Proje',
            ),
            Question(
              text:
                  'Yeni bir Flutter projesi oluşturmak için hangi komut kullanılır?',
              options: [
                'flutter new',
                'flutter create',
                'flutter init',
                'flutter project',
              ],
              correctOptionIndex: 1,
              relatedTaskName: 'Küçük Proje',
            ),
            Question(
              text:
                  'Bir Flutter projesini emülatörde çalıştırmak için temel komut nedir?',
              options: [
                'flutter start',
                'flutter device',
                'flutter go',
                'flutter run',
              ],
              correctOptionIndex: 3,
              relatedTaskName: 'Küçük Proje',
            ),
            Question(
              text: 'Hot Reload ne işe yarar?',
              options: [
                'Uygulamayı yeniden başlatır',
                'Sadece UI değişikliklerini hızlıca uygular',
                'Uygulamayı siler ve yeniden yükler',
                'Derleme hatalarını düzeltir',
              ],
              correctOptionIndex: 1,
              relatedTaskName: 'Küçük Proje',
            ),
            Question(
              text: 'Flutter projesinin ana kodları hangi klasörde bulunur?',
              options: ['src', 'app', 'lib', 'code'],
              correctOptionIndex: 2,
              relatedTaskName: 'Küçük Proje',
            ),
          ],
        ),
      ];
    case 3:
      return [
        Task(
          name: "Fonksiyon Testi",
          description: "Fonksiyonunu test et.",
          durationSeconds: 40,
          taskUrl:
              "https://flutter.dev/docs/cookbook/testing/unit/introduction",
          explanationUrl:
              "https://www.google.com/search?q=flutter+unit+test+tutorial",
          questions: [
            Question(
              text:
                  "Flutter'da birim (unit) testleri için hangi paket kullanılır?",
              options: ["flutter_test", "test", "mockito", "bloc_test"],
              correctOptionIndex: 1,
              relatedTaskName: "Fonksiyon Testi",
            ),
            Question(
              text:
                  "Bir testin başlangıcında bir kez çalışacak kod nereye yazılır?",
              options: ["setUp", "setUpAll", "tearDown", "tearDownAll"],
              correctOptionIndex: 1,
              relatedTaskName: "Fonksiyon Testi",
            ),
            Question(
              text:
                  "Bir testin beklentisini kontrol etmek için hangi fonksiyon kullanılır?",
              options: ["verify()", "check()", "assert()", "expect()"],
              correctOptionIndex: 3,
              relatedTaskName: "Fonksiyon Testi",
            ),
            Question(
              text: "`group()` fonksiyonu testlerde ne için kullanılır?",
              options: [
                "Testleri hızlandırmak için",
                "İlgili testleri bir araya toplamak için",
                "Testleri atlamak için",
                "Hata ayıklamak için",
              ],
              correctOptionIndex: 1,
              relatedTaskName: "Fonksiyon Testi",
            ),
            Question(
              text:
                  "Her testten sonra çalışan temizleme kodları nereye yazılır?",
              options: ["setUp", "setUpAll", "tearDown", "tearDownAll"],
              correctOptionIndex: 2,
              relatedTaskName: "Fonksiyon Testi",
            ),
          ],
        ),
        Task(
          name: "Basit Sınıf",
          description: "Bir sınıf oluştur.",
          durationSeconds: 60,
          taskUrl: "https://dart.dev/language/classes",
          explanationUrl:
              "https://www.google.com/search?q=dart+classes+tutorial",
          questions: [
            Question(
              text:
                  "Bir sınıftan nesne türetmek için hangi anahtar kelime kullanılır?",
              options: [
                "new",
                "create",
                "instance",
                "Hiçbiri, sadece SınıfAdı() yeterlidir",
              ],
              correctOptionIndex: 3,
              relatedTaskName: "Basit Sınıf",
            ),
            Question(
              text:
                  "Bir sınıfın yapıcı (constructor) metodu ne zaman çağrılır?",
              options: [
                "Sınıf tanımlandığında",
                "Nesne türetildiğinde",
                "Metot çağrıldığında",
                "Program bittiğinde",
              ],
              correctOptionIndex: 1,
              relatedTaskName: "Basit Sınıf",
            ),
            Question(
              text: "Sınıf içindeki değişkenlere ne ad verilir?",
              options: [
                "Global değişken",
                "Yerel değişken",
                "Özellik (property/field)",
                "Parametre",
              ],
              correctOptionIndex: 2,
              relatedTaskName: "Basit Sınıf",
            ),
            Question(
              text: "`this` anahtar kelimesi neyi ifade eder?",
              options: [
                "Bir üst sınıfı",
                "Global nesneyi",
                "Sınıfın o anki nesnesini (instance)",
                "Statik metotları",
              ],
              correctOptionIndex: 2,
              relatedTaskName: "Basit Sınıf",
            ),
            Question(
              text:
                  "Bir sınıfın metotlarına dışarıdan erişimi engellemek için metodun başına ne konur?",
              options: ["private", "_", "hidden", "static"],
              correctOptionIndex: 1,
              relatedTaskName: "Basit Sınıf",
            ),
          ],
        ),
        Task(
          name: "Dosya Okuma",
          description: "Bir dosyadan veri oku.",
          durationSeconds: 50,
          taskUrl:
              "https://dart.dev/tutorials/server/cmdline#reading-and-writing-files",
          explanationUrl: "https://www.google.com/search?q=dart+read+file",
          questions: [
            Question(
              text: "Dart'ta dosya işlemleri için hangi kütüphane kullanılır?",
              options: ["dart:io", "dart:file", "dart:system", "dart:path"],
              correctOptionIndex: 0,
              relatedTaskName: "Dosya Okuma",
            ),
            Question(
              text:
                  "Bir dosyayı asenkron olarak satır satır okumak için ne kullanılır?",
              options: [
                "file.readAsLinesSync()",
                "file.open()",
                "file.readAsLines()",
                "file.lines()",
              ],
              correctOptionIndex: 2,
              relatedTaskName: "Dosya Okuma",
            ),
            Question(
              text: "`await` anahtar kelimesi ne işe yarar?",
              options: [
                "Fonksiyonu anında bitirir",
                "Asenkron bir işlemin bitmesini bekler",
                "Hata fırlatır",
                "Yeni bir thread başlatır",
              ],
              correctOptionIndex: 1,
              relatedTaskName: "Dosya Okuma",
            ),
            Question(
              text:
                  "Bir dosyanın var olup olmadığını kontrol eden metot hangisidir?",
              options: ["exists()", "check()", "isOpen()", "isValid()"],
              correctOptionIndex: 0,
              relatedTaskName: "Dosya Okuma",
            ),
            Question(
              text: "Dosya okuma işlemleri neden genellikle asenkron yapılır?",
              options: [
                "Daha havalı olduğu için",
                "UI'ın donmasını engellemek için",
                "Daha az bellek kullandığı için",
                "Daha güvenli olduğu için",
              ],
              correctOptionIndex: 1,
              relatedTaskName: "Dosya Okuma",
            ),
          ],
        ),
        Task(
          name: "Veri Yazma",
          description: "Bir dosyaya veri yaz.",
          durationSeconds: 50,
          taskUrl:
              "https://dart.dev/tutorials/server/cmdline#reading-and-writing-files",
          explanationUrl: "https://www.google.com/search?q=dart+write+file",
          questions: [
            Question(
              text:
                  "Bir dosyaya asenkron olarak metin yazmak için hangi metot kullanılır?",
              options: [
                "file.writeAsString()",
                "file.write()",
                "file.print()",
                "file.save()",
              ],
              correctOptionIndex: 0,
              relatedTaskName: "Veri Yazma",
            ),
            Question(
              text:
                  "Dosyaya yazma modlarından hangisi dosyanın sonuna ekleme yapar?",
              options: [
                "FileMode.write",
                "FileMode.read",
                "FileMode.append",
                "FileMode.create",
              ],
              correctOptionIndex: 2,
              relatedTaskName: "Veri Yazma",
            ),
            Question(
              text: "Bir dosyayı senkron olarak yazmak ne anlama gelir?",
              options: [
                "İşlem bitene kadar programın beklemesi",
                "İşlemin arka planda yapılması",
                "İşlemin yarım kalabilmesi",
                "İşlemin daha hızlı olması",
              ],
              correctOptionIndex: 0,
              relatedTaskName: "Veri Yazma",
            ),
            Question(
              text:
                  "Bir byte listesini dosyaya yazmak için hangi metot kullanılır?",
              options: [
                "writeAsBytes()",
                "writeAsList()",
                "writeAsData()",
                "writeAsBuffer()",
              ],
              correctOptionIndex: 0,
              relatedTaskName: "Veri Yazma",
            ),
            Question(
              text:
                  "Dosya yazma işleminden sonra kaynağı serbest bırakmak için ne yapılmalıdır?",
              options: [
                "Dosyayı silmek",
                "Stream'i kapatmak (close)",
                "Değişkeni null yapmak",
                "Hiçbir şey yapmaya gerek yoktur",
              ],
              correctOptionIndex: 1,
              relatedTaskName: "Veri Yazma",
            ),
          ],
        ),
        Task(
          name: "Kod Gözden Geçirme",
          description: "Kodunu gözden geçir.",
          durationSeconds: 40,
          taskUrl: "https://www.atlassian.com/agile/bitbucket/code-review",
          explanationUrl:
              "https://www.google.com/search?q=code+review+best+practices",
          questions: [
            Question(
              text: "Kod gözden geçirmenin (code review) temel amacı nedir?",
              options: [
                "Hata bulmak",
                "Kod kalitesini artırmak",
                "Bilgi paylaşımı sağlamak",
                "Hepsi",
              ],
              correctOptionIndex: 3,
              relatedTaskName: "Kod Gözden Geçirme",
            ),
            Question(
              text: "Bir Pull Request (PR) nedir?",
              options: [
                "Kodun bir kopyasıdır",
                "Bir hata raporudur",
                "Kod değişikliklerini ana dala eklemek için bir taleptir",
                "Bir test senaryosudur",
              ],
              correctOptionIndex: 2,
              relatedTaskName: "Kod Gözden Geçirme",
            ),
            Question(
              text: "Kod gözden geçirirken yapıcı bir yorum nasıl olmalıdır?",
              options: [
                "'Bu kod çok kötü'",
                "'Neden bu şekilde yaptın?'",
                "'Bu yaklaşım yerine X yaklaşımını düşünür müsün? Çünkü... '",
                "'Bunu hemen düzelt'",
              ],
              correctOptionIndex: 2,
              relatedTaskName: "Kod Gözden Geçirme",
            ),
            Question(
              text: "'LGTM' kısaltması kod incelemelerinde ne anlama gelir?",
              options: [
                "Looks Good To Me",
                "Let's Go To Market",
                "Leave a Good Tip, Man",
                "Let's Get This Merged",
              ],
              correctOptionIndex: 0,
              relatedTaskName: "Kod Gözden Geçirme",
            ),
            Question(
              text: "Kod gözden geçirme sürecini kim başlatır?",
              options: [
                "Proje yöneticisi",
                "Test mühendisi",
                "Kodu yazan geliştirici",
                "Müşteri",
              ],
              correctOptionIndex: 2,
              relatedTaskName: "Kod Gözden Geçirme",
            ),
          ],
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
          explanationUrl:
              'https://www.google.com/search?q=flutter+json+parsing',
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
          explanationUrl:
              'https://www.google.com/search?q=flutter+beginner+ui+tutorial',
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
          taskUrl:
              'https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request',
          explanationUrl:
              'https://www.google.com/search?q=how+to+create+a+pull+request',
        ),
        Task(
          name: 'Code Review',
          description: 'Başkasının kodunu incele.',
          durationSeconds: 60,
          taskUrl:
              'https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/about-pull-request-reviews',
          explanationUrl:
              'https://www.google.com/search?q=how+to+do+a+code+review',
        ),
        Task(
          name: 'Merge İşlemi',
          description: 'Kodları birleştir.',
          durationSeconds: 40,
          taskUrl:
              'https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/merging-a-pull-request',
          explanationUrl:
              'https://www.google.com/search?q=how+to+merge+a+pull+request',
        ),
        Task(
          name: 'Dokümantasyon',
          description: 'Küçük bir doküman hazırla.',
          durationSeconds: 60,
          taskUrl: 'https://www.writethedocs.org/',
          explanationUrl:
              'https://www.google.com/search?q=how+to+write+good+documentation',
        ),
        Task(
          name: 'Junior Final',
          description: 'Tüm görevleri tamamla.',
          durationSeconds: 90,
          taskUrl: 'https://www.google.com/',
          explanationUrl:
              'https://www.google.com/search?q=what+is+next+after+junior+developer',
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
          explanationUrl:
              'https://www.google.com/search?q=what+is+code+refactoring',
        ),
        Task(
          name: 'Unit Test Yaz',
          description: 'Birim testi uygula.',
          durationSeconds: 70,
          taskUrl:
              'https://flutter.dev/docs/cookbook/testing/unit/introduction',
          explanationUrl:
              'https://www.google.com/search?q=flutter+unit+testing+best+practices',
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
          explanationUrl:
              'https://www.google.com/search?q=database+design+tutorial',
        ),
        Task(
          name: 'Performans Analizi',
          description: 'Kodun performansını ölç.',
          durationSeconds: 60,
          taskUrl: 'https://flutter.dev/docs/perf/rendering/ui-performance',
          explanationUrl:
              'https://www.google.com/search?q=flutter+performance+analysis',
        ),
      ];
    case 2:
      return [
        Task(
          name: 'API Geliştirme',
          description: 'REST API geliştir.',
          durationSeconds: 90,
          taskUrl: 'https://restfulapi.net/',
          explanationUrl:
              'https://www.google.com/search?q=rest+api+design+tutorial',
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
          taskUrl:
              'https://www.loggly.com/ultimate-guide/logging-best-practices/',
          explanationUrl:
              'https://www.google.com/search?q=logging+best+practices',
        ),
        Task(
          name: 'Ortak Kütüphane',
          description: 'Paylaşılan bir kütüphane yaz.',
          durationSeconds: 80,
          taskUrl: 'https://dart.dev/guides/libraries/create-library-packages',
          explanationUrl:
              'https://www.google.com/search?q=creating+a+dart+library',
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
          taskUrl:
              'https://www.oreilly.com/library/view/software-architecture-patterns/9781491971437/',
          explanationUrl:
              'https://www.google.com/search?q=multilayered+architecture',
        ),
        Task(
          name: 'Socket Programlama',
          description: 'Gerçek zamanlı iletişim kur.',
          durationSeconds: 90,
          taskUrl:
              'https://dart.dev/tutorials/server/https-servers#web-sockets',
          explanationUrl: 'https://www.google.com/search?q=dart+websockets',
        ),
        Task(
          name: 'Test Otomasyonu',
          description: 'Testleri otomatikleştir.',
          durationSeconds: 80,
          taskUrl: 'https://flutter.dev/docs/testing',
          explanationUrl:
              'https://www.google.com/search?q=flutter+test+automation',
        ),
        Task(
          name: 'Versiyon Yükseltme',
          description: 'Bağımlılıkları güncelle.',
          durationSeconds: 60,
          taskUrl: 'https://dart.dev/tools/pub/cmd/pub-upgrade',
          explanationUrl:
              'https://www.google.com/search?q=flutter+dependency+management',
        ),
        Task(
          name: 'Kod Analizi',
          description: 'Statik analiz uygula.',
          durationSeconds: 70,
          taskUrl: 'https://dart.dev/tools/linter-rules',
          explanationUrl:
              'https://www.google.com/search?q=dart+static+analysis',
        ),
      ];
    case 4:
      return [
        Task(
          name: 'Takım Yönetimi',
          description: 'Küçük bir ekibi yönet.',
          durationSeconds: 90,
          taskUrl: 'https://www.atlassian.com/agile/project-management',
          explanationUrl:
              'https://www.google.com/search?q=agile+team+management',
        ),
        Task(
          name: 'Mentorluk',
          description: 'Bir junior geliştiriciye mentorluk yap.',
          durationSeconds: 80,
          taskUrl:
              'https://www.pluralsight.com/blog/software-development/mentoring-junior-developers',
          explanationUrl:
              'https://www.google.com/search?q=how+to+mentor+junior+developers',
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
          taskUrl:
              'https://www.atlassian.com/continuous-delivery/release-management',
          explanationUrl: 'https://www.google.com/search?q=release+management',
        ),
        Task(
          name: 'Dokümantasyon Geliştirme',
          description: 'Gelişmiş doküman hazırla.',
          durationSeconds: 70,
          taskUrl:
              'https://www.writethedocs.org/guide/writing/beginners-guide-to-docs/',
          explanationUrl:
              'https://www.google.com/search?q=advanced+technical+writing',
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
          explanationUrl:
              'https://www.google.com/search?q=flutter+performance+optimization',
        ),
        Task(
          name: 'Büyük Proje Teslimi',
          description: 'Kapsamlı bir projeyi teslim et.',
          durationSeconds: 120,
          taskUrl:
              'https://www.pmi.org/learning/library/project-delivery-framework-7541',
          explanationUrl:
              'https://www.google.com/search?q=project+delivery+methodologies',
        ),
        Task(
          name: 'Senior Final',
          description: 'Tüm görevleri tamamla.',
          durationSeconds: 100,
          taskUrl: 'https://www.google.com/',
          explanationUrl:
              'https://www.google.com/search?q=what+is+next+after+senior+developer',
        ),
        Task(
          name: 'Sunum Hazırlığı',
          description: 'Projeyi sunuma hazırla.',
          durationSeconds: 80,
          taskUrl:
              'https://www.harvardbusiness.org/how-to-give-a-killer-presentation/',
          explanationUrl:
              'https://www.google.com/search?q=how+to+prepare+a+project+presentation',
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
          explanationUrl:
              'https://www.google.com/search?q=how+to+give+a+technical+presentation',
        ),
        Task(
          name: 'Open Source Katkı',
          description: 'Açık kaynak projeye katkı sağla.',
          durationSeconds: 100,
          taskUrl: 'https://github.com/explore',
          explanationUrl:
              'https://www.google.com/search?q=how+to+contribute+to+open+source',
        ),
        Task(
          name: 'Yenilikçi Çözüm',
          description: 'Yeni bir çözüm üret.',
          durationSeconds: 110,
          taskUrl:
              'https://www.ideo.com/blog/seven-tips-for-better-brainstorming',
          explanationUrl: 'https://www.google.com/search?q=how+to+innovate',
        ),
        Task(
          name: 'Topluluk Etkinliği',
          description: 'Bir etkinlikte konuş.',
          durationSeconds: 90,
          taskUrl: 'https://www.meetup.com/',
          explanationUrl:
              'https://www.google.com/search?q=public+speaking+tips',
        ),
        Task(
          name: 'Mentor Programı',
          description: 'Mentor programı başlat.',
          durationSeconds: 100,
          taskUrl: 'https://www.mentoring.org/',
          explanationUrl:
              'https://www.google.com/search?q=how+to+start+a+mentoring+program',
        ),
      ];
    case 2:
      return [
        Task(
          name: 'Makale Yazımı',
          description: 'Teknik makale yaz.',
          durationSeconds: 120,
          taskUrl: 'https://medium.com/',
          explanationUrl:
              'https://www.google.com/search?q=how+to+write+a+technical+article',
        ),
        Task(
          name: 'Teknik Değerlendirme',
          description: 'Başka bir projeyi değerlendir.',
          durationSeconds: 100,
          taskUrl: 'https://www.codacy.com/',
          explanationUrl:
              'https://www.google.com/search?q=how+to+do+a+technical+assessment',
        ),
        Task(
          name: 'Yenilikçi Proje',
          description: 'Yenilikçi bir proje başlat.',
          durationSeconds: 130,
          taskUrl: 'https://www.ycombinator.com/library',
          explanationUrl:
              'https://www.google.com/search?q=how+to+start+an+innovative+project',
        ),
        Task(
          name: 'Eğitim Verme',
          description: 'Bir konuda eğitim ver.',
          durationSeconds: 110,
          taskUrl: 'https://www.coursera.org/',
          explanationUrl:
              'https://www.google.com/search?q=how+to+give+a+training+session',
        ),
        Task(
          name: 'Master Final',
          description: 'Tüm görevleri tamamla.',
          durationSeconds: 120,
          taskUrl: 'https://www.google.com/',
          explanationUrl:
              'https://www.google.com/search?q=what+is+next+after+master+developer',
        ),
      ];
    case 3:
      return [
        Task(
          name: 'Teknik Liderlik',
          description: 'Büyük bir projede liderlik yap.',
          durationSeconds: 140,
          taskUrl: 'https://www.atlassian.com/agile/teams/team-lead',
          explanationUrl:
              'https://www.google.com/search?q=technical+leadership+skills',
        ),
        Task(
          name: 'Yazılım Mimarisi',
          description: 'Mimari tasarım yap.',
          durationSeconds: 130,
          taskUrl: 'https://aws.amazon.com/architecture/',
          explanationUrl:
              'https://www.google.com/search?q=software+architecture+design',
        ),
        Task(
          name: 'Topluluk Yönetimi',
          description: 'Geliştirici topluluğu yönet.',
          durationSeconds: 120,
          taskUrl: 'https://community.cmxhub.com/',
          explanationUrl:
              'https://www.google.com/search?q=developer+community+management',
        ),
        Task(
          name: 'Kariyer Danışmanlığı',
          description: 'Geliştiricilere kariyer danışmanlığı yap.',
          durationSeconds: 110,
          taskUrl: 'https://www.linkedin.com/advice',
          explanationUrl:
              'https://www.google.com/search?q=career+advice+for+developers',
        ),
        Task(
          name: 'Global Proje',
          description: 'Uluslararası bir projede çalış.',
          durationSeconds: 150,
          taskUrl: 'https://www.toptal.com/',
          explanationUrl:
              'https://www.google.com/search?q=working+on+global+projects',
        ),
      ];
    case 4:
      return [
        Task(
          name: 'Teknoloji Konferansı',
          description: 'Konferansta konuşmacı ol.',
          durationSeconds: 150,
          taskUrl: 'https://www.papercall.io/',
          explanationUrl:
              'https://www.google.com/search?q=how+to+speak+at+a+tech+conference',
        ),
        Task(
          name: 'Patent Başvurusu',
          description: 'Bir buluş için patent başvurusu yap.',
          durationSeconds: 130,
          taskUrl: 'https://www.uspto.gov/patents/basics/apply-patent',
          explanationUrl:
              'https://www.google.com/search?q=how+to+apply+for+a+patent',
        ),
        Task(
          name: 'Kitap Yazımı',
          description: 'Teknik kitap yaz.',
          durationSeconds: 180,
          taskUrl: 'https://www.amazon.com/kdp',
          explanationUrl:
              'https://www.google.com/search?q=how+to+write+a+technical+book',
        ),
        Task(
          name: 'Masterclass',
          description: 'Uzmanlık dersi ver.',
          durationSeconds: 140,
          taskUrl: 'https://www.masterclass.com/',
          explanationUrl:
              'https://www.google.com/search?q=how+to+create+a+masterclass',
        ),
        Task(
          name: 'Master Zirvesi',
          description: 'Zirveye katıl ve sunum yap.',
          durationSeconds: 160,
          taskUrl: 'https://www.weforum.org/',
          explanationUrl:
              'https://www.google.com/search?q=how+to+present+at+a+summit',
        ),
      ];
    case 5:
      return [
        Task(
          name: 'Master Final Proje',
          description: 'Tüm seviyeleri tamamla ve oyunu bitir.',
          durationSeconds: 200,
          taskUrl: 'https://www.google.com/',
          explanationUrl:
              'https://www.google.com/search?q=what+is+the+end+of+a+career',
        ),
        Task(
          name: 'Topluluk Liderliği',
          description: 'Topluluğa liderlik et.',
          durationSeconds: 150,
          taskUrl: 'https://www.cmxhub.com/',
          explanationUrl:
              'https://www.google.com/search?q=community+leadership',
        ),
        Task(
          name: 'Teknoloji Yatırımı',
          description: 'Bir teknolojiye yatırım yap.',
          durationSeconds: 120,
          taskUrl: 'https://www.angellist.com/',
          explanationUrl:
              'https://www.google.com/search?q=how+to+invest+in+technology',
        ),
        Task(
          name: 'Global Sunum',
          description: 'Dünya çapında sunum yap.',
          durationSeconds: 180,
          taskUrl: 'https://www.ted.com/',
          explanationUrl:
              'https://www.google.com/search?q=how+to+give+a+global+presentation',
        ),
        Task(
          name: 'Kariyer Zirvesi',
          description: 'Kariyerinin zirvesine ulaş.',
          durationSeconds: 200,
          taskUrl: 'https://www.google.com/',
          explanationUrl:
              'https://www.google.com/search?q=what+is+the+pinnacle+of+a+career',
        ),
      ];
    default:
      return [];
  }
}
