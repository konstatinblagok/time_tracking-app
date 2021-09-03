<template lang="html">
    <section class="forms">
        <div class="row">
            <div class="col-md-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <form  enctype="multipart/form-data">
                            <h3 class="tile-title">Site Logo</h3>
                            <hr>
                            <div class="tile-body">
                                <div class="row">
                                    <div class="col-3">
                                        <img alt="" src="https://via.placeholder.com/80x80?text=Placeholder+Image" id="logoImg" style="width: 80px; height: auto;">
                                    </div>
                                    <div class="col-9">
                                        <div class="form-group">
                                            <label class="control-label">Site Logo</label>
                                            <input class="form-control" type="file" name="site_logo" onchange="loadFile(event,'logoImg')"/>
                                        </div>
                                    </div>
                                </div>
                                <div class="row mt-4">
                                    <div class="col-3">
                                        <img src="https://via.placeholder.com/80x80?text=Placeholder+Image" id="faviconImg" style="width: 80px; height: auto;" alt="">
                                    </div>
                                    <div class="col-9">
                                        <div class="form-group">
                                            <label class="control-label">Site Favicon</label>
                                            <input class="form-control" type="file" name="site_favicon" onchange="loadFile(event,'faviconImg')"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="tile-footer">
                                <div class="row d-print-none mt-2">
                                    <div class="col-12 text-right">
                                        <button class="btn btn-primary" type="submit">Update Settings</button>
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
        name: 'Site Logo',
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
