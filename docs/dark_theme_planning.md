# План реализации тёмной темы

## Цель

Добавить в приложение Easy Fin переключаемую тёмную тему в стиле Todoist (Noir). Переключатель размещается в боковой навигационной панели (`MainNavPage`). Выбор пользователя сохраняется между сессиями.

## Принятые решения

| Вопрос | Решение |
|--------|---------|
| Режимы темы | Только **светлая** и **тёмная** (без «как в системе») |
| Акцентный цвет | Оставить текущий — `AppColors.primary` (`#1F1F1F`) в обеих темах |
| Сохранение выбора | **Обязательно** — `shared_preferences`, ключ `app_theme_mode` |
| Активный пункт навигации | Подстроить под нейтральный акцент (см. раздел ниже) |
| Референс Todoist | Берём **общую тёмную атмосферу** (фоны, контрасты), но **не** красный акцент |

## Референс: палитра (Todoist Noir + наш акцент)

Берём у Todoist тёмные фоны и уровни контраста. Акцент и выделение — из нашей палитры.

| Роль | HEX (тёмная тема) | Использование |
|------|-------------------|---------------|
| Фон контента | `#1F1F1F` | Основная рабочая область, scaffold |
| Фон сайдбара | `#282828` | Боковая навигационная панель |
| Основной текст | `#FFFFFF` | Заголовки, строки таблиц |
| Вторичный текст | `#808080` | Подписи, метаданные |
| Акцент | `#1F1F1F` | Кнопки, ссылки, DatePicker header — **как сейчас** |
| Активный пункт меню (фон) | `#3A3A3A` | Приподнятая поверхность на сайдбаре |
| Активный пункт меню (текст) | `#FFFFFF` | Иконка и подпись выбранного пункта |
| Разделители / границы | `#333333` | Divider, border таблиц и полей |
| Поверхность (карточки) | `#2A2A2A` | Таблицы, dropdown, диалоги |
| Hover / pressed | `#333333` | InkWell, наведение на строку |

> `#1F1F1F` совпадает с фоном контента — поэтому в тёмной теме акцент **не красится** в этот цвет на тёмном фоне, а выражается через контраст и выделение поверхности (см. «Активный пункт навигации»).

## Текущее состояние

### Что уже есть

- `lib/utils/app_theme.dart` — единая светлая `ThemeData` через `buildAppTheme()`
- `lib/utils/app_colors.dart` — семантические цвета (primary, blue, green, red, purple, border)
- `lib/main.dart` — `MaterialApp(theme: buildAppTheme())`, без `darkTheme` и `themeMode`
- `lib/view/pages/main_nav_page.dart` — боковая панель с захардкоженным `Colors.white`
- Riverpod 3.x — стандартный способ управления состоянием в проекте

### Проблемы для тёмной темы

1. **~45 файлов** содержат захардкоженные `Colors.white`, `Colors.black`, `Colors.grey` или `Color(0x...)`
2. `ReportTableTheme` — статические константы цветов, не зависящие от темы
3. `filterFieldHintTextStyle` в `app_sizes.dart` — `color: Colors.grey` зашит в const
4. Графики (`expense_categories_pie_chart`, `expense_chart_common`) рисуют `Colors.white` на canvas
5. Нет механизма сохранения пользовательских настроек (нет `shared_preferences`)

---

## Архитектура решения

### 1. Семантические цвета через `ThemeExtension`

Создать `AppThemeColors` — расширение темы с именованными цветами, которые меняются в зависимости от режима:

```dart
@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.sidebarBackground,
    required this.surface,
    required this.primaryText,
    required this.secondaryText,
    required this.border,
    required this.navActiveBackground,
    required this.navActiveText,
    required this.tableRowDivider,
    required this.accent,
  });

  final Color sidebarBackground;
  final Color surface;
  final Color primaryText;
  final Color secondaryText;
  final Color border;
  final Color navActiveBackground;
  final Color navActiveText;
  final Color tableRowDivider;
  final Color accent;

  static const light = AppThemeColors(/* текущие светлые значения */);
  static const dark = AppThemeColors(/* палитра Todoist */);

  // copyWith, lerp — стандартная реализация ThemeExtension
}

extension AppThemeColorsX on BuildContext {
  AppThemeColors get appColors =>
      Theme.of(this).extension<AppThemeColors>()!;
}
```

**Почему ThemeExtension, а не только ColorScheme:**
- `ColorScheme` покрывает Material-компоненты, но не специфичные для приложения роли (sidebar, table divider, nav active)
- Позволяет обращаться к цветам единообразно: `context.appColors.surface`

### 2. Две темы в `app_theme.dart`

```dart
ThemeData buildLightTheme() { ... }
ThemeData buildDarkTheme() { ... }
```

Каждая тема включает:
- `colorScheme` (light / dark)
- `scaffoldBackgroundColor`
- `extensions: [AppThemeColors.light]` / `[AppThemeColors.dark]`
- `datePickerTheme`, `dividerTheme`, `inputDecorationTheme`, `dialogTheme`, `cardTheme`

### 3. Состояние темы — Riverpod Notifier

```
lib/view/providers/theme_mode_provider.dart
```

```dart
enum AppThemeMode { light, dark }

final themeModeProvider =
    AsyncNotifierProvider<ThemeModeNotifier, AppThemeMode>(ThemeModeNotifier.new);
```

- При старте: читает сохранённое значение из `shared_preferences`
- `toggle()` / `setMode(AppThemeMode)` — меняет состояние и сохраняет
- По умолчанию: `AppThemeMode.light`

### 4. Персистентность — `shared_preferences` (обязательно)

Выбранная тема **должна сохраняться** между запусками приложения.

Добавить зависимость в `pubspec.yaml`:

```yaml
shared_preferences: ^2.5.3
```

**Ключ:** `app_theme_mode` → значения `"light"` / `"dark"`.

**Жизненный цикл:**

```
Запуск приложения
    → ThemeModeNotifier.build()
    → SharedPreferences.getString('app_theme_mode')
    → AppThemeMode.light (если ключа нет — первый запуск)
    → MaterialApp применяет тему

Пользователь переключает тему в сайдбаре
    → notifier.setMode() / toggle()
    → state обновляется → UI перерисовывается
    → prefs.setString('app_theme_mode', ...) — сразу же
```

> Альтернатива — таблица в Drift, но для одного enum это избыточно.

### 5. Подключение в `main.dart`

```dart
class MainApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: themeMode == AppThemeMode.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      // ...
    );
  }
}
```

### 6. Переключатель в навигационной панели

Разместить в нижней части сайдбара (`main_nav_page.dart`), над `Gap(20)`:

```
┌─────────────────────┐
│  ≡  (свернуть)      │
│                     │
│  📊 Отчёты          │
│  📄 Документы       │
│  ⚙️  Настройки      │
│                     │
│  ─────────────────  │
│  🌙 Тёмная тема  ○  │  ← Switch или IconButton (sun/moon)
└─────────────────────┘
```

**Вариант UI (рекомендуемый):** `SwitchListTile` или кастомная строка с иконкой `LucideIcons.moon` / `LucideIcons.sun` и `Switch`. В свёрнутом режиме — только иконка с `Tooltip`.

### 7. Активный пункт навигации под наш акцент

Акцент `#1F1F1F` — тёмный цвет. На тёмном фоне его нельзя использовать как цвет текста/иконки (не будет контраста). Поэтому в каждой теме акцент выражается **по-разному**, но визуально согласованно:

| | Светлая тема | Тёмная тема |
|---|-------------|-------------|
| **Неактивный пункт** | Иконка/текст `#8E8E8E`, фон прозрачный | Иконка/текст `#808080`, фон прозрачный |
| **Активный пункт — иконка/текст** | `accent` (`#1F1F1F`) | `#FFFFFF` (максимальный контраст) |
| **Активный пункт — фон** | `#F0F0F0` (лёгкая серая подложка) | `#3A3A3A` (приподнятая поверхность на сайдбаре) |
| **Скругление** | `BorderRadius.circular(8)` | то же |

**Логика:** в светлой теме акцент = тёмный текст (как сейчас). В тёмной — акцент = «выбранность» через светлый текст на чуть более светлом фоне. Это тот же приём, что у Todoist (бордовая подложка + белый текст), но в нейтральной серой гамме, родственной `#1F1F1F`.

**Реализация в `NavItem`:**

```dart
// Псевдокод
final colors = context.appColors;
final iconColor = isActive ? colors.navActiveText : colors.secondaryText;
final bgColor = isActive ? colors.navActiveBackground : Colors.transparent;

// InkWell обёрнут в DecoratedBox с bgColor и borderRadius
```

**Светлая тема — уточнённые значения:**

```dart
navActiveBackground: Color(0xFFF0F0F0),
navActiveText: Color(0xFF1F1F1F),  // = accent
```

**Тёмная тема — уточнённые значения:**

```dart
navActiveBackground: Color(0xFF3A3A3A),
navActiveText: Color(0xFFFFFFFF),
```

---

## План работ по этапам

### Этап 1 — Инфраструктура (MVP)

**Цель:** переключение темы работает, навигация и scaffold корректны.

| # | Задача | Файлы |
|---|--------|-------|
| 1.1 | Добавить `shared_preferences` | `pubspec.yaml` |
| 1.2 | Создать `AppThemeColors` | `lib/utils/app_theme_colors.dart` |
| 1.3 | Разделить `buildAppTheme` → light/dark | `lib/utils/app_theme.dart` |
| 1.4 | Создать `theme_mode_provider` | `lib/view/providers/theme_mode_provider.dart` |
| 1.5 | Подключить темы в `MaterialApp` | `lib/main.dart` |
| 1.6 | Обновить сайдбар + переключатель | `lib/view/pages/main_nav_page.dart` |
| 1.7 | Обновить `NavItem` — цвета из темы | `main_nav_page.dart` |

**Критерий готовности:** переключатель в сайдбаре меняет фон приложения и сайдбара; выбор сохраняется после перезапуска.

### Этап 2 — Общие виджеты

**Цель:** переиспользуемые компоненты адаптированы к теме.

| # | Задача | Файлы |
|---|--------|-------|
| 2.1 | `TemplatePage` — заголовок, divider | `template_page.dart` |
| 2.2 | `DropdownWidget`, `MultiDropdownWidget` | `dropdown_widget.dart`, `multi_dropdown_widget.dart` |
| 2.3 | `ReportTableTheme` → методы/геттеры от темы | `report_table_theme.dart` |
| 2.4 | `MonthNavigatorField`, `DatePickerField` | соответствующие виджеты |
| 2.5 | `ConfirmDialog` и базовые диалоги | `confirm_dialog.dart` |
| 2.6 | `AddActionSpeedDial` | `add_action_speed_dial.dart` |
| 2.7 | Убрать `color: Colors.grey` из const-стилей | `app_sizes.dart` → стили через `Theme.of(context)` или extension |

**Подход для `ReportTableTheme`:**

```dart
// Было: static const primaryText = Color(0xFF333333);
// Стало:
static TextStyle primaryTextStyle(BuildContext context) => TextStyle(
  fontSize: 13,
  color: context.appColors.primaryText,
);
```

### Этап 3 — Страницы и таблицы

| # | Задача | Файлы |
|---|--------|-------|
| 3.1 | Страницы отчётов | `reports_page.dart`, `renter_debts_report_page.dart`, `expense_categories_report_page.dart` |
| 3.2 | Таблицы отчётов | `*_table.dart` (5 файлов) |
| 3.3 | Страница документов | `documents_page.dart`, `documents_table.dart` |
| 3.4 | Формы добавления | `add_income_page.dart`, `add_expense_page.dart`, `add_rent_accrual_page.dart` |
| 3.5 | Справочники | `renters_page.dart`, `bases_page.dart`, `*_categories_page.dart` |
| 3.6 | Настройки | `settings_page.dart` |
| 3.7 | Диалоги импорта | `import_*_dialog.dart` (6 файлов) |
| 3.8 | Диалоги редактирования | `edit_*_dialog.dart`, `add_renter_dialog.dart` |

**Правило замены:**

| Было | Стало |
|------|-------|
| `Colors.white` (фон) | `context.appColors.surface` или `Theme.of(context).colorScheme.surface` |
| `Colors.black` (текст) | `context.appColors.primaryText` |
| `Colors.grey` (вторичный) | `context.appColors.secondaryText` |
| `AppColors.border` | `context.appColors.border` |
| `Color(0xFFF0F0F0)` (divider) | `context.appColors.tableRowDivider` |

### Этап 4 — Графики

Графики рисуются через `CustomPainter` / `Canvas` — `Theme.of(context)` там недоступен напрямую.

| # | Задача | Файлы |
|---|--------|-------|
| 4.1 | Передавать цвета в painter через параметры | `expense_categories_pie_chart.dart`, `expense_chart_common.dart`, `expense_categories_report_charts.dart`, `renter_debts_bar_chart.dart` |
| 4.2 | Фон «дырки» в pie chart | `surface` вместо `Colors.white` |
| 4.3 | Подписи и оси | `primaryText` / `secondaryText` |

---

## Детали реализации ключевых компонентов

### `AppThemeColors.dark`

```dart
static const dark = AppThemeColors(
  sidebarBackground: Color(0xFF282828),
  surface: Color(0xFF2A2A2A),
  primaryText: Color(0xFFFFFFFF),
  secondaryText: Color(0xFF808080),
  border: Color(0xFF333333),
  navActiveBackground: Color(0xFF3A3A3A),
  navActiveText: Color(0xFFFFFFFF),
  tableRowDivider: Color(0xFF333333),
  accent: Color(0xFF1F1F1F), // тот же акцент; на тёмном UI — для header DatePicker, кнопок onPrimary
);
```

### `AppThemeColors.light` (текущее поведение)

```dart
static const light = AppThemeColors(
  sidebarBackground: Color(0xFFFFFFFF),
  surface: Color(0xFFFFFFFF),
  primaryText: Color(0xFF1F1F1F),
  secondaryText: Color(0xFF8E8E8E),
  border: Color(0xFFE7E7E7),
  navActiveBackground: Color(0xFFF0F0F0),
  navActiveText: Color(0xFF1F1F1F), // = accent
  tableRowDivider: Color(0xFFF0F0F0),
  accent: Color(0xFF1F1F1F),
);
```

### `ColorScheme` для Material-компонентов

Акцент `#1F1F1F` в `ColorScheme.primary` для обеих тем:

```dart
// Светлая
colorScheme: ColorScheme.fromSeed(
  seedColor: AppColors.primary,
  primary: AppColors.primary, // #1F1F1F
),

// Тёмная
colorScheme: const ColorScheme.dark(
  primary: Color(0xFF1F1F1F),
  onPrimary: Color(0xFFFFFFFF),
  surface: Color(0xFF2A2A2A),
  onSurface: Color(0xFFFFFFFF),
  outline: Color(0xFF333333),
),
scaffoldBackgroundColor: const Color(0xFF1F1F1F),
```

### DatePicker в тёмной теме

Обновить `datePickerTheme` в `buildDarkTheme()`:
- `backgroundColor: Color(0xFF2A2A2A)`
- `headerBackgroundColor: Color(0xFF1F1F1F)` (наш акцент)
- `headerForegroundColor: Colors.white`
- Цвета дней — из `colorScheme`

---

## Структура новых файлов

```
lib/
├── utils/
│   ├── app_theme.dart          (изменить)
│   ├── app_theme_colors.dart   (создать)
│   └── app_colors.dart         (оставить для семантических: green, red, blue — не зависят от темы)
└── view/
    └── providers/
        └── theme_mode_provider.dart  (создать)
```

---

## Риски и как их снизить

| Риск | Решение |
|------|---------|
| Пропущенные захардкоженные цвета | После каждого этапа — ручная проверка всех экранов; grep по `Colors.white` |
| Const-виджеты с цветами | Убрать `const` там, где цвет зависит от темы |
| Графики не обновляются при смене темы | Передавать `themeMode` или цвета как параметры; `ref.watch(themeModeProvider)` в родителе |
| Контрастность текста | Проверить WCAG для `#808080` на `#1F1F1F` — для вторичного текста допустимо |
| Семантические цвета (зелёный/красный для сумм) | `AppColors.green` / `AppColors.red` **не менять** — они одинаковы в обеих темах |

---

## Чек-лист тестирования

### Функциональность
- [ ] Переключатель в сайдбаре меняет тему мгновенно
- [ ] Тема сохраняется после перезапуска приложения
- [ ] Переключатель виден в свёрнутом и развёрнутом режиме сайдбара
- [ ] Активный пункт навигации выделен (светлая — тёмный текст на `#F0F0F0`; тёмная — белый текст на `#3A3A3A`)
- [ ] После перезапуска приложения восстанавливается последняя выбранная тема

### Визуальная проверка по экранам
- [ ] Отчёты (все вкладки)
- [ ] Таблицы отчётов (границы, чередование строк, footer)
- [ ] Документы (таблица, фильтры)
- [ ] Формы: приход, расход, начисление аренды
- [ ] Справочники: базы, арендаторы, категории
- [ ] Диалоги импорта
- [ ] DatePicker, Dropdown
- [ ] Speed dial (кнопка «+»)
- [ ] Графики: pie chart, bar chart

### Граничные случаи
- [ ] Переключение темы на открытом диалоге
- [ ] Переключение темы на странице с графиком
- [ ] macOS: корректное отображение тени сайдбара в обеих темах

---

## Оценка трудозатрат

| Этап | Оценка |
|------|--------|
| 1. Инфраструктура | ~2–3 часа |
| 2. Общие виджеты | ~3–4 часа |
| 3. Страницы и таблицы | ~6–8 часов |
| 4. Графики | ~2–3 часа |
| Тестирование и полировка | ~2 часа |
| **Итого** | **~15–20 часов** |

---

## Порядок выполнения (рекомендуемый)

1. Этап 1 целиком → можно показать результат (переключатель работает)
2. Этап 2 → основные виджеты перестают «ломать» картинку
3. Этап 3 → по одной вкладке/разделу (Отчёты → Документы → Настройки → Формы)
4. Этап 4 → графики
5. Финальный grep + ручной проход
6. Удалить этот документ после завершения (по правилам проекта)

---

## Оставшийся вопрос на усмотрение при реализации

**Тень сайдбара в тёмной теме**  
Сейчас: `Colors.black.withValues(alpha: 0.15)`. В dark mode можно убрать тень и использовать только разницу в цвете фона (`#282828` vs `#1F1F1F`) — рекомендуется так и сделать.
