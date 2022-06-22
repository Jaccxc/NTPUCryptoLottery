<script setup lang="ts">
import { storeToRefs } from 'pinia'
import { useCryptoStore } from '~/store/crypto'
const money = ref(null as any)
const a = ref(null as any)
const b = ref(null as any)
const c = ref(null as any)
const d = ref(null as any)
const e = ref(null as any)
const f = ref(null as any)
const cryptoStore = useCryptoStore()
const { Enter, connectWallet } = useCryptoStore()
const { account, totalBalance, prizeBalance, charityBalance, charityAddress } = storeToRefs(cryptoStore)
</script>

<template>
  <div class="flex flex-col items-center">
    <h1 class="text-2xl m-4">
      NTPU Blockchain Charity Lottery
    </h1>
    <button v-if="!account" class="bg-green-300 rounded p-4" @click="connectWallet">
      Connect Wallet
    </button>
    <div v-if="account" class="mt-5">
      <input
        v-model="a"
        name="a"
        class="py-4 px-4  shadow border rounded"
        maxlength="20"
      >
      <input
        v-model="b"
        name="b"
        class="py-4 px-4  shadow border rounded"
        maxlength="20"
      >
      <input
        v-model="c"
        name="c"
        class="py-4 px-4  shadow border rounded"
        maxlength="20"
      >
      <input
        v-model="d"
        name="d"
        class="py-4 px-4  shadow border rounded"
        maxlength="20"
      >
      <input
        v-model="e"
        name="e"
        class="py-4 px-4  shadow border rounded"
        maxlength="20"
      >
      <input
        v-model="f"
        name="f"
        class="py-4 px-4  shadow border rounded"
        maxlength="20"
      >
      <input
        v-model="money"
        name="money"
        class="py-4 px-4  shadow border rounded"
        maxlength="20"
      >
      <button class="bg-yellow-300 rounded p-4 mt-10" @click="Enter(money, a, b, c, d, e, f)">
        Buy
      </button>
    </div>

    <div v-if="account" class="border shadow  w-4/12 p-4 mt-10">
      <h3 class="text-2xl">
        Current Total Balance: {{ totalBalance }}
      </h3>
      <h3 class="text-2xl">
        Current Prize Balance: {{ prizeBalance }}
      </h3>
      <h3 class="text-2xl">
        Current Charity Balance: {{ charityBalance }}
      </h3>
    </div>
    <span> Current charity organizations: </span>
    <div v-for="(address, idx) in charityAddress" :key="idx" class="flex flex-col m-auto ">
      <span>{{ address }}</span>
    </div>
  </div>
</template>

<route lang="yaml">
meta:
  layout: home
</route>
