<template>
  <v-app>
    <div id="newStreamRoom" class="stream">
      <v-card v-if="!hasLoaded" class="loading-message" flat color="#000000">
        <v-row justify="space-around">
          <v-card-title class="header justify-space-around white--text"
            >The stream is loading. Please wait...</v-card-title
          >
        </v-row>
        <v-row justify="space-around">
          <v-progress-circular
            indeterminate
            class="mb-6"
            color="white"
          ></v-progress-circular>
        </v-row>
      </v-card>
    </div>

    <v-card flat>
      <v-expansion-panels>
        <v-expansion-panel>
          <v-container>
              <v-card >
                <v-alert
                  :value="alert"
                  dismissible
                  color="primary"
                  border="left"
                  elevation="2"
                  type="error"
                >
                  Please <strong>Record</strong> the session !!!
                </v-alert>
            </v-card>
            <v-row class="px-3">
              <v-col cols="10" class="text-left">
                <div class="headline font-weight-bold">{{ streamTitle }}</div>
                <div class="subtitle-2 font-weight-light">{{ author }}</div>
              </v-col>
              <v-col cols="2" class="d-flex justify-end align-center">
                <div class="mx-2">
                  <v-icon color="red lighten-2">mdi-eye</v-icon>
                </div>
                <div>
                  <span class="red--text text--lighten-2" id="viewCount">1</span>
                </div>
                <div class="ml-4">
                  <!-- <v-btn icon>
                    <v-icon>mdi-pencil</v-icon>
                  </v-btn> -->
                  <v-btn @click="$vuetify.theme.dark = !$vuetify.theme.dark" icon>
                  <v-icon :class="$vuetify.theme.dark ? 'd-none' : 'd-flex'">mdi-moon-waning-crescent</v-icon>
                    <v-icon :class="$vuetify.theme.dark ? 'd-flex' : 'd-none'">mdi-white-balance-sunny</v-icon>
                  </v-btn>
                </div>
                <div>
                  <router-link
                  style="text-decoration: none"
                  class="ml-4"
                  to="/home"
                  >
                    <v-icon>mdi-exit-to-app</v-icon>
                  </router-link>
                </div>
              </v-col>
            </v-row>
          </v-container>

          <v-divider></v-divider>

          <v-expansion-panel-header>
            <!-- <div class="link">Show Details</div> -->
            <span
              class="subtitle-2 text-uppercase font-weight-bold"
              style="letter-spacing:0.15em"
              >Show description</span
            >
          </v-expansion-panel-header>
          <v-expansion-panel-content>
            <v-row>
              <v-col>
                <p>{{ description }}</p>
              </v-col>
            </v-row>
          </v-expansion-panel-content>
        </v-expansion-panel>
      </v-expansion-panels>
 
    </v-card>

    
  </v-app>
</template>

<script>
// import StreamDetails from "../StreamComponents/StreamDetails";
import backend from "../../Service";

export default {
  name: "streambox",
  components: {
    // StreamDetails
  },
  // metaInfo: {
  // 	title: 'StreamRoom',
  // 	script: [
  // 		{ src: 'https://meet.jit.si/external_api.js', async: true, defer: true }
  // 	]
  // },
  


  data() {
    return {
      api: null,
      hasLoaded: true,
      streamName: this.$route.params.streamName,
      streamTitle: "",
      description: "",
      author: "",
      alert: true,
      viewCount : 1
    };
  },
  
  async created() {
    this.getStreamDetails();
        setTimeout(()=>{
      this.alert=false
    },10000)
  },
  destroyed() {
    console.log("stopping.......");
    backend.stopStream();
    this.$store.commit('setStopStream')

    // this.socket.emit('stop',this.user.email)
  },
  methods: {
    async getStreamDetails() {
      const streamDetail = await backend.getStreamDetail(
        this.$route.params.streamName
      );
      console.log(streamDetail);
      if (streamDetail.data) {
        this.streamTitle = streamDetail.data.streamTitle;
        this.author = streamDetail.data.ownerName;
        this.description = streamDetail.data.description;
        this.streamOn(streamDetail.data.streamCode, this.streamTitle);
      }
    },
    async streamOn(streamCode, streamTitle) {
      // eslint-disable-next-line no-unused-vars
      const { domain, options, role, name } = await backend.joinStream(
        streamCode,
        ""
      );
      this.api = null;
      $(document).ready(function() {
        options["parentNode"] = document.querySelector("#newStreamRoom");
        this.api = new JitsiMeetExternalAPI(domain, options);
        this.api.executeCommand("displayName", name);
        this.api.executeCommand("subject", streamTitle);
        if (role != "Lecturer") {
          this.api.executeCommand("toggleVideo");
          this.api.executeCommand("toggleAudio")
        }
        // Count when a user join
        this.api.on("participantJoined",(data) => {
          console.log(`New Comer - ${data.displayName} : ${data.id}`)
          this.viewCount = this.api.getNumberOfParticipants()
          let viewBox = document.getElementById("viewCount")
          viewBox.innerHTML = this.viewCount
        })
        // Count when a user left
        this.api.on("participantLeft",(data) => {
          console.log(`User left - ${data.displayName} : ${data.id}`)
          this.viewCount = this.api.getNumberOfParticipants()
          let viewBox = document.getElementById("viewCount")
          viewBox.innerHTML = this.viewCount
        })
      });
    }
  }
};
</script>

<style scoped>
.stream {
  height: 635px;
  background-color: #000000;
  border: 5px solid #000000;
}
.loading-message {
  position: relative;
  top: 40%;
}

.link {
  color: #0275d8;
  text-decoration: underline;
}
</style>
