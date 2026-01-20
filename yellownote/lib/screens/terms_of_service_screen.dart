import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regulamin'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Regulamin Aplikacji YellowNote'),
            const SizedBox(height: 8),
            _buildDate('Data ostatniej aktualizacji: 20 stycznia 2026'),
            const SizedBox(height: 24),
            
            _buildSection(
              '1. Postanowienia ogólne',
              'Niniejszy Regulamin określa zasady korzystania z aplikacji mobilnej i webowej YellowNote '
              '(zwanej dalej "Aplikacją").\n\n'
              'Korzystanie z Aplikacji oznacza akceptację postanowień niniejszego Regulaminu.\n\n'
              'Aplikacja YellowNote służy do organizacji zadań, notatek, projektów i prowadzenia dziennika osobistego.',
            ),
            
            _buildSection(
              '2. Definicje',
              '• Aplikacja - oprogramowanie YellowNote dostępne na urządzenia mobilne i przeglądarki internetowe\n'
              '• Użytkownik - osoba fizyczna korzystająca z Aplikacji\n'
              '• Konto - zbiór danych i ustawień Użytkownika w Aplikacji\n'
              '• Treści - wszystkie dane wprowadzone przez Użytkownika (projekty, notatki, listy, wpisy dziennika)\n'
              '• Administrator - właściciel i operator Aplikacji YellowNote',
            ),
            
            _buildSection(
              '3. Warunki korzystania z Aplikacji',
              'Aby korzystać z pełni funkcjonalności Aplikacji, Użytkownik powinien:\n\n'
              '• Posiadać urządzenie z dostępem do Internetu\n'
              '• Posiadać aktywną przeglądarkę internetową lub system Android/iOS\n'
              '• Zaakceptować niniejszy Regulamin\n'
              '• Zaakceptować Politykę Prywatności\n'
              '• Mieć ukończone 13 lat (osoby poniżej 18 roku życia wymagają zgody opiekuna prawnego)',
            ),
            
            _buildSection(
              '4. Rejestracja i konto',
              'Użytkownik może korzystać z Aplikacji:\n\n'
              '• Bez rejestracji - dane przechowywane tylko lokalnie na urządzeniu\n'
              '• Z rejestracją przez Google - umożliwia synchronizację między urządzeniami\n\n'
              'Użytkownik zobowiązuje się:\n\n'
              '• Podawać prawdziwe dane przy rejestracji\n'
              '• Zachować poufność danych dostępu do konta\n'
              '• Natychmiast poinformować Administratora o nieautoryzowanym dostępie do konta\n'
              '• Nie udostępniać konta innym osobom',
            ),
            
            _buildSection(
              '5. Zasady użytkowania',
              'Użytkownik zobowiązuje się:\n\n'
              '• Korzystać z Aplikacji zgodnie z jej przeznaczeniem\n'
              '• Nie wykorzystywać Aplikacji w sposób sprzeczny z prawem\n'
              '• Nie naruszać praw innych użytkowników\n'
              '• Nie wprowadzać treści bezprawnych, obraźliwych lub szkodliwych\n'
              '• Nie podejmować działań mogących zakłócić działanie Aplikacji\n'
              '• Nie kopiować, modyfikować ani dekompilować Aplikacji',
            ),
            
            _buildSection(
              '6. Prawa autorskie',
              'Aplikacja YellowNote, jej kod źródłowy, interfejs użytkownika i wszystkie elementy graficzne '
              'są chronione prawem autorskim.\n\n'
              'Użytkownik nabywa jedynie prawo do korzystania z Aplikacji zgodnie z jej przeznaczeniem.\n\n'
              'Treści tworzone przez Użytkownika pozostają jego własnością. Administrator nie rości sobie '
              'praw do treści użytkowników.',
            ),
            
            _buildSection(
              '7. Dostępność usług',
              'Administrator dokłada wszelkich starań, aby Aplikacja działała bez przerw, jednak nie gwarantuje:\n\n'
              '• Ciągłej dostępności Aplikacji\n'
              '• Braku błędów w działaniu\n'
              '• Zgodności z konkretnymi oczekiwaniami Użytkownika\n\n'
              'Administrator zastrzega sobie prawo do:\n\n'
              '• Przerw technicznych w celu konserwacji lub aktualizacji\n'
              '• Modyfikacji funkcjonalności Aplikacji\n'
              '• Czasowego zawieszenia dostępu w uzasadnionych przypadkach',
            ),
            
            _buildSection(
              '8. Odpowiedzialność',
              'Administrator nie ponosi odpowiedzialności za:\n\n'
              '• Utratę danych spowodowaną działaniem Użytkownika\n'
              '• Szkody wynikłe z niewłaściwego użytkowania Aplikacji\n'
              '• Niemożność korzystania z Aplikacji z przyczyn niezależnych od Administratora\n'
              '• Treści wprowadzone przez Użytkownika\n\n'
              'Użytkownik jest odpowiedzialny za:\n\n'
              '• Regularne tworzenie kopii zapasowych swoich danych\n'
              '• Zabezpieczenie dostępu do swojego konta\n'
              '• Treści przez siebie publikowane',
            ),
            
            _buildSection(
              '9. Płatności i subskrypcje',
              'Obecnie Aplikacja YellowNote jest dostępna bezpłatnie.\n\n'
              'W przyszłości mogą zostać wprowadzone płatne funkcjonalności Premium. '
              'W takim przypadku Użytkownicy zostaną poinformowani z wyprzedzeniem o:\n\n'
              '• Cenach i okresach rozliczeniowych\n'
              '• Zakresie funkcji Premium\n'
              '• Warunkach anulowania subskrypcji',
            ),
            
            _buildSection(
              '10. Usunięcie konta',
              'Użytkownik ma prawo do usunięcia swojego konta w dowolnym momencie przez:\n\n'
              '• Ustawienia aplikacji\n'
              '• Kontakt z Administratorem\n\n'
              'Usunięcie konta skutkuje:\n\n'
              '• Trwałym usunięciem wszystkich danych użytkownika z serwerów (w ciągu 30 dni)\n'
              '• Utratą dostępu do zsynchronizowanych treści\n'
              '• Niemożnością odzyskania danych',
            ),
            
            _buildSection(
              '11. Reklamacje',
              'Reklamacje dotyczące działania Aplikacji można zgłaszać:\n\n'
              'Email: support@yellownote.app\n'
              '(Uwaga: To przykładowy adres - należy go zmienić na właściwy)\n\n'
              'Reklamacja powinna zawierać:\n\n'
              '• Opis problemu\n'
              '• Data wystąpienia problemu\n'
              '• Kontakt zwrotny\n\n'
              'Administrator rozpatruje reklamacje w ciągu 14 dni roboczych.',
            ),
            
            _buildSection(
              '12. Zmiany regulaminu',
              'Administrator zastrzega sobie prawo do wprowadzania zmian w Regulaminie.\n\n'
              'O zmianach Użytkownicy zostaną poinformowani poprzez:\n\n'
              '• Powiadomienie w Aplikacji\n'
              '• Email (jeśli podany)\n\n'
              'Zmiany wchodzą w życie po 7 dniach od opublikowania.\n\n'
              'Dalsze korzystanie z Aplikacji po wejściu zmian w życie oznacza ich akceptację.',
            ),
            
            _buildSection(
              '13. Postanowienia końcowe',
              'W sprawach nieuregulowanych niniejszym Regulaminem zastosowanie mają przepisy:\n\n'
              '• Ustawy o świadczeniu usług drogą elektroniczną\n'
              '• Kodeksu cywilnego\n'
              '• RODO\n\n'
              'Wszelkie spory będą rozstrzygane przez właściwe sądy polskie.\n\n'
              'Regulamin wchodzi w życie z dniem 20 stycznia 2026.',
            ),
            
            _buildSection(
              '14. Kontakt',
              'W sprawach dotyczących Regulaminu prosimy o kontakt:\n\n'
              'Email: legal@yellownote.app\n'
              '(Uwaga: To przykładowy adres - należy go zmienić na właściwy)',
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
