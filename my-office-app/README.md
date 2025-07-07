# Office Management App

## Overview
The main page (`src/routes/+page.svelte`) provides a comprehensive office management interface built with Svelte 5. Users can view, add, edit, and delete offices with a modern, responsive UI.

## Main Page: `/` (`+page.svelte`)

### Core Functionality
- **Office Display**: Lists all offices in a card-based layout
- **Add Office**: Modal form to create new offices
- **Edit Office**: Modal form to modify existing offices
- **Delete Office**: Confirmation modal to remove offices
- **Authentication Check**: Verifies user authentication before loading data

### State Management
```typescript
// Reactive state variables
let offices: Office[] = $state([]);
let showEditModal = $state(false);
let showDeleteModal = $state(false);
let showAddModal = $state(false);
let editingOffice: Office | null = $state(null);
let deletingOffice: Office | null = $state(null);
```

### Form State
```typescript
// Edit form state
let editForm = $state({
  name: '',
  address: '',
  maxItemsPerUser: 0
});

// Add form state
let addForm = $state({
  name: '',
  address: '',
  maxItemsPerUser: 1
});
```

### Key Functions

#### Data Loading
- `onMount()`: Initializes the page, fetches offices if authenticated
- `$effect()`: Subscribes to office store changes

#### Modal Management
- `openAddModal()`: Resets form and opens add modal
- `openEditModal(office)`: Populates form with office data and opens edit modal
- `openDeleteModal(office)`: Sets office for deletion and opens confirmation modal
- `closeAddModal()`: Closes add modal
- `closeEditModal()`: Closes edit modal and clears editing state
- `closeDeleteModal()`: Closes delete modal and clears deletion state

#### CRUD Operations
- `handleAddSubmit()`: Creates new office and adds to store
- `handleEditSubmit()`: Updates existing office in store
- `handleDeleteConfirm()`: Removes office from store

## Components Used

### 1. Modal Component (`src/lib/components/Modal.svelte`)
**Purpose**: Reusable modal dialog with backdrop
**Props**:
- `isOpen: boolean` - Controls modal visibility
- `title: string` - Modal header text
- `on:close` - Event dispatched when backdrop is clicked

**Features**:
- Backdrop click to close
- Content click prevention (event bubbling)
- Responsive design with Tailwind CSS
- Z-index management for proper layering

### 2. OfficeForm Component (`src/lib/components/OfficeForm.svelte`)
**Purpose**: Form for creating/editing office data
**Props**:
- `form` (bindable) - Form data object
- `submit` - Function called on form submission
- `cancel` - Function called on cancel button click
- `submitLabel` - Text for submit button
- `cancelLabel` - Text for cancel button

**Form Fields**:
- Office Name (text input, required)
- Address (text input, required)
- Max Items Per User (number input, min: 1, required)

**Features**:
- Two-way data binding with `$bindable()`
- Form validation
- Responsive button layout
- Tailwind CSS styling

### 3. OfficeCard Component (`src/lib/components/OfficeCard.svelte`)
**Purpose**: Displays individual office information
**Props**:
- `office: Office` - Office object to display
- `editOffice` - Function called when edit is triggered
- `deleteOffice` - Function called when delete is triggered

**Displayed Information**:
- Office name (clickable for edit)
- Office address
- Max items per user setting
- Delete button with trash icon

**Features**:
- Click-to-edit functionality
- Hover effects
- Delete confirmation integration
- Responsive design

### 4. DeleteConfirmation Component (`src/lib/components/DeleteConfirmation.svelte`)
**Purpose**: Confirmation dialog for delete operations
**Props**:
- `isOpen: boolean` - Controls modal visibility
- `itemName: string` - Name of item to be deleted
- `itemType: string` - Type of item (e.g., "Office")
- `on:confirm` - Event when deletion is confirmed
- `on:cancel` - Event when deletion is cancelled

## Data Flow

### Store Integration
- Uses `officeStore` from `$lib/stores/officeStore`
- `setOffices()` function for state updates
- Reactive subscription to store changes

### API Integration
- `fetchOffices()` from `$lib/api` for data fetching
- Error handling for API failures
- Authentication check before API calls

### Authentication
- `isAuthenticated()` from `$lib/auth`
- Conditional rendering based on auth status
- Error messages for unauthenticated users

## UI/UX Features

### Responsive Design
- Mobile-first approach with Tailwind CSS
- Flexible card layout
- Responsive modal sizing

### User Experience
- Loading states
- Error handling and display
- Intuitive modal interactions
- Clear visual hierarchy

### Accessibility
- Proper form labels
- Semantic HTML structure
- Keyboard navigation support
- Screen reader friendly

## File Structure
```
src/
├── routes/
│   └── +page.svelte          # Main office management page
├── lib/
│   ├── components/
│   │   ├── Modal.svelte      # Reusable modal component
│   │   ├── OfficeForm.svelte # Office form component
│   │   ├── OfficeCard.svelte # Office display component
│   │   └── DeleteConfirmation.svelte # Delete confirmation
│   ├── stores/
│   │   └── officeStore.ts    # Office state management
│   ├── api.ts               # API functions
│   └── auth.ts              # Authentication utilities
```

## Dependencies
- **Svelte 5**: Modern reactive framework
- **SvelteKit**: Full-stack framework
- **Tailwind CSS**: Utility-first CSS framework
- **TypeScript**: Type safety and development experience

## Development Notes
- Uses Svelte 5's new `$state()` and `$effect()` syntax
- Modern component props with `$props()` and `$bindable()`
- No deprecated `createEventDispatcher` usage
- Type-safe component interfaces
- Clean separation of concerns between components

```bash
# create a new project in the current directory
npx sv create

# create a new project in my-app
npx sv create my-app
```

## Developing

Once you've created a project and installed dependencies with `npm install` (or `pnpm install` or `yarn`), start a development server:

```bash
npm run dev

# or start the server and open the app in a new browser tab
npm run dev -- --open
```

## Building

To create a production version of your app:

```bash
npm run build
```

You can preview the production build with `npm run preview`.

> To deploy your app, you may need to install an [adapter](https://svelte.dev/docs/kit/adapters) for your target environment.
