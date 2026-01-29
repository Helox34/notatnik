import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polityka Prywatności'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Polityka Prywatności YellowNote'),
            const SizedBox(height: 8),
            _buildDate('Data ostatniej aktualizacji: 20 stycznia 2026'),
            const SizedBox(height: 24),
            
            _buildSection(
              '1. Informacje ogólne',
              'Niniejsza Polityka Prywatności określa zasady przetwarzania i ochrony danych osobowych '
              'przekazanych przez Użytkowników w związku z korzystaniem z aplikacji YellowNote.\n\n'
              'Administratorem danych osobowych jest właściciel aplikacji YellowNote.',
            ),
            
            _buildSection(
              '2. Zakres zbieranych danych',
              'W ramach korzystania z aplikacji YellowNote możemy zbierać następujące dane:\n\n'
              '• Dane konta Google (email, imię, zdjęcie profilowe) - w przypadku logowania przez Google\n'
              '• Dane utworzone przez Użytkownika (projekty, notatki, listy, wpisy dziennika)\n'
              '• Dane techniczne (typ urządzenia, system operacyjny) - w celach technicznych\n'
              '• Dane o korzystaniu z aplikacji - w celu poprawy funkcjonalności',
            ),
            
            _buildSection(
              '3. Cel przetwarzania danych',
              'Dane osobowe są przetwarzane w następujących celach:\n\n'
              '• Świadczenie usług aplikacji YellowNote\n'
              '• Synchronizacja danych między urządzeniami\n'
              '• Uwierzytelnianie użytkownika\n'
              '• Poprawa jakości i funkcjonalności aplikacji\n'
              '• Komunikacja z użytkownikiem\n'
              '• Wypełnienie obowiązków prawnych',
            ),
            
            _buildSection(
              '4. Podstawa prawna przetwarzania',
              'Dane osobowe przetwarzane są na podstawie:\n\n'
              '• Zgody użytkownika (art. 6 ust. 1 lit. a RODO)\n'
              '• Wykonania umowy o świadczenie usług (art. 6 ust. 1 lit. b RODO)\n'
              '• Prawnie uzasadnionego interesu administratora (art. 6 ust. 1 lit. f RODO)',
            ),
            
            _buildSection(
              '5. Przechowywanie danych',
              'Dane osobowe przechowywane są:\n\n'
              '• Lokalnie na urządzeniu użytkownika\n'
              '• W infrastrukturze Firebase (Google Cloud) - w przypadku włączonej synchronizacji\n'
              '• Przez okres korzystania z aplikacji i 30 dni po usunięciu konta\n\n'
              'Użytkownik ma możliwość usunięcia wszystkich swoich danych w dowolnym momencie.',
            ),
            
            _buildSection(
              '6. Udostępnianie danych',
              'Dane osobowe nie są sprzedawane ani udostępniane podmiotom trzecim, za wyjątkiem:\n\n'
              '• Google LLC (Firebase) - w celu synchronizacji danych\n'
              '• Sytuacji wymaganych prawem\n\n'
              'Wszystkie podmioty przetwarzające dane zobowiązane są do zachowania poufności.',
            ),
            
            _buildSection(
              '7. Prawa użytkownika',
              'Zgodnie z RODO użytkownik ma prawo do:\n\n'
              '• Dostępu do swoich danych osobowych\n'
              '• Sprostowania (poprawiania) danych\n'
              '• Usunięcia danych ("prawo do bycia zapomnianym")\n'
              '• Ograniczenia przetwarzania\n'
              '• Przenoszenia danych\n'
              '• Wniesienia sprzeciwu wobec przetwarzania\n'
              '• Cofnięcia zgody w dowolnym momencie\n'
              '• Wniesienia skargi do organu nadzorczego (UODO)',
            ),
            
            _buildSection(
              '8. Bezpieczeństwo danych',
              'Stosujemy odpowiednie środki techniczne i organizacyjne w celu ochrony danych:\n\n'
              '• Szyfrowanie transmisji danych (SSL/TLS)\n'
              '• Bezpieczne przechowywanie w Firebase\n'
              '• Regularne aktualizacje zabezpieczeń\n'
              '• Ograniczony dostęp do danych osobowych',
            ),
            
            _buildSection(
              '9. Pliki cookies',
              'Aplikacja może wykorzystywać technologie śledzące (cookies) w celach:\n\n'
              '• Uwierzytelniania użytkownika\n'
              '• Zapamiętywania preferencji\n'
              '• Analizy korzystania z aplikacji\n\n'
              'Użytkownik może zarządzać cookies w ustawieniach przeglądarki.',
            ),
            
            _buildSection(
              '10. Zmiany polityki',
              'Administrator zastrzega sobie prawo do wprowadzania zmian w niniejszej Polityce Prywatności. '
              'O wszelkich zmianach użytkownicy będą informowani w aplikacji.\n\n'
              'Dalsze korzystanie z aplikacji po wprowadzeniu zmian oznacza akceptację nowej Polityki Prywatności.',
            ),
            
            _buildSection(
              '11. Kontakt',
              'W sprawach dotyczących przetwarzania danych osobowych prosimy o kontakt:\n\n'
              'Email: yellownotesupport@gmail.com\n'
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.darkNavy,
      ),
    );
  }

  Widget _buildDate(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: AppColors.darkGray,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkNavy,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
