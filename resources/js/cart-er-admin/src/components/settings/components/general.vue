<template lang="html">
    <section class="forms">
        <div class="row">
            <div class="col-md-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <form>
                            <h3 class="tile-title">General Setting</h3>
                            <hr>
                            <div class="form-group">
                                <label for="site-name">Site Name</label>
                                <input type="text" class="form-control" id="site-name" aria-describedby="site-name" placeholder="Site name">
                            </div>
                            <div class="form-group">
                                <label for="site-title">Site Title</label>
                                <input type="text" class="form-control" id="site-title" placeholder="Site Title">
                            </div>
                            <div class="form-group">
                                <label for="site-email">Site Email</label>
                                <input type="email" class="form-control" id="site-email" placeholder="Email">

                            </div>
                            <div class="form-group">
                                <label for="site-currency-code">Currency Code</label>
                                <input type="text" class="form-control" id="site-currency-code" placeholder="Currency Code">

                            </div>
                            <div class="form-group">
                                <label for="site-currency-symbol">Currency Symbol</label>
                                <input type="text" class="form-control" id="site-currency-symbol" placeholder="Currency Symbol">
                            </div>
                            <button type="submit" class="btn btn-primary">Submit</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </section>

</template>
<script>
    // eslint-disable
    import {mapState} from 'vuex'

    export default {
        name: 'General Setting',
        data() {
            return {

            };
        },

        computed: {},
        components: {},
        methods: {
            addProduct() {
                this.$store.dispatch('getStoreSettings', this.objProduct)
            },

        }
    };

</script>
<style scoped>

</style>
