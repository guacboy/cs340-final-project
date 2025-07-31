<script setup>
import { ref } from 'vue'

const sections = ref([
  { name: 'products',    label: 'Products',    path: '/products' },
  { name: 'sales',       label: 'Sales',       path: '/sales' },
  { name: 'ingredients', label: 'Ingredients', path: '/ingredients' },
  { name: 'suppliers',   label: 'Suppliers',   path: '/suppliers' },
])
</script>


<template>
  <div class="flex flex-col items-center p-8 space-y-6">
    <h1 class="text-4xl font-extrabold text-(--primaryText)">Lemonade Co. Management System</h1>
    <p class="text-(--secondaryText)">Choose a section to manage:</p>
    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 w-full max-w-md">
      <RouterLink
        v-for="item in sections"
        :key="item.name"
        :to="item.path"
        class="block text-center p-6 bg-(--elevated) text-(--secondary-light) hover:text-(--primary-light) rounded-md shadow hover:shadow-md transition"
      >
        <span class="text-2xl font-semibold">{{ item.label }}</span>
      </RouterLink>
    </div>
  </div>
</template>

