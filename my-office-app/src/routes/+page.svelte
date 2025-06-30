<script lang="ts">
  import { onMount } from 'svelte';
  import { fetchOffices } from '$lib/api';
  import { isAuthenticated } from '$lib/auth';
  import { officeStore, setOffices, type Office } from '$lib/stores/officeStore';
  import { Modal, OfficeForm, DeleteConfirmation, OfficeCard } from '$lib/components';

  let error: string | null = null;
  let offices: Office[] = $state([]);
  let showEditModal = $state(false);
  let showDeleteModal = $state(false);
  let showAddModal = $state(false);
  let editingOffice: Office | null = $state(null);
  let deletingOffice: Office | null = $state(null);
  let editForm = $state({
    name: '',
    address: '',
    maxItemsPerUser: 0
  });
  let addForm = $state({
    name: '',
    address: '',
    maxItemsPerUser: 1
  });

  $effect(() => {
    officeStore.subscribe(state => {
      offices = state.offices;
    });
  });

  onMount(async () => {
    if (isAuthenticated()) {
      try {
        const data = await fetchOffices();
        setOffices(data.offices);
      } catch (err: any) {
        error = err.message;
      }
    } else {
      error = 'Not authenticated. Please log in.';
    }
  });

  function openAddModal() {
    addForm = {
      name: '',
      address: '',
      maxItemsPerUser: 1
    };
    showAddModal = true;
  }

  function openEditModal(office: Office) {
    editingOffice = office;
    editForm = {
      name: office.name,
      address: office.address,
      maxItemsPerUser: office.settings.maxItemsPerUser
    };
    showEditModal = true;
  }

  function openDeleteModal(office: Office) {
    deletingOffice = office;
    showDeleteModal = true;
  }

  function closeAddModal() {
    showAddModal = false;
  }

  function closeEditModal() {
    showEditModal = false;
    editingOffice = null;
  }

  function closeDeleteModal() {
    showDeleteModal = false;
    deletingOffice = null;
  }

  function handleAddSubmit() {
    // Create new office with a unique ID
    const newOffice: Office = {
      id: Math.max(...offices.map(o => o.id), 0) + 1,
      name: addForm.name,
      address: addForm.address,
      settings: {
        maxItemsPerUser: addForm.maxItemsPerUser
      }
    };
    
    // Add to store
    const updatedOffices = [newOffice, ...offices];
    setOffices(updatedOffices);
    closeAddModal();
  }

  function handleEditSubmit() {
    if (editingOffice) {
      // Update the office in the store
      const updatedOffices = offices.map(office => 
        office.id === editingOffice!.id 
          ? {
              ...office,
              name: editForm.name,
              address: editForm.address,
              settings: {
                ...office.settings,
                maxItemsPerUser: editForm.maxItemsPerUser
              }
            }
          : office
      );
      setOffices(updatedOffices);
      closeEditModal();
    }
  }

  function handleDeleteConfirm() {
    if (deletingOffice) {
      // Remove the office from the store
      const updatedOffices = offices.filter(office => office.id !== deletingOffice!.id);
      setOffices(updatedOffices);
      closeDeleteModal();
    }
  }

  function handleOfficeEdit(event: CustomEvent) {
    openEditModal(event.detail);
  }

  function handleOfficeDelete(event: CustomEvent) {
    openDeleteModal(event.detail);
  }
</script>

<main class="p-6">
  <div class="flex justify-between items-center mb-6">
    <h1 class="text-2xl font-bold">Offices</h1>
    <button
      on:click={openAddModal}
      class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 flex items-center space-x-2"
    >
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
      </svg>
      <span>Add Office</span>
    </button>
  </div>

  {#if error}
    <p class="text-red-600">{error}</p>
  {:else if offices.length === 0 && isAuthenticated()}
    <p>Loading offices...</p>
  {:else if offices.length === 0 && !isAuthenticated()}
    <p>Please log in to view offices.</p>
  {:else}
    <ul class="space-y-4">
      {#each offices as office}
        <OfficeCard 
          {office}
          editOffice={openEditModal}
          deleteOffice={() => openDeleteModal(office)}
        />
      {/each}
    </ul>
  {/if}
</main>

<!-- Add Office Modal -->
<Modal 
  isOpen={showAddModal} 
  title="Add New Office"
  on:close={closeAddModal}
>
  <OfficeForm 
    bind:form={addForm}
    submitLabel="Add Office"
    cancelLabel="Cancel"
    submit={handleAddSubmit}
    cancel={closeAddModal}
  />
</Modal>

<!-- Edit Office Modal -->
<Modal 
  isOpen={showEditModal} 
  title="Edit Office"
  on:close={closeEditModal}
>
  <OfficeForm 
    bind:form={editForm}
    submitLabel="Save Changes"
    cancelLabel="Cancel"
    submit={handleEditSubmit}
    cancel={closeEditModal}
  />
</Modal>

<!-- Delete Confirmation Modal -->
<DeleteConfirmation 
  isOpen={showDeleteModal}
  itemName={deletingOffice?.name || ''}
  itemType="Office"
  on:confirm={handleDeleteConfirm}
  on:cancel={closeDeleteModal}
/>
