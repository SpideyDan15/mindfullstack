<template>
  <div>
    <v-app>
      <v-app-bar
      prominent
      scroll-behavior="fade-image collapse elevate"
      scroll-threshold="408"
      image="/banner.jpg"
      style="background: linear-gradient(225deg, #da2c38 0%, #1b2021 100%)">
        <v-app-bar-nav-icon @click.stop="drawer = !drawer"></v-app-bar-nav-icon>
        <v-app-bar-title>The Mindfull-Stack</v-app-bar-title>
      </v-app-bar>

      <v-navigation-drawer
        v-model="drawer"
        :rail="rail"
        permanent
        @click="rail = false">
        <v-list-item>
          <v-btn
            variant="text"
            :icon="(rail) ? 'mdi-chevron-right' : 'mdi-chevron-left'"
            @click.stop="rail = !rail">
          </v-btn>
        </v-list-item>
        <v-divider></v-divider>
        <v-list nav>
          <v-list-item v-for="page in pages"
            :prepend-icon="page.icon" :title="page.name" :value="page.path" nuxt :to="page.path">
          </v-list-item>
        </v-list>
      </v-navigation-drawer>

      <v-main>
        <v-container>
          <NuxtPage/>
        </v-container>

        
      </v-main>
      
      <!-- <v-card> -->
        <!-- <div style="position: relative; width: 100%; height: 0; padding-top: 56.2225%;
        padding-bottom: 0; box-shadow: 0 2px 8px 0 rgba(63,69,81,0.16); margin-top: 1.6em; margin-bottom: 0.9em; overflow: hidden;
        border-radius: 8px; will-change: transform;">
          <iframe loading="lazy" style="position: absolute; width: 100%; height: 100%; top: 0; left: 0; border: none; padding: 0;margin: 0;"
            src="https:&#x2F;&#x2F;www.canva.com&#x2F;design&#x2F;DAF0uv75ys8&#x2F;view?embed" allowfullscreen="allowfullscreen" allow="fullscreen">
          </iframe>
        </div> -->
      <!-- </v-card> -->
      <v-footer>
        <v-row justify="center" no-gutters>
          <v-btn
            v-for="page in pages"
            :key="page.path"
            @click.stop="$router.push(page.path)"
            color="white"
            variant="text"
            class="mx-2"
            rounded="xl">
            {{ page.name }}
          </v-btn>
          <v-col class="text-center mt-4" cols="12">
            2023 ~ <strong>The Mindfull-Stack</strong>
          </v-col>
        </v-row>
      </v-footer>
    </v-app>
  </div>
</template>

<script setup lang="ts">
const config = useRuntimeConfig()
useHead({
  titleTemplate: (titleChunk) => {
    return titleChunk ? `${titleChunk} - MindFull-Stack` : 'MindFull-Stack';
  },
  meta: [
    { name: 'description', content: 'A blog and portfolio of my work as a Computer Science student and Software Engineer.' }
  ],
  bodyAttrs: {
    class: 'test'
  },
  script: [ { innerHTML: 'console.log(\'Hello my world\')' } ],
  link: [
    { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' },
    { rel: 'apple-touch-icon', type: 'image/png', sizes: '180x180', href: '/apple-touch-icon.png' },
    { rel: 'icon', type: 'image/png', sizes: '32x32', href: '/favicon-32x32.png' },
    { rel: 'icon', type: 'image/png', sizes: '16x16', href: '/favicon-16x16.png' },
    { rel: 'icon', type: 'image/png', href: '/icon.png' },
    { rel: 'manifest', href: '/site.webmanifest' }
  ]
})
</script>

<script lang="ts">
  export default {
  name: 'DefaultLayout',
  created () {
    console.log('PATH:', this.$route.path)
    this.currentPage = this.$route.path
  },
  mounted () {
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
      this.$vuetify.theme.dark = true
    }
  },
  data: function () {
    return {
      currentPage: null,
      drawer: true,
      rail: true,
      pages: [{name: "Home", path: "/", icon: "mdi-home"},
              {name: "About", path: "/about", icon: "mdi-account"},
              {name: "Blog", path: "/blog", icon: "mdi-post"}
             ],
    }
  },
  watch: {
    currentPage () {
      console.log('currentPage', this.currentPage)
    },
    drawer () { console.log("drawer",this.drawer) }
  }
}
</script>