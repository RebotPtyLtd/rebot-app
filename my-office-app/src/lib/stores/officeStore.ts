import { writable } from 'svelte/store';
import { browser } from '$app/environment';

export interface Office {
  id: number;
  name: string;
  address: string;
  settings: {
    maxItemsPerUser: number;
  };
}

interface OfficeState {
  offices: Office[];
}

const initialOfficeState: OfficeState = {
  offices: [],
};

export const officeStore = writable<OfficeState>(initialOfficeState);

export function setOffices(offices: Office[]) {
  if (browser) {
    localStorage.setItem('offices', JSON.stringify(offices));
  }
  officeStore.set({ offices });
}