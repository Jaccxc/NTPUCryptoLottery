<script setup lang="ts">
</script>

<template>
  <div class="lowest">
    <div class="flex flex-col items-center">
      <h1 class="text-2xl m-4">
        NTPU Blockchain Charity Lottery
      </h1>

      <RouterLink class="rounded bg-white text-black text-center rounded-40" to="/lottery" style="height: 40px; width: 120px; float:right; margin: 7.5px; margin-top: 30px;">
        <div style="margin-top: 8px">
          Lottery
        </div>
      </RouterLink>
      <RouterLink class="rounded bg-white text-black text-center rounded-40" to="/charity" style="height: 40px; width: 120px; float:right; margin: 7.5px; margin-top: 20px;">
        <div style="margin-top: 8px">
          Charity
        </div>
      </RouterLink>
    </div>
  </div>
</template>

<route lang="yaml">
meta:
  layout: home
</route>
