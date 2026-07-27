import 'dart:async';
import 'dart:io';

import 'package:bohiba/extensions/bohiba_extension.dart';
import 'package:bohiba/model/pdf_generate_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import '/dist/enums/enum_search_state.dart';
import '/model/company_model.dart';
import '/model/trip_report_model.dart';
import '/services/company_service.dart';
import '/services/trip_report_service.dart';
import '/services/global_service.dart';
import '/dist/enums/app_enums.dart';

enum ReportStep { idle, fetching, generating, done, error }

class TripReportController extends GetxController {
  // ── Filter state — company search (mirrors TripAddController) ─
  Rxn<CompanyModel> selectedTransporter = Rxn();
  RxList<CompanyModel> transporterSearchResults = <CompanyModel>[].obs;
  Rx<EnumSearchState> transporterSearchState = EnumSearchState.idle.obs;
  TextEditingController transporterController = TextEditingController();
  Timer? _transporterDebounce;

  Rxn<CompanyModel> selectedMine = Rxn();
  RxList<CompanyModel> mineSearchResults = <CompanyModel>[].obs;
  Rx<EnumSearchState> mineSearchState = EnumSearchState.idle.obs;
  TextEditingController mineController = TextEditingController();
  Timer? _mineDebounce;

  Rxn<CompanyModel> selectedPlant = Rxn();
  RxList<CompanyModel> plantSearchResults = <CompanyModel>[].obs;
  Rx<EnumSearchState> plantSearchState = EnumSearchState.idle.obs;
  TextEditingController plantController = TextEditingController();
  Timer? _plantDebounce;

  Rx<TextEditingController> fromDate = TextEditingController().obs;
  Rx<TextEditingController> toDate = TextEditingController().obs;

  // ── Trip list state ───────────────────────────────────────────
  RxList<TripReportModel> trips = <TripReportModel>[].obs;
  RxBool isSearching = false.obs;
  RxBool hasSearched = false.obs;
  RxBool searchError = false.obs;

  // ── Selection state ───────────────────────────────────────────
  final RxSet<int> selectedIds = <int>{}.obs;

  bool get hasSelection => selectedIds.isNotEmpty;
  int get selectionCount => selectedIds.length;
  bool get allSelected =>
      trips.isNotEmpty && selectedIds.length == trips.length;

  final _amountFmt = NumberFormat('#,##,##0.##', 'en_IN');

  void toggleTrip(int id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }

  void selectAll() =>
      selectedIds.addAll(trips.map((t) => t.id).whereType<int>());
  void deselectAll() => selectedIds.clear();

  // ── Report generation state ───────────────────────────────────
  Rx<ReportStep> reportStep = ReportStep.idle.obs;
  Rxn<Uint8List> pdfBytes = Rxn();
  Rxn<PdfGenerateModel> reportData = Rxn();

  // ── Company search callbacks ──────────────────────────────────
  void onTransporterQueryChanged(String query) {
    _transporterDebounce?.cancel();
    if (query.trim().isEmpty || query.length < 2) {
      transporterSearchState.value = EnumSearchState.idle;
      transporterSearchResults.clear();
      return;
    }
    transporterSearchState.value = EnumSearchState.searching;
    _transporterDebounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final results = await CompanyService.searchTransporters(query.trim());
        transporterSearchResults.assignAll(results);
        transporterSearchState.value = results.isEmpty
            ? EnumSearchState.noDataFound
            : EnumSearchState.success;
      } catch (_) {
        transporterSearchState.value = EnumSearchState.error;
      }
    });
  }

  void onTransporterSelected(CompanyModel? company) {
    selectedTransporter.value = company;
    transporterController.text = company?.name ?? '';
  }

  void onMineQueryChanged(String query) {
    _mineDebounce?.cancel();
    if (query.trim().isEmpty || query.length < 3) {
      mineSearchState.value = EnumSearchState.idle;
      mineSearchResults.clear();
      return;
    }
    mineSearchState.value = EnumSearchState.searching;
    _mineDebounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final results = await CompanyService.searchMines(query.trim());
        mineSearchResults.assignAll(results);
        mineSearchState.value = results.isEmpty
            ? EnumSearchState.noDataFound
            : EnumSearchState.success;
      } catch (_) {
        mineSearchState.value = EnumSearchState.error;
      }
    });
  }

  void onMineSelected(CompanyModel? company) {
    selectedMine.value = company;
    mineController.text = company?.name ?? '';
  }

  void onPlantQueryChanged(String query) {
    _plantDebounce?.cancel();
    if (query.trim().isEmpty || query.length < 3) {
      plantSearchState.value = EnumSearchState.idle;
      plantSearchResults.clear();
      return;
    }
    plantSearchState.value = EnumSearchState.searching;
    _plantDebounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final results = await CompanyService.searchPlants(query.trim());
        plantSearchResults.assignAll(results);
        plantSearchState.value = results.isEmpty
            ? EnumSearchState.noDataFound
            : EnumSearchState.success;
      } catch (_) {
        plantSearchState.value = EnumSearchState.error;
      }
    });
  }

  void onPlantSelected(CompanyModel? company) {
    selectedPlant.value = company;
    plantController.text = company?.name ?? '';
  }

  // ── Filter helpers ────────────────────────────────────────────
  TripReportFilter get currentFilter => TripReportFilter(
        transportId: selectedTransporter.value?.id,
        mineId: selectedMine.value?.id,
        plantId: selectedPlant.value?.id,
        fromDate: fromDate.value.text.toYMD(),
        toDate: toDate.value.text.toYMD(),
      );

  int get activeFilterCount => [
        selectedTransporter.value,
        selectedMine.value,
        selectedPlant.value,
        fromDate.value.text.isNotEmpty ? 1 : null,
        toDate.value.text.isNotEmpty ? 1 : null,
      ].where((v) => v != null).length;

  void resetFilters() {
    selectedTransporter.value = null;
    transporterController.clear();
    transporterSearchResults.clear();
    transporterSearchState.value = EnumSearchState.idle;

    selectedMine.value = null;
    mineController.clear();
    mineSearchResults.clear();
    mineSearchState.value = EnumSearchState.idle;

    selectedPlant.value = null;
    plantController.clear();
    plantSearchResults.clear();
    plantSearchState.value = EnumSearchState.idle;

    fromDate.value.clear();
    toDate.value.clear();
  }

  // ── Search trips ──────────────────────────────────────────────
  Future<void> searchTrips() async {
    isSearching.value = true;
    searchError.value = false;
    hasSearched.value = false;
    selectedIds.clear();

    final result = await TripReportService.searchTrips(currentFilter);

    isSearching.value = false;
    hasSearched.value = true;

    if (result == null) {
      searchError.value = true;
    } else {
      trips.value = result;
    }
  }

  // ── Generate PDF ──────────────────────────────────────────────
  Future<void> generatePdf() async {
    if (selectedIds.isEmpty) {
      GlobalService.showSnackBar(
        status: AlertStatus.warning,
        title: 'Trip Report',
        desc: 'Please select at least one trip.',
      );
      return;
    }

    reportStep.value = ReportStep.fetching;
    final data = await TripReportService.generateReport(selectedIds.toList());

    if (data == null) {
      reportStep.value = ReportStep.error;
      return;
    }

    reportData.value = data;
    reportStep.value = ReportStep.generating;
    try {
      pdfBytes.value = await _buildPdf(data);
      reportStep.value = ReportStep.done;
    } catch (_) {
      reportStep.value = ReportStep.error;
    }
  }

  void retryGenerate() {
    reportStep.value = ReportStep.idle;
    generatePdf();
  }

  // ── PDF builder ───────────────────────────────────────────────
  Future<Uint8List> _buildPdf(PdfGenerateModel data) async {
    // Load Inter TTF so Unicode characters render correctly (Helvetica is Latin-only)
    final regularData = await rootBundle.load('assets/fonts/Inter-Regular.ttf');
    final boldData = await rootBundle.load('assets/fonts/Inter-Bold.ttf');
    final baseFont = pw.Font.ttf(regularData);
    final boldFont = pw.Font.ttf(boldData);

    final doc = pw.Document(
      theme: pw.ThemeData.withFont(base: baseFont, bold: boldFont),
    );
    final dateStr = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());
    final owner = data.owner;
    final ownerCompany = data.ownerCompany;
    final route = data.route;
    final transporter = data.transporter;
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (_) {
          return pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                if (ownerCompany?.name != null)
                  pw.Text(
                    ownerCompany?.name ?? '',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold),
                    textAlign: pw.TextAlign.center,
                  ),

                // ADDRESS & GST
                if (ownerCompany?.address != null) ...[
                  pw.Text(
                    '${ownerCompany?.address?.address ?? ''}, '
                    '${ownerCompany?.address?.district ?? ''}, '
                    '${ownerCompany?.address?.state ?? ''} - '
                    '${ownerCompany?.address?.pincode ?? ''}',
                    style: const pw.TextStyle(fontSize: 10),
                    textAlign: pw.TextAlign.center,
                  ),
                ],

                // CONTACTS
                if (ownerCompany?.contactPhones != null &&
                    (ownerCompany!.contactPhones.isNotEmpty))
                  pw.Text(
                    'Contact: ${ownerCompany.contactPhones.join(', ')}',
                    style: const pw.TextStyle(fontSize: 10),
                    textAlign: pw.TextAlign.center,
                  ),

                if ((ownerCompany?.legal?.gstNo?.isNotEmpty ?? false) ||
                    (ownerCompany?.legal?.panNo?.isNotEmpty ?? false))
                  pw.Text(
                    '${ownerCompany?.legal?.gstNo?.isNotEmpty ?? false ? "GST No.: ${ownerCompany?.legal?.gstNo ?? ''}" : ""} | ${ownerCompany?.legal?.panNo?.isNotEmpty ?? false ? "PAN No.: ${ownerCompany?.legal?.panNo ?? ''}" : ""}',
                    style: const pw.TextStyle(fontSize: 10),
                    textAlign: pw.TextAlign.center,
                  ),
                pw.SizedBox(height: 4),
                pw.Divider(thickness: 0.5, color: PdfColors.grey400),
              ],
            ),
          );
        },
        build: (_) => [
          pw.Column(children: [
            // Transporter Name
            if (transporter?.name != null)
              _pdfRowWidget(
                  title: 'Transporter:', subtitle: transporter?.name ?? ""),

            pw.SizedBox(height: 4),
            if (owner != null) ...[
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _pdfRowWidget(title: 'Owner:', subtitle: owner.name ?? ''),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _pdfRowWidget(title: 'Bank:', subtitle: owner.bankName ?? ''),
                  _pdfRowWidget(
                      title: 'A/c', subtitle: owner.bankAccountNumber ?? ''),
                  _pdfRowWidget(title: 'IFSC', subtitle: owner.bankIfsc ?? ''),
                ],
              ),
            ],
            if (route != null)
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _pdfRowWidget(title: 'From:', subtitle: route.from ?? ''),
                  _pdfRowWidget(title: 'To:', subtitle: route.to ?? ''),
                ],
              ),
            pw.SizedBox(height: 10),
          ]),
          pw.TableHelper.fromTextArray(
            headers: [
              'No',
              'Date',
              'Vehicle Number',
              'T.P No',
              'Net Wt (MT)',
              'Rate',
              'Shortage',
              'Diesel',
            ],
            data: data.trips == null || (data.trips?.isEmpty ?? true)
                ? []
                : List.generate(data.trips!.length, (index) {
                    final trips = data.trips;
                    if (trips == null || (trips.isEmpty)) {
                      return [];
                    } else {
                      final t = trips[index];
                      return [
                        (index + 1).toString(),
                        _formatDate(t.date),
                        t.vehicleNumber ?? '',
                        t.tripCode ?? '',
                        t.netWeight?.toStringAsFixed(2) ?? '-',
                        t.rate?.toStringAsFixed(2) ?? '',
                        t.shortWeight?.toStringAsFixed(2) ?? '',
                        t.dieselAmount?.toStringAsFixed(2) ?? '',
                      ];
                    }
                  }),
            headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 9,
                color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
            cellStyle: const pw.TextStyle(fontSize: 8),
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              8: pw.Alignment.centerRight,
            },
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            cellPadding:
                const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          ),
          if (data.summary != null)
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              columnWidths: const {
                0: pw.FlexColumnWidth(0.5),
                1: pw.FlexColumnWidth(1.2),
                2: pw.FlexColumnWidth(1.5),
                3: pw.FlexColumnWidth(1.5),
                4: pw.FlexColumnWidth(1.0),
                5: pw.FlexColumnWidth(1.0),
                6: pw.FlexColumnWidth(1.0),
                7: pw.FlexColumnWidth(1.0),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.blue50),
                  children: [
                    _pdfTotalCell('TOTAL', bold: true),
                    _pdfTotalCell(''),
                    _pdfTotalCell(''),
                    _pdfTotalCell(''),
                    _pdfTotalCell(
                        data.summary!.totalNetWeight?.toStringAsFixed(2) ?? '-',
                        bold: true),
                    _pdfTotalCell(
                        "₹ ${_amountFmt.format(data.summary!.totalAmount ?? 0.0)}",
                        bold: true),
                    _pdfTotalCell(
                        data.summary!.totalShortage?.toStringAsFixed(2) ?? '-',
                        bold: true),
                    _pdfTotalCell(
                        "₹ ${_amountFmt.format(data.summary!.totalHsdAmount ?? 0.0)}",
                        bold: true),
                  ],
                ),
              ],
            ),
        ],
        footer: (context) => pw.Column(
          children: [
            pw.SizedBox(height: 4),
            pw.Divider(thickness: 0.5, color: PdfColors.grey400),
            pw.SizedBox(height: 4),
            pw.Text('Generated: $dateStr',
                style:
                    const pw.TextStyle(fontSize: 6, color: PdfColors.grey700)),
            pw.Text('Bohiba - Trip Report',
                style:
                    pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.bold)),
          ],
        ),
      ),
    );

    return doc.save();
  }

  _pdfRowWidget({required String title, required String subtitle}) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(top: 2),
      child: pw.Row(
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 10),
          ),
          pw.SizedBox(width: 5),
          pw.Text(
            subtitle,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfTotalCell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  String _formatDate(String? raw) {
    if (raw == null) return '-';
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    return DateFormat('dd/MM/yy').format(dt);
  }

  // MethodChannel that routes to MainActivity.saveToDownloads().
  // On Android 10+ this uses MediaStore.Downloads (no permission required).
  // On Android ≤ 9 it writes directly to the public Downloads dir
  // (WRITE_EXTERNAL_STORAGE declared with maxSdkVersion=28 in manifest).
  static const _fileSaverChannel =
      MethodChannel('com.app.bohiba/file_saver');

  Future<void> downloadPdf() async {
    final bytes = pdfBytes.value;
    if (bytes == null) return;

    final fileName =
        'BOHIBA_TRIP_REPORT_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';

    try {
      if (Platform.isAndroid) {
        await _fileSaverChannel.invokeMethod<String>('saveToDownloads', {
          'bytes': bytes,
          'fileName': fileName,
          'mimeType': 'application/pdf',
        });
        GlobalService.showSnackBar(
          status: AlertStatus.success,
          title: 'PDF Saved',
          desc: 'Saved to Downloads — $fileName',
        );
      } else {
        // iOS: save to app Documents and open with the system viewer.
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/$fileName');
        await file.writeAsBytes(bytes);
        final result = await OpenFilex.open(file.path, type: 'application/pdf');
        if (result.type != ResultType.done) {
          GlobalService.showSnackBar(
            status: AlertStatus.success,
            title: 'PDF Saved',
            desc: 'Saved as $fileName',
          );
        }
      }
    } catch (e) {
      GlobalService.showSnackBar(
        status: AlertStatus.failure,
        title: 'Save Failed',
        desc: 'Could not save PDF. Please try sharing instead.',
      );
    }
  }

  Future<void> sharePdf() async {
    final bytes = pdfBytes.value;
    if (bytes == null) return;
    final dir = await getDownloadsDirectory();
    final file = File('${dir?.path}/trip_report.pdf');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/pdf')],
      subject: 'Bohiba Trip Report',
    );
  }

  Future<void> printPdf() async {
    final bytes = pdfBytes.value;
    if (bytes == null) return;
    await Printing.layoutPdf(onLayout: (_) async => bytes);
  }

  @override
  void onClose() {
    _transporterDebounce?.cancel();
    _mineDebounce?.cancel();
    _plantDebounce?.cancel();
    transporterController.dispose();
    mineController.dispose();
    plantController.dispose();
    super.onClose();
  }
}
