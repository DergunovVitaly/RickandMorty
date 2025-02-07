# RickAndMorty

**An iOS app that displays characters from the Rick and Morty API in a paginated list, using UIKit for the list and SwiftUI for character details.**

---

## Requirements / Features

1. **Character List (Screen 1)**
   - Displays a paginated list of characters (20 per page).
   - Each row shows:
     - **Name**
     - **Image**
     - **Species**
   - Filter the list by **Status** (`alive`, `dead`, `unknown`).

2. **Character Details (Screen 2)**
   - Shows detailed information about a selected character:
     - **Name**
     - **Image**
     - **Species**
     - **Status**
     - **Gender**

3. **Pagination**
   - Automatically loads the next page (20 more characters) when scrolling near the bottom.

4. **Filtering**
   - Filter by `alive`, `dead`, or `unknown` status.

---

## Project Structure
RickAndMorty

<img width="477" alt="Screenshot 2025-02-07 at 19 23 19" src="https://github.com/user-attachments/assets/0c75f603-b366-4327-a148-501e9b890625" />


### Key Files

- **`CharacterListViewController`**  
  Displays the list of characters in a `UITableView`. Handles pagination and filtering.
- **`CharacterDetailView`**  
  A SwiftUI view showing the character’s name, species, status, gender, and an async-loaded image.
- **`CharacterListViewModel`**  
  Contains the business logic for fetching (paginated) data and filtering from the `NetworkService`, storing results in `characters`.
- **`RickAndMortyNetworkService`**  
  Makes REST calls to [Rick and Morty API](https://rickandmortyapi.com) at `https://rickandmortyapi.com/api/character`.
- **`MockNetworkService` (Tests)**  
  Used to mock network responses in unit tests without hitting the real API.

---

## Build and Run Instructions

1. **Clone the repository**:

   ```bash
   git clone https://github.com/YourUsername/RickAndMorty.git
   cd RickAndMorty

#	2.	** Open in Xcode:
	•	Double-click RickAndMorty.xcodeproj (or .xcworkspace if you have one).
	•	Select the RickAndMorty scheme and a simulator (e.g., iPhone 14).
	3.	Run:
	•	Press Cmd + R or the Run button to build and launch the app in the Simulator.
	•	The app shows the first 20 characters. Scroll down to trigger pagination.
	•	Use the filter (chips or segmented control) for alive, dead, unknown.
	•	Tap on a character to see details in a SwiftUI view.

   
