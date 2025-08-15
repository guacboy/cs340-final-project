<script setup>
import { reactive, onUnmounted, watch, toRaw } from 'vue';
import { Trash } from 'lucide-vue-next';

const props = defineProps({
  value: { type: Object, required: true },
  onRemove: { type: Function, required: true },
  onChange: { type: Function, required: true }
});

// local copy
const editCopy = reactive(JSON.parse(JSON.stringify(toRaw(props.value))));

watch(
  () => props.value,
  (val) => Object.assign(editCopy, JSON.parse(JSON.stringify(toRaw(val)))),
  { immediate: true }
);

let changeTimeout = null;

onUnmounted(() => {
  if (changeTimeout) clearTimeout(changeTimeout);
});

watch(
  editCopy,
  (newVal) => {
    if (changeTimeout) clearTimeout(changeTimeout);
    changeTimeout = setTimeout(() => {
      props.onChange(JSON.parse(JSON.stringify(toRaw(newVal))));
    }, 150);
  },
  { deep: true }
);


function remove() {
  props.onRemove(JSON.parse(JSON.stringify(toRaw(editCopy))));
}
</script>

<template>
  <tr>
    <slot name="cols" :row="editCopy"></slot>
    <td class="px-4 py-2 text-right space-x-2">
      <button @click="remove()" class="cursor-pointer px-1 py-1 bg-(--primary) text-black rounded-sm hover:bg-(--primary-light) transition">
        <Trash />
      </button>
    </td>
  </tr>
</template>
