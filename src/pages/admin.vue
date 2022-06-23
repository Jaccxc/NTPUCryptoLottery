<script setup lang="ts">
import { storeToRefs } from 'pinia'
import { useCryptoStore } from '~/store/crypto'
const inputString = ref(null as any)
const a = ref(null as any)
const b = ref(null as any)
const c = ref(null as any)
const d = ref(null as any)
const e = ref(null as any)
const f = ref(null as any)
const cryptoStore = useCryptoStore()
const { addCharityAddress, connectWallet, customPickWinner } = useCryptoStore()
const { account, totalBalance, prizeBalance, charityBalance, charityAddress } = storeToRefs(cryptoStore)
</script>

<template>
  <div class="lowest">
    <div class="flex flex-col items-center">
      <h1 class="text-2xl m-4">
        Admin
      </h1>
      <button v-if="!account" class="bg-purple-300 rounded p-4 rounded-30" @click="connectWallet">
        <h1 class="m-0 text-dark">
          Connect Wallet To Use Admin functions
        </h1>
      </button>
      <div v-if="account" class="mt-5">
        <input
          v-model="inputString"
          name="a"
          class="py-4 px-4  shadow border rounded"
          maxlength="256"
          style="color:black; width: 400px;"
        >
        <button class="bg-yellow-300 rounded p-4 mt-10 text-dark" @click="addCharityAddress(inputString)">
          Add Charity Address
        </button>
      </div>

      <div v-if="account" class="mt-5">
        Numbers:
        <input
          v-model="a"
          name="a"
          class="py-4 px-4  shadow border rounded m-10"
          maxlength="20"
          style="width: 70px; height: 60px; font-size: 26px; background-color: #00000000; text-align: center;"
        >
        <input
          v-model="b"
          name="b"
          class="py-4 px-4  shadow border rounded m-10"
          maxlength="20"
          style="width: 70px; height: 60px; font-size: 26px; background-color: #00000000; text-align: center;"
        >
        <input
          v-model="c"
          name="c"
          class="py-4 px-4  shadow border rounded m-10"
          maxlength="20"
          style="width: 70px; height: 60px; font-size: 26px; background-color: #00000000; text-align: center;"
        >
        <input
          v-model="d"
          name="d"
          class="py-4 px-4  shadow border rounded m-10"
          maxlength="20"
          style="width: 70px; height: 60px; font-size: 26px; background-color: #00000000; text-align: center;"
        >
        <input
          v-model="e"
          name="e"
          class="py-4 px-4  shadow border rounded m-10"
          maxlength="20"
          style="width: 70px; height: 60px; font-size: 26px; background-color: #00000000; text-align: center;"
        >
        <input
          v-model="f"
          name="f"
          class="py-4 px-4  shadow border rounded m-10"
          maxlength="20"
          style="width: 70px; height: 60px; font-size: 26px; background-color: #00000000; text-align: center;"
        >
        <button class="bg-yellow-300 rounded p-5 mt-10 text-black" @click="customPickWinner(a, b, c, d, e, f)">
          Set Custom Winner
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
