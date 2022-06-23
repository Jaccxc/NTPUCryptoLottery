<script setup lang="ts">
// https://github.com/vueuse/head
// you can use this to manipulate the document head in any components,
// they will be rendered correctly in the html results with vite-ssg

import { storeToRefs } from 'pinia'
import { useCryptoStore } from '~/store/crypto'
const cryptoStore = useCryptoStore()
const { connectWallet } = useCryptoStore()
const { account } = storeToRefs(cryptoStore)

useHead({
  title: 'Vitesse',
  meta: [
    { name: 'description', content: 'Opinionated Vite Starter Template' },
    {
      name: 'theme-color',
      content: computed(() => isDark.value ? '#00aba9' : '#ffffff'),
    },
  ],
  link: [
    {
      rel: 'icon',
      type: 'image/svg+xml',
      href: computed(() => preferredDark.value ? '/favicon-dark.svg' : '/favicon.svg'),
    },
  ],
})
</script>

<template>
  <div class="head">
    <div class="button1 text-white" style="padding-left:30px">
      <RouterLink class="rounded" to="/about" style="height: 40px; width: 120px; float:right; margin: 7.5px; margin-left: 30px;">
        About Us
      </RouterLink>
    </div>
    <div class="button2 text-white" style="padding-left:30px">
      <button v-if="!account" class="rounded border border-white border-3 rounded-90" style="height: 30px; width: 170px; float:right; margin-top: 5px;" @click="connectWallet">
        Connect Wallet
      </button>
      <button v-if="account" class="rounded border border-white border-3 rounded-90" style="height: 30px; width: 140px; float:right; margin-top: 5px;">
        Connected!
      </button>
    </div>
  </div>
  <RouterView />
</template>

<style>
  .head{
    height: 40px;
    background-color: #00000040;
  }
</style>
