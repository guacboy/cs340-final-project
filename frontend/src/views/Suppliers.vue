<script setup>
import { ref } from "vue";
import InlineEditableRow from "../components/InlineEditableRow.vue";
import BackButton from "../components/Button.vue";
import { Pencil, X, Plus } from "lucide-vue-next";

// Sample data
const suppliers = ref([
  {
    supplierID: 1,
    name: "Wario's Warehouse",
    phone: "1-800-555-1111",
    email: "wario.warehouse@gmail.com",
  },
  {
    supplierID: 2,
    name: "Stan's Store",
    phone: "1-800-555-2222",
    email: "stan.store@hotmail.com",
  },
  {
    supplierID: 3,
    name: "Garry's Garden",
    phone: "1-800-555-3333",
    email: "garry.garden@yahoo.com",
  },
]);

const isModalOpen = ref(false);
const selected = ref("");
const newSupplier = ref({
  name: "",
  phone: "",
  email: "",
});

function submitNewSupplier() {
  console.log("New Supplier:", newSupplier.value);
  closeModal();
}

function onAdd() {
  isModalOpen.value = true;
}

function closeModal() {
  isModalOpen.value = false;
  newSupplier.value = {
    name: "",
    phone: "",
    email: "",
  };
}

// Edit Table Row
const editingID = ref(null);

function startEdit(id) {
  editingID.value = id;
}

function cancelEdit() {
  editingID.value = null;
}

function saveEdit(id, update) {
  const index = suppliers.value.findIndex(s => s.supplierID === id);
  if (index !== -1) {
    suppliers.value[index] = { ...suppliers.value[index], ...update };
  }
  cancelEdit();
}

function onRemove(id) {
  console.log("Remove Supplier ID:", id);
  alert("Deleting Supplier ID: " + id);
}
</script>

<template>
  <BackButton />
  <div class="flex justify-between items-center mb-4">
    <h2 class="text-2xl font-bold">Manage Suppliers</h2>
    <button
      @click="onAdd()"
      class="cursor-pointer px-2 py-2 bg-(--success-light) text-black rounded-sm hover:bg-(--success)"
    >
      Add Supplier
    </button>
  </div>

  <div class="overflow-auto bg-(--surface) border border-(--grey) rounded-md shadow-md">
    <table class="min-w-full divide-y">
      <thead class="bg-(--base)">
        <tr>
          <th class="px-4 py-2 text-left">ID</th>
          <th class="px-4 py-2 text-left">Name</th>
          <th class="px-4 py-2 text-left">Phone</th>
          <th class="px-4 py-2 text-left">Email</th>
          <th class="px-4 py-2 text-right">Actions</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-(--grey)">
        <template v-for="s in suppliers" :key="s.supplierID">

          <template v-if="editingID === s.supplierID">
            <InlineEditableRow
              :value="s"
              :onSave="update => saveEdit(s.supplierID, update)"
              :onCancel="cancelEdit"
            >
              <template #cols="{ row }">
                <td class="px-4 py-2 text-left">{{ row.supplierID }}</td>
                <td class="px-1">
                  <input
                    v-model="row.name"
                    type="text"
                    class="w-full h-full border-box bg-(--base) border border-(--grey) p-1"
                  />
                </td>
                <td class="px-1">
                  <input
                    v-model="row.phone"
                    type="text"
                    class="w-full h-full border-box bg-(--base) border border-(--grey) p-1"
                  />
                </td>
                <td class="px-1">
                  <input
                    v-model="row.email"
                    type="text"
                    class="w-full h-full border-box bg-(--base) border border-(--grey) p-1"
                  />
                </td>
              </template>
            </InlineEditableRow>
          </template>

          <template v-else>
            <tr class="cursor-pointer hover:bg-(--base)">
              <td class="px-4 py-2 text-left">{{ s.supplierID }}</td>
              <td class="px-4 py-2 text-left">{{ s.name }}</td>
              <td class="px-4 py-2 text-left">{{ s.phone }}</td>
              <td class="px-4 py-2 text-left">{{ s.email }}</td>
              <td class="px-4 py-2 text-right space-x-2">
                <button
                  @click.stop="startEdit(s.supplierID)"
                  class="cursor-pointer px-1 py-1 bg-(--secondary) text-black rounded-sm hover:bg-(--secondary-light) transition"
                >
                  <Pencil />
                </button>
                <button
                  @click.stop="onRemove(s.supplierID)"
                  class="cursor-pointer px-1 py-1 bg-(--primary) text-black rounded-sm hover:bg-(--primary-light) transition"
                >
                  <X />
                </button>
              </td>
            </tr>
          </template>
        </template>
      </tbody>
    </table>
  </div>

  <Transition name="fade">
    <div v-if="isModalOpen" class="fixed inset-0 z-50 flex items-start justify-center pt-50">
      <div class="fixed inset-0 bg-black opacity-60"></div>

      <form
        @submit.prevent="submitNewSupplier()"
        class="relative opacity-100 bg-(--surface) text-(--white) p-4 rounded-md w-full max-w-lg shadow-lg"
      >
        <div class="absolute top-2 right-2">
          <button
            @click="closeModal()"
            type="button"
            class="cursor-pointer text-(--grey) hover:text-(--primary) transition"
          >
            <X />
          </button>
        </div>
        <h3 class="text-xl font-semibold mb-6">Add New Supplier</h3>

        <label class="block mb-4">
          Name:
          <input
            v-model="newSupplier.name"
            type="text"
            required
            class="mt-1 w-full rounded border border-grey-600 bg-(--base) p-2 focus:outline-none focus:ring-1 focus:ring-(--grey)"
          />
        </label>

        <label class="block mb-4">
          Phone:
          <input
            v-model.number="newSupplier.phone"
            type="text"
            required
            class="mt-1 w-full rounded border border-grey-600 bg-(--base) p-2 focus:outline-none focus:ring-1 focus:ring-(--grey)"
          />
        </label>

        <label class="block mb-4">
          Email:
          <input
            v-model.number="newSupplier.email"
            type="text"
            required
            class="mt-1 w-full rounded border border-grey-600 bg-(--base) p-2 focus:outline-none focus:ring-1 focus:ring-(--grey)"
          />
        </label>

        <div class="flex justify-center space-x-4">
          <button
            type="button"
            @click="closeModal"
            class="px-2 py-2 bg-gray-700 rounded-sm hover:bg-(--primary) transition"
          >
            Cancel
          </button>
          <button
            type="submit"
            class="px-2 py-2 bg-gray-700 rounded hover:bg-(--success) transition"
          >
            Save
          </button>
        </div>
      </form>
    </div>
  </Transition>
</template>
