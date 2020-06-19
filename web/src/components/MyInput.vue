<template>
  <div class="inputWrap">
    <input :disabled="disabled" class="input" :placeholder="placeholder" @input="change" v-model="input" :type="type ? type : 'text'"/>
    <div class="tipRight" v-if="textRight">{{textRight}}</div>
  </div>
</template>

<script>
export default {
  props: ['textRight', 'placeholder', 'value', 'type', 'precision', 'disabled'],
  data() {
    return {
      input: '',
    }
  },
  watch: {
    value(newValue, oldValue) {
      if (newValue !== oldValue) {
        this.input = newValue
      }
    }
  },
  methods:{
    getPrecision(value) {
      if (value === undefined) return 0;
      const valueString = value.toString();
      const dotPosition = valueString.indexOf('.');
      let precision = 0;
      if (dotPosition !== -1) {
        precision = valueString.length - dotPosition - 1;
      }
      return precision;
    },
    change(e) {
      const currPrecision = this.getPrecision(e.target.value)
      if(this.precision && currPrecision > this.precision){
        this.input = Number(this.input)
        this.input = this.input.toFixed(this.precision);
      }
      this.$emit("input", this.input)
      this.$emit("change", this.input)
    },
  },
  created() {
    this.input = this.value
  },
}
</script>

<style lang="stylus" scoped>
  .inputWrap{
    padding 0 31px
    background-color #edf1f5
    display flex
    height 92px
    border-radius 4px
    align-items center
    .input{
      background none 
      border none 
      outline none 
      color #2e394b
      flex-grow 1
      height 30px
    }
    .tipRight{
      font-size 24px
      color #2e394b
    }
  }
</style>