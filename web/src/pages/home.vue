<template>
  <div class="app">
    <div class="home-contain" v-if="!account">
    <div class="header">
      <div class="title">YeeCo转换网关</div>
      <div class="tips">将YEE-Erc20转换为YEE-YeeCo</div>
    </div>
    <div class="main"> 
      <div class="mainBox">
        <div class="title" >请登录以太坊钱包</div>
        <a class="tips" href="https://github.com/yeeco/wiki/wiki/YeeCo%E8%BD%AC%E6%8D%A2%E7%BD%91%E5%85%B3%E4%BD%BF%E7%94%A8%E8%AF%B4%E6%98%8E">未检测到钱包？</a>
        <div class="wallet"></div>
        <div class="button" @click="login">登录钱包</div>
      </div>
    <div class="explain">
      <div class="title">转换说明</div>
      <div class="content">
        1. 转换后的YEE-YeeCo暂不支持在交易所充提，具体支持日期后续公布<br />
        2. 仅支持YEE-Erc20转换为YEE-YeeCo，不支持逆向转换<br />
        3. 转换网关采用每7天一个周期进行登记并统一进行转换，每周五0:00为登记截止日期，7天内在网关登记的记录将在下周二前完成转换。届时请前往绑定的YeeCo主网钱包地址查收转换的YEE-YeeCo<br />
        4. 1个Erc20地址仅能绑定1个YeeCo主网地址，且无法修改<br />
        5. YEE转换网关采用智能合约实现，转换时需要消耗少量ETH作为GAS费，为保证转换成功，请确保Erc20地址中持有一定ETH<br />
        6. 转换网关将于2020年08月31日截止登记，截止后将无法通过网关进行登记转换<br />
        <br />
        <br />
      </div>
    </div>
    </div>
    
  </div>
  <div class="transfer-contain" v-else>
    <div class="header">
      <div class="title">YeeCo转换网关</div>
      <div class="tips">将YEE-ER20转换为YEE-YeeCo</div>
      <div class="address">{{account}}</div>
    </div>
    <div class="main">
      <div class="mainBox">
        <div v-if="!serveAddress">
          <a class="tips" href="https://github.com/yeeco/wiki/wiki/YeeCo%E8%BD%AC%E6%8D%A2%E7%BD%91%E5%85%B3%E4%BD%BF%E7%94%A8%E8%AF%B4%E6%98%8E">如何获得主网地址？</a>
          <div class="title">请输入你的YeeCo主网钱包地址</div>
        </div>
        <div v-else-if="serveAddress && approveStatus === 0">
          <div class="title">请输入转换数量后确认授权</div>
        </div>
        <div v-else-if="approveStatus === 1">
          <div class="title">请等待授权确认后，登记转换</div>
        </div>
        <div v-else-if="approveStatus === 2 && transferStatus === 0">
          <div class="title">请确认登记</div>
        </div>
        <div class="walletAddress" v-if="serveAddress">
          {{YeeCoaddress}}
        </div>
        <my-input v-else class="input" :disabled="approveStatus !== 0" placeholder="eg. yee开头的62位字符串" v-model="YeeCoaddress" />
        <div class="info">累计已登记：{{amountPrice}} YEE-YeeCo</div>
        <div class="heng"></div>
        <my-input class="input" textRight="YEE-Erc20" v-if="approveStatus === 0" v-model="transferPrice" placeholder="请输入转换数量" type="number" :precision="2" />
         <div class="walletAddress" v-else>
          <div class="number">{{transferPrice}}</div>
          <div class="textRight">YEE-Erc20</div>
        </div>
        <div class="info">剩余：{{balancePrice}} YEE-Erc20可转换</div>
         <div class="button" :class="{ disabled: approveStatus > 0 }" @click="confirmAuth" v-if="approveStatus <= 1">
            {{
              approveStatus === 1 ? '授权确认中...' : '确认授权'
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
        1. 转换后的YEE-YeeCo暂不支持在交易所充提，具体支持日期后续公布<br />
        2. 仅支持YEE-Erc20转换为YEE-YeeCo，不支持逆向转换<br />
        3. 转换网关采用每7天一个周期进行登记并统一进行转换，每周五0:00为登记截止日期，7天内在网关登记的记录将在下周二前完成转换。届时请前往绑定的YeeCo主网钱包地址查收转换的YEE-YeeCo<br />
        4. 1个Erc20地址仅能绑定1个YeeCo主网地址，且无法修改<br />
        5. YEE转换网关采用智能合约实现，转换时需要消耗少量ETH作为GAS费，为保证转换成功，请确保Erc20地址中持有一定ETH<br />
        6. 转换网关将于2020年08月31日截止登记，截止后将无法通过网关进行登记转换<br />
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
import { Dialog, Toast } from 'vant';
import { converterAdress, tokenAdress, hrp } from '../config/index'
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
      if (window.web3 === undefined) {
        Toast.fail('未检测到钱包');
        return;
      }
      await this.login(async () => {
        const token = window.web3.eth.contract(tokenConfig)
        this.tokenContext = token.at(tokenAdress)
        const contract = window.web3.eth.contract(converter)
        this.contractContext =  contract.at(converterAdress)
        this.converterFn()
        this.checkHasAddress()
        this.getblance()
        await this.getAllowancePrice()
      })
  },
  methods: {
    async confirmAuth() {
      if(this.approveStatus > 0) return
      const res = this.checkAdress()
      if(!res) {
        return Toast.fail('YeeCo主网地址错误');
      }
      if(res && this.transferPrice) {
        Dialog.confirm({
          messageAlign: 'left',
          title: '请核对你的YeeCo主网地址及转换数量',
          message: `YeeCo主网地址：\n${this.YeeCoaddress}\n转换数量：\n${this.transferPrice} YEE-Erc20`,
        }).then(() => {
          this.approve()
        });
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
          this.amountPrice =  NP.divide(a.toNumber(), 1e18).toFixed(2)
        }
      })
    },
    getAllowancePrice() {
      return new Promise((resolve, reject) => {
        this.tokenContext.allowance(this.account,converterAdress,(e, a) => {
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
         res.bytes = bech32.fromWords(res.words)
       } catch (error){
         return false
       }
       if(res.prefix === hrp && res.bytes.length === 32) {
         return true
       }
     },
     transferFn() {
      return new Promise((resolve, reject) => {
        const transferPrice = this.transferPrice * 1e18
        this.contractContext.checkIn(transferPrice, this.YeeCoaddress, (e,a) => {
          if(!e) {
            this.transferStatus = 1
            this.contractContext.CheckIn((error, result) => {
              if(result.transactionHash === a) {
                this.transferStatus = 2
                Dialog.alert({
                  messageAlign: 'left',
                  title: '登记已确认',
                  message: `YeeCo主网地址：\n${this.YeeCoaddress}\n转换金额：\n${this.transferPrice} YEE-Erc20`,
                }).then(() => {
                  window.location.reload()
                });
                this.converterFn()
                this.balancePrice()
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
      return new Promise((resolve, reject) => {
        const transferPrice = Number(this.transferPrice) * 1e18

        this.tokenContext.allowance(this.account,converterAdress,(e, a) => {
            if(!e) {
                this.allowancePrice =  a.toNumber()

                if (this.allowancePrice >= transferPrice) {
                    // skip approve
                    this.approveStatus = 2
                } else{
                    this.tokenContext.approve(converterAdress, transferPrice, (e,a) => {
                        if(!e) {
                            this.approveStatus = 1
                            this.serveAddress = this.YeeCoaddress
                            resolve(a)
                            this.tokenContext.Approval((error, result) => {
                                if(result.transactionHash === a) {
                                    this.approveStatus = 2
                                }
                            })
                        }
                    })
                }
            } else {
                reject(e)
            }
        })
        return
      })
    },
    getblance() {
      return new Promise((resolve, reject) => {
        this.tokenContext.balanceOf(this.account, (e,a) => {
          if(!e) {
            console.log(a.toNumber())
            this.balancePrice =  NP.divide(a.toNumber(), 1e18).toFixed(2)
            resolve(this.balancePrice)
          } else {
            reject(e)
          }
        })
      })
    },
    async login(callback) {
      let web3Provider;
      if (window.web3 === undefined) {
        Toast.fail('未检测到钱包');
        return;
      }
      console.log(window.web3)
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
  cursor pointer
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
    top -138px
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
      padding-top: 24px;
      padding-bottom: 24px;
      box-sizing border-box
      padding-left 33px
      background-color: rgba(12, 104, 255, 0.1);
      border-radius: 4px;
      border-left #0c68ff 6px solid 
      color #0c68ff
      display flex
      word-wrap:break-word;
      word-break:break-all;
      .number{
        margin-right 10px
      }
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
