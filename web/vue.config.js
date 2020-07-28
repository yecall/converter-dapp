const path = require("path");

module.exports = {

    configureWebpack: () => {
        return {
            output : {
                filename: 'js/[name].[hash].js'
            },

        }
    },
}
