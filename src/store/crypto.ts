import { ethers } from 'ethers'
import { acceptHMRUpdate, defineStore } from 'pinia'
import contractABI from '../artifacts/contracts/lottery.sol/Lottery.json'
const contractAddress = '0xd084441617a9b470DA8899812Ff1c6Dd72b6ba7C'

/* eslint no-var: off */
declare var window: any

export const useCryptoStore = defineStore('user', () => {
  const account = ref(null)
  const charityAddress = ref([] as any)
  const loading = ref(false)
  const totalBalance = ref('')
  const prizeBalance = ref('')
  const charityBalance = ref('')

  async function getBalance() {
    setLoader(true)
    try {
      const { ethereum } = window
      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum)
        const signer = provider.getSigner()
        const lotteryContract = new ethers.Contract(contractAddress, contractABI.abi, signer)
        const balance = (await lotteryContract.getBalance())
        const amt = ethers.utils.formatEther(balance)
        console.log('balance: ', amt)
        totalBalance.value = amt
        setLoader(false)
      }
    }
    catch (e) {
      setLoader(false)
      console.log('e', e)
    }
  }

  async function getPrize() {
    setLoader(true)
    try {
      const { ethereum } = window
      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum)
        const signer = provider.getSigner()
        const lotteryContract = new ethers.Contract(contractAddress, contractABI.abi, signer)
        const prize = (await lotteryContract.getprize())
        const amt = ethers.utils.formatEther(prize)
        console.log('prize: ', amt)
        prizeBalance.value = amt
        setLoader(false)
      }
    }
    catch (e) {
      setLoader(false)
      console.log('e', e)
    }
  }

  async function getCharity() {
    setLoader(true)
    try {
      const { ethereum } = window
      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum)
        const signer = provider.getSigner()
        const lotteryContract = new ethers.Contract(contractAddress, contractABI.abi, signer)
        const charity = (await lotteryContract.getCharity())
        const amt = ethers.utils.formatEther(charity)
        console.log('charity: ', amt)
        charityBalance.value = amt
        setLoader(false)
      }
    }
    catch (e) {
      setLoader(false)
      console.log('e', e)
    }
  }

  async function getCharityAddress() {
    setLoader(true)
    try {
      const { ethereum } = window
      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum)
        const signer = provider.getSigner()
        const lotteryContract = new ethers.Contract(contractAddress, contractABI.abi, signer)
        const charityAddressRaw = (await lotteryContract.getCharity_Address())
        console.log('charity: ', charityAddressRaw)
        const charityAddressParsed = [] as any
        charityAddressRaw.forEach((data: string) => {
          charityAddressParsed.push(data)
        })
        charityAddress.value = charityAddressParsed
        setLoader(false)
      }
    }
    catch (e) {
      setLoader(false)
      console.log('e', e)
    }
  }

  async function addCharityAddress(address: string) {
    setLoader(true)
    try {
      const { ethereum } = window
      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum)
        const signer = provider.getSigner()
        const lotteryContract = new ethers.Contract(contractAddress, contractABI.abi, signer)
        await lotteryContract.charity_add_address(address)
        console.log('charity address added: ', address)
        setLoader(false)
      }
    }
    catch (e) {
      setLoader(false)
      console.log('e', e)
    }
  }

  async function Enter(money: string, a: any, b: any, c: any, d: any, e: any, f: any) {
    console.log('setting loader')
    setLoader(true)
    try {
      console.log('got 6 number: ', a, b, c, d, e, f)
      console.log('with bet amount of ', money, ' Ether')
      const { ethereum } = window
      if (ethereum) {
        // create provider object from ethers library, using ethereum object injected by metamask
        const provider = new ethers.providers.Web3Provider(ethereum)
        const signer = provider.getSigner()
        const lotteryContract = new ethers.Contract(contractAddress, contractABI.abi, signer)

        const overrides = {
          value: ethers.utils.parseEther(money), // sending one ether
        }

        /*
     * Execute the actual wave from your smart contract
     */
        const lotteryTxn = await lotteryContract.enter(a, b, c, d, e, f, overrides)
        console.log('Mining...', lotteryTxn.hash)
        await lotteryTxn.wait()
        console.log('Mined -- ', lotteryTxn.hash)

        money = '0'
        setLoader(false)
      }
      else {
        console.log('Ethereum object doesn\'t exist!')
      }
    }
    catch (error) {
      setLoader(false)
      console.log(error)
    }
  }

  async function connectWallet() {
    try {
      const { ethereum } = window
      if (!ethereum) {
        /* eslint no-alert: off */
        alert('Must connect to MetaMask!')
        return
      }
      const myAccounts = await ethereum.request({ method: 'eth_requestAccounts' })
      getBalance()
      getCharity()
      getPrize()
      getCharityAddress()
      console.log('Connected: ', myAccounts[0])
      account.value = myAccounts[0]
    }
    catch (error) {
      console.log(error)
    }
  }

  function setLoader(value: boolean) {
    console.log('setLoader', value)
    loading.value = value
  }

  return {
    setLoader,
    getBalance,
    getPrize,
    getCharity,
    addCharityAddress,
    getCharityAddress,
    Enter,
    loading,
    connectWallet,
    account,
    charityAddress,
    totalBalance,
    charityBalance,
    prizeBalance,
  }
})

if (import.meta.hot)
  import.meta.hot.accept(acceptHMRUpdate(useCryptoStore, import.meta.hot))
