import 'package:flutter/material.dart';
import '../localizations/app_localizations.dart';
import '../widgets/background_image.dart';

class AboutScreen extends StatelessWidget {
  static const String routeName = '/about';

  Widget _arabicContent() {
    return Text(
      'تريت-من هو مشروع تخرج مجموعة من الطلاب المقيدين'
      ' بكلية الهندسة جامعة عين شمس، دفعة 2021.\n\n'
      'تريت-من هو خدمة تهدف إلى تسهيل عملية إيجاد العيادات بمختلف التخصصات '
      'والخدمات الطبية الأخري بجميع أنحاء مصر. وايضا يعطي معلومات عن أقرب'
      ' المستشفيات في حالة الطوارئ.\n\n'
      'الفكرة خلف الاسم (تريت-من) هي أن المستخدم يمكنه إيجاد العلاج المناسب'
      ' له في دقيقة واحدة فقط :)\n\n'
      'مطورين تطبيق المحمول والواجهة الخلفية:\n'
      'خالد محمد رفعت\n'
      'أحمد خالد سيد\n\n'
      'مطورين موقع الويب:\n'
      'منة علاء نعيم\n'
      'محمد رمضان سيد\n'
      'جرجس وجيه ثابت\n\n'
      'تحت إشراف:\n'
      'أ. د. أحمد حسن محمد يوسف\n'
      'م. سارة عبد العزيز محمود عبده\n\n'
      'رقم الإصدار: 1.0.5\n',
      textAlign: TextAlign.justify,
    );
  }

  Widget _englishContent() {
    return Text(
      'Treat-min is the graduation project of a group of students of '
      'Faculty of Engineering, Ain Shams University, Class of 2021.\n\n'
      'Treat-min is a service that aims to facilitate the process of '
      'finding clinics of different specialities and other medical services '
      'all over Egypt. It also provides information about nearest hospitals '
      'in case of emergency.\n\n'
      'The idea behind the name (Treat-min) is that users can find their '
      'appropriate treatment in just one minute :)\n\n'
      'Mobile application and backend developers:\n'
      'Khalid Muhammad Refaat\n'
      'Ahmed Khalid Sayed\n\n'
      'Website developers:\n'
      'Menna Alaa Naeim\n'
      'Muhammad Ramadan Sayed\n'
      'Gerges Wageh Thabet\n\n'
      'Under the supervision of:\n'
      'Prof. Dr. Ahmed Hassan Muhammad Yousef\n'
      'Eng. Sarah Abdulaziz Mahmoud Abdu\n\n'
      'Version Number: 1.0.5\n',
      textAlign: TextAlign.justify,
    );
  }

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    setAppLocalization(context);

    return Scaffold(
      appBar: AppBar(title: Text(t('about_us'))),
      body: BackgroundImage(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowGlow();
            return;
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: Image.asset('assets/images/logo.png'),
              ),
              langCode == 'ar' ? _arabicContent() : _englishContent(),
            ],
          ),
        ),
      ),
    );
  }
}
