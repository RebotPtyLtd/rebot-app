import { writable } from 'svelte/store';
import { browser } from '$app/environment';

interface User {
  id: number;
  email: string;
  username: string;
  role: string;
}

interface AuthState {
  isAuthenticated: boolean;
  user: User | null;
}

const initialAuthState: AuthState = {
  isAuthenticated: false,
  user: null,
};

export const authStore = writable<AuthState>(initialAuthState);

// Initialize store from localStorage if in browser environment
if (browser) {
  const token = localStorage.getItem('token');
  const userString = localStorage.getItem('user');
  console.log('authStore: Initializing from localStorage. Token present:', !!token, 'User present:', !!userString);
  if (token && userString) {
    try {
      const user = JSON.parse(userString);
      authStore.set({ isAuthenticated: true, user });
      console.log('authStore: Initial state set to authenticated.', user);
    } catch (e) {
      console.error("authStore: Failed to parse user from localStorage", e);
      // Clear invalid data
      localStorage.removeItem('token');
      localStorage.removeItem('user');
    }
  }
}

export function setAuth(token: string, user: User) {
  if (browser) {
    localStorage.setItem('token', token);
    localStorage.setItem('user', JSON.stringify(user));
  }
  authStore.set({ isAuthenticated: true, user });
  console.log('authStore: setAuth called. State set to authenticated.', user);
}

export function clearAuth() {
  if (browser) {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
  }
  authStore.set({ isAuthenticated: false, user: null });
  console.log('authStore: clearAuth called. State set to unauthenticated.');
}
