import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../../../../Models/book model/book_model.dart';
import '../../../../../Models/book progress model/book_progress_model.dart';
import '../../../../../core/themes/theme_colors.dart';
import '../../../../components/utils/size_config.dart';

class BookReaderWidget extends StatefulWidget {
  final BookModel book;
  final BookProgress? progress;
  final LevelType levelType;
  final Function(int) onPageChanged;
  final VoidCallback onComplete;

  const BookReaderWidget({
    super.key,
    required this.book,
    required this.progress,
    required this.levelType,
    required this.onPageChanged,
    required this.onComplete,
  });

  @override
  State<BookReaderWidget> createState() => _BookReaderWidgetState();
}

class _BookReaderWidgetState extends State<BookReaderWidget> {
  late PdfViewerController _pdfController;
  int _currentPage = 1;
  int _totalPages = 0;
  bool _isLoading = true;
  bool _isPdfViewerReady = false;
  String? _errorMessage;
  Uint8List? _pdfBytes;
  bool _useMemoryLoad = false;
  bool _hasJumpedToInitialPage = false;

  @override
  void initState() {
    super.initState();
    _initializeReader();
  }

  void _initializeReader() {
    _currentPage = (widget.progress?.pagesRead ?? 1);
    if (_currentPage <= 0) _currentPage = 1;

    _pdfController = PdfViewerController();
    _loadPdf();
  }

  void _loadPdf() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _isPdfViewerReady = false;
      _hasJumpedToInitialPage = false;
    });

    if (_useMemoryLoad) {
      _loadPdfFromMemory();
    } else {
      _startLoadingTimeout();
    }
  }

  Future<void> _loadPdfFromMemory() async {
    try {
      final response = await http
          .get(
            Uri.parse(_getCleanPdfUrl()),
            headers: {
              'Accept': 'application/pdf,*/*',
              'User-Agent': 'Flutter PDF Viewer',
              'Cache-Control': 'no-cache',
            },
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        setState(() {
          _pdfBytes = response.bodyBytes;
          _isLoading = false;
        });
      } else {
        throw Exception(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Download failed: $e';
      });
    }
  }

  void _startLoadingTimeout() {
    Future.delayed(const Duration(seconds: 20), () {
      if (mounted && _isLoading && !_isPdfViewerReady) {
        setState(() {
          _useMemoryLoad = true;
          _isLoading = true;
          _errorMessage = null;
        });
        _loadPdfFromMemory();
      }
    });
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  String _getCleanPdfUrl() {
    String url = widget.book.pdfUrl.trim();

    if (url.contains(' ')) {
      url = url.replaceAll(' ', '%20');
    }

    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    return url;
  }

  void _onPageChanged(int page) {
    if (page != _currentPage && page > 0) {
      setState(() {
        _currentPage = page;
      });

      widget.onPageChanged(_currentPage);

      if (_totalPages > 0 && _currentPage >= _totalPages) {
        widget.onComplete();
      }
    }
  }

  void _onDocumentLoaded(PdfDocumentLoadedDetails details) {
    if (!mounted) return;

    setState(() {
      _totalPages = details.document.pages.count;
      _isLoading = false;
      _errorMessage = null;
      _isPdfViewerReady = true;
    });

    if (_currentPage > 1 && !_hasJumpedToInitialPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _jumpToInitialPage();
      });
    }
  }

  void _jumpToInitialPage() {
    if (!mounted || !_isPdfViewerReady || _hasJumpedToInitialPage) return;

    if (_currentPage > 1 && _currentPage <= _totalPages) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && _isPdfViewerReady) {
          try {
            _pdfController.jumpToPage(_currentPage);
            _hasJumpedToInitialPage = true;
          } catch (e) {
            // Silently handle jump error
          }
        }
      });
    } else {
      _hasJumpedToInitialPage = true;
    }
  }

  void _onDocumentLoadFailed(PdfDocumentLoadFailedDetails details) {
    if (!mounted) return;

    if (!_useMemoryLoad) {
      setState(() {
        _useMemoryLoad = true;
        _isLoading = true;
        _errorMessage = null;
      });
      _loadPdfFromMemory();
      return;
    }

    setState(() {
      _isLoading = false;
      _errorMessage = 'Failed to load PDF: ${details.error}';
    });
  }

  void _navigateToPreviousPage() {
    if (_currentPage > 1) {
      _pdfController.previousPage();
    }
  }

  void _navigateToNextPage() {
    if (_currentPage < _totalPages) {
      _pdfController.nextPage();
    }
  }

  void _retryLoading() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _pdfBytes = null;
      _useMemoryLoad = false;
      _isPdfViewerReady = false;
      _hasJumpedToInitialPage = false;
    });
    _loadPdf();
  }

  void _tryAlternativeMethod() {
    setState(() {
      _useMemoryLoad = !_useMemoryLoad;
      _isLoading = true;
      _errorMessage = null;
      _pdfBytes = null;
      _isPdfViewerReady = false;
      _hasJumpedToInitialPage = false;
    });
    _loadPdf();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    return Column(
      children: [
        Expanded(child: _buildPdfViewer()),
        _buildProgressBar(),
        // _buildNavigationFooter(),
      ],
    );
  }

  Widget _buildPdfViewer() {
    if (_useMemoryLoad && _pdfBytes != null) {
      return SfPdfViewer.memory(
        _pdfBytes!,
        controller: _pdfController,
        onPageChanged: (PdfPageChangedDetails details) {
          _onPageChanged(details.newPageNumber);
        },
        onDocumentLoaded: _onDocumentLoaded,
        onDocumentLoadFailed: _onDocumentLoadFailed,
        pageLayoutMode: PdfPageLayoutMode.single,
        scrollDirection: PdfScrollDirection.horizontal,
        pageSpacing: 0,
        canShowScrollHead: false,
        canShowScrollStatus: false,
        enableDoubleTapZooming: true,
        enableTextSelection: false,
      );
    } else {
      return SfPdfViewer.network(
        _getCleanPdfUrl(),
        controller: _pdfController,
        onPageChanged: (PdfPageChangedDetails details) {
          _onPageChanged(details.newPageNumber);
        },
        onDocumentLoaded: _onDocumentLoaded,
        onDocumentLoadFailed: _onDocumentLoadFailed,
        pageLayoutMode: PdfPageLayoutMode.single,
        scrollDirection: PdfScrollDirection.horizontal,
        pageSpacing: 0,
        canShowScrollHead: false,
        canShowScrollStatus: false,
        enableDoubleTapZooming: true,
        enableTextSelection: false,
        headers: {
          'Accept': 'application/pdf,*/*',
          'User-Agent': 'Flutter PDF Viewer',
          'Cache-Control': 'no-cache',
          'Connection': 'keep-alive',
        },
      );
    }
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: widget.levelType.color),
          SizedBox(height: SizeConfig.scaleHeight(16)),
          Text(
            _useMemoryLoad ? 'Downloading PDF...' : 'Loading PDF...',
            style: TextStyle(
              fontSize: SizeConfig.scaleText(16),
              color: AppColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.scaleWidth(24)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: SizeConfig.scaleWidth(60),
              color: AppColors.grey500,
            ),
            SizedBox(height: SizeConfig.scaleHeight(16)),
            Text(
              'Failed to load PDF',
              style: TextStyle(
                fontSize: SizeConfig.scaleText(18),
                fontWeight: FontWeight.w600,
                color: AppColors.grey700,
              ),
            ),
            SizedBox(height: SizeConfig.scaleHeight(8)),
            Text(
              _errorMessage ?? 'Unknown error occurred',
              style: TextStyle(
                fontSize: SizeConfig.scaleText(14),
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.scaleHeight(24)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _retryLoading,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.levelType.color,
                  ),
                  child: const Text('Retry'),
                ),
                SizedBox(width: SizeConfig.scaleWidth(12)),
                ElevatedButton(
                  onPressed: _tryAlternativeMethod,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text('Try ${_useMemoryLoad ? "Network" : "Memory"}'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final progressPercentage = _totalPages > 0
        ? ((_currentPage / _totalPages) * 100).toInt()
        : 0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.scaleWidth(16),
        vertical: SizeConfig.scaleHeight(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Page $_currentPage of $_totalPages',
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(14),
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey700,
                ),
              ),
              Text(
                '$progressPercentage%',
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(14),
                  fontWeight: FontWeight.w600,
                  color: widget.levelType.color,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.scaleHeight(8)),
          LinearProgressIndicator(
            value: _totalPages > 0 ? _currentPage / _totalPages : 0,
            backgroundColor: AppColors.grey200,
            valueColor: AlwaysStoppedAnimation<Color>(widget.levelType.color),
            minHeight: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationFooter() {
    return Container(
      padding: EdgeInsets.all(SizeConfig.scaleWidth(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _currentPage > 1 ? _navigateToPreviousPage : null,
            icon: Icon(
              Icons.arrow_back_ios,
              color: _currentPage > 1
                  ? widget.levelType.color
                  : AppColors.grey400,
            ),
            tooltip: 'Previous Page',
          ),
          GestureDetector(
            onTap: _showPageNavigationDialog,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.scaleWidth(12),
                vertical: SizeConfig.scaleHeight(6),
              ),
              decoration: BoxDecoration(
                color: widget.levelType.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
              ),
              child: Text(
                '$_currentPage / $_totalPages',
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(16),
                  fontWeight: FontWeight.w500,
                  color: widget.levelType.color,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: _currentPage < _totalPages ? _navigateToNextPage : null,
            icon: Icon(
              Icons.arrow_forward_ios,
              color: _currentPage < _totalPages
                  ? widget.levelType.color
                  : AppColors.grey400,
            ),
            tooltip: 'Next Page',
          ),
        ],
      ),
    );
  }

  void _showPageNavigationDialog() {
    if (_totalPages <= 0) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController pageController = TextEditingController();
        return AlertDialog(
          title: Text(
            'Go to Page',
            style: TextStyle(
              color: widget.levelType.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter page number (1-$_totalPages):',
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(14),
                  color: AppColors.grey600,
                ),
              ),
              SizedBox(height: SizeConfig.scaleHeight(12)),
              TextField(
                controller: pageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: widget.levelType.color),
                  ),
                  hintText: 'Page number',
                ),
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: AppColors.grey600)),
            ),
            ElevatedButton(
              onPressed: () {
                final pageNumber = int.tryParse(pageController.text);
                if (pageNumber != null &&
                    pageNumber >= 1 &&
                    pageNumber <= _totalPages) {
                  _pdfController.jumpToPage(pageNumber);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please enter a valid page number between 1 and $_totalPages',
                      ),
                      backgroundColor: AppColors.redDark,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.levelType.color,
              ),
              child: const Text('Go'),
            ),
          ],
        );
      },
    );
  }
}
