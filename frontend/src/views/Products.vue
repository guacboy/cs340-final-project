<script setup>
import { ref, onMounted } from "vue";
import BackButton from "../components/Button.vue";
import InlineEditableRow from "../components/InlineEditableRow.vue";
import InlineEditableDropdownRow from "../components/InlineEditableDropdownRow.vue";
import { Pencil, X, Plus, Trash } from "lucide-vue-next";
import axios from "axios";
import ResetDBButton from "../components/ResetDBButton.vue";

function deepCopy(obj) {
  return JSON.parse(JSON.stringify(obj));
}

// Sample data
const ingredients = ref([]);
const products = ref([]);

const newProduct = ref({
  name: "",
  price: 0,
  ingredients: [],
});

async function loadIngredients() {
  try {
    const res = await axios.get("/api/ingredients");
    ingredients.value = res.data;
  } catch (err) {
    console.log("Error: ", err);
  }
}

async function loadProducts() {
  try {
    const res = await axios.get("/api/products");
    const product_details = await Promise.all(
      res.data.map(async (p) => {
        const recipe = await axios.get(`/api/products/${p.productID}/ingredients`);
        return {
          ...p,
          ingredients: recipe.data,
        };
      })
    );

    products.value = product_details;
  } catch (err) {
    console.log("Error: ", err);
  }
}

onMounted(() => {
  loadIngredients();
  loadProducts();
});

function newProductAddIngredient() {
  newProduct.value.ingredients.push({
    ingredientID: 0,
    name: "",
    unitQuantityRequired: 0,
  });
}

function newProductRemoveIngredient(index) {
  newProduct.value.ingredients.splice(index, 1);
}

async function submitNewProduct() {
  const productRes = await axios.post("/api/products", {
    name: newProduct.value.name,
    price: newProduct.value.price,
  });
  const productID = productRes.data.productID;
  if (newProduct.value.ingredients.length > 0) {
    await axios.post(`/api/products/${productID}/ingredients`, {
      ingredients: newProduct.value.ingredients,
    });
  }

  await loadProducts();
  closeModal();
}

// UI
const selected = ref("");
const isModalOpen = ref(false);

function onAdd() {
  isModalOpen.value = true;
}

function closeModal() {
  isModalOpen.value = false;
  newProduct.value = {
    name: "",
    price: 0,
    ingredients: [{ ingredientID: "", name: "", unitQuantityRequired: 0 }],
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

async function onRemove(id) {
  if (!confirm(`Are you sure you want to delete product ID: ${id}?`)) {
    return;
  }
  try {
    const res = await axios.delete(`/api/products/${id}`);
    products.value = products.value.filter((p) => p.productID !== id);
  } catch (err) {
    console.log("Error deleting ", err);
    alert("You cannot delete a product that is referenced in a SaleDetails.");
  }
}

// Edit Table Row
const editingID = ref(null);
const editingRow = ref(null);

function startEdit(id) {
  editingID.value = id;
  expanded.value.add(id);
  let p = products.value.find((p) => p.productID === id);
  if (!p) { return; }
  editingRow.value = deepCopy(p);

}

function cancelEdit() {
  editingID.value = null;
  editingRow.value = null;
}

function saveEdit(id, update) {
  if (!editingRow.value) { return; }
  const index = products.value.findIndex((p) => p.productID === id);
  if (index === -1) { return; }

  editingRow.value = {
    ...editingRow.value,
    name: update.name || editingRow.value.name,
    price: update.price || editingRow.value.price,
  };

  // validate fields
  if (!editingRow.value.name || editingRow.value.price < 0) {A
    alert("Please fill in all required fields.");
    return;
  }
  if (editingRow.value.ingredients.length === 0) {
    alert("Please add at least one ingredient.");
    return;
  }
  if (editingRow.value.ingredients.some(i => !i.ingredientID || i.unitQuantityRequired <= 0)) {
    alert("Please ensure all ingredients have a valid name and quantity.");
    return;
  }


  try {
    console.log("Updating product: ", editingRow.value);

    axios.put(`/api/products/${id}`, {
      name: editingRow.value.name,
      price: editingRow.value.price,
    });

    let ingredientsToUpdate = editingRow.value.ingredients.map(i => ({
      ingredientID: i.ingredientID,
      unitQuantityRequired: i.unitQuantityRequired,
    }));

    axios.put(`/api/products/${id}/ingredients`, {
      ingredients: ingredientsToUpdate,
    });

  } catch (err) {
    console.log("Error updating product: ", err);
    alert("Failed to update product. Please try again.");
  }

  products.value[index] = { 
    ...products.value[index],
    ...editingRow.value,
    ingredients: [...editingRow.value.ingredients],
  };

  cancelEdit();
}

function updateProduct(id, update) {
  console.log("Updating product: ", id, update);
  if (!editingRow.value) { return; }
  if (editingID.value !== id) { return; }
  //editingRow.value = { ...editingRow.value, name: update.name, price: update.price };
}

function updateIngredient(id, update) {
  console.log("Updating ingredient: ", id, update);
  if (!editingRow.value) { return; }
  const index = editingRow.value.ingredients.findIndex((i) => i.ingredientID === id);
  if (index !== -1) {
    editingRow.value.ingredients[index] = { ...editingRow.value.ingredients[index], ...deepCopy(update) };
  }
}

function removeIngredient(id) {
  if (!editingRow.value) { return; }
  const index = editingRow.value.ingredients.findIndex((i) => i.ingredientID === id);
  if (index !== -1) {
    editingRow.value.ingredients.splice(index, 1);
  }
}

function editProductAddIngredient() {
  if (!editingRow.value) { return; }
  editingRow.value.ingredients.push({
    ingredientID: "",
    name: "",
    unitQuantityRequired: 0,
  });
}

function onNewIngredientSelect(row) {
  const selected = ingredients.value.find((i) => i.ingredientID === row.ingredientID);
  if (!selected) { return; }
  row.name = selected.name;
  row.unit = selected.unit;
}
</script>

<template>
  <BackButton />
  <div class="flex justify-between items-center mb-4">
    <h2 class="text-2xl font-bold">Manage Products</h2>
    <button
      @click="onAdd()"
      class="cursor-pointer px-2 py-2 bg-(--success-light) text-black rounded-sm hover:bg-(--success)"
    >
      Add Product
    </button>
  </div>

  <div class="overflow-auto bg-(--surface) border border-(--grey) rounded-md shadow-md">
    <table class="min-w-full divide-y">
      <thead class="bg-(--base)">
        <tr>
          <th class="px-4 py-2 text-left">ID</th>
          <th class="px-4 py-2 text-left">Name</th>
          <th class="px-4 py-2 text-left">Price</th>
          <th class="px-4 py-2 text-right">Actions</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-(--grey)">
        <template v-for="p in products" :key="p.productID">
          <template v-if="editingID === p.productID">
            <InlineEditableRow
              :value="editingRow"
              :onSave="(update) => saveEdit(p.productID, update)"
              :onCancel="cancelEdit"
            >
              <template #cols="{ row }">
                <td class="px-4 py-2 text-left">{{ row.productID }}</td>
                <td class="px-1">
                  <input
                    v-model="row.name"
                    type="text"
                    class="w-full h-full border-box bg-(--base) border border-(--grey) p-1"
                  />
                </td>
                <td class="px-1">
                  <input
                    v-model.number="row.price"
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
            <tr @click="toggleExpand(p.productID)" class="cursor-pointer hover:bg-(--base)">
              <td class="px-4 py-2 text-left">{{ p.productID }}</td>
              <td class="px-4 py-2 text-left">{{ p.name }}</td>
              <td class="px-4 py-2 text-left">{{ p.price }}</td>
              <td class="px-4 py-2 text-right space-x-2">
                <button
                  @click.stop="startEdit(p.productID)"
                  class="cursor-pointer px-1 py-1 bg-(--secondary) text-black rounded-sm hover:bg-(--secondary-light) transition"
                >
                  <Pencil />
                </button>
                <button
                  @click.stop="onRemove(p.productID)"
                  class="cursor-pointer px-1 py-1 bg-(--primary) text-black rounded-sm hover:bg-(--primary-light) transition"
                >
                  <X />
                </button>
              </td>
            </tr>
          </template>

          <tr v-if="expanded.has(p.productID)">
            <td colspan="4" class="bg-(--elevated) p-1">
              <table class="w-full divide-y divide-(--base)">
                <thead>
                  <tr>
                    <th class="py-1 text-sm">Ingredient</th>
                    <th class="py-1 text-sm">Quantity</th>
                    <th class="py-1 text-sm">Unit</th>
                  </tr>
                </thead>
                <tbody class="text-sm text-(--grey)">

                  <template v-if="editingID === p.productID">
                    <template v-for="i in (editingRow && editingRow.ingredients) || []" :key="i.ingredientID">
                      <InlineEditableDropdownRow v-if="i.ingredientID !== ''"
                        :value="i"
                        :onChange="(update) => updateIngredient(i.ingredientID, update)"
                        :onRemove="() => removeIngredient(i.ingredientID)"
                      >
                        <template #cols="{ row }">
                          <td class="py-1">{{ i.name }}</td>
                          <td class="px-1">
                            <input v-model.number="row.unitQuantityRequired" 
                              type="number" min="0" step="1" S
                              @input="row.unitQuantityRequired = Math.floor(row.unitQuantityRequired)"
                              class="h-full border-box bg-(--base) border border-(--grey) p-1"
                            />
                          </td>
                          <td class="px-1 text-left">{{ i.unit }}</td>
                        </template>
                      </InlineEditableDropdownRow>

                      <template v-else>
                        <tr>
                          <td>
                            <select
                              v-model.number="i.ingredientID"
                              @change="onNewIngredientSelect(i)"
                              class="rounded border border-grey-600 bg-(--base) p-2 focus:outline-none focus:ring-1 focus:ring-(--grey)"
                            >
                              <option disabled value="">Select one</option>
                              <option
                                v-for="ingr in ingredients.filter(ingr => !editingRow.ingredients.some(eri => eri.ingredientID === ingr.ingredientID))"
                                :key="ingr.ingredientID"
                                :value="ingr.ingredientID"
                              >
                                {{ ingr.name }}
                              </option>
                            </select>
                          </td>
                          <td>
                            <input
                              v-model.number="i.unitQuantityRequired"
                              type="number" min="0" step="1"
                              @input="i.unitQuantityRequired = Math.floor(i.unitQuantityRequired)"
                              placeholder="Qty"
                              class="rounded border border-grey-600 bg-(--base) p-2 focus:outline-none focus:ring-1 focus:ring-(--grey)"
                            />
                          </td>
                          <td></td>
                          <td>
                            <button @click="" class="cursor-pointer px-1 py-1 bg-(--primary) text-black rounded-sm hover:bg-(--success-light) transition">
                              <Trash />
                            </button>
                          </td>
                        </tr>
                      </template>
                    </template>
                    <tr>
                      <td colspan="4">
                        <div class="w-full flex justify-center my-1">
                          <button
                            type="button"
                            @click="editProductAddIngredient"
                            class="cursor-pointer flex hover:bg-(--base) rounded-sm transition text-(--success)"
                          >
                            <Plus /> Add Ingredient
                          </button>
                        </div>
                      </td>
                    </tr>
                  </template>

                  <template v-else>
                    <tr v-for="i in p.ingredients" :key="i.ingredientID">
                      <td class="py-1">{{ i.name }}</td>
                      <td class="py-1">{{ i.unitQuantityRequired }}</td>
                      <td class="py-1 text">{{ i.unit }}</td>
                    </tr>
                  </template>
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
        @submit.prevent="submitNewProduct()"
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
        <h3 class="text-xl font-semibold mb-6">Add New Product</h3>

        <label class="block mb-4">
          Name:
          <input
            v-model="newProduct.name"
            type="text"
            required
            class="mt-1 w-full rounded border border-grey-600 bg-(--base) p-2 focus:outline-none focus:ring-1 focus:ring-(--grey)"
          />
        </label>

        <label class="block mb-4">
          Price:
          <input
            v-model.number="newProduct.price"
            type="number"
            min="0"
            step="0.01"
            required
            class="mt-1 w-full rounded border border-grey-600 bg-(--base) p-2 focus:outline-none focus:ring-1 focus:ring-(--grey)"
          />
        </label>

        <label class="block mb-2">
          Ingredients:
          <div
            v-for="(ingredient, index) in newProduct.ingredients"
            :key="index"
            class="flex items-center gap-2 mt-1"
          >
            <select
              v-model.number="ingredient.ingredientID"
              class="w-1/2 rounded border border-grey-600 bg-(--base) p-2 focus:outline-none focus:ring-1 focus:ring-(--grey)"
            >
              <option disabled value="">Select one</option>
              <option
                v-for="ingr in ingredients"
                :key="ingr.ingredientID"
                :value="ingr.ingredientID"
              >
                {{ ingr.name }}
              </option>
            </select>
            <input
              v-model.number="ingredient.unitQuantityRequired"
              type="number"
              placeholder="Qty"
              class="w-1/2 rounded border border-grey-600 bg-(--base) p-2 focus:outline-none focus:ring-1 focus:ring-(--grey)"
            />
            <button
              type="button"
              @click="newProductRemoveIngredient(index)"
              class="cursor-pointer text-(--primary) hover:text-(--primary-light)"
            >
              <X />
            </button>
          </div>
        </label>

        <div class="w-full flex justify-end mb-6">
          <button
            type="button"
            @click="newProductAddIngredient"
            class="cursor-pointer flex hover:bg-(--base) rounded-sm transition"
          >
            <Plus /> Add Ingredient
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
