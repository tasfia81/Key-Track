# Key Handover Tracker

A simple and professional office key tracking Flutter application designed to track and manage key handovers with support for local data persistence, search, history, and automatic overdue calculations.

---

## How I Implemented It

- **Flutter** was used to build this cross-platform application.
- **MVVM (Model-View-ViewModel)** architecture was implemented to cleanly separate the User Interface (Views) from the business logic and state management (ViewModels).
- **Local Persistence** via `shared_preferences` stores keys, current statuses, and handover history logs, ensuring that all data survives app close and reopen states.
- **Key Status** transitions reactively from **Available** to **Taken** on handover confirmation, and back to **Available** upon key return.
- **Overdue** status is automatically calculated by checking if the expected return time has passed on any active handover without the key being returned.
- **Search** filters the displayed key list in real time by checking the key name, identifier/room ID, and the current borrower/person's name.

---

## Features & Workflows

### 1. Core Workflow (Available → Taken → Returned)
- **Available**: The key is in the drawer and ready to be checked out. Tap on any Available key card to navigate to the details and open the "Take Key" checkout form.
- **Take Key**: Collects the borrower's name and expected return date/time. The checkout time defaults to the current timestamp. On confirmation, the key status changes to `Taken`.
- **Taken**: Shows who currently holds the key, when they checked it out, and when they are expected to return it. Provides a "Return Key" button.
- **Return Key**: Recording a return sets the returned time, updates the handover log, and immediately marks the key as `Available`.

### 2. Automatic Overdue Detection
- If the current time exceeds the `expectedReturnTime` and the key has not been returned, the key status immediately updates to `Overdue`.
- App refreshes statuses automatically when opened/resumed (via `WidgetsBindingObserver`) or when viewing the key list/details.
- Overdue keys remain associated with the holder, display the red "Overdue" badge, and show the "Return Key" action.

### 3. Real-time Search
- Search bar filters the dashboard list on the fly.
- Matches key name, identifier, or the current borrower's name.
- Displays a clean visual empty state (`No keys found`) if no match is found.

### 4. Handover History
- Preserves a clean history log of all past and active transactions.
- Shows key metadata, borrower name, taken time, return/expected return time, and the transaction's status.

---

## Architecture & Folder Structure

The project is structured under the `lib` folder as follows:

```
lib/
  core/
    constants/        # AppColors definition
    theme/            # Light and Dark ThemeData configurations
  data/
    models/           # KeyModel and HandoverModel structures
    repositories/     # KeyRepository with SharedPreferences local persistence
  viewmodels/         # KeyListViewModel managing UI state and logic
  views/
    screens/          # KeyListScreen, KeyDetailScreen, TakeKeyScreen, HandoverHistoryScreen
    widgets/          # KeyCard, StatusBadge custom reusable widgets
  main.dart           # App entry point initializing packages and repository
```

---

## Packages Used

- **flutter_screenutil**: Sizing/spacing scaling and responsive text adaptation across devices.
- **shared_preferences**: Local disk persistence for key states and transaction history logs.

---

## How to Run the Project

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run the application:
   ```bash
   flutter run
   ```

---

## How the Application Was Tested

1. **Static Analysis**:
   - Run standard analysis tests to confirm zero errors or warning alerts:
     ```bash
     flutter analyze
     ```
2. **Visual States & Flow Verification**:
   - Tested checkout: `Available` -> Enter Name/Choose Time -> `Taken`.
   - Verified metadata details showing holder's name and schedules.
   - Tested overdue trigger by setting a short return date/time, and validated app resume recalculation.
   - Tested return workflow: `Taken`/`Overdue` -> `Return Key` -> Status returns to `Available` immediately.
   - Checked that history lists completed handovers correctly.
   - Checked empty list illustrations and empty search results.
