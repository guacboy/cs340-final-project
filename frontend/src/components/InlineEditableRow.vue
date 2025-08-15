<script setup>
import { reactive, watch, toRaw, onUnmounted } from 'vue';
import { Save, Undo2 } from 'lucide-vue-next';

const props = defineProps({
  value: { type: Object, required: true },
  onSave: { type: Function, required: true },
  onCancel: { type: Function, required: true }
});

// local copy
const editCopy = reactive(JSON.parse(JSON.stringify(toRaw(props.value))));

watch(
  () => props.value,
  (val) => Object.assign(editCopy, JSON.parse(JSON.stringify(toRaw(val)))),
  { immediate: true }
);

function save() {
  props.onSave(JSON.parse(JSON.stringify(toRaw(editCopy))));
}
</script>

<template>
  <tr>
    <slot name="cols" :row="editCopy"></slot>
    <td class="px-4 py-2 text-right space-x-2">
      <button @click="save" class="cursor-pointer px-1 py-1 bg-(--success) text-black rounded-sm hover:bg-(--success-light) transition">
        <Save />
      </button>
      <button @click="onCancel()" class="cursor-pointer px-1 py-1 bg-(--secondary) text-black rounded-sm hover:bg-(--secondary-light) transition">
        <Undo2 />
      </button>
    </td>
  </tr>
</template>
