// Unit tests for TripAddController's date-format helpers.
//
// Root cause being tested: the UI stores dates as "dd-MM-yyyy" but the
// backend requires "yyyy-MM-dd" (Laravel Y-m-d rule). Sending the raw
// display string caused: "The started at field must match the format Y-m-d."
//
// Run with: flutter test test/trip_date_format_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Mirrors of the private helpers in TripAddController ──────────────────────
// These are extracted here so they can be unit-tested without spinning up
// GetX / Dio / Firebase. If the helpers change in the controller, update here.

final _displayFmt = DateFormat('dd-MM-yyyy');
final _apiFmt     = DateFormat('yyyy-MM-dd');

String? toApiDate(String raw) {
  final s = raw.trim();
  if (s.isEmpty) return null;
  try {
    return _apiFmt.format(_displayFmt.parseStrict(s));
  } catch (_) {}
  try {
    return _apiFmt.format(DateTime.parse(s));
  } catch (_) {}
  return null;
}

String? toDisplayDate(String? raw) {
  if (raw == null || raw.trim().isEmpty) return null;
  try {
    return _displayFmt.format(DateTime.parse(raw.trim()));
  } catch (_) {}
  try {
    return _displayFmt.format(_displayFmt.parseStrict(raw.trim()));
  } catch (_) {}
  return null;
}
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  group('toApiDate — display (dd-MM-yyyy) → API (yyyy-MM-dd)', () {
    test('normal date converts correctly', () {
      expect(toApiDate('25-07-2026'), '2026-07-25');
    });

    test('first day of month', () {
      expect(toApiDate('01-01-2024'), '2024-01-01');
    });

    test('last day of month', () {
      expect(toApiDate('31-12-2025'), '2025-12-31');
    });

    test('leading zeros preserved in output', () {
      expect(toApiDate('05-03-2026'), '2026-03-05');
    });

    test('whitespace is trimmed', () {
      expect(toApiDate('  25-07-2026  '), '2026-07-25');
    });

    test('empty string returns null', () {
      expect(toApiDate(''), isNull);
    });

    test('blank whitespace string returns null', () {
      expect(toApiDate('   '), isNull);
    });

    test('garbage input returns null', () {
      expect(toApiDate('not-a-date'), isNull);
    });

    test('partial date returns null', () {
      expect(toApiDate('25-07'), isNull);
    });

    // Edit-mode fallback: _parseDate() in TripModel returns DateTime.toString()
    test('DateTime.toString() format is converted', () {
      expect(toApiDate('2026-07-25 00:00:00.000'), '2026-07-25');
    });

    test('DateTime.toString() with non-zero time component', () {
      expect(toApiDate('2026-07-25 14:30:59.123'), '2026-07-25');
    });

    test('ISO 8601 with Z suffix', () {
      expect(toApiDate('2026-07-25T00:00:00.000Z'), '2026-07-25');
    });

    test('output is always Y-m-d — single digit month/day zero-padded', () {
      final result = toApiDate('05-03-2026');
      // Must match Y-m-d exactly: 4-digit year, 2-digit month, 2-digit day
      expect(result, matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
    });
  });

  group('toDisplayDate — raw server string → display (dd-MM-yyyy)', () {
    test('DateTime.toString() converts to display format', () {
      expect(toDisplayDate('2026-07-25 00:00:00.000'), '25-07-2026');
    });

    test('API date string (yyyy-MM-dd) converts correctly', () {
      expect(toDisplayDate('2026-07-25'), '25-07-2026');
    });

    test('first of month', () {
      expect(toDisplayDate('2024-01-01 00:00:00.000'), '01-01-2024');
    });

    test('null input returns null', () {
      expect(toDisplayDate(null), isNull);
    });

    test('empty string returns null', () {
      expect(toDisplayDate(''), isNull);
    });

    test('whitespace-only returns null', () {
      expect(toDisplayDate('   '), isNull);
    });

    test('garbage returns null', () {
      expect(toDisplayDate('not-a-date'), isNull);
    });

    test('already in display format passes through', () {
      expect(toDisplayDate('25-07-2026'), '25-07-2026');
    });
  });

  group('round-trip correctness', () {
    test('display → API → display is lossless', () {
      const display = '14-03-2026';
      final api     = toApiDate(display)!;
      final back    = toDisplayDate(api)!;
      expect(back, display);
    });

    test('server DateTime.toString() → API format is idempotent', () {
      const server = '2026-03-14 00:00:00.000';
      final api    = toApiDate(server)!;
      expect(api, '2026-03-14');
      // Converting again must not change result
      expect(toApiDate(api), '2026-03-14');
    });
  });

  group('tripCode2 derivation', () {
    // tripCode2 = toApiDate(startDate)?.replaceAll('-', '')
    // Must be purely numeric and in yyyyMMdd order (not ddMMyyyy).
    test('trip code from display date is yyyyMMdd', () {
      final code = (toApiDate('25-07-2026') ?? '').replaceAll('-', '');
      expect(code, '20260725');
    });

    test('trip code from edit-mode date is yyyyMMdd', () {
      final code =
          (toApiDate('2026-07-25 00:00:00.000') ?? '').replaceAll('-', '');
      expect(code, '20260725');
    });

    test('trip code is 8 digits', () {
      final code = (toApiDate('05-03-2026') ?? '').replaceAll('-', '');
      expect(code.length, 8);
      expect(code, matches(RegExp(r'^\d{8}$')));
    });
  });
}
