<script setup>
import { ref } from "vue";
import axios from "axios";
import { RotateCcw } from "lucide-vue-next";

const isResetting = ref(false);

async function resetDB() {
  isResetting.value = true;
  const res = await axios.post("/api/reset");
  isResetting.value = false;
}
</script>

<template>
  <div class="flex">
    <button
      :disabled="isResetting"
      @click="resetDB"
      class="flex space-x-2 p-2 text-center bg-(--primary) rounded-sm shadow hover:bg-(--elevated) hover:shadow-md transition"
    >
      <RotateCcw />
      <span class="text-black)"> Reset DB </span>
    </button>
  </div>
</template>
