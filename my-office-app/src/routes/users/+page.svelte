<script lang="ts">
  import { onMount } from 'svelte';
  import {
    getUsers,
    createUser,
    updateUser,
    deleteUser,
    fetchOffices,
    type UserPayload
  } from '$lib/api';

  import { isAuthenticated } from '$lib/auth';
  import { authStore } from '$lib/stores/authStore';
  import '$lib/styles/form.css';
  import '$lib/styles/users.css';
  import SuccessModal from '$lib/components/SuccessModal.svelte';
  import ConfirmModal from '$lib/components/ConfirmModal.svelte';
  import ErrorModal from '$lib/components/ErrorModal.svelte';

  let editUser: UserPayload = { username: '', email: '', role: 'User', officeId: 1, firstName: '', lastName: '' };
  let newUser: UserPayload = { username: '', email: '', role: 'User', officeId: 1, firstName: '', lastName: '' };
  let editingId: number | null = null;
  let deletedUserIds: number[] = [];
  let offices: { id: number, name?: string }[] = [];
  let showSuccessModal = false;
  let showConfirmModal = false;
  let showErrorModal = false;
  let showDeleteSuccessModal = false;
  let showEmailValidateModal = true;
  let showOfficeAdminModal = true
  let createErrorMessage = '';
  let errorMessage = '';
  let userIdToDelete: number | null = null;
  let users: UserPayload[] = [];
  let filteredUsers: UserPayload[] = [];

  // Get current user from auth.store

  $: currentUser = $authStore?.user;

  // Check the role of the current user

  $: isAdmin = currentUser?.role === 'Admin';
  $: isOfficeAdmin = currentUser?.role === 'OfficeAdmin';
  $: isUser = currentUser?.role === 'User';

  // Filter users based on current user's role

  $: filteredUsers = users.filter(user => {

  if (!currentUser || !currentUser.role) {
    console.warn('currentUser not ready:', currentUser);
    return false;
  }

  if (currentUser.role === 'Admin') return true;

  if (currentUser.role === 'OfficeAdmin') {
    const match = Number(user.officeId) === Number(currentUser.officeId);
    return match;
  }

  return false;
  });

  // create user validation
  async function handleCreate() {
    // Check if office already has the maximum allowed users (5)

    if (hasMaxUsersInOffice(newUser.officeId)) {
      const office = offices.find(o => o.id == newUser.officeId);
      const officeName = office?.name ?? `Office ${newUser.officeId}`;
      createErrorMessage = `Cannot add user. ${officeName} already has 5 users.`;
      showErrorModal = true;
      return;
    }

    // Check if the office already has one OfficeAdmin (only 1 allowed per office)

    if (newUser.role === 'OfficeAdmin' && hasOfficeAdminInOffice(newUser.officeId)) {
      const office = offices.find(o => o.id === newUser.officeId);
      const officeName = office?.name ?? `Office ${newUser.officeId}`;
      createErrorMessage = `Cannot add another OfficeAdmin to ${officeName}.`;
      showErrorModal = true;
      return;
    }

    // If both conditions passed, create the user and add them on the top of the table

    try {
      const created = await createUser(newUser);
      const tempId = Math.max(0, ...users.map(u => u.id ?? 0)) + 1;
      const newUserWithId = { ...newUser, id: created.id ?? tempId };
      users = [newUserWithId, ...users];

      newUser = { username: '', email: '', role: 'User', officeId: 1, firstName: '', lastName: '' };
      showSuccessModal = true;
    } catch (err) {
      console.error('Failed to create user:', err);
    }
  }
 
  // Mark which user is being edited

  function startEdit(user: UserPayload & { id: number }) {
    editingId = user.id;
    editUser = { ...user };
  }

  async function handleUpdate() {
    if (editingId !== null) {

      // Validate email address format

      if (!isValidEmail(editUser.email)) {
        showEmailValidateModal = true;
        errorMessage = `Please enter a valid email address.`;
        return;
      }
      try {

        // Call the backend api for updating the user...

        const updatedUser = await updateUser(editingId, editUser);
        users = users.map(u => u.id === editingId ? { ...editUser, id: editingId } : u);
        editingId = null;
        showSuccessModal = true;
      } catch (err) {
        console.error(err);
      }
    }
  }

  // Frontend check user is not deleted local storage

  function isNotDeleted(user: UserPayload) {
    return user.id !== undefined && !deletedUserIds.includes(user.id);
  }

  // Confirm Delete

  async function handleDelete(userId: number) {
    userIdToDelete = userId;
    showConfirmModal = true;
  }

  // Handle cancel button

  function cancelDelete() {
    showConfirmModal = false;
    userIdToDelete = null;
  }

  // Function to handle confirm button

  async function confirmDelete() {
    // Checks if there's a user to delete

    try {
      if (userIdToDelete !== null) {
        // Send a delete request to the backend API...

        await deleteUser(userIdToDelete);
        deletedUserIds = [...deletedUserIds, userIdToDelete];
        console.log('User deleted');
      }
    } catch (err) {
      console.error('Delete failed:', err);
    } finally {
      showConfirmModal = false;
      showDeleteSuccessModal = true;
      userIdToDelete = null;
    }
  }
  
  // Function to check if office has maximum of five users

  function hasMaxUsersInOffice(officeId: number): boolean {
    const count = users.filter(u => u.officeId === officeId && !deletedUserIds.includes(u.id!)).length;
    return count >= 5;
  }

  // Function to verify that there should be only one OfficeAdmin in every office.

  function hasOfficeAdminInOffice(officeId: number): boolean {
    return users.some(
      u => u.officeId === officeId &&
           u.role === 'OfficeAdmin' &&
           !deletedUserIds.includes(u.id!)
    );
  }

  function handleRoleChange(event: Event) {
  // Gets the selected Role from the dropdown
  const selectedRole = (event.target as HTMLSelectElement).value;

  // Checks or capture if new userRole has changed to OfficeAdmin

  if (
    selectedRole === 'OfficeAdmin' &&
    users.some(
      u =>
        u.officeId === editUser.officeId &&
        u.role === 'OfficeAdmin' &&
        u.id !== editingId && 
        !deletedUserIds.includes(u.id!)
    )
  ) {
    // Condition to handle if officeAdmin already exist.

    const office = offices.find(o => o.id === editUser.officeId);
    const officeName = office?.name ?? `Office ${editUser.officeId}`;

    editUser.role = 'User'; 
    errorMessage = `Cannot Edit. Only one OfficeAdmin is allowed in ${officeName}.`;
    showOfficeAdminModal = true;
    return;
  }

  // if no OfficeAdmin yet, create

  editUser.role = selectedRole;
}

  // Validate email address format

  function isValidEmail(email: string): boolean {
    return /^[^\s@]+@[^\s@]+$/.test(email);
  }

  // Load users and offices from backends

  onMount(async () => {
    if (isAuthenticated()) {
      try {
        const data = await getUsers();
        users = data.users.map((u, i) => ({
          ...u,
          id: u.id ?? i + 1
        }));
        const officeData = await fetchOffices();
        offices = officeData.offices ?? officeData;
      } catch (err: any) {
        console.error('Fetch error:', err);
      }
    } else {
      console.error('Not authenticated');
    }
  });
</script>

{#if isAdmin || isOfficeAdmin}
<div class="form-wrapper">
  <form on:submit|preventDefault={handleCreate} class="form-container">
    <h2 class="text-xl font-bold mb-4">Create User</h2>

    <div class="form-group">
      <label>Username</label>
      <input bind:value={newUser.username} placeholder="Username" required />
    </div>

    <div class="form-group">
      <label>Email</label>
      <input type="email" bind:value={newUser.email} placeholder="Email" required />
    </div>

    <div class="form-group">
      <label>First Name</label>
      <input bind:value={newUser.firstName} placeholder="First Name" required />
    </div>

    <div class="form-group">
      <label>Last Name</label>
      <input bind:value={newUser.lastName} placeholder="Last Name" required />
    </div>

    <div class="form-group">
      <label>Role</label>
      <select bind:value={newUser.role}>
        <option value="User">User</option>
        <option value="OfficeAdmin">OfficeAdmin</option>
      </select>
    </div>

    <div class="form-group">
      <label>Office</label>
      <select bind:value={newUser.officeId} required>
        <option value="" disabled selected>Select Office</option>
        {#if isAdmin}  
          {#each offices as office}
            <option value={office.id}>{office.name ?? `Office ${office.id}`}</option>
          {/each}
        {:else if isOfficeAdmin}
          {#each offices.filter(o => o.id === currentUser.officeId) as office}
            <option value={office.id}>{office.name ?? `Office ${office.id}`}</option>
          {/each}
        {/if}
      </select>
    </div>

    <div class="form-actions">
      <button type="submit">Add User</button>
    </div>
  </form>
</div>
{/if}


<!-- LIST USERS -->
<h2 class="center-title">List of Users</h2>

<div class="table-container">
  <table class="user-table">
    <thead>
      <tr>
        <th>User ID</th>
        <th>Username</th>
        <th>Email</th>
        <th>Role</th>
        <th>Office</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      {#each filteredUsers.filter(user => !deletedUserIds.includes(user.id)) as user}
        <tr>
          {#if editingId === user.id}
            <td>{user.id}</td>
            <td><input bind:value={editUser.username} class="table-input" /></td>
            <td><input type="email" bind:value={editUser.email} class="table-input" required/></td>
            <td>
              <select on:change={handleRoleChange} bind:value={editUser.role} class="table-select">
                <option value="User">User</option>
                <option value="OfficeAdmin">OfficeAdmin</option>
              </select>
            </td>
            <td>
              <select bind:value={editUser.officeId} class="table-select" required>
                <option value="" disabled>Select Office</option>
                {#each offices as office}
                  <option value={office.id}>{office.name ?? `Office ${office.id}`}</option>
                {/each}
              </select>
            </td>
            <td>
              <button on:click={handleUpdate} class="btn btn-primary">Save</button>
              <button on:click={() => (editingId = null)} class="btn btn-secondary">Cancel</button>
            </td>
          {:else}
            <td>{user.id}</td>
            <td>{user.username}</td>
            <td>{user.email}</td>
            <td>{user.role}</td>
            <td>{offices.find(o => o.id === user.officeId)?.name ?? `Office ${user.officeId}`}</td>
            <td>
              <button on:click={() => startEdit(user)} class="btn btn-primary">Edit</button>
              <button on:click={() => handleDelete(user.id)} class="btn btn-danger">Delete</button>
            </td>
          {/if}
        </tr>
      {/each}
    </tbody>
  </table>
</div>


<!-- modal for confirm delete-->
{#if showConfirmModal}
  <ConfirmModal
    message="Are you sure you want to delete this user?"
    onConfirm={confirmDelete}
    onCancel={() => {
      showConfirmModal = false;
      userIdToDelete = null;
    }}
  />
{/if}

<!--  modal for delete success -->
{#if showDeleteSuccessModal}
  <SuccessModal
    message = "User is deleted."
    onClose={() => showDeleteSuccessModal = false}
  />
{/if}

<!-- modal for edit success -->
{#if showSuccessModal}
  <SuccessModal
    message = "User is updated."
    onClose={() => showSuccessModal = false}
  />
{/if}

<!-- modal for error modal -->
{#if showErrorModal}
  <ErrorModal
    message={createErrorMessage}
    onClose={() => showErrorModal = false}
  />
{/if}

<!-- modal for email validation -->
{#if showEmailValidateModal}
  <ErrorModal
    message={errorMessage}
    onClose={() => showEmailValidateModal = false}
  />
{/if}

<!-- modal for officeadmin validation -->
{#if showOfficeAdminModal}
  <ErrorModal
    message={errorMessage}
    onClose={() => showOfficeAdminModal = false}
  />
{/if}

