<template>
  <!-- <v-btn @click.stop="$vuetify.theme.dark = !$vuetify.theme.dark">
			<v-icon :class="$vuetify.theme.dark ? 'd-flex' : 'd-none'"
				>mdi-white-balance-sunny</v-icon
			>
			<v-icon :class="$vuetify.theme.dark ? 'd-none' : 'd-flex'"
				>mdi-moon-waning-crescent</v-icon
			>
  </v-btn>-->

  <!-- <v-simple-table>
			<tr>
				<td style="width: 75%">
					<StreamBox />
				</td>
				<td style="width: 25%">
					<ChatBox />
				</td>
			</tr>
  </v-simple-table> -->
  <v-card class="mx-2 transparent" flat id="streamRoom">
    <v-row >
      <v-col cols="12" >
        <StreamBox />
      </v-col>
      <!-- <v-col cols="3">
        <ChatBox :user="user" />
      </v-col> -->
    </v-row>

  </v-card>
  
</template>

<script>
// import ChatBox from "../components/StreamComponents/ChatBox";
import StreamBox from "../components/StreamComponents/StreamBox";
// import BlankLayout from "../layouts/Blank";

export default {
  name: "stream",
  beforeRouteLeave (to, from, next) {
  this.$dialog.confirm('Do you want to leave this session ?')
  .then(function () {
    next();
  })
  .catch(function () {
    next(false);
  });
},
  components: {
    
    StreamBox,
    // ChatBox
  },
  
  props: {
    user: Object
  }
  //   created() {
  //     this.$emit("update:layout", BlankLayout);
  //   }
};
</script>

<style>

.dg-content {
  font-family:  Arial, Helvetica, sans-serif;
  text-align: 100px;
  width: 500px;
  
}

.dg-btn.dg-btn--ok {
    color: #96281B;
    background-color: #fefefe;
    font-family:  Arial, Helvetica, sans-serif;
    border-color: #96281B;
    border-width: 0.7px;
}

.dg-btn.dg-btn--cancel{
    color: #96281B;
    background-color: #fefefe;
    font-family:  Arial, Helvetica, sans-serif;
    border-color: #96281B;
    border-width: 0.7px;
}

</style>



