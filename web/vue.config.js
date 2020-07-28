const path = require("path");

module.exports = {

    publicPath: process.env.VUE_APP_PUBLIC_PATH ? process.env.VUE_APP_PUBLIC_PATH: '/',

    configureWebpack: () => {
        console.log(": " + process.env.NODE_ENV)
        return {
            output : {
                filename: 'js/[name].[hash].js'
            },

        }
    },
}
