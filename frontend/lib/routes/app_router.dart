// lib/routes/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

import 'package:initial_bf/screens/analysis/photo_capture_screen.dart';
import 'package:initial_bf/screens/analysis/photo_confirm_screen.dart';
import 'package:initial_bf/screens/analysis/analysis_loading_screen.dart';
import 'package:initial_bf/screens/result/analysis_report_screen.dart';
import 'package:initial_bf/models/analysis_result.dart'; 

final router = GoRouter(
  initialLocation: '/',
  routes: [
    // 사진 촬영 화면
    GoRoute(
      path: '/photo-capture',
      builder: (context, state) {
        return const PhotoCaptureScreen();
      },
    ),
    
    // 사진 확인 화면
    GoRoute(
      path: '/photo-confirm',
      builder: (context, state) {
        final imageFile = state.extra as File;
        return PhotoConfirmScreen(imageFile: imageFile);
      },
    ),
    
    // 분석 로딩 화면
    GoRoute(
      path: '/analysis-loading',
      builder: (context, state) {
        final imageUrl = state.extra as String;
        return AnalysisLoadingScreen(imageUrl: imageUrl);
      },
    ),
    
    // 분석 결과 화면
    GoRoute(
      path: '/analysis-result',
      builder: (context, state) {
        final extra = state.extra;
        
        // 기존 AnalysisResult 모델을 사용하는 경우
        if (extra is AnalysisResult) {
          return AnalysisReportScreen(result: extra);
        }
        // Map으로 받는 경우 (새로운 Edge Function 결과)
        else if (extra is Map<String, dynamic>) {
          return AnalysisReportScreen(resultMap: extra);
        }
        
        throw Exception('Invalid result type');
      },
    ),
  ],
);