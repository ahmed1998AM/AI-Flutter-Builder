import 'package:flutter/material.dart';

void main() => runApp(const AppBuilder());

class AppBuilder extends StatelessWidget {
  const AppBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Flutter Builder',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        fontFamily: 'Cairo',
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.2),
              theme.colorScheme.surface,
              theme.colorScheme.tertiary.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: isWide
                  ? _buildWideLayout(context)
                  : _buildNarrowLayout(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLogo(theme),
        const SizedBox(height: 24),
        _buildTitle(theme),
        const SizedBox(height: 12),
        _buildDescription(theme),
        const SizedBox(height: 32),
        _buildAIChip(theme),
        const SizedBox(height: 24),
        _buildFeatureCards(theme),
        const SizedBox(height: 32),
        _buildHowItWorks(theme),
        const SizedBox(height: 32),
        _buildActionButtons(context, theme),
      ],
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1000),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLogo(theme),
                  const SizedBox(height: 16),
                  _buildTitle(theme),
                  const SizedBox(height: 12),
                  _buildDescription(theme),
                  const SizedBox(height: 16),
                  _buildAIChip(theme),
                ],
              )),
              const SizedBox(width: 48),
              Expanded(child: _buildFeatureCards(theme)),
            ],
          ),
          const SizedBox(height: 48),
          _buildHowItWorks(theme),
          const SizedBox(height: 32),
          _buildActionButtons(context, theme),
        ],
      ),
    );
  }

  Widget _buildLogo(ThemeData theme) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Center(
        child: Text('AI', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white)),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      'AI Flutter Builder',
      style: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
      ),
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Text(
      'منصة متكاملة لبناء تطبيقات Android و iOS بالذكاء الاصطناعي\nعبر GitHub Actions — مجاناً تماماً',
      textAlign: TextAlign.center,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        height: 1.5,
      ),
    );
  }

  Widget _buildAIChip(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text('مدعوم بـ Gemini AI', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildFeatureCards(ThemeData theme) {
    const features = [
      ('🧠', 'ذكاء اصطناعي مجاني', 'Gemini 2.0 Flash — قوي وسريع ومجاني بالكامل'),
      ('📱', 'Android + iOS', 'بناء APK/AAB/IPA جاهز للنشر والتوزيع'),
      ('🌐', 'معاينة حية', 'رابط مباشر مع QR code على GitHub Pages'),
      ('⚡', 'تلقائي بالكامل', 'Issue واحد يولد تطبيق كامل في دقيقتين'),
    ];
    return Column(
      children: features.map((f) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _FeatureCard(icon: f.$1, title: f.$2, desc: f.$3),
      )).toList(),
    );
  }

  Widget _buildHowItWorks(ThemeData theme) {
    return Column(
      children: [
        Text('كيف تعمل؟', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            _StepCard(step: '1', title: 'اكتب الفكرة', desc: 'افتح Issue جديد واذكر تفاصيل تطبيقك'),
            _StepCard(step: '2', title: 'AI يبني التطبيق', desc: 'Gemini AI يولد كود Flutter كامل'),
            _StepCard(step: '3', title: 'معاينة حية', desc: 'جرب التطبيق فوراً عبر GitHub Pages'),
            _StepCard(step: '4', title: 'نزل APK/IPA', desc: 'احصل على ملفات التثبيت النهائية'),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        FilledButton.icon(
          onPressed: () => _openUrl(context, 'https://github.com/new'),
          icon: const Icon(Icons.add),
          label: const Text('ابدأ مشروع جديد'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () => _openUrl(context, 'https://github.com'),
          icon: const Icon(Icons.info_outline),
          label: const Text('تعلم المزيد عن المنصة'),
        ),
      ],
    );
  }

  void _openUrl(BuildContext context, String url) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('سيتم فتح: $url')),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String icon, title, desc;
  const _FeatureCard({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 16),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(desc, style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 13,
              )),
            ],
          )),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String step, title, desc;
  const _StepCard({required this.step, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withValues(alpha: 0.15),
            ),
            child: Center(child: Text(step, style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ))),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(desc, textAlign: TextAlign.center, style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          )),
        ],
      ),
    );
  }
}
