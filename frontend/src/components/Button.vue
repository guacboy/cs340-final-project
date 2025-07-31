<script setup>
import { ArrowBigLeft } from 'lucide-vue-next'
</script>


<template>
  <div class="flex min-w-xl">
    <RouterLink 
      to="/"
      class="flex space-x-2 p-2 text-center bg-(--surface) rounded-sm shadow hover:bg-(--elevated) hover:shadow-md transition"
    >
      <ArrowBigLeft />
      <span class="text-(--white)">
        Back
      </span>
    </RouterLink>
  </div>
</template>
