import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf_plus/flutter_html_to_pdf_plus.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? generatedPdfFilePath;
  bool isGenerating = false;

  Future<void> generateExampleDocument() async {
    setState(() {
      isGenerating = true;
    });

    const htmlContent = """
    <!DOCTYPE html>
    <html>
      <head>
        <style>
        table, th, td {
          border: 1px solid black;
          border-collapse: collapse;
        }
        th, td, p {
          padding: 5px;
          text-align: left;
        }
        </style>
      </head>
      <body>
        <h2>PDF Generated with flutter_html_to_pdf plugin</h2>
        
        <table style="width:100%">
          <caption>Sample HTML Table</caption>
          <tr>
            <th>Month</th>
            <th>Savings</th>
          </tr>
          <tr>
            <td>January</td>
            <td>100</td>
          </tr>
          <tr>
            <td>February</td>
            <td>50</td>
          </tr>
        </table>
        
        <p>Image loaded from web</p>
        <img src="https://i.imgur.com/wxaJsXF.png" alt="web-img">
      </body>
    </html>
    """;

    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      final targetPath = appDocDir.path;
      const targetFileName = "example-pdf";

      final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        content: htmlContent,
        configuration: PrintPdfConfiguration(
          targetDirectory: targetPath,
          targetName: targetFileName,
          printSize: PrintSize.A4,
          printOrientation: PrintOrientation.Portrait,
        ),
      );
      setState(() {
        generatedPdfFilePath = generatedPdfFile.path;
        isGenerating = false;
      });
    } catch (e) {
      setState(() {
        isGenerating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter HTML to PDF Example'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isGenerating ? null : generateExampleDocument,
                  child: Text(
                      isGenerating ? "Generating..." : "Generate PDF Document"),
                ),
                const SizedBox(height: 20),
                if (generatedPdfFilePath != null)
                  Text(
                    "Generated PDF at:\n$generatedPdfFilePath",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
