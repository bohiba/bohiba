import 'package:bohiba/component/bohiba_appbar/title_appbar.dart';
import 'package:bohiba/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlavorConfigPage extends StatelessWidget {
  const FlavorConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(title: '${AppConfig.appName} — Config'),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        children: [
          _SectionHeader('Flavor'),
          _ConfigTile(
            label: 'Flavor',
            value: AppConfig.isProd ? 'prod' : 'beta',
            badge: AppConfig.isProd ? _Badge.prod : _Badge.beta,
          ),
          _ConfigTile(label: 'App Name', value: AppConfig.appName),
          _ConfigTile(label: 'Package', value: AppConfig.packageName),
          SizedBox(height: 16.h),
          _SectionHeader('API'),
          _ConfigTile(label: 'Base URL', value: AppConfig.baseUrl),
          _ConfigTile(label: 'Image URL', value: AppConfig.imageUrl),
          SizedBox(height: 16.h),
          _SectionHeader('Local Storage'),
          _ConfigTile(label: 'Database', value: AppConfig.dbName),
          SizedBox(height: 16.h),
          _SectionHeader('Firebase'),
          _ConfigTile(label: 'Project ID', value: AppConfig.firebaseProjectId),
          _ConfigTile(label: 'App ID', value: AppConfig.firebaseAppId),
          _ConfigTile(label: 'Sender ID', value: AppConfig.firebaseMessagingSenderId),
          _ConfigTile(label: 'Database URL', value: AppConfig.firebaseDatabaseUrl),
          _ConfigTile(label: 'Storage Bucket', value: AppConfig.firebaseStorageBucket),
          _ConfigTile(label: 'API Key', value: AppConfig.firebaseApiKey, obscure: true),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ── Config tile ───────────────────────────────────────────────────────────────

enum _Badge { prod, beta }

class _ConfigTile extends StatefulWidget {
  const _ConfigTile({
    required this.label,
    required this.value,
    this.badge,
    this.obscure = false,
  });

  final String label;
  final String value;
  final _Badge? badge;
  final bool obscure;

  @override
  State<_ConfigTile> createState() => _ConfigTileState();
}

class _ConfigTileState extends State<_ConfigTile> {
  bool _revealed = false;
  bool _copied = false;

  String get _display {
    if (widget.obscure && !_revealed) {
      return '${widget.value.substring(0, 6)}••••••••••••••••';
    }
    return widget.value;
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.value));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: theme.colorScheme.onSurface.withValues(alpha:0.55),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (widget.badge != null) ...[
                        SizedBox(width: 6.w),
                        _FlavorChip(widget.badge!),
                      ],
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    _display,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            if (widget.obscure)
              IconButton(
                icon: Icon(
                  _revealed ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 18,
                  color: theme.colorScheme.onSurface.withValues(alpha:0.5),
                ),
                onPressed: () => setState(() => _revealed = !_revealed),
              ),
            IconButton(
              icon: Icon(
                _copied ? Icons.check_rounded : Icons.copy_rounded,
                size: 18,
                color: _copied ? Colors.green : theme.colorScheme.onSurface.withValues(alpha:0.5),
              ),
              onPressed: _copy,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Flavor chip ───────────────────────────────────────────────────────────────

class _FlavorChip extends StatelessWidget {
  const _FlavorChip(this.badge);
  final _Badge badge;

  @override
  Widget build(BuildContext context) {
    final isProd = badge == _Badge.prod;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isProd ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: isProd ? Colors.green.shade300 : Colors.red.shade300,
        ),
      ),
      child: Text(
        isProd ? 'PROD' : 'BETA',
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w800,
          color: isProd ? Colors.green.shade700 : Colors.red.shade700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
