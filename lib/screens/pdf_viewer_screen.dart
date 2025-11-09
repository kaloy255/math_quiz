import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../utils/responsive_helper.dart';
import '../utils/theme_helper.dart';

class PdfViewerScreen extends StatelessWidget {
  final String pdfPath;
  final String lessonTitle;

  const PdfViewerScreen({
    super.key,
    required this.pdfPath,
    required this.lessonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getContainerColor(context),
      body: Container(
        decoration: BoxDecoration(
          color: ThemeHelper.getContainerColor(context),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Header
              Container(
                width: double.infinity,
                padding: ResponsiveHelper.padding(
                  context,
                  horizontal: ResponsiveHelper.contentPadding(context),
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6BBF59), Color(0xFF5AA849)],
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: ResponsiveHelper.iconSize(context, 24),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        lessonTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.fontSize(context, 18),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // PDF Viewer
              Expanded(
                child: Container(
                  margin: ResponsiveHelper.margin(
                    context,
                    all: ResponsiveHelper.spacing(context, 8),
                  ),
                  decoration: BoxDecoration(
                    color: ThemeHelper.isDarkMode(context)
                        ? const Color(0xFF161B22)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(context, 8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: ThemeHelper.isDarkMode(context) ? 0.3 : 0.1,
                        ),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(context, 8),
                    ),
                    child: SfPdfViewer.asset(
                      pdfPath,
                      canShowScrollHead: true,
                      canShowScrollStatus: true,
                      canShowPasswordDialog: false,
                      onDocumentLoadFailed: (details) {
                        // Handle error if PDF fails to load
                      },
                    ),
                  ),
                ),
              ),

              // Bottom Navigation
              Container(
                width: double.infinity,
                padding: ResponsiveHelper.padding(
                  context,
                  all: ResponsiveHelper.contentPadding(context),
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6BBF59), Color(0xFF5AA849)],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF6BBF59),
                    minimumSize: Size(
                      double.infinity,
                      ResponsiveHelper.height(context, 50),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(context, 10),
                      ),
                    ),
                  ),
                  child: Text(
                    'Back to Lessons',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
