<template lang="html">
    <section class="forms">
        <div class="row">
            <div class="col-md-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <form  method="POST" role="form">

                            <h3 class="tile-title">Footer &amp; SEO</h3>
                            <hr>
                            <div class="tile-body">
                                <div class="form-group">
                                    <label class="control-label" for="footer_copyright_text">Footer Copyright Text</label>
                                    <textarea
                                        class="form-control"
                                        rows="4"
                                        placeholder="Enter footer copyright text"
                                        id="footer_copyright_text"
                                        name="footer_copyright_text"
                                    ></textarea>
                                </div>
                                <div class="form-group">
                                    <label class="control-label" for="seo_meta_title">SEO Meta Title</label>
                                    <input
                                        class="form-control"
                                        type="text"
                                        placeholder="Enter seo meta title for store"
                                        id="seo_meta_title"
                                        name="seo_meta_title"

                                    />
                                </div>
                                <div class="form-group">
                                    <label class="control-label" for="seo_meta_description">SEO Meta Description</label>
                                    <textarea
                                        class="form-control"
                                        rows="4"
                                        placeholder="Enter seo meta description for store"
                                        id="seo_meta_description"
                                        name="seo_meta_description"
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
        name: 'Footer & SEO',
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
