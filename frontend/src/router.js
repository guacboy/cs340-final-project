import { createRouter, createWebHistory } from "vue-router";

import Home from "./views/Home.vue";
import Products from "./views/Products.vue";
import Suppliers from "./views/Suppliers.vue";
import Ingredients from "./views/Ingredients.vue";
import Sales from "./views/Sales.vue";

const routes = [
  { path: "/", name: "Home", component: Home },
  { path: "/products", name: "Products", component: Products },
  { path: "/suppliers", name: "Suppliers", component: Suppliers },
  { path: "/ingredients", name: "Ingredients", component: Ingredients },
  { path: "/sales", name: "Sales", component: Sales },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
