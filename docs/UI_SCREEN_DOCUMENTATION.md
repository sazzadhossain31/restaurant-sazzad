# SAVORIA — UI Screen Documentation
*Food delivery mobile app*

An illustrated guide to the Savoria interface, from account access and menu discovery to saved favorites, checkout, and profile management.

---

## Screen Index

| # | Screen Name | Description | Key Action / Goal |
|---|---|---|---|
| **01** | [Welcome Back Login Screen](#screen-01--welcome-back-login-screen) | Sign-in screen for returning users | Access account quickly with email & password |
| **02** | [Join Savoria Screen](#screen-02--join-savoria-screen) | Account registration for new users | Seamless registration with credentials |
| **03** | [Home & Menu Browsing Screen](#screen-03--home-and-menu-browsing-screen) | Main discovery & quick ordering screen | Search, filter, compare, and select food items |
| **04** | [Chef’s Menu Screen](#screen-04--chefs-menu-screen) | Detailed culinary creations list | Browse offerings, prep time, calories, and prices |
| **05** | [Curated Favorites Screen](#screen-05--curated-favorites-screen) | Saved dishes for fast repeat orders | Quickly re-order saved dishes with one tap |
| **06** | [Your Dining Bag Screen](#screen-06--your-dining-bag-screen) | Cart review and checkout preparation | Review order, adjust quantities, verify subtotal |
| **07** | [Order Confirmation Modal](#screen-07--order-confirmation-modal) | Successful order placement feedback | Transaction reassurance with delivery status |
| **08** | [Dining Profile Screen](#screen-08--dining-profile-screen) | User account management & settings hub | Central management for addresses, payments & security |

---

### Screen 01 — Welcome Back Login Screen
**Sign-in screen for returning users**

- **Description**: This screen welcomes returning users and gives them a clear path to sign in with email and password. It includes a password recovery link and an option to create a new account.
- **Primary User Goal**: Help users access their account quickly while keeping the interface elegant and trustworthy.
- **Key UI Components**:
  - App logo and welcome headline (*"Welcome back, food connoisseur."*)
  - Email and password input fields with floating labels & show/hide toggle
  - *"Forgot password?"* link
  - Prominent gold *"Sign in"* CTA button
  - Account creation prompt for new users (*"New to Savoria? Create an account"*)
- **Design Note**: The dark canvas, muted input fields, and bold golden-yellow login button create a premium, artisanal dining onboarding experience.

---

### Screen 02 — Join Savoria Screen
**Account registration for new users**

- **Description**: This screen invites new users to join the platform, offering a seamless registration process with email, password, and confirmation fields.
- **Primary User Goal**: Allow users to easily create a new account and enter the ecosystem.
- **Key UI Components**:
  - Compelling welcome headline (*"Join Savoria. Taste extraordinary."*)
  - Descriptive subtext (*"One account. A whole world of artisanal dining waiting for you."*)
  - Email, password, and confirm password fields
  - Primary *"Create account"* button
  - Sign-in redirect link for existing users (*"Already a member of Savoria? Sign in"*)
- **Design Note**: The typography is bold and modern, emphasizing the "extraordinary" taste experience awaiting the user.

---

### Screen 03 — Home and Menu Browsing Screen
**Main discovery screen for food browsing and quick ordering**

- **Description**: This screen displays promotional offers, a search bar, category filters, and the Chef's Menu. It is designed to help users discover meals quickly and move toward ordering with minimal friction.
- **Primary User Goal**: Let users search, filter, compare, and select food items from one central home screen.
- **Key UI Components**:
  - Top header with Savoria branding and profile avatar
  - High-impact promotional discount banner (*"Savor 35% Off Your Next Feast"*, Code: `SAVOR35`)
  - Search input area (*"Search handcrafted dishes, gourmet kitchen..."*)
  - Food category chips (*All, Bowls, Burgers, Drinks, Pasta, Pizza, Salads*)
  - Chef's Menu item cards with item counts
  - Bottom navigation bar (*Explore, My Bag, Favorites, Account*)
- **Design Note**: The layout balances promotion and navigation. The bold yellow promotional card instantly catches the eye against the dark background.

---

### Screen 04 — Chef’s Menu Screen
**Detailed list of available culinary creations**

- **Description**: This screen lists multiple menu items such as the *Lemon chicken bowl* and *Garden margherita*, complete with high-quality imagery, preparation time, calories, and price.
- **Primary User Goal**: Browse through the chef's offerings and add desired items to the bag.
- **Key UI Components**:
  - Large hero images for each dish
  - Dish title and restaurant/category subtitle (e.g., *The Green Kitchen*, *The Stone Oven*)
  - Preparation time and calorie metadata tags (e.g., `20 min`, `540 kcal`)
  - Quick `+ Add` button
  - Interactive Favorite heart toggle icon
- **Design Note**: The visual hierarchy is strong: vibrant food photography stands out vividly on the dark canvas, while price and add actions stay clearly visible.

---

### Screen 05 — Curated Favorites Screen
**Saved dishes for faster repeat ordering**

- **Description**: This screen stores the user's saved or favorite dishes in a focused format. Each card shows the item image, name, prep time, calories, and an add-to-bag action.
- **Primary User Goal**: Help users quickly return to meals they already like without searching again.
- **Key UI Components**:
  - Header with descriptive subtext (*"Your Curated Favorites — The signature culinary creations you love returning to."*)
  - Favorite item cards with active golden heart indicators
  - Food thumbnail/hero images
  - Cooking duration, calorie count, and pricing tags
  - Direct `+ Add` to bag button
- **Design Note**: The prominent golden heart icon clearly communicates the item's favorite status.

---

### Screen 06 — Your Dining Bag Screen
**Order review and checkout preparation**

- **Description**: This cart screen shows the selected items, item price, quantity controls, subtotal, and the checkout call-to-action. It gives the user a clear financial summary before placing the order.
- **Primary User Goal**: Allow users to review their order, adjust quantity, confirm cost, and proceed to checkout.
- **Key UI Components**:
  - List of selected cart item cards with dish thumbnails
  - Stepper quantity selector (`-`, count, `+`)
  - Delete/remove button (`×`)
  - Live subtotal calculation
  - Prominent gold *"Checkout"* button displaying total amount
- **Design Note**: The summary panel below the item card improves clarity. The golden checkout button stands out as the primary next action.

---

### Screen 07 — Order Confirmation Modal
**Successful order placement feedback state**

- **Description**: After checkout, this modal confirms that the order has been placed. The background is dimmed to focus attention on the success message, check icon, and acknowledgement button.
- **Primary User Goal**: Reassure users that the transaction is complete and the meal is on the way.
- **Key UI Components**:
  - Dimmed background overlay preserving context
  - Centered elevated success modal
  - Circular golden checkmark badge icon
  - Confirmation headline (*"Order confirmed!"*)
  - Order summary text (*"Congratulations! Your item is on the way. Total: $18.00"*)
  - Primary *"Keep exploring"* button
- **Design Note**: The modal uses a simple success pattern that is easy to understand instantly. The high-contrast layout reduces uncertainty after checkout.

---

### Screen 08 — Dining Profile Screen
**User account management and settings hub**

- **Description**: This profile screen gives users access to account information and key settings. It includes user identity, dining history, delivery addresses, payment methods, notifications, and security options.
- **Primary User Goal**: Provide a central place for users to manage account, delivery, payment, notification, and privacy settings.
- **Key UI Components**:
  - Profile identity card with avatar and authenticated email
  - Navigation list items with distinctive gold category icons:
    - **Dining history**: Past orders & receipts
    - **Delivery addresses**: Saved homes, offices & destinations
    - **Payment methods**: Manage secure payment cards & options
    - **Notifications**: Chef specials, offers & order updates
    - **Security & privacy**: Account security & data preferences
  - Distinctive red *"Sign out of Savoria"* action button
- **Design Note**: The screen uses strong spacing, rounded settings rows, and subtle icons so account actions are easy to locate and understand.
