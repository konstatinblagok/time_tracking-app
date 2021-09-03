<template lang="html">
    <section class="forms">
        <div class="row">
            <div class="col-md-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <form  method="POST" role="form">

                            <h3 class="tile-title">Analytics</h3>
                            <hr>
                            <div class="tile-body">
                                <div class="form-group">
                                    <label class="control-label" for="google_analytics">Google Analytics Code</label>
                                    <textarea
                                        class="form-control"
                                        rows="4"
                                        placeholder="Enter google analytics code"
                                        id="google_analytics"
                                        name="google_analytics"
                                    ></textarea>
                                </div>
                                <div class="form-group">
                                    <label class="control-label" for="facebook_pixels">Facebook Pixel Code</label>
                                    <textarea
                                        class="form-control"
                                        rows="4"
                                        placeholder="Enter facebook pixel code"
                                        id="facebook_pixels"
                                        name="facebook_pixels"
                                    ></textarea>
                                </div>
                            </div>
                            <div class="tile-footer">
                                <div class="row d-print-none mt-2">
                                    <div class="col-12 text-right">
                                        <button class="btn btn-success" type="submit"><i class="fa fa-fw fa-lg fa-check-circle"></i>Update Settings</button>
                                    </div>
                                </div>
                            </div>
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
        name: 'Analytics',
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
