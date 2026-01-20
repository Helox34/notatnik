# Raport: Zaawansowane Systemy Agentowe we Flutterze (2025)

## 1. Wstęp i Metodologia
[cite_start]Współczesna inżynieria oprogramowania ewoluuje w kierunku "Programowania Agentowego" (Agentic Workflow), gdzie rola dewelopera zmienia się z twórcy kodu na orkiestratora systemów autonomicznych[cite: 5, 6]. [cite_start]Kluczem do sukcesu jest precyzyjne zarządzanie kontekstem poprzez pliki takie jak `AGENTS.md` oraz `.cursorrules`[cite: 7].

### Model "Architect-Implementer Split"
[cite_start]Aby uniknąć degradacji jakości kodu i halucynacji modeli AI, stosuje się podział na dwie role[cite: 13, 19]:
1.  **Architekt (Planner):** Faza dywergencji. Analiza wymagań i tworzenie planu. [cite_start]Nie pisze kodu, skupia się na logice[cite: 21, 22].
2.  **Implementator (Coder):** Faza konwergencji. Ścisła realizacja planu. [cite_start]Skupia się na składni i poprawności technicznej[cite: 23].

## 2. Standardy Kontekstowe
* **AGENTS.md:** "README dla robotów". [cite_start]Dokument agnostyczny (dla każdego AI), definiujący słownik pojęć, architekturę wysokopoziomową i "umowy o pracę"[cite: 35, 37].
* **.cursorrules:** Sztywne reguły dla IDE (np. Cursor, Windsurf). Zawierają nakazy i zakazy (Negative Constraints), np. [cite_start]"NIGDY nie używaj setState"[cite: 42, 43].

## 3. Wytyczne Techniczne dla Fluttera (2025)
Na podstawie analizy domenowej, system AI musi przestrzegać następujących zasad:

* **Architektura:** Feature-First Clean Architecture. [cite_start]Struktura katalogów: `lib/features/<name>/{data, domain, presentation}`[cite: 62, 66].
* [cite_start]**Dependency Rule:** Warstwa domeny (Domain) nie może zależeć od warstw zewnętrznych (Data/Presentation)[cite: 72].
* [cite_start]**Stan:** Riverpod 2.0+ z generatorem kodu (`@riverpod`) i adnotacjami[cite: 79, 81]. Unikanie starej składni `FutureProvider` czy `ChangeNotifier`.
* [cite_start]**Immutability:** Wymuszone użycie `freezed` do generowania klas stanu i modeli[cite: 86, 94].
* [cite_start]**Anty-wzorce:** Zakaz logiki biznesowej w `build()`, wymóg `dispose()` dla kontrolerów (lub użycie `flutter_hooks`)[cite: 89, 91].

---

## 4. Konfiguracja i Prompty (Gotowe do użycia)

Poniższe sekcje zawierają gotowe konfiguracje do wklejenia do odpowiednich plików w projekcie.

### A. Plik `.cursorrules` (Global Context)
*Umieść ten kod w pliku `.cursorrules` w głównym katalogu projektu.*

```text
FLUTTER PROJECT RULES & CONTEXT

You are an expert Flutter Engineer specializing in Feature-First Clean Architecture and Riverpod 2.0. Your goal is to produce production-grade, maintainable code that adheres to strict architectural boundaries.

1. ARCHITECTURAL STANDARDS
• Structure: Follow the lib/features/<feature_name>/{data, domain, presentation} pattern.
• Dependency Rule:
    - Domain depends on NOTHING.
    - Presentation depends on Domain.
    - Data depends on Domain.
    - NEVER import Data layers into Presentation.
• Logic Isolation: No business logic in UI build() methods. All logic resides in Notifiers/Controllers.

2. TECH STACK & PATTERNS
• State Management: Riverpod with Code Generation (@riverpod).
    - Use AsyncNotifier<T> for async data.
    - Use Notifier<T> for synchronous state.
    - AVOID: StateProvider, ChangeNotifier, FutureProvider (legacy syntax).
• Data Models: Immutable classes using freezed and json_serializable.
• Navigation: GoRouter with typed routes (Gen package) or encapsulation in a Router Controller.
• Dependency Injection: Use Riverpod Provider overrides or functional injection. Avoid GetIt if Riverpod is sufficient.

3. CODING GUIDELINES
• Immutability: Always prefer final variables and const constructors.
• Typing: Strict typing. NEVER use dynamic unless interacting with untyped JSON (immediately cast to DTO).
• Async: Use async/await over raw .then(). Handle errors with AsyncValue.guard.
• Safety: Always dispose controllers (use flutter_hooks if available, or explicit dispose).

4. CRITICAL "NEGATIVE CONSTRAINTS"
• NEVER leave print() statements. Use a proper Logger.
• NEVER use setState for complex state.
• NEVER skip error handling in Repositories. Return Either<Failure, T> (using fpdart or dartz).

5. TESTING STRATEGY
• Generate test IDs (Key('..._test_key')) for critical widgets.
• Write unit tests for all Notifiers and Repositories using mocktail.