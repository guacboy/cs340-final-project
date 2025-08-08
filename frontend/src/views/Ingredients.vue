<script setup>
import { ref, onMounted } from "vue";
import InlineEditableRow from "../components/InlineEditableRow.vue";
import BackButton from "../components/Button.vue";
import { Pencil, X, Plus } from "lucide-vue-next";
import axios from "axios";

// Sample data
const ingredients = ref([]);
const suppliers = ref([]);

async function loadIngredients() {
  try {
    const res = await axios.get("/api/ingredients");
    ingredients.value = res.data;
  } catch (err) {
    console.log("Error: ", err);
  }
}

async function loadSuppliers() {
  try {
    const res = await axios.get("/api/suppliers");
    suppliers.value = res.data;
  } catch (err) {
    console.log("Error: ", err);
  }
}

onMounted(() => {
  loadIngredients();
  loadSuppliers();
});

const isModalOpen = ref(false);
const selected = ref("");
const newIngredient = ref({
  name: "",
  unit: "",
  costPerUnit: 0,
  stock: 0,
  supplierID: null,
});

function submitNewIngredient() {
  console.log("New Ingredient:", newIngredient.value);
  closeModal();
}

function onAdd() {
  isModalOpen.value = true;
}

function closeModal() {
  isModalOpen.value = false;
  newIngredient.value = {
    name: "",
    unit: "",
    costPerUnit: 0,
    stock: 0,
    supplierID: null,
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
  const index = ingredients.value.findIndex((i) => i.ingredientID === id);
  if (index !== -1) {
    ingredients.value[index] = { ...ingredients.value[index], ...update };
  }
  cancelEdit();
}

async function onRemove(id) {
  if (!confirm(`Are you sure you want to delete ingredient ID: ${id}?`)) {
    return;
  }
}
</script>

<template>
  <BackButton />
  <div class="flex justify-between items-center mb-4">
    <h2 class="text-2xl font-bold">Manage Ingredients</h2>
    <button
      @click="onAdd()"
      class="cursor-pointer px-2 py-2 bg-(--success-light) text-black rounded-sm hover:bg-(--success)"
    >
      Add Ingredient
    </button>
  </div>

  <div class="overflow-auto bg-(--surface) border border-(--grey) rounded-md shadow-md">
    <table class="min-w-full divide-y">
      <colgroup v-if="editingID != null">
        <col class="w-1/13" />
        <col class="w-2/13" />
        <col class="w-2/13" />
        <col class="w-2/13" />
        <col class="w-2/13" />
        <col class="w-2/13" />
        <col class="w-2/13" />
      </colgroup>
      <thead class="bg-(--base)">
        <tr>
          <th class="px-4 py-2 text-left">ID</th>
          <th class="px-4 py-2 text-left">Name</th>
          <th class="px-4 py-2 text-left">Unit</th>
          <th class="px-4 py-2 text-left">Cost (per unit)</th>
          <th class="px-4 py-2 text-left">Stock</th>
          <th class="px-4 py-2 text-left">Supplier ID</th>
          <th class="px-4 py-2 text-right">Actions</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-(--grey)">
        <template v-for="i in ingredients" :key="i.ingredientID">
          <template v-if="editingID === i.ingredientID">
            <InlineEditableRow
              :value="i"
              :onSave="(update) => saveEdit(i.ingredientID, update)"
              :onCancel="cancelEdit"
            >
              <template #cols="{ row }">
                <td class="px-4 py-2 text-left">{{ row.ingredientID }}</td>
                <td class="px-1">
                  <input
                    v-model="row.name"
                    type="text"
                    class="w-full h-full border-box bg-(--base) border border-(--grey) p-1"
                  />
                </td>
                <td class="px-1">
                  <input
                    v-model="row.unit"
                    type="text"
                    class="w-full h-full border-box bg-(--base) border border-(--grey) p-1"
                  />
                </td>
                <td class="px-1">
                  <input
                    v-model.number="row.costPerUnit"
                    type="number"
                    min="0"
                    step="0.01"
                    class="w-full h-full border-box bg-(--base) border border-(--grey) p-1"
                  />
                </td>
                <td class="px-1">
                  <input
                    v-model.number="row.stock"
                    type="number"
                    min="0"
                    step="1"
                    class="w-full h-full border-box bg-(--base) border border-(--grey) p-1"
                  />
                </td>
                <td class="px-1">
                  <input
                    v-model.number="row.supplierID"
                    type="number"
                    min="0"
                    step="1"
                    class="w-full h-full border-box bg-(--base) border border-(--grey) p-1"
                  />
                </td>
              </template>
            </InlineEditableRow>
          </template>

          <template v-else>
            <tr class="hover:bg-(--base)">
              <td class="px-4 py-2 text-left">{{ i.ingredientID }}</td>
              <td class="px-4 py-2 text-left">{{ i.name }}</td>
              <td class="px-4 py-2">{{ i.unit }}</td>
              <td class="px-4 py-2">{{ i.costPerUnit }}</td>
              <td class="px-4 py-2 text-left">{{ i.stock }}</td>
              <td class="px-4 py-2">{{ i.supplierID }}</td>
              <td class="px-4 py-2 text-right space-x-2">
                <button
                  @click.stop="startEdit(i.ingredientID)"
                  class="cursor-pointer px-1 py-1 bg-(--secondary) text-black rounded-sm hover:bg-(--secondary-light) transition"
                >
                  <Pencil />
                </button>
                <button
                  @click.stop="onRemove(i.ingredientID)"
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
        @submit.prevent="submitNewIngredient()"
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
        <h3 class="text-xl font-semibold mb-6">Add New Ingredient</h3>

        <label class="block mb-4">
          Name:
          <input
            v-model="newIngredient.name"
            type="text"
            required
            class="mt-1 w-full rounded border border-grey-600 bg-(--base) p-2 focus:outline-none focus:ring-1 focus:ring-(--grey)"
          />
        </label>

        <label class="block mb-4">
          Unit:
          <input
            v-model="newIngredient.unit"
            type="text"
            required
            class="mt-1 w-full rounded border border-grey-600 bg-(--base) p-2 focus:outline-none focus:ring-1 focus:ring-(--grey)"
          />
        </label>

        <label class="block mb-4">
          Cost (per unit):
          <input
            v-model.number="newIngredient.costPerUnit"
            type="number"
            min="0"
            step="0.01"
            required
            class="mt-1 w-full rounded border border-grey-600 bg-(--base) p-2 focus:outline-none focus:ring-1 focus:ring-(--grey)"
          />
        </label>

        <label class="block mb-4">
          Stock:
          <input
            v-model.number="newIngredient.stock"
            type="number"
            min="0"
            required
            class="mt-1 w-full rounded border border-grey-600 bg-(--base) p-2 focus:outline-none focus:ring-1 focus:ring-(--grey)"
          />
        </label>

        <label class="block mb-6">
          Supplier:
          <select
            v-model="selected"
            class="w-full rounded border border-grey-600 bg-(--base) p-2 focus:outline-none focus:ring-1 focus:ring-(--grey)"
          >
            <option disabled value="">Select one</option>
            <option
              v-for="supplier in suppliers"
              :key="supplier.supplierID"
              :value="supplier.supplierID"
            >
              {{ supplier.name }}
            </option>
          </select>
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
