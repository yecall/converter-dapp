<template>
  <div class="app">
    <div class="home-contain" v-if="!account">
    <div class="header">
      <div class="title">YeeCo转换网关</div>
      <div class="tips">将YEE-ERC20转换为YEE-YeeCo</div>
    </div>
    <div class="main"> 
      <div class="mainBox">
        <div class="title" >请登录以太坊钱包</div>
        <div class="tips">未检测到钱包？</div>
        <div class="wallet"></div>
        <div class="button" @click="login">登录钱包</div>
      </div>
    <div class="explain">
      <div class="title">转换说明</div>
      <div class="content">
        1. 仅支持YEE-ERC20转换为YEE-YEECO，不支持逆向转换 <br />
        2. 转换后的YEE-YEECO将在主网上线后3个工作日内收到<br />
        3. 1个ERC20地址仅能绑定1个YEECO主网地址，且无法修改<br />
        4. YEE转换网关采用智能合约实现，转换时需要消耗一定ETH作为GAS费<br />
      </div>
    </div>
    </div>
    
  </div>
  <div class="transfer-contain" v-else>
    <div class="header">
      <div class="title">YeeCo转换网关</div>
      <div class="tips">将YEE-ERC20转换为YEE-YeeCo</div>
      <div class="address">{{account}}</div>
    </div>
    <div class="main">
      <div class="mainBox">
        <div class="tips">如何获得主网地址？</div>
        <div class="title">请输入你的YeeCo主网钱包地址</div>
        <div class="walletAddress" v-if="serveAddress">
          {{YeeCoaddress}}
        </div>
        <my-input v-else class="input"  placeholder="eg: yeexdsdfsf" v-model="YeeCoaddress" />
        <div class="info">累计已登记：{{amountPrice}} YEE-YeeCo</div>
        <div class="heng"></div>
        <my-input class="input" textRight="YEE-ERC20" :disabled="approveStatus !== 0" v-model="transferPrice" placeholder="请输入转换数量" type="number" :precision="1" />
        <div class="info">剩余：{{balancePrice}} YEE-ERc20可转换</div>
         <div class="button" :class="{ disabled: approveStatus > 0 }" @click="confirmAuth" v-if="approveStatus <= 1">
            {{
              approveStatus === 1 ? '授权确认中' : '确认授权'
            }}
          </div>
          <div class="button" :class="{ disabled: transferStatus > 0 }" @click="transfer" v-else>
             {{
              transferStatus === 1 ? '确认登记中...' : transferStatus === 0 ? '确认登记' : '登记已完成'
            }}
          </div>
      </div>
    <div class="explain">
      <div class="title">转换说明</div>
      <div class="content">
        1. 仅支持YEE-ERC20转换为YEE-YEECO，不支持逆向转换 <br />
        2. 转换后的YEE-YEECO将在主网上线后3个工作日内收到<br />
        3. 1个ERC20地址仅能绑定1个YEECO主网地址，且无法修改<br />
        4. YEE转换网关采用智能合约实现，转换时需要消耗一定ETH作为GAS费<br />
        <br />
        <br />
      </div>
    </div>
    </div>
    </div>
  </div>
</template>
<script>
import MyInput from "../components/MyInput";
import bech32 from "bech32"
import converter from '../config/converter.json'
import tokenConfig from '../config/token.json'
import { converterAdress, tokenAdress, testAdress } from '../config/index'
import NP from 'number-precision'
const Web3 = window.Web3
export default {
  name: 'App',
  data() {
    return {
      transferStatus: 0,
      approveStatus: 0,
      transferPrice: '',
      YeeCoaddress: '',
      serveAddress: '',
      tokenContext: null,
      contractContext: null,
      account: '',
      amountPrice: '',
      allowancePrice: '',
      balancePrice: '',
    }
  },
  components: {
    MyInput
  },
  async created() {
    if (typeof window.web3 === "undefined") {
      alert('未检测到Web3环境，请使用集成以太坊钱包的浏览器查看');
      return;
    }
      await this.login(async () => {
        const token = window.web3.eth.contract(tokenConfig)
        this.tokenContext = token.at(tokenAdress)
        const contract = window.web3.eth.contract(converter)
        this.contractContext =  contract.at(converterAdress)
        this.converterFn()
        await this.getAllowancePrice()
        this.checkHasAddress()
        this.getblance()
      })
  },
  methods: {
    async confirmAuth() {
      if(this.approveStatus > 0) return
      const res = this.checkAdress()
      if(!res) {
        return alert('YeeCo主网地址错误')
      }
      if(res && this.transferPrice) {
        await this.approve()
      }
    },
    checkHasAddress() {
      this.contractContext.chainAddressMap(this.account, (e,a) => {
        if(!e) {
          const [res, address] = a
          if(res) {
            this.YeeCoaddress = address
            this.serveAddress = address
          }
        }
      })
    }, 
    converterFn() {
      console.log(this.account)
      this.contractContext.amountMap(this.account,(e, a) => {
        if(!e) {
          console.log(a.toNumber())
          this.amountPrice =  NP.divide(a.toNumber(), 1e18)
        }
      })
    },
    getAllowancePrice() {
      return new Promise((resolve, reject) => {
        this.tokenContext.allowance(testAdress,tokenAdress,(e, a) => {
          if(!e) {
            this.allowancePrice =  NP.divide(a.toNumber(), 1e18)
            resolve(this.allowancePrice)
          } else {
            reject(e)
          }
        })
      })
    },
    async transfer() {
      if(this.transferStatus > 0) return
      await this.transferFn()
    },
     checkAdress() {
       const address = this.YeeCoaddress
       let res
       try {
         res = bech32.decode(address)
       } catch (error){
         return false
       }
       if(res.prefix === 'yee' && res.words.length === 32) {
         return true
       }
     },
     transferFn() {
      return new Promise((resolve, reject) => {
        const transferPrice = this.transferPrice * 1e18
        this.transferStatus = 1
        this.contractContext.checkIn(transferPrice, this.YeeCoaddress, (e,a) => {
          if(!e) {
            this.contractContext.CheckIn((error, result) => {
              if(result.transactionHash === a) {
                this.transferStatus = 2
              } 
          })
            resolve(a)  
          } else {
            reject(e)
          }
        })
      })
    },
    approve() {
      return new Promise((resolve) => {
        this.approveStatus = 1
        const transferPrice = Number(this.transferPrice) * 1e18
        this.tokenContext.approve(converterAdress, transferPrice, (e,a) => {
          if(!e) {
            resolve(a)
             this.tokenContext.Approval((error, result) => {
                if(result.transactionHash === a) {
                  this.approveStatus = 2
                } 
            })
          }
        })
        return
      })
    },
    getblance() {
      return new Promise((resolve, reject) => {
        this.tokenContext.balanceOf(testAdress, (e,a) => {
          if(!e) {
            console.log(a.toNumber())
            this.balancePrice =  NP.divide(a.toNumber(), 1e18)
            resolve(this.balancePrice)
          } else {
            reject(e)
          }
        })
      })
    },
    async login(callback) {
      let web3Provider;
      if (window.ethereum) {
        web3Provider = window.ethereum;
        try {
          await window.ethereum.enable();
        } catch (error) {
          console.error("User denied account access")
        }
      } else if (window.web3) {   // 老版 MetaMask Legacy dapp browsers...
        web3Provider = window.web3.currentProvider;
      } else {
        web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
      }
      const web3js = new Web3(web3Provider); //web3js就是你需要的web3实例
      web3js.eth.getAccounts( (error, result) => {
        if (!error)
          this.account = result[0]
          callback()
      });
    }
  }
}
</script>

<style lang="stylus" scoped>
.button{
  padding 37px 0
  background-color: #2e394b;
  box-shadow: 6px 10px 36px 0px rgba(46, 57, 75, 0.36);
  border-radius: 4px;
  color #ffffff
  font-size: 30px;
  text-align center
  position relative
  z-index 1
  &.disabled{
    opacity 0.7
  }
 }
.home-contain{
  min-height 100vh
  background-color #ebedf0
  .main{
    margin  0 auto
  }
  .mainBox{
    .title{
      font-family: PingFangSC-Medium;
      font-size: 30px;
      letter-spacing: 0px;
      line-height: 50px;
      color: #2e394b;
    }
    .tips{
      font-size: 24px;
      line-height: 50px;
      color: #0c68ff;
    }
    .wallet{
      background url('../assets/wallet.png')
      width 220px
      height 212px
      background-size cover
      margin 100px auto 75px
    }
    padding 40px
    box-sizing border-box
    width: 690px;
    background-color: #ffffff;
    box-shadow: 6px 10px 42px 0px rgba(46, 57, 75, 0.04);
    border-radius: 4px;
    margin 0 auto
    position relative
    top -78px
  }
  .explain{
    margin-left 29px
    margin-right 49px
    .title{
      height: 29px;
      font-family: PingFangSC-Medium;
      font-size: 30px;
      color: #2e394b;
    }
    .content {
      margin-top 28px
      font-size: 24px;
      line-height: 38px;
      color: #7c838d;
    }
  }
}
.transfer-contain{
  min-height 100vh
  background-color #ebedf0
  .main{
    margin  0 auto
  }
  .mainBox{
    .title{
      font-family: PingFangSC-Medium;
      font-size: 30px;
      letter-spacing: 0px;
      line-height: 50px;
      color: #2e394b;
      margin-bottom 23px
    }
    .walletAddress{
      margin-bottom 27px
    }
    .input{
      margin-bottom 27px
    }
    .tips{
      font-size: 24px;
      line-height: 50px;
      color: #0c68ff;
    }
    .walletAddress{
      height: 92px;
      line-height 92px
      box-sizing border-box
      padding-left 33px
      background-color: rgba(12, 104, 255, 0.1);
      border-radius: 4px;
      border-left #0c68ff 6px solid 
      color #0c68ff
    }
    .info{
      font-size: 24px;
      color: #2e394b;
      margin-bottom 64px
    }
    .heng{
      height: 1PX;
      background-color: #e1e3e6;
      margin-bottom 64px
    }
    .wallet{
      background url('../assets/wallet.png')
      width 220px
      height 212px
      background-size cover
      margin 100px auto 75px
    }
    padding 40px
    box-sizing border-box
    background-color: #ffffff;
    box-shadow: 6px 10px 42px 0px rgba(46, 57, 75, 0.04);
    border-radius: 4px;
    position relative
    top -78px
  }
  .explain{
    margin-left 29px
    margin-right 49px
    .title{
      height: 29px;
      font-family: PingFangSC-Medium;
      font-size: 30px;
      color: #2e394b;
    }
    .content {
      margin-top 28px
      font-size: 24px;
      line-height: 38px;
      color: #7c838d;
    }
  }
}
.header{
  width 750px
  height 400px
  overflow hidden
  background url('../assets/bg.png') no-repeat, linear-gradient(47deg, #232931 0%, #474a57 100%);
  background-size cover
  .title{
    font-size: 52px;
    color: #ffffff;
    margin-left 30px
    margin-top 94px
  }
  .tips{
    margin-left 30px
    font-size: 24px;
    line-height: 50px;
    color: #ffffff;
    opacity: 0.6;
  }
  .address{
    margin-left 30px
    background #42464e
    font-size: 26px;
    display inline-block
    line-height 57px
    padding 0 20px
    height: 54px;
    border-radius: 27px;
    border: solid 2px #edf1f521
    color: #ffffff;
  }
}
</style>
