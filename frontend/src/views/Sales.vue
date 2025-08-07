<script setup>
import { ref } from "vue";
import InlineEditableRow from "../components/InlineEditableRow.vue";
import BackButton from "../components/Button.vue";
import { Pencil, X } from "lucide-vue-next";

// Sample data
const sales = ref([
  {
    saleID: 1,
    saleDate: "2025-06-20",
    saleDetails: [{ saleID: 1, productID: 1, quantity: 4, salePrice: 5.0 }],
    totalRevenue: 20.0,
  },
  {
    saleID: 2,
    saleDate: "2025-06-24",
    saleDetails: [
      { saleID: 2, productID: 1, quantity: 1, salePrice: 5.0 },
      { saleID: 2, productID: 2, quantity: 2, salePrice: 7.25 },
    ],
    totalRevenue: 19.5,
  },
  {
    saleID: 3,
    saleDate: "2025-06-27",
    saleDetails: [{ saleID: 3, productID: 3, quantity: 2, salePrice: 7.25 }],
    totalRevenue: 14.5,
  },
]);

const expanded = ref(new Set());
function toggleExpand(id) {
  if (expanded.value.has(id)) {
    expanded.value.delete(id);
  } else {
    expanded.value.add(id);
  }
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
  const index = sales.value.findIndex(s => s.saleID === id);
  if (index !== -1) {
    sales.value[index] = { ...sales.value[index], ...update };
  }
  cancelEdit();
}

function onRemove(id) {
  console.log("Remove Sale ID:", id);
  alert("Deleting Sale ID: " + id);
}
</script>

<template>
  <BackButton />
  <div class="flex justify-between items-center mb-4">
    <h2 class="text-2xl font-bold">Manage Sales</h2>
  </div>

  <div class="overflow-auto bg-(--surface) border border-(--grey) rounded-md shadow-md">
    <table class="min-w-full divide-y">
      <thead class="bg-(--base)">
        <tr>
          <th class="px-4 py-2 text-left">ID</th>
          <th class="px-4 py-2 text-left">Date</th>
          <th class="px-4 py-2 text">Total Revenue</th>
          <th class="px-4 py-2 text-right">Actions</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-(--grey)">
        <template v-for="s in sales" :key="s.saleID">


          <template v-if="editingID === s.saleID">
            <InlineEditableRow
              :value="s"
              :onSave="update => saveEdit(s.saleID, update)"
              :onCancel="cancelEdit"
            >
              <template #cols="{ row }">
                <td class="px-4 py-2 text-left">{{ row.saleID }}</td>
                <td class="px-1">
                  <input
                    v-model="row.saleDate"
                    type="text"
                    class="w-full h-full border-box bg-(--base) border border-(--grey) p-1"
                  />
                </td>
                <td class="px-1">
                  <input
                    v-model.number="row.totalRevenue"
                    type="number"
                    min="0"
                    step="0.01"
                    class="w-full h-full border-box bg-(--base) border border-(--grey) p-1"
                  />
                </td>
              </template>
            </InlineEditableRow>
          </template>

          <template v-else>
          <tr @click="toggleExpand(s.saleID)" class="cursor-pointer hover:bg-(--base)">
            <td class="px-4 py-2 text-left">{{ s.saleID }}</td>
            <td class="px-4 py-2 text-left">{{ s.saleDate }}</td>
            <td class="px-4 py-2">{{ s.totalRevenue.toFixed(2) }}</td>
            <td class="px-4 py-2 text-right space-x-2">
              <button
                @click.stop="startEdit(s.saleID)"
                class="cursor-pointer px-1 py-1 bg-(--secondary) text-black rounded-sm hover:bg-(--secondary-light) transition"
              >
                <Pencil />
              </button>
              <button
                @click.stop="onRemove(s.saleID)"
                class="cursor-pointer px-1 py-1 bg-(--primary) text-black rounded-sm hover:bg-(--primary-light) transition"
              >
                <X />
              </button>
            </td>
          </tr>

          <tr v-if="expanded.has(s.saleID)">
            <td colspan="4" class="bg-(--elevated) p-1">
              <table class="w-full divide-y divide-(--base)">
                <thead>
                  <tr>
                    <th class="py-1 text-sm">Product ID</th>
                    <th class="py-1 text-sm">Quantity</th>
                    <th class="py-1 text-sm">Sale Price</th>
                  </tr>
                </thead>
                <tbody class="">
                  <tr v-for="sd in s.saleDetails" :key="sd.productID">
                    <td class="py-1 text-sm text-(--grey)">{{ sd.productID }}</td>
                    <td class="py-1 text-sm text-(--grey)">{{ sd.quantity }}</td>
                    <td class="py-1 text-sm text-(--grey)">{{ sd.salePrice.toFixed(2) }}</td>
                  </tr>
                </tbody>
              </table>
            </td>
          </tr>
          </template>
        </template>
      </tbody>
    </table>
  </div>
</template>
