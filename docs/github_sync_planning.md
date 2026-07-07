# Синхронизация через private GitHub repo

## Цель

Добавить в Easy Fin синхронизацию локальной базы данных (`easy_fin.sqlite`) с **приватным GitHub-репозиторием**. Два устройства (iPhone + Mac) работают **по очереди**, параллельного редактирования нет.

Приложение **при запуске** автоматически скачивает данные с GitHub — **только если версия на сервере новее локальной**. Кнопка **«Синхронизировать»** отправляет локальные изменения на GitHub (upload).

### Рабочий процесс (2 устройства)

```
iPhone: поработала → «Синхронизировать» (upload) → закрыла
Mac:    открыла     → автоматически скачалось с GitHub
Mac:    поработала → «Синхронизировать» (upload) → закрыла
iPhone: открыла     → автоматически скачалось с GitHub
```

> **Важно:** перед сменой устройства нажимай «Синхронизировать», иначе изменения останутся только локально.

## Принятые решения

| Вопрос | Решение |
|--------|---------|
| Что синхронизируем | Файл SQLite целиком (`easy_fin.sqlite`) |
| Где хранится remote | Private GitHub repo, ветка `main` |
| API | [GitHub Contents API](https://docs.github.com/en/rest/repos/contents) |
| Стратегия конфликтов | Last-write-wins (параллельной работы нет) |
| Когда скачивать | **Автоматически при запуске**, если `remote` новее `local` |
| Когда загружать | **Только кнопка «Синхронизировать»** (upload на GitHub) |
| Сравнение версий | По `updated_at` в manifest; при равных датах — по `checksum_sha256`. Локальная версия новее → download **не выполняется** |
| Токен GitHub | Personal Access Token (classic), scope `repo` |
| Хранение токена | `flutter_secure_storage` (Keychain на iOS, Keychain на macOS) |
| Настройки repo | `shared_preferences` (owner, repo name, branch) |
| Сжатие | Gzip перед загрузкой (уменьшает размер, ускоряет transfer) |

## Что НЕ делаем

- GitHub Pages — это хостинг статики, не хранилище данных.
- Пофайловая / построчная синхронизация таблиц — избыточно для 2 устройств.
- Realtime sync, CRDT, merge конфликтов — не нужно при последовательной работе.
- Хранение токена в `shared_preferences` — небезопасно.

---

## Структура репозитория

```
easy-fin-data/          # private repo (пример имени)
├── data/
│   └── easy_fin.sqlite.gz   # сжатая копия БД
└── sync_manifest.json       # метаданные для сравнения версий
```

### `sync_manifest.json`

```json
{
  "updated_at": "2026-07-07T09:30:00.000Z",
  "schema_version": 14,
  "device_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "checksum_sha256": "abc123...",
  "size_bytes": 1048576
}
```

| Поле | Назначение |
|------|------------|
| `updated_at` | ISO 8601 UTC — основной критерий «что новее» |
| `schema_version` | Текущая `schemaVersion` из `AppDatabase` (сейчас `14`) |
| `device_id` | UUID устройства, которое последним загрузило данные |
| `checksum_sha256` | Контрольная сумма **распакованного** `.sqlite` |
| `size_bytes` | Размер распакованного файла |

---

## Настройка GitHub (один раз, вручную)

### 1. Создать private repo

1. GitHub → New repository.
2. Имя, например: `easy-fin-data`.
3. Visibility: **Private**.
4. README можно не добавлять.

### 2. Создать Personal Access Token

1. GitHub → Settings → Developer settings → Personal access tokens → **Tokens (classic)**.
2. Generate new token.
3. Scope: **`repo`** (полный доступ к private repos).
4. Скопировать токен — показывается один раз.

### 3. Инициализировать repo (опционально)

Можно оставить пустым — первый upload из приложения создаст файлы через API.

---

## Архитектура в приложении

```
lib/
├── data/
│   └── github_sync/
│       ├── github_api_client.dart       # HTTP-обёртка над Contents API
│       ├── github_sync_config_storage.dart # токен, owner, repo (secure + prefs)
│       ├── github_sync_service.dart     # бизнес-логика sync
│       └── models/
│           ├── github_sync_config.dart
│           └── sync_manifest.dart
├── view/
│   ├── pages/
│   │   └── github_sync_settings_page.dart
│   ├── providers/
│   │   └── github_sync_provider.dart
│   └── widgets/
│       └── sync_status_banner.dart      # опционально: статус на главном экране
└── utils/
    └── database_path.dart               # общий путь к easy_fin.sqlite
```

### Слои и ответственность

| Слой | Файл | Ответственность |
|------|------|-----------------|
| API | `github_api_client.dart` | GET/PUT файлов, base64, обработка 404/409 |
| Config | `github_sync_config_storage.dart` | Чтение/запись настроек и токена |
| Service | `github_sync_service.dart` | Download, upload, сравнение manifest, работа с файлом БД |
| View | `github_sync_settings_page.dart` | UI настройки и кнопка синхронизации |
| Provider | `github_sync_provider.dart` | Состояние sync, вызов service |

**Существующие `*Storage` репозитории не меняем** — sync работает на уровне файла БД, не на уровне таблиц.

---

## Зависимости

Добавить в `pubspec.yaml`:

```yaml
dependencies:
  http: ^1.4.0
  flutter_secure_storage: ^9.2.4
  crypto: ^3.0.6
  uuid: ^4.5.1
```

| Пакет | Зачем |
|-------|-------|
| `http` | Запросы к GitHub API |
| `flutter_secure_storage` | Безопасное хранение PAT |
| `crypto` | SHA-256 checksum |
| `uuid` | `device_id` при первом запуске |

После добавления: `flutter pub get`.

### iOS (`ios/Runner/Info.plist`)

Для `flutter_secure_storage` на iOS обычно достаточно стандартной настройки. Если Keychain недоступен в debug — проверить Team ID в Xcode.

### macOS (`macos/Runner/DebugProfile.entitlements`, `Release.entitlements`)

Добавить при необходимости:

```xml
<key>keychain-access-groups</key>
<array>
  <string>$(AppIdentifierPrefix)$(CFBundleIdentifier)</string>
</array>
```

---

## GitHub Contents API

Базовый URL: `https://api.github.com`

Заголовки для всех запросов:

```
Authorization: Bearer <token>
Accept: application/vnd.github+json
X-GitHub-Api-Version: 2022-11-28
User-Agent: easy-fin-app
```

### Скачать файл

```
GET /repos/{owner}/{repo}/contents/data/easy_fin.sqlite.gz?ref=main
```

Ответ: `content` (base64), `sha` (нужен для обновления).

### Загрузить / обновить файл

```
PUT /repos/{owner}/{repo}/contents/data/easy_fin.sqlite.gz
```

```json
{
  "message": "sync: upload database",
  "content": "<base64>",
  "sha": "<sha существующего файла или omit при первой загрузке>",
  "branch": "main"
}
```

### Ошибки

| Код | Значение | Действие |
|-----|----------|----------|
| 404 | Файл не найден | Первый upload — PUT без `sha` |
| 401 | Неверный токен | Показать ошибку, предложить перенастроить |
| 403 | Нет доступа / rate limit | Сообщение пользователю |
| 409 | Конфликт SHA | Повторить: скачать актуальный `sha`, retry PUT один раз |

Rate limit: 5000 req/hour с токеном — для 2 устройств более чем достаточно.

---

## Алгоритм синхронизации

### Общая схема

```
┌─────────────┐         ┌──────────────────┐         ┌─────────────┐
│   iPhone    │ ◄─────► │  GitHub (private) │ ◄─────► │     Mac     │
│ easy_fin.db │  upload │  .sqlite.gz       │ download│ easy_fin.db │
└─────────────┘         │  manifest.json    │         └─────────────┘
                        └──────────────────┘
```

### Download (автоматически при запуске)

**Правило:** скачивать с GitHub только если серверная версия **новее** локальной. Если локальная новее или есть несинхронизированные изменения — не перезаписывать молча.

```
1. Если sync выключен или нет сети → пропустить, работать с локальной БД
2. Прочитать локальный manifest (если есть)
3. Посчитать checksum текущей локальной БД
4. isDirty = localManifest != null && checksum != localManifest.checksum
5. GET sync_manifest.json из GitHub
6. Если remote нет (404, первый запуск) → пропустить download
7. Определить, какая версия новее:
   isRemoteNewer = compareManifests(local, remote) == RemoteNewer
   isLocalNewer  = compareManifests(local, remote) == LocalNewer
8. Если isDirty || isLocalNewer:
   → Локальная версия новее (или изменена, но ещё не отправлена)
   → Download НЕ выполнять автоматически
   → Диалог: «Локальная версия новее»
     • «Отправить на GitHub» → upload
     • «Скачать с GitHub» → download принудительно (локальные изменения будут потеряны)
     • «Продолжить с локальными данными»
9. Если isRemoteNewer && !isDirty:
   a. Закрыть AppDatabase (invalidate appDatabaseProvider)
   b. Скачать easy_fin.sqlite.gz
   c. Распаковать gzip → заменить easy_fin.sqlite
   d. Проверить checksum с remote manifest
   e. Сохранить manifest локально
   f. Открыть AppDatabase заново
10. Если версии равны (!isRemoteNewer && !isLocalNewer && !isDirty):
    → Ничего не делать, данные уже актуальны
```

#### Сравнение версий (`compareManifests`)

```dart
enum ManifestComparison { remoteNewer, localNewer, equal }

ManifestComparison compareManifests(
  SyncManifest? local,
  SyncManifest remote,
) {
  if (local == null) return ManifestComparison.remoteNewer;

  if (remote.updatedAt.isAfter(local.updatedAt)) {
    return ManifestComparison.remoteNewer;
  }
  if (local.updatedAt.isAfter(remote.updatedAt)) {
    return ManifestComparison.localNewer;
  }
  // Равные даты — сравнить checksum
  if (remote.checksumSha256 != local.checksumSha256) {
    // При равных датах и разном checksum — считать локальную новее (осторожнее)
    return ManifestComparison.localNewer;
  }
  return ManifestComparison.equal;
}
```

> `isDirty` — дополнительная проверка: даже если manifest совпадает с remote, но файл БД изменился (не нажали «Синхронизировать»), локальная версия считается новее.

### Upload (кнопка «Синхронизировать»)

```
1. GET remote manifest (если есть)
2. Если remote.updated_at > local.updated_at:
   → Диалог: «На сервере более новая версия. Сначала скачайте или загрузите принудительно»
3. Закрыть AppDatabase
4. Checkpoint WAL (см. ниже)
5. Прочитать easy_fin.sqlite, посчитать SHA-256
6. Gzip-сжать
7. PUT easy_fin.sqlite.gz (+ sha если файл уже есть)
8. Сформировать и PUT sync_manifest.json
9. Сохранить manifest локально
10. Открыть AppDatabase заново
11. Snackbar: «Данные отправлены на GitHub»
```

### Работа с SQLite-файлом

Drift держит файл открытым через `appDatabaseProvider`. Перед заменой файла:

```dart
// 1. Инвалидировать провайдер — закроет соединение
ref.invalidate(appDatabaseProvider);

// 2. Дождаться, что никакие другие операции с БД не идут
//    (показать loading overlay на время sync)

// 3. Заменить файл

// 4. Прочитать провайдер снова — откроет новый файл
ref.read(appDatabaseProvider);
```

#### WAL checkpoint

SQLite в режиме WAL может оставлять данные в `-wal` / `-shm` файлах. Перед upload:

```dart
import 'package:sqlite3/sqlite3.dart';

void checkpointDatabase(String dbPath) {
  final db = sqlite3.open(dbPath);
  try {
    db.execute('PRAGMA wal_checkpoint(FULL);');
  } finally {
    db.dispose();
  }
}
```

Либо экспортировать через `VACUUM INTO 'path/to/export.sqlite'` — получится консистентная копия без WAL-файлов.

Рекомендация: **checkpoint + upload основного файла**, удалить `-wal` и `-shm` только если они остались после checkpoint (обычно checkpoint достаточно).

---

## Конфигурация в приложении

### `GithubSyncConfig`

```dart
class GithubSyncConfig {
  const GithubSyncConfig({
    required this.owner,
    required this.repo,
    this.branch = 'main',
    required this.isEnabled,
  });

  final String owner;   // GitHub username или org
  final String repo;    // имя репозитория
  final String branch;
  final bool isEnabled;
}
```

### Где хранить

| Данные | Хранилище | Ключ |
|--------|-----------|------|
| `owner`, `repo`, `branch`, `isEnabled` | `shared_preferences` | `github_sync_owner`, `github_sync_repo`, ... |
| Personal Access Token | `flutter_secure_storage` | `github_sync_token` |
| Локальный manifest | файл `sync_manifest.json` в app documents | — |
| `device_id` | `shared_preferences` | `device_id` (генерировать один раз через `uuid`) |

---

## UI

### Раздел в `SettingsPage`

Новая плитка:

- **Заголовок:** «Синхронизация»
- **Подзаголовок:** «GitHub — резервная копия данных»
- **Переход:** `GithubSyncSettingsPage`

### `GithubSyncSettingsPage`

| Элемент | Описание |
|---------|----------|
| Switch «Включить синхронизацию» | `isEnabled` |
| Поле Owner | GitHub username |
| Поле Repository | имя repo |
| Поле Branch | по умолчанию `main` |
| Поле Token | `obscureText: true`, placeholder «ghp_...» |
| Кнопка «Проверить подключение» | GET manifest или repo info |
| Кнопка **«Синхронизировать»** | **Upload** — отправить локальную БД на GitHub |
| Статус | «Последняя отправка: …», «Есть несинхронизированные изменения» |

Кнопку «Синхронизировать» можно продублировать на главном экране (боковая панель / app bar) — чтобы не заходить в настройки каждый раз перед сменой устройства.

### Поведение при запуске

В `main.dart` или `MainNavPage` после инициализации:

1. Если sync включён → автоматический **download** (алгоритм выше).
2. Пока идёт sync → splash / overlay «Загрузка данных…».
3. При ошибке сети → работать с локальной БД, snackbar «Нет подключения, используются локальные данные».
4. Если `isDirty` → диалог, download не выполняется без выбора пользователя.

---

## Провайдеры

### `githubSyncProvider`

```dart
@immutable
sealed class GithubSyncState {}

class GithubSyncIdle extends GithubSyncState {}
class GithubSyncInProgress extends GithubSyncState {}
class GithubSyncSuccess extends GithubSyncState {
  const GithubSyncSuccess({required this.direction, required this.at});
  final SyncDirection direction; // download | upload
  final DateTime at;
}
class GithubSyncError extends GithubSyncState {
  const GithubSyncError(this.message);
  final String message;
}
```

```dart
final githubSyncProvider =
    NotifierProvider<GithubSyncNotifier, GithubSyncState>(
  GithubSyncNotifier.new,
);
```

Методы `GithubSyncNotifier`:

- `Future<void> downloadOnStartup()` — автоматически при запуске
- `Future<void> upload()` — кнопка «Синхронизировать»
- `Future<bool> hasUnsyncedChanges()` — checksum БД ≠ manifest
- `Future<void> forceDownload()` — принудительный download (из диалога конфликта)

---

## Выделить путь к БД

Сейчас путь захардкожен в `app_database.dart`. Вынести в утилиту:

```dart
// lib/utils/database_path.dart
Future<File> getDatabaseFile() async {
  final dbFolder = await getApplicationDocumentsDirectory();
  return File(p.join(dbFolder.path, 'easy_fin.sqlite'));
}
```

Использовать и в `AppDatabase._openConnection()`, и в `GithubSyncService`.

---

## Обнаружение несинхронизированных изменений (`isDirty`)

Отдельный флаг в `shared_preferences` не нужен. Сравниваем checksum файла БД с `checksum_sha256` в локальном manifest:

```dart
Future<bool> hasUnsyncedChanges(SyncManifest? localManifest) async {
  if (localManifest == null) return false;
  final checksum = await sha256OfDatabaseFile();
  return checksum != localManifest.checksumSha256;
}
```

- После успешного **upload** manifest обновляется → `isDirty = false`.
- После любого **save** в приложении checksum меняется → `isDirty = true`.
- При **download** manifest перезаписывается remote → `isDirty = false`.

Используется при запуске: если `isDirty`, не скачивать автоматически, показать диалог.

---

## Порядок реализации

### Этап 1 — Инфраструктура (1–2 дня)

- [ ] Добавить зависимости в `pubspec.yaml`
- [ ] Создать `lib/utils/database_path.dart`, подключить в `app_database.dart`
- [ ] Модели: `SyncManifest`, `GithubSyncConfig`
- [ ] `GithubSyncConfigStorage` (prefs + secure storage)
- [ ] `GithubApiClient` с методами `getFile`, `putFile`

### Этап 2 — Sync service (2–3 дня)

- [ ] `GithubSyncService.download()`
- [ ] `GithubSyncService.upload()`
- [ ] Gzip compress/decompress
- [ ] SHA-256 checksum
- [ ] Закрытие/открытие БД через invalidate провайдера
- [ ] WAL checkpoint перед upload

### Этап 3 — UI (1–2 дня)

- [ ] `GithubSyncSettingsPage`
- [ ] Плитка в `SettingsPage`
- [ ] `githubSyncProvider`
- [ ] Кнопка «Проверить подключение»
- [ ] Кнопка «Синхронизировать»

### Этап 4 — Автоматизация при запуске (1 день)

- [ ] `downloadOnStartup()` в `MainNavPage`
- [ ] Диалог при `isDirty` на старте
- [ ] Loading overlay на время download
- [ ] Обработка ошибок сети (offline-first)

### Этап 5 — Тестирование (1–2 дня)

- [ ] Mac: настроить → upload → проверить файлы в repo
- [ ] iPhone: download → данные на месте
- [ ] iPhone: изменения → upload
- [ ] Mac: download → изменения видны
- [ ] Сценарий «на сервере новее» при upload
- [ ] Неверный токен / нет сети

**Оценка:** ~7–10 рабочих дней.

---

## Обработка ошибок

| Ситуация | Поведение |
|----------|-----------|
| Нет сети при старте | Работа с локальной БД, snackbar «Нет подключения» |
| Нет сети при upload | Ошибка на экране, данные локально сохранены |
| Неверный токен | «Проверьте токен в настройках» |
| `isDirty` при старте | Локальная новее → диалог, auto-download не выполняется |
| Локальная версия новее remote | Auto-download не выполняется, snackbar «Используются локальные данные» |
| Remote новее локальной | Auto-download при старте |
| Remote новее при upload | Диалог: «Сначала скачайте с сервера» / «Всё равно загрузить» |
| Забыли нажать «Синхронизировать» перед сменой устройства | На другом устройстве будут старые данные — нужно вернуться и нажать кнопку |
| Checksum не совпал после download | Не заменять локальную БД, показать ошибку |
| `schema_version` remote > local | «Обновите приложение» (миграции в новой версии) |
| `schema_version` remote < local | Upload с предупреждением (старое приложение на другом устройстве) |

---

## Безопасность

1. **Только private repo** — финансовые данные не должны быть публичными.
2. **Токен только в Keychain** — не логировать, не коммитить.
3. **Минимальный scope** — только `repo`, не `admin`.
4. **Ротация токена** — в настройках возможность заменить token.
5. **GitHub не шифрует содержимое** — данные в repo хранятся как base64 в git. Private repo защищает от посторонних, но не от GitHub. Для личного учёта это обычно приемлемо.
6. **Опционально (v2):** шифровать `.sqlite.gz` перед upload (AES-256, ключ из пароля пользователя).

---

## Пример: `GithubApiClient.getFile`

```dart
Future<GitHubFileContent?> getFile({
  required String owner,
  required String repo,
  required String path,
  required String branch,
  required String token,
}) async {
  final uri = Uri.https(
    'api.github.com',
    '/repos/$owner/$repo/contents/$path',
    {'ref': branch},
  );

  final response = await http.get(
    uri,
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
    },
  );

  if (response.statusCode == 404) return null;
  if (response.statusCode != 200) {
    throw GitHubApiException(response.statusCode, response.body);
  }

  final json = jsonDecode(response.body) as Map<String, dynamic>;
  final bytes = base64Decode(json['content'] as String);
  return GitHubFileContent(
    bytes: bytes,
    sha: json['sha'] as String,
  );
}
```

---

## Пример: сравнение manifest

```dart
bool isRemoteNewer(SyncManifest? local, SyncManifest remote) {
  return compareManifests(local, remote) == ManifestComparison.remoteNewer;
}

bool isLocalNewer(SyncManifest? local, SyncManifest remote) {
  return compareManifests(local, remote) == ManifestComparison.localNewer;
}
```

При равных `updated_at` и разных `checksum_sha256` — **считать локальную новее** (не перезаписывать без явного согласия пользователя).

---

## Чек-лист перед релизом

- [ ] Sync работает Mac → GitHub → iPhone
- [ ] Sync работает iPhone → GitHub → Mac
- [ ] При ошибке сети приложение не падает
- [ ] Токен не попадает в логи
- [ ] БД корректно открывается после replace
- [ ] Все отчёты и документы совпадают после sync
- [ ] В repo только private, токен с минимальными правами

---

## Возможные улучшения (v2)

- Напоминание «Отправить на GitHub?» при закрытии приложения, если `isDirty`
- Шифрование файла перед upload
- История версий: хранить `data/easy_fin_2026-07-07.sqlite.gz` вместо перезаписи одного файла
- Индикатор статуса sync в боковой панели
- GitHub fine-grained token вместо classic PAT
