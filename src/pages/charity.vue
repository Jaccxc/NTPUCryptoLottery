<script setup lang="ts">
import { storeToRefs } from 'pinia'
import { useCryptoStore } from '~/store/crypto'
const cryptoStore = useCryptoStore()
const { account, charityAddress } = storeToRefs(cryptoStore)
</script>

<template>
  <div class="lowest">
    <div class="flex flex-col items-center">
      <h1 class="text-2xl m-4">
        Charity
      </h1>
      <div v-if="account" class="border shadow  w-4/12 p-4 mt-10">
        <span> Current charity organizations: </span>
        <div v-for="(address, idx) in charityAddress" :key="idx" class="flex flex-col m-auto ">
          <span>{{ address }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<route lang="yaml">
meta:
  layout: home
</route>
