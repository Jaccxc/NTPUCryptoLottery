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
const { account, totalBalance, prizeBalance, charityBalance } = storeToRefs(cryptoStore)
</script>

<template>
  <div class="lowest">
    <div class="flex flex-col items-center">
      <h1 class="text-2xl m-4">
        Lottery
      </h1>
      <button v-if="!account" class="bg-purple-300 rounded p-4 rounded-30" @click="connectWallet">
        <h1 class="m-0 text-dark">
          Connect Wallet To Buy
        </h1>
      </button>
      <div v-if="account" class="mt-5">
        Numbers:
        <input
          v-model="a"
          name="a"
          class="py-4 px-4  shadow border rounded m-10"
          maxlength="20"
          style="width:70px; height: 60px; font-size: 26px; background-color: #00000000; text-align: center;"
        >
        <input
          v-model="b"
          name="b"
          class="py-4 px-4  shadow border rounded m-10"
          maxlength="20"
          style="width:70px; height: 60px; font-size: 26px; background-color: #00000000; text-align: center;"
        >
        <input
          v-model="c"
          name="c"
          class="py-4 px-4  shadow border rounded m-10"
          maxlength="20"
          style="width:70px; height: 60px; font-size: 26px; background-color: #00000000; text-align: center;"
        >
        <input
          v-model="d"
          name="d"
          class="py-4 px-4  shadow border rounded m-10"
          maxlength="20"
          style="width:70px; height: 60px; font-size: 26px; background-color: #00000000; text-align: center;"
        >
        <input
          v-model="e"
          name="e"
          class="py-4 px-4  shadow border rounded m-10"
          maxlength="20"
          style="width:70px; height: 60px; font-size: 26px; background-color: #00000000; text-align: center;"
        >
        <input
          v-model="f"
          name="f"
          class="py-4 px-4  shadow border rounded m-10"
          maxlength="20"
          style="width:70px; height: 60px; font-size: 26px; background-color: #00000000; text-align: center;"
        >
        <div>
          Money (in ETH):
          <input
            v-model="money"
            name="money"
            class="py-4 px-4  shadow border rounded m-10"
            maxlength="20"
            style="width:120px; height: 60px; color: black; font-size: 20px; text-align: center;"
          >
        </div>
        <button class="bg-yellow-300 rounded p-5 mt-10 text-black" @click="Enter(money, a, b, c, d, e, f)">
          Buy
        </button>
      </div>

      <div v-if="account" class="rounded rounded-5 shadow w-3/12 p-4 mt-10">
        <h3 class="text-xl">
          Current Total Balance: {{ totalBalance }}
        </h3>
        <br>
        <h3 class="text-xl">
          Current Prize Balance: {{ prizeBalance }}
        </h3>
        <br>
        <h3 class="text-xl">
          Current Charity Balance: {{ charityBalance }}
        </h3>
      </div>
    </div>
  </div>
</template>

<route lang="yaml">
meta:
  layout: home
</route>
