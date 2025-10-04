// lib/screens/auth/signup_email_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async'; // Timer 사용을 위해 import

// 디자인 시스템 파일 임포트
import 'package:initial_bf/constants/app_colors.dart';
import 'package:initial_bf/constants/app_text_styles.dart';

class SignUpEmailScreen extends StatefulWidget {
  const SignUpEmailScreen({super.key});

  @override
  State<SignUpEmailScreen> createState() => _SignUpEmailScreenState();
}

class _SignUpEmailScreenState extends State<SignUpEmailScreen> {
  // 폼의 상태를 관리하기 위한 GlobalKey
  final _formKey = GlobalKey<FormState>();

  // 입력 필드 컨트롤러
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _authCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // 이메일 인증 관련 상태 변수
  bool _isEmailSent = false; // 인증 코드가 전송되었는지 여부
  bool _isEmailVerified = false; // 이메일이 인증되었는지 여부
  Timer? _timer; // 인증 코드 타이머
  int _remainingSeconds = 180; // 남은 시간 (3분 = 180초)

  // 비밀번호 가시성 토글
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _authCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _timer?.cancel(); // 위젯이 dispose될 때 타이머도 반드시 해제
    super.dispose();
  }

  // 💡 [핵심 로직] 인증 코드 전송 버튼 클릭 시 동작
  void _sendAuthCode() async {
    if (_formKey.currentState!.validate()) {
      // 이메일 유효성 검사
      // TODO: 백엔드 API와 연동하여 인증 코드 전송 로직 구현
      // 이메일: _emailController.text
      print('인증 코드 전송: ${_emailController.text}');

      // 실제 API 호출 대신 딜레이를 주어 비동기 동작 시뮬레이션
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isEmailSent = true; // 인증 코드가 전송되었음을 표시
        _remainingSeconds = 180; // 타이머 초기화 (3분)
      });
      _startTimer(); // 타이머 시작

      // 사용자에게 알림
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('인증 코드가 이메일로 전송되었습니다.')));
    }
  }

  // 💡 [핵심 로직] 인증 코드 확인 버튼 클릭 시 동작
  void _verifyAuthCode() async {
    // TODO: 백엔드 API와 연동하여 인증 코드 확인 로직 구현
    // 이메일: _emailController.text
    // 인증 코드: _authCodeController.text
    print('인증 코드 확인: ${_authCodeController.text}');

    // 실제 API 호출 대신 딜레이를 주어 비동기 동작 시뮬레이션
    // 여기서는 '123456'을 정답으로 가정합니다.
    await Future.delayed(const Duration(seconds: 1));
    bool isCodeCorrect =
        (_authCodeController.text == '123456'); // 실제로는 백엔드에서 확인

    if (isCodeCorrect) {
      _timer?.cancel(); // 타이머 중지
      setState(() {
        _isEmailVerified = true; // 이메일 인증 완료
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('이메일 인증이 완료되었습니다.')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('인증 코드가 올바르지 않습니다.')));
    }
  }

  // 💡 [핵심 로직] 타이머 시작
  void _startTimer() {
    _timer?.cancel(); // 기존 타이머가 있다면 중지
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel(); // 0초가 되면 타이머 중지
        setState(() {
          _isEmailSent = false; // 시간 초과 시 인증 코드를 다시 보내야 함
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('인증 시간이 만료되었습니다. 다시 시도해주세요.')),
        );
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  // 💡 [핵심 로직] 회원가입 완료 버튼 클릭 시 동작
  void _signUpComplete() async {
    if (_formKey.currentState!.validate() && _isEmailVerified) {
      // 모든 필드 유효성 및 이메일 인증 확인
      // TODO: 백엔드 API와 연동하여 회원가입 완료 로직 구현
      // 이메일: _emailController.text
      // 비밀번호: _passwordController.text
      print(
        '회원가입 완료: ${_emailController.text}, 비밀번호: ${_passwordController.text}',
      );

      // 실제 API 호출 대신 딜레이를 주어 비동기 동작 시뮬레이션
      await Future.delayed(const Duration(seconds: 2));

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('회원가입이 성공적으로 완료되었습니다!')));

      // 회원가입 성공 후 메인 화면으로 이동
      if (context.mounted) {
        context.go('/home');
      }
    } else if (!_isEmailVerified) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('이메일 인증을 완료해주세요.')));
    }
  }

  // 남은 시간을 'MM:SS' 형식으로 포맷
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입', style: AppTextStyles.body), // AppBar 타이틀
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // 키보드가 올라올 때 화면이 잘리지 않도록 스크롤 가능하게 함
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey, // 폼 유효성 검사를 위한 키
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('이메일로 회원가입', style: AppTextStyles.headline1),
                const SizedBox(height: 30),

                // 1. 이메일 입력 필드
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: '이메일',
                    hintText: 'user@example.com',
                    border: const OutlineInputBorder(),
                    suffixIcon: _isEmailSent
                        ? Icon(
                            Icons.check_circle,
                            color: _isEmailVerified
                                ? Colors.green
                                : Colors.grey,
                          )
                        : null,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이메일을 입력해주세요.';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return '유효한 이메일 주소를 입력해주세요.';
                    }
                    return null;
                  },
                  readOnly: _isEmailVerified, // 인증 완료 시 이메일 수정 불가
                ),
                const SizedBox(height: 10),
                // [인증 코드 전송] 버튼
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _isEmailVerified
                        ? null
                        : _sendAuthCode, // 인증 완료 시 버튼 비활성화
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_isEmailSent ? '재전송' : '인증 코드 전송'),
                  ),
                ),
                const SizedBox(height: 30),

                // 2. 인증 코드 입력 필드 (인증 코드가 전송된 후에만 보임)
                if (_isEmailSent && !_isEmailVerified) ...[
                  TextFormField(
                    controller: _authCodeController,
                    decoration: InputDecoration(
                      labelText: '인증 코드',
                      hintText: '6자리 인증 코드를 입력하세요',
                      border: const OutlineInputBorder(),
                      counterText: _formatTime(_remainingSeconds), // 타이머 표시
                      counterStyle: AppTextStyles.body.copyWith(
                        color: _remainingSeconds <= 30
                            ? Colors.red
                            : AppColors.text,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '인증 코드를 입력해주세요.';
                      }
                      if (value.length != 6) {
                        return '6자리 숫자를 입력해주세요.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  // [인증 확인] 버튼
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _verifyAuthCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('인증 확인'),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],

                // 3. 비밀번호 설정 필드 (이메일 인증이 완료된 후에만 보임)
                if (_isEmailVerified) ...[
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible, // 비밀번호 숨김/표시
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                      hintText: '영문, 숫자, 특수문자 포함 8자 이상',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 입력해주세요.';
                      }
                      if (value.length < 8) {
                        return '비밀번호는 8자 이상이어야 합니다.';
                      }
                      // 더 복잡한 비밀번호 유효성 검사 추가 가능 (정규식 사용)
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible, // 비밀번호 숨김/표시
                    decoration: InputDecoration(
                      labelText: '비밀번호 확인',
                      hintText: '비밀번호를 다시 입력해주세요.',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호 확인을 입력해주세요.';
                      }
                      if (value != _passwordController.text) {
                        return '비밀번호가 일치하지 않습니다.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  // [회원가입 완료] 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _signUpComplete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('회원가입 완료', style: AppTextStyles.button),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
