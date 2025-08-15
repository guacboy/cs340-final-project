<script setup>
import { ref, onMounted } from "vue";
import InlineEditableRow from "../components/InlineEditableRow.vue";
import BackButton from "../components/Button.vue";
import { Pencil, X, Plus } from "lucide-vue-next";
import axios from "axios";

// Sample data
const sales = ref([]);
const products = ref([]);

const newSale = ref({
  date: "",
  totalRevenue: 0,
  saleDetails: [],
});

async function loadSales() {
  try {
    const res = await axios.get("/api/sales");
    const sale_details = await Promise.all(
      res.data.map(async (s) => {
        const details = await axios.get(`/api/sales/${s.saleID}/details`);
        const totalRevenue = details.data.reduce((sum, d) => {
          const price = typeof d.salePrice === "string" ? parseFloat(d.salePrice) : d.salePrice;
          return sum + d.quantity * price.toFixed(2);
        }, 0);
        return {
          ...s,
          saleDetails: details.data,
          totalRevenue: totalRevenue.toFixed(2),
        };
      })
    );

    sales.value = sale_details;
  } catch (err) {
    console.log("Error: ", err);
  }
}

async function loadProducts() {
  try {
    const res = await axios.get("/api/products");
    products.value = res.data;
    console.log("Products loaded: ", products.value);
  } catch (err) {
    console.log("Error: ", err);
  }
}

onMounted(() => {
  loadSales();
  loadProducts();
});

const isModalOpen = ref(false);

function onAdd() {
  isModalOpen.value = true;
}

function closeModal() {
  isModalOpen.value = false;
  newSale.value = {
    date: "",
    totalRevenue: 0,
    saleDetails: [],
  };
}

const expanded = ref(new Set());
function toggleExpand(id) {
  if (expanded.value.has(id)) {
    expanded.value.delete(id);
  } else {
    expanded.value.add(id);
  }
}

async function submitNewSale() {
  const newSale = {
    date: "",
    saleDetails: [],
  };
  const res = await axios.post("/api/sales", );
  const saleID = res.data.saleID;

  await loadProducts();
  closeModal();
}

async function onRemove(id) {
  if (!confirm(`Are you sure you want to delete sale ID: ${id}?`)) {
    return;
  }
  try {
    const res = await axios.delete(`/api/sales/${id}`);
    sales.value = sales.value.filter((s) => s.saleID !== id);
  } catch (err) {
    console.log("Error deleting ", err);
  }
}
</script>

<template>
  <BackButton />
  <div class="flex justify-between items-start mb-4">
    <div class="flex items-start flex-col">
      <h2 class="text-2xl font-bold">Manage Sales</h2>
      <p class="text-sm text-(--grey)">Select a row to view sale details</p>
    </div>
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
            <tr @click="toggleExpand(s.saleID)" class="cursor-pointer hover:bg-(--base)">
              <td class="px-4 py-2 text-left">{{ s.saleID }}</td>
              <td class="px-4 py-2 text-left">{{ s.saleDate }}</td>
              <td class="px-4 py-2 text-center">${{ s.totalRevenue }}</td>
              <td class="px-4 py-2 text-right space-x-2">
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
                      <td class="py-1 text-sm text-(--grey)">${{ sd.salePrice }}</td>
                    </tr>
                  </tbody>
                </table>
              </td>
            </tr>
        </template>
      </tbody>
    </table>
  </div>


  <Transition name="fade">
    <div v-if="isModalOpen" class="fixed inset-0 z-50 flex items-start justify-center pt-50">
      <div class="fixed inset-0 bg-black opacity-60"></div>

      <form
        @submit.prevent="submitNewSale()"
        class="relative opacity-100 bg-(--surface) text-(--white) p-4 rounded-md w-full max-w-lg shadow-lg"
      >
        <div class="absolute top-2 right-2">
          <button
            @click="closeModal"
            type="button"
            class="cursor-pointer text-(--grey) hover:text-(--primary) transition"
          >
            <X />
          </button>
        </div>
        <h3 class="text-xl font-semibold mb-6">Add New Sale</h3>

        <label class="block mb-4">
          Date:
          <input
            v-model="newSale.date"
            type="text"
            required
            class="mt-1 w-full rounded border border-grey-600 bg-(--base) p-2 focus:outline-none focus:ring-1 focus:ring-(--grey)"
          />
        </label>

        <label class="block mb-2">
          Details:
          <div
            v-for="(detail, index) in newSale.saleDetails"
            :key="index"
            class="flex items-center gap-2 mt-1"
          >
            <select
              v-model.number="saleDetails.productID"
              class="w-1/2 rounded border border-grey-600 bg-(--base) p-2 focus:outline-none focus:ring-1 focus:ring-(--grey)"
            >
              <option disabled value="">Select one</option>
              <option
                v-for="p in products"
                :key="p.productID"
                :value="p.productID"
              >
                {{ p.name }}
              </option>
            </select>
            <input
              v-model.number="p.price"
              type="number"
              placeholder="Sale Price"
              class="w-1/2 rounded border border-grey-600 bg-(--base) p-2 focus:outline-none focus:ring-1 focus:ring-(--grey)"
            />
            <button
              type="button"
              @click="newSaleRemoveDetail(index)"
              class="cursor-pointer text-(--primary) hover:text-(--primary-light)"
            >
              <X />
            </button>
          </div>
        </label>

        <div class="w-full flex justify-end mb-6">
          <button
            type="button"
            @click="newSaleDetail"
            class="cursor-pointer flex hover:bg-(--base) rounded-sm transition"
          >
            <Plus /> Add Product
          </button>
        </div>

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
