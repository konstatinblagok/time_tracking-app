<template lang="html">
    <section class="forms">
        <div class="row">
            <div class="col-md-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <div>
                            <b-card no-body>
                                <b-tabs pills card vertical>
                                    <b-tab title="General"><general-setting/></b-tab>
                                    <b-tab title="Site Logo"><site-logo/></b-tab>
                                    <b-tab title="Footer & SEO"><footer-seo/></b-tab>
                                    <b-tab title="Social Links"><social-links/></b-tab>
                                    <b-tab title="Analytics"><analytics/></b-tab>
                                    <b-tab title="Payments"><payments/></b-tab>
                                </b-tabs>
                            </b-card>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

</template>
<script>
    import general from "./general";
    import siteLogo from  "./logo";
    import footerSeo from  "./footerSeo";
    import analytics from "./analytics";
    import socialLinks from "./socialLinks"
    import payments from "./payments";

    export default {
        name: 'Settings',
        data() {
            return {

            };
        },

        computed: {},
        components: {
            'general-setting':general,
            'site-logo':siteLogo,
            'footer-seo':footerSeo,
            'analytics': analytics,
            'socialLinks':socialLinks,
            'payments':payments
        },
        methods: {
            addProduct() {
                this.$store.dispatch('addNewProduct', this.objProduct)
            },

            selectFile(event) {
                // `files` is always an array because the file input may be in multiple mode
                // this.image = event.target.files[0].name;
                this.image = '';
            }

        }
    };

</script>
<style scoped>

</style>
