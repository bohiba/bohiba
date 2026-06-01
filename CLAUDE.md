# CLAUDE.md — Bohiba Mobile App

> **Purpose:** This file is the single source of truth for Claude Code sessions on this project.
> It records architecture decisions, coding standards, every fix applied across all sessions,
> open security findings, and the forward roadmap. Update it at the end of every session.

---

## 0. Progress Summary (all sessions)

| Session | Focus | Files changed | Status |
|---------|-------|---------------|--------|
| **1** | Security audit + core bug fixes — splash, location, entire sign-up flow | ~50 files | ✅ Done |
| **2** | `AppDatePicker` month-navigation — 3 nested bugs fixed | 1 file | ✅ Done |
| **3** | `AddTripPage` company/mineral search — API, async dropdown, controller, UI | 5 files | ✅ Done |

### What works now (that didn't before)

**Authentication & startup**
- Splash never freezes — try/catch fallback to SignIn on any error
- Manager role (ID 7) routes correctly to `truckOwnerNavBar` (was silently falling through)
- Sign-up flow carries `token` + `validationType: whileSignUp` through all 6 screens — no more 401s mid-flow
- OTP timer no longer leaks; debounced re-send; validator fixed (`||` not `&&`)

**Location & address**
- Location modal opens pre-populated — no more blank screen requiring manual Refresh
- `LocationController` is a true singleton — no orphaned second instance
- District lookup uses shared `DioService`; any cert/network error silently falls back to geocoder

**Date picker**
- Month dropdown correctly limits to current month in the last allowed year (was showing all 12)
- Selecting a month now scrolls the calendar to that month (was silently skipped)
- No more calendar jumping to wrong month when day > days-in-target-month (clamped)

**Add / Edit Trip**
- Origin and Destination are now live company search fields (API: `GET /companies/search?search=…`)
- Search overlay shows 4 states: loading spinner, "No results found", error message, result list
- Selecting an origin company automatically loads its associated minerals from the local DB
- Material Type dropdown is populated from those minerals (replaces the hardcoded 29-item list)
- Edit mode pre-populates company names and attempts to re-select the saved mineral
- API body now sends `origin: company_id` and `destination: company_id` (integers) — was free text
- All 15+ other `AppDropdownSearch` call-sites are **unaffected** (async mode is strictly opt-in)

### Outstanding before production

| Priority | Item | Detail |
|----------|------|--------|
| 🔴 Critical | S1 — AES key in source | Hardcoded in `encryption_service.dart` |
| 🔴 Critical | S2 — Auth token in plain SharedPrefs | Migrate to `flutter_secure_storage` |
| 🔴 Critical | S3 — SQLite unencrypted | Trip data + PII at rest |
| 🟠 High | S4 — No SSL pinning | `network_security_config.xml` + Dio interceptor |
| 🟠 High | S5 — Maps API key unrestricted | Restrict by SHA-1 + package name |
| 🟠 High | S6 — Background location no foreground service | Android 14+ compliance |
| 🟡 Medium | S7–S13 | See §6 for full list |

---

## 1. Project Overview

**App name:** Bohiba
**Platform:** Flutter (Dart SDK `>=3.0.5 <4.0.0`)
**Branch under active development:** `developement`
**Remote:** `https://github.com/bohiba/bohiba.git`
**Backend:** `https://beta-server-t1.bohiba.com/api` (beta) / `https://bohiba.com/api` (prod)
**State management:** GetX (`get: ^4.7.2`) — controllers, bindings, reactive state, routing
**Domain:** India logistics & fleet management — truck owners, drivers, managers, load-board, trips, wallet, challan, KYC

---

## 2. Architecture

### 2.1 Layer Map

```
lib/
├── main.dart                    Entry point — Firebase init, ScreenUtil, GetMaterialApp
├── routes/app_route.dart        GetX named routes + binding injection per page
├── bindings/                    GetX Binding per screen (lazy DI)
├── controllers/                 GetX GetxController — one per screen/feature
├── services/                    Stateless service classes (Dio, Auth, Role, Pref, DB…)
├── model/                       Plain Dart model classes (JSON serialisation)
├── pages/                       UI — one sub-folder per feature domain
│   ├── widget/                  Shared reusable widgets (AppDatePicker, etc.)
│   ├── authentication/          Sign-in, sign-up, OTP, password
│   ├── dashboard/               Role-specific dashboards
│   ├── trips/                   Trip lifecycle screens
│   ├── driver/                  Driver management
│   ├── truck/                   Vehicle management
│   ├── wallet/                  Wallet, deposit, withdraw, transactions
│   ├── challan/                 Trip documents / challan
│   ├── status/                  Trip status tabs (booked / loaded / complete)
│   ├── jobs/                    Owner job posts & driver job applications
│   ├── expenses/                Owner & trip expenses
│   ├── user/                    Profile, KYC, scan
│   └── maps/                    Google Maps integration
├── component/                   Design-system widgets
│   ├── bohiba_buttons/          PrimaryButton, etc.
│   ├── bohiba_dropdown/         AppDropdownSearch<T> (FormField + DropdownMenu / Overlay)
│   ├── bohiba_inputfield/
│   ├── bohiba_modal/
│   ├── bohiba_dialog/
│   └── …
├── core/network/                DioService (shared Dio instance)
├── dist/enums/                  All app-wide enums
├── extensions/                  Dart extension methods
└── theme/                       bohibaTheme, BohibaColors
```

### 2.2 Role System

| Role ID | Enum | Nav destination |
|---------|------|-----------------|
| 1 | `superAdmin` | admin dashboard |
| 6 | `truckOwner` | `truckOwnerNavBar` |
| 7 | `manager` | `truckOwnerNavBar` |
| 8 | `driver` | driver nav bar |
| 9 | `guest` | guest view |

Defined in `lib/dist/enums/app_enums.dart` (`UserRoleType`).
Role-based permissions live in `lib/services/role_service.dart` (`RolePermissionManager`).

### 2.3 Auth Flow (Sign-Up)

```
VerifyEmail → OTP → CreateUser → AddAddress → SetRole → DocAuth
```

Navigation args must carry **both** `token` AND `validationType: EnumRoleValidation.whileSignUp`
at every step. Missing either causes 401 / wrong routing.

### 2.4 Splash Controller Decision Tree

```
onInit → defer →
  token null/empty? → SignIn
  RoleService.initRole() →
    role resolved? → _navigateAuthenticated()
      └── _routeForRole(role) → truckOwnerNavBar / driverNavBar / guestView
    failed? → SignIn (catch fallback)
```

### 2.5 Network Stack

- **HTTP client:** Dio via shared `DioService` instance — never create raw `Dio()` per call
- **Base URL:** `ApiEndPoint.baseUrl` — currently points to beta server
- **Auth:** Bearer token stored via `PrefUtils` (SharedPreferences — **see security debt**)
- **Token refresh:** 401 → `AuthService.refreshToken()` → retry
- **Postal/district lookup:** `api.postalpincode.in` — wrapped in `_resolveDistrict()` with
  silent fallback to geocoder's `subAdministrativeArea` on any failure

---

## 3. Key Dependencies

| Package | Purpose | Notes |
|---------|---------|-------|
| `get ^4.7.2` | State, routing, DI | All controllers extend `GetxController` |
| `dio ^5.8.0` | HTTP | Use shared `dioService.dio`, never `Dio()` directly |
| `shared_preferences ^2.0.15` | Local KV store | **Security debt — token stored in plain prefs** |
| `encrypt ^5.0.3` | AES-256 encryption | **Security debt — key hardcoded in source** |
| `sqflite ^2.4.2` | Local SQLite DB | **Security debt — unencrypted** |
| `geolocator ^14.0.1` | Device location | Use `LocationController` singleton via `Get.find<>()` |
| `geocoding ^3.0.0` | Reverse geocoding | Fallback when postal API fails |
| `google_maps_flutter ^2.16.0` | Maps | API key must be restricted by SHA-1 + package name |
| `firebase_messaging ^16.0.4` | Push notifications | Token registered via `ApiEndPoint.firbaseToken` |
| `firebase_crashlytics ^5.2.2` | Crash reporting | PII must be scrubbed before sending |
| `table_calendar ^3.2.0` | Date picker calendar | See fix notes in §5, Session 2 |
| `local_auth ^2.1.6` | Biometrics | |
| `permission_handler ^11.3.1` | Runtime permissions | |
| `flutter_screenutil ^5.9.0` | Responsive sizing | Use `.r`, `.w`, `.h`, `.sp` suffixes |

---

## 4. Coding Standards

### 4.1 GetX Rules

- **Always `onClose()`, never `dispose()`** in `GetxController` subclasses.
- **Always `Get.find<ControllerName>()`**, never `Get.put(ControllerName())` inside a widget
  that isn't the binding — creates a second orphaned instance with no state.
- **Dispose `TextEditingController`s in `onClose()`** — every controller that creates one.
- Use guard-and-return pattern in routing (`if (x == null) return;`) instead of nested if/else.
- **Never use `RxList.value` outside RxList subclasses** — use `.toList()` to pass to widget
  params; use the `RxList` directly inside `Obx` for reactive reads.

### 4.2 Dart / Flutter Rules

- **`setState` is atomic** — all related state fields must update inside a single `setState`
  call. Never mutate state outside `setState` and expect a rebuild.
- **No `BuildContext` across async gaps** — check `mounted` before any `setState` /
  `Navigator` call that follows an `await`.
- **`StatefulWidget` for any widget that needs data on open** — do not use `StatelessWidget`
  when `initState` work (API call, auto-fetch) is required.
- **`||` not `&&` in validators** — null-OR-empty checks must use `||`; `&&` means
  the null branch never fires.
- **Day clamping before `DateTime` construction** — always use
  `day.clamp(1, _daysInMonth(year, month))` before building a `DateTime` to avoid month
  overflow (e.g. Jan 31 → Feb = Mar 3).

### 4.3 API / Service Rules

- **Never create a bare `Dio()` instance** per-call; use the shared `dioService.dio`.
  A bare instance has no interceptors, no pinning, no shared headers.
- **Wrap external APIs in try/catch with silent fallback** — district lookup, postal pin,
  any third-party endpoint. Never surface a certificate or network error directly to the user.
- **Sequential `await`** for critical auth calls (main API + register token) — bare
  `Future.wait` without await is a silent fire-and-forget.

### 4.4 Form / Validation Rules

- DOB / date fields → non-empty check only, never `isPhoneNumber`.
- UUID (6-char) field → empty check only, never length range check with impossible bounds.
- Disable submit button during async calls — toggle `isDisabled` true/false around the
  API call to prevent duplicate submissions.
- `currentState?.validate() ?? false` — never `currentState!.validate()` (null-crash risk).

### 4.5 Timer / Resource Lifecycle

- `stopTimer()` pattern: **`cancel()` first, then null the reference**. Nulling first
  leaves the timer running and leaks memory.
- **Debounce timers must be cancelled in `onClose()`** — always store the `Timer?` as a
  field and cancel it before nulling.

### 4.6 Async Search Dropdowns

- Use `AppDropdownSearch<T>` with `searchState: AppDropdownSearchState.xxx` to enter async
  mode — the controller owns the state machine, the widget just renders it.
- Debounce keystrokes 500 ms before firing an API call (use `Timer` in the controller).
- On empty query → set state to `idle` and clear results immediately (no API call).
- On selection → update the reactive `Rxn<T>` in the controller; drive any dependent data
  (e.g. minerals from origin company) in the `onChanged` callback.
- Pass `.toList()` for `items` param (not the raw `RxList`) to avoid protected-member warnings.

---

## 5. All Fixes Applied (Session Log)

### Session 1 — Security & Core Bug Fixes (commit `05d1c8f`, branch `developement`)

#### Android / Security
| File | Fix |
|------|-----|
| `AndroidManifest.xml` | Removed `usesCleartextTraffic="true"` from `<activity>` (was a no-op there, misleading); moved Google Maps API key to `<application>` level |

#### Splash Controller (`lib/controllers/splash_controller.dart`)
| Before | After |
|--------|-------|
| Double `Future.delayed` nesting | Single defer in `onInit` |
| No try/catch — any throw froze splash | try/catch fallback to SignIn |
| Dead `else if` / `else` branches | Guard-and-return pattern |
| `RoleService.initRole()` before null check | Null check first |
| Bare unawaited `Future.wait` | Sequential `await` calls |
| Manager role (7) silently fell through | Maps to `truckOwnerNavBar` |
| Routing logic duplicated inline | `_navigateAuthenticated()` + `_routeForRole()` extracted |

#### Location / Address (`lib/controllers/location_controller.dart`)
| Before | After |
|--------|-------|
| `initialize()` called `getCurrentLocation()` without `isShowAppLoader: false` | Added `isShowAppLoader: false` — prevents loader on every cold start |
| Raw `Dio()` in `_resolveDistrict()` — cert failure surfaced to user | Uses shared `dioService.dio`; silently falls back to geocoder on any failure |
| `currentPosition.value!` null crash | Null guard before dereference |
| `AllLocationModal` used `Get.put(LocationController())` | Changed to `Get.find<LocationController>()` |
| Modal opened empty, user had to tap Refresh | `StatelessWidget` → `StatefulWidget`; `getCurrentAddress()` called in `initState` |

#### Signup Flow (50 files total)
| # | File | Bug | Fix |
|---|------|-----|-----|
| 1 | `address_auth_page.dart` | Missing `token` + `validationType: whileSignUp` in nav args to `SetRolePage` → 401, wrong routing | Added both keys |
| 2 | `otp_controller.dart` | `stopTimer()` nulled `_timer` before `cancel()` — timer leak | Swap: `cancel()` first, then null |
| 3 | `otp_screen.dart` | OTP validator used `&&` — null branch never fired | Changed to `||` |
| 4 | `otp_controller.dart` | `dispose()` instead of `onClose()` | Fixed |
| 5 | `create_user_page.dart` | DOB validated with `isPhoneNumber` — showed "invalid mobile number" | Replaced with non-empty check |
| 6 | `signup_controller.dart` | `isDisabled` never toggled — duplicate API calls possible | Toggle true/false around `verifyEmail()` |
| 7 | `signup_controller.dart` | `dispose()` instead of `onClose()` | Fixed |
| 8 | `auth_controller.dart` | `validateUUIDField` said "too short" when length > 7 (impossible with maxLength 6) | Simplified to empty-check only |
| 9 | `auth_controller.dart` | Duplicate `refreshToken()` identical to `AuthService.refreshToken()`, never called | Removed |
| 10 | `auth_controller.dart` | `currentState!.validate()` crash risk | Changed to `currentState?.validate() ?? false` |
| 11 | `user_doc_auth_controller.dart` | `dispose()` instead of `onClose()`; 3 `TextEditingController`s not disposed | Fixed to `onClose()` + `.dispose()` all 3 |

---

### Session 2 — AppDatePicker Month Navigation Fix

**File:** `lib/pages/widget/app_date_picker.dart`

**Symptom:** Selecting a month from the dropdown did not scroll the calendar to that month;
year selection worked fine.

#### Bug 1 — `getMonthList` never capped `endMonth`

`endMonth` was hardcoded to `12` and never updated. For the last allowed year
(e.g. `lastDate = DateTime.now()` = current month), the dropdown showed all 12 months.
Picking a month past `lastDate.month` made `newDate.isBefore(lastDate)` return `false` so
the `setState` block was silently skipped.

```dart
// Before
int endMonth = 12; // never changed
// After
endMonth = (year == lastDate.year) ? lastDate.month : 12;
```

#### Bug 2 — Day overflow creates wrong month

`DateTime(selectedYear, m, pickedDate.day)` — when `pickedDate.day` is 29/30/31 and the
target month has fewer days, Dart normalises to the next month (Feb 31 → Mar 3).

```dart
int _daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;
final clampedDay = pickedDate.day.clamp(1, _daysInMonth(selectedYear, m));
final newDate = DateTime(selectedYear, m, clampedDay);
```

#### Bug 3 — Year `onChanged` mutated state outside `setState`

The fallback `pickedDate = DateTime(selectedYear, _monthList.first, 1)` ran after `setState`
returned (no re-render). `dTFocusedDate` was also calculated with the stale `pickedDate.month`.

```dart
// Fix: resolve all values BEFORE setState, update all three fields together
final newMonth = _monthList.contains(pickedDate.month)
    ? pickedDate.month : _monthList.first;
final clampedDay = pickedDate.day.clamp(1, _daysInMonth(y, newMonth));
final newDate = DateTime(y, newMonth, clampedDay);
setState(() {
  selectedYear = y;
  pickedDate = newDate;
  dTFocusedDate = newDate;
});
```

---

### Session 3 — Company Search + Mineral Dropdown in AddTripPage

**Files changed:** 5 — `company_model.dart`, `company_service.dart`,
`app_search_dropdown_button.dart`, `trip_add_controller.dart`, `trip_add_page.dart`

#### 3a. `CompanyModel.fromJSON` — `lib/model/company_model.dart`

Added `factory CompanyModel.fromJSON(Map<String, dynamic> json)` to deserialise API search
responses. The API uses snake_case keys (`name_code`, `mineral_id`); `fromDB` uses camelCase
DB keys — both factories now coexist.

#### 3b. `CompanyService.searchCompanies` — `lib/services/company_service.dart`

```dart
static Future<List<CompanyModel>> searchCompanies(String query)
// GET /companies/search?search=<query>  via shared DioService
// Returns [] on any error (silent fallback — §4.3)
```

Added `static final DioService _dioService = DioService()` (shared instance — never bare `Dio()`).

#### 3c. `AppDropdownSearch` async mode — `lib/component/bohiba_dropdown/app_search_dropdown_button.dart`

All 15+ existing static-mode call-sites are **100 % unchanged**. Async mode is opt-in:

| New optional param | Type | Purpose |
|---|---|---|
| `searchState` | `AppDropdownSearchState?` | Non-null activates async mode |
| `onSearchChanged` | `void Function(String)?` | Keystroke callback; caller debounces |
| `searchErrorMessage` | `String?` | Custom error copy |

New `AppDropdownSearchState` enum:
```dart
enum AppDropdownSearchState { idle, searching, success, noDataFound, error }
```

Private `_AsyncSearchDropdownContent<T>` (`StatefulWidget`) manages:
- Internal `TextEditingController` + `FocusNode`
- `LayerLink` + `CompositedTransformTarget/Follower` → `OverlayEntry` positioned below input
- `_handleFocusChange` — opens overlay on focus; 150 ms delay on blur so taps register first
- `didUpdateWidget` → `_overlayEntry?.markNeedsBuild()` when `searchState` or item count changes
- Overlay per state: idle → hint; searching → spinner; noDataFound → message; error → message; success → `ListView`
- Item tap → `fieldState.didChange(item)` + `onChanged` + `unfocus`
- Clear `✕` → resets text, form value, fires `onSearchChanged('')`
- `dispose()` removes listener, disposes controllers, removes overlay

#### 3d. `TripAddController` — `lib/controllers/trip_add_controller.dart`

| Removed | Added |
|---------|-------|
| `originController` / `destinationController` (`TextEditingController`) | `selectedOriginCompany` / `selectedDestinationCompany` (`Rxn<CompanyModel>`) |
| `ironOreTypes` (`List<String>`) + `strOre` | `availableMinerals` (`RxList<MineralModel>`) + `selectedMineral` (`Rxn<MineralModel>`) |
| `materialController` | — |
| `addUpdateTrip` sent `origin: text` | sends `origin: company.id` (int) |

New search machinery:
- `originSearchResults` / `destinationSearchResults` — `RxList<CompanyModel>`
- `originSearchState` / `destinationSearchState` — `Rx<AppDropdownSearchState>`
- `_originSearchDebounce` / `_destinationSearchDebounce` — `Timer?` (cancelled in `onClose`)
- `onOriginQueryChanged(String)` — 500 ms debounce → `_fetchCompanies`
- `onOriginSelected(CompanyModel?)` — sets company; calls `MineralsService.getMineralsByIds(company.mineralId)` to populate `availableMinerals`
- `onDestinationQueryChanged/Selected` — symmetric
- `editTripController()` — fetches full `CompanyModel` from local DB via `CompanyService.getCompany(id)`; loads minerals; matches saved `materialType` string to a mineral; stubs a minimal `CompanyModel` if company is not in local DB

#### 3e. `AddTripPage` — `lib/pages/trips/trip_add_page.dart`

| Removed | Replaced with |
|---------|---------------|
| Origin `TextInputField` (free text) | `AppDropdownSearch<CompanyModel>` — async search mode |
| Destination `TextInputField` (free text) | `AppDropdownSearch<CompanyModel>` — async search mode |
| Material Type `AppDropdownSearch<String>` (hardcoded 29-item list) | `AppDropdownSearch<MineralModel>` — static mode, items from `controller.availableMinerals` |

---

## 6. Open Security Findings (Not Yet Fixed)

Identified in Session 1 security audit. **Address before production release.**

| # | Severity | File | Finding | Recommended Fix |
|---|----------|------|---------|-----------------|
| S1 | 🔴 Critical | `lib/services/encryption_service.dart` | AES-256 key hardcoded as string literal (`my32lengthsupersecretnooneknows1`) | Derive key from Android Keystore / iOS Keychain |
| S2 | 🔴 Critical | `lib/services/pref_utils.dart` | Auth token in plain `SharedPreferences` | Migrate to `flutter_secure_storage` |
| S3 | 🔴 Critical | `lib/services/db2_service.dart` | SQLite unencrypted — trip data + user PII at rest | SQLCipher / drift encryption; wrap key in Keystore/Keychain |
| S4 | 🟠 High | `AndroidManifest.xml` | No SSL pinning | `network_security_config.xml` SPKI pins + Dio interceptor |
| S5 | 🟠 High | `lib/services/api_end_point.dart` | Google Maps API key unrestricted | Restrict by SHA-1 + package name; rotate if leaked |
| S6 | 🟠 High | `lib/controllers/location_controller.dart` | Background location without `FOREGROUND_SERVICE_LOCATION` | Foreground service + persistent notification (Android 14+) |
| S7 | 🟡 Medium | `lib/services/encryption_service.dart` | `decryptText` uses zero IV instead of embedded IV | Extract IV from `iv:ciphertext` format that `encryptText` already produces |
| S8 | 🟡 Medium | Multiple controllers | `logger`/`print` may leak tokens, GPS, PII in release | Gate behind `kDebugMode` |
| S9 | 🟡 Medium | `android/` | No Play Integrity / SafetyNet | Integrate Play Integrity API for attestation |
| S10 | 🟡 Medium | App-wide | No root/jailbreak detection | `flutter_jailbreak_detection` |
| S11 | 🟡 Medium | `lib/services/firebase_app_service.dart` | Crashlytics — PII scrubbing unverified | Audit all `recordError` calls; strip GPS, phone, Aadhaar |
| S12 | 🟡 Medium | App-wide | No DPDP Act 2023 consent screen | Consent flow on first run + data deletion support |
| S13 | 🟡 Medium | `lib/pages/payment/` | Client-side UPI `SUCCESS` trusted without server reconciliation | Server-side webhook reconciliation; treat client status as advisory |

---

## 7. Architecture Constraints (Non-Negotiable)

1. **Never create `Dio()` directly** — always use the shared `dioService.dio` instance.
2. **Never `Get.put(ControllerX())` inside a widget** — use `Get.find<ControllerX>()`;
   let the binding inject.
3. **`onClose()` not `dispose()`** in every `GetxController`.
4. **Dispose all `TextEditingController`s** explicitly in `onClose()`.
5. **All `setState` mutations must be inside the closure** — no state changes outside.
6. **Token/secrets never in source code** — Keystore/Keychain only (currently violated, see §6).
7. **Shared `LocationController` singleton** — location is expensive; one instance, accessed
   via `Get.find<LocationController>()`.
8. **External API failures must be silent with fallback** — never propagate a network or
   cert error to a user-facing widget from a utility call.
9. **Async search state lives in the controller, not the widget** — `AppDropdownSearch`
   renders state; the `GetxController` owns the state machine, debounce timer, and results list.

---

## 8. Roadmap

### 8.1 Immediate (Security — before production)

- [ ] **S1** — Migrate AES key to Android Keystore / iOS Keychain
- [ ] **S2** — Migrate auth token to `flutter_secure_storage`
- [ ] **S3** — Encrypt SQLite with SQLCipher / drift encryption
- [ ] **S4** — Add SSL/SPKI pinning (`network_security_config.xml` + Dio interceptor)
- [ ] **S5** — Restrict Google Maps API key; rotate current key
- [ ] **S7** — Fix `decryptText` to use the IV embedded in ciphertext, not a zero IV

### 8.2 Short-term (Compliance & Stability)

- [ ] **S6** — Background location foreground service (`FOREGROUND_SERVICE_LOCATION`) for Android 14+
- [ ] **S8** — Gate all `logger`/`print` behind `kDebugMode`; scrub PII from logs
- [ ] **S11** — Audit Crashlytics `recordError` calls — strip GPS, phone, Aadhaar
- [ ] **S12** — DPDP Act 2023 consent screen on first run + data deletion support
- [ ] **S13** — Server-side webhook reconciliation for UPI payments; remove client-status trust
- [ ] Push branch + open PR for all session fixes (needs GitHub PAT)
  ```bash
  git remote set-url origin https://<YOUR_PAT>@github.com/bohiba/bohiba.git
  git push origin developement
  gh pr create --title "fix: auth flow, splash, location, date-picker, company/mineral search" --base main
  ```

### 8.3 Medium-term (Hardening)

- [ ] **S9** — Play Integrity API integration for device attestation
- [ ] **S10** — Root/jailbreak detection (`flutter_jailbreak_detection`)

### 8.4 Long-term (Feature Completions noted during audit)

- [ ] Role-based custom permissions — `RolePermissionManager` has a `TODO` to merge
  truck-owner custom permissions from the backend SQL store
- [ ] AIS-140 telematics coexistence — ensure app GPS data doesn't contradict or
  duplicate the mandatory AIS-140 device data for commercial vehicles
- [ ] E-way bill Part-B vehicle update on trip start (GSTN / GSP integration)
- [ ] DigiLocker / Vahan / Sarathi driver KYC verification (DL, RC, PUC)
- [ ] Offline-first location buffering with retry — GPS points written to local store
  first, uploaded with exponential backoff, not one-at-a-time

---

## 9. Component Reference

### 9.1 `AppDropdownSearch<T>` — `lib/component/bohiba_dropdown/app_search_dropdown_button.dart`

A `FormField<T>` that operates in two modes:

**Static mode** (default — `searchState` param absent):
- Backed by Flutter's `DropdownMenu`
- `initialValue` → `initialSelection`
- `_AppDropdownFormFieldState.didUpdateWidget` calls `setValue(initialValue)` on change
- **Do NOT pass a stale `initialValue`** — derive from current reactive state

**Async search mode** (`searchState` non-null):
- Backed by `_AsyncSearchDropdownContent<T>` (private `StatefulWidget`)
- `TextField` + `OverlayEntry` via `CompositedTransformFollower`
- Overlay refreshes via `markNeedsBuild()` — no teardown on state changes
- Clear `✕` button resets form value and fires `onSearchChanged('')`
- Edit-mode pre-population: set `initialValue` from reactive state; `didUpdateWidget` syncs text

### 9.2 `AppDropdownSearchState` enum

```dart
enum AppDropdownSearchState { idle, searching, success, noDataFound, error }
```

State machine owned by the controller. Rendered by the widget. Never drive state from the widget.

---

*Last updated: Session 3 — Company/Mineral search in AddTripPage*
*Sessions completed: 3*
*Active branch: `developement`*
*Last commit on branch: `05d1c8f` (Session 1 — 50 files; Sessions 2 & 3 not yet committed)*
